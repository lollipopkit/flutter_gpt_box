import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/model/chat.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:shortid/shortid.dart';

/// The reply being written: what the stream has said so far.
final class StreamingReply {
  const StreamingReply({this.text = '', this.thinking = '', this.tools = const []});

  final String text;
  final String thinking;

  /// Tool calls running now, by name.
  final List<String> tools;

  StreamingReply copyWith({String? text, String? thinking, List<String>? tools}) =>
      StreamingReply(text: text ?? this.text, thinking: thinking ?? this.thinking, tools: tools ?? this.tools);
}

/// A tool call waiting for the user, shown in the chat it belongs to.
final class PendingApproval {
  PendingApproval(this.call);

  final LlmToolCall call;
  final _answer = Completer<LlmApproval>();

  void _complete(LlmApproval a) {
    if (!_answer.isCompleted) _answer.complete(a);
  }
}

/// How the user answered a [PendingApproval].
enum ApprovalAnswer { deny, once, always }

/// A file [Chats.send] cannot attach: not an image, and not text of at most
/// [maxBytes].
final class UnsupportedAttachment implements Exception {
  const UnsupportedAttachment(this.name);

  final String name;
  static const maxBytes = 512 * 1024;

  @override
  String toString() => 'Cannot attach $name: only images and text files up to 512 KB';
}

/// An open chat: its session, and what the chat view draws.
///
/// Outlives its session: a sync that rewrites the session file swaps a new
/// one in ([Chats.rewrite]), and the chat view keeps drawing this.
final class OpenChat {
  OpenChat._(this.id, LlmSession session) {
    _attach(session);
  }

  final String id;
  late LlmSession _session;
  late StreamSubscription<LlmEvent> _sub;

  LlmSession get session => _session;

  void _attach(LlmSession s) {
    _session = s;
    _sub = s.events.listen(_onEvent);
  }

  Future<void> _detach() async {
    await _sub.cancel();
    await _session.close();
  }

  /// The current branch, root first.
  final entries = <LlmEntry>[].vn;

  /// Every entry on every branch, for switching between versions.
  var tree = <LlmEntry>[];

  /// While a run is going.
  final running = false.vn;

  /// The reply being streamed, if one is.
  final streaming = nvn<StreamingReply>();

  /// An error the last run ended with.
  final error = nvn<String>();

  /// A run a previous launch left unfinished: [Chats.resume] picks it up.
  final interrupted = false.vn;

  /// How long each reply of this session thought, by entry id, as measured
  /// while it streamed. A reply that also wrote text cannot be timed from its
  /// timestamps alone.
  final thoughtMs = <String, int>{};
  DateTime? _thinkStart, _thinkEnd;

  /// Tool calls the run is waiting on the user for, in the order asked.
  /// The first is the one on screen.
  final approvals = <PendingApproval>[].vn;

  /// Answers every pending call: a run is never left waiting.
  void _denyPending(String why) {
    for (final p in approvals.value) {
      p._complete(LlmApproval.deny(why));
    }
    approvals.value = const [];
  }

  Future<void> reload() async {
    entries.value = await session.entries();
    tree = await session.tree();
    interrupted.value = session.interrupted;
  }

  void _onEvent(LlmEvent e) {
    switch (e.type) {
      case 'message_start' when e.message?.role == 'assistant':
        streaming.value = const StreamingReply();
        _thinkStart = _thinkEnd = null;
      case 'message_update':
        final s = streaming.value ?? const StreamingReply();
        if (e.textDelta case final d?) {
          if (_thinkStart != null) _thinkEnd ??= DateTime.now();
          streaming.value = s.copyWith(text: s.text + d);
        } else if (e.thinkingDelta case final d?) {
          _thinkStart ??= DateTime.now();
          streaming.value = s.copyWith(thinking: s.thinking + d);
        }
      case 'tool_start':
        final s = streaming.value ?? const StreamingReply();
        streaming.value = s.copyWith(tools: [...s.tools, e.toolName ?? '?']);
      case 'entry_added':
        final entry = e.entry;
        if (entry == null) return;
        final list = entries.value;
        if (entry.parentId == list.lastOrNull?.id) {
          entries.value = [...list, entry];
          tree = [...tree, entry];
        }
        if (entry.type == 'message' && entry.message?.role == 'assistant') {
          if (_thinkStart case final start?) {
            thoughtMs[entry.id] = (_thinkEnd ?? DateTime.now()).difference(start).inMilliseconds;
          }
          _thinkStart = _thinkEnd = null;
          streaming.value = null;
        }
      case 'run_end':
        streaming.value = null;
        if (e.status == 'failed') error.value = e.error;
    }
  }

  /// The versions of the message [entry] is: it and its siblings, oldest
  /// first. One element when it was never edited or regenerated.
  List<LlmEntry> versionsOf(LlmEntry entry) {
    final siblings = [
      for (final t in tree)
        if (t.parentId == entry.parentId && t.type == 'message' && t.message?.role == entry.message?.role) t,
    ]..sort((a, b) => a.seq.compareTo(b.seq));
    return siblings.isEmpty ? [entry] : siblings;
  }

  /// The newest leaf under [entryId]: where switching to that version lands.
  String _leafOf(String entryId) {
    final children = <String, List<LlmEntry>>{};
    for (final t in tree) {
      final p = t.parentId;
      if (p != null) (children[p] ??= []).add(t);
    }
    var cur = entryId;
    while (true) {
      final next = children[cur];
      if (next == null || next.isEmpty) return cur;
      next.sort((a, b) => b.seq.compareTo(a.seq));
      cur = next.first.id;
    }
  }

  Future<void> _dispose() async {
    _denyPending('The chat was closed');
    await _detach();
  }
}

/// Chats: the list, the open ones, and everything done to them.
abstract final class Chats {
  static final _open = <String, OpenChat>{};
  static final _opening = <String, Future<OpenChat>>{};

  /// The chat on screen.
  static final current = nvn<String>();

  /// Notified when a chat is opened or closed: what shows its state follows.
  static final openChanges = RNode();

  /// Temporary users of each chat ([borrow]), which close it when done.
  static final _borrows = <String, int>{};

  static OpenChat? openOf(String id) => _open[id];

  /// The chat, opened if it is not.
  static Future<OpenChat> open(String id) {
    final c = _open[id];
    if (c != null) return Future.value(c);
    // A block, not an arrow: `remove` returns this very future, and
    // `whenComplete` would wait for it — for itself.
    return _opening[id] ??= _doOpen(id).whenComplete(() {
      _opening.remove(id);
    });
  }

  static Future<OpenChat> _doOpen(String id) async {
    final chat = OpenChat._(id, await _openSession(id));
    try {
      await chat.reload();
    } catch (_) {
      // Or the runtime keeps it, and every later open fails as "already open".
      await chat._dispose();
      rethrow;
    }
    _open[id] = chat;
    openChanges.notify();
    return chat;
  }

  static Future<LlmSession> _openSession(String id) {
    final meta = Stores.chat.fetch(id);
    final model = meta?.model ?? Llm.defaultModel;
    if (model == null) throw const LlmException('No model: add a provider key first');
    return Llm.rt.openSession(
      id: id,
      model: model,
      systemPrompt: systemPromptFor(meta),
      tools: _toolsFor(meta),
      thinkingLevel: _thinkingFor(model),
      compaction: Stores.llm.compaction.get() ? const CompactionSettings() : CompactionSettings.disabled,
      approve: _approve,
    );
  }

  /// Runs [write], which replaces chat [id]'s session file, with the chat's
  /// session closed, then opens it again in the same [OpenChat]: the view
  /// showing it carries on. Returns false, and does not write, while a reply
  /// is being written.
  static Future<bool> rewrite(String id, Future<void> Function() write) async {
    // One being opened is waited for: it would otherwise read the file mid-write.
    try {
      await _opening[id];
    } catch (_) {
      // Failed to open: then it is not open.
    }
    final chat = _open[id];
    if (chat == null) {
      await write();
      return true;
    }
    if (chat.running.value) return false;
    await chat._detach();
    try {
      await write();
    } finally {
      try {
        chat._attach(await _openSession(id));
        await chat.reload();
      } catch (e, s) {
        Loggers.app.warning('Reopen $id', e, s);
        _open.remove(id);
        openChanges.notify();
        chat.error.value = '$e';
      }
    }
    return true;
  }

  static Future<void> close(String id) async {
    final c = _open.remove(id);
    if (c != null) openChanges.notify();
    await c?._dispose();
  }

  static Future<void> closeAll() async {
    for (final id in [..._open.keys]) {
      await close(id);
    }
  }

  /// Runs [fn] on chat [id], opened for it if it was not, and closed again
  /// after unless something else has taken it up meanwhile: it went on
  /// screen, or started a run.
  static Future<T> borrow<T>(String id, Future<T> Function(OpenChat chat) fn) async {
    final wasOpen = _open.containsKey(id) || _opening.containsKey(id);
    _borrows[id] = (_borrows[id] ?? 0) + 1;
    try {
      return await fn(await open(id));
    } finally {
      final n = _borrows[id]! - 1;
      n == 0 ? _borrows.remove(id) : _borrows[id] = n;
      final c = _open[id];
      if (!wasOpen && n == 0 && c != null && !c.running.value && current.value != id) await close(id);
    }
  }

  /// The chat's current branch as markdown.
  static Future<String> markdownOf(String id) => borrow(id, (c) async => toMarkdown(c.entries.value));

  static String toMarkdown(List<LlmEntry> entries) {
    final sb = StringBuffer();
    for (final e in entries) {
      final m = e.message;
      if (m == null) continue;
      final who = switch (m.role) {
        'user' => '👤',
        'assistant' => '🤖',
        _ => null,
      };
      if (who == null) continue;
      sb
        ..writeln('### $who')
        ..writeln()
        ..writeln(m.text)
        ..writeln();
    }
    return sb.toString();
  }

  /// Makes a new chat and returns its id. Its session is created on open.
  static String create() {
    final id = shortid.generate();
    Stores.chat.put(ChatMeta(id: id, updatedAt: DateTime.now(), model: Llm.defaultModel));
    return id;
  }

  /// Sends [text], with [files] attached, and runs until the reply is done.
  static Future<void> send(String id, String text, {List<String> files = const []}) async {
    final chat = await open(id);
    _claim(chat);
    final (String, List<Map<String, Object?>>) composed;
    try {
      composed = await _compose(text, files);
    } catch (_) {
      chat.running.value = false;
      rethrow;
    }
    final (prompt, images) = composed;
    await _run(chat, () => chat.session.prompt(prompt, images: images.isEmpty ? null : images));
    _touch(id);
    unawaited(_maybeTitle(chat, text));
  }

  /// Sends [text] in place of the user message [entry]; the old one stays as
  /// another version.
  static Future<void> edit(String id, LlmEntry entry, String text) async {
    final chat = await open(id);
    _claim(chat);
    final images = _imagesOf(entry.message);
    await _run(chat, () async {
      await chat.session.navigate(entry.parentId);
      await chat.reload();
      return chat.session.prompt(text, images: images.isEmpty ? null : images);
    });
    _touch(id);
  }

  /// Asks for another reply to the user message [entry].
  static Future<void> regenerate(String id, LlmEntry entry) =>
      edit(id, entry, entry.message?.text ?? '');

  /// Asks again after the last run failed: the last user message, again.
  static Future<void> retry(String id) async {
    final chat = await open(id);
    final user = chat.entries.value.lastWhereOrNull((e) => e.message?.role == 'user');
    if (user != null) await regenerate(id, user);
  }

  /// Carries on the run a previous launch left unfinished.
  static Future<void> resume(String id) async {
    final chat = await open(id);
    _claim(chat);
    await _run(chat, chat.session.resume);
    _touch(id);
  }

  /// Shows the version [entry] of a message, and the conversation that
  /// followed it.
  static Future<void> switchTo(String id, LlmEntry entry) async {
    final chat = await open(id);
    await chat.session.navigate(chat._leafOf(entry.id));
    await chat.reload();
  }

  static Future<void> abort(String id) async {
    final chat = _open[id];
    chat?._denyPending('The user stopped the reply');
    await chat?.session.abort();
  }

  /// Answers the tool call chat [id] is waiting on.
  static void answer(String id, ApprovalAnswer answer) {
    final chat = _open[id];
    final pending = chat?.approvals.value.firstOrNull;
    if (chat == null || pending == null) return;
    chat.approvals.value = chat.approvals.value.skip(1).toList();
    switch (answer) {
      case ApprovalAnswer.always:
        Stores.mcp.permittedTools.set({...Stores.mcp.permittedTools.get(), pending.call.name}.toList());
        pending._complete(const LlmApproval.allow());
      case ApprovalAnswer.once:
        pending._complete(const LlmApproval.allow());
      case ApprovalAnswer.deny:
        pending._complete(const LlmApproval.deny('The user denied it'));
    }
  }

  /// Marks [chat] as running, or refuses: one run at a time. Synchronous
  /// after the open, so two sends a moment apart cannot both start one.
  static void _claim(OpenChat chat) {
    if (chat.running.value) throw const LlmException('A reply is still being written');
    chat.error.value = null;
    chat.running.value = true;
  }

  /// Runs [run] on [chat], which [_claim] has marked running.
  static Future<void> _run(OpenChat chat, Future<LlmRunResult> Function() run) async {
    try {
      final r = await run();
      if (r.status == 'failed') chat.error.value = r.error;
    } catch (e, s) {
      Loggers.app.warning('Run in ${chat.id}', e, s);
      chat.error.value = '$e';
    } finally {
      chat.running.value = false;
      chat.streaming.value = null;
      // Closed meanwhile (trashed, say): nothing to show.
      if (_open[chat.id] == chat) {
        try {
          await chat.reload();
        } catch (e, s) {
          Loggers.app.warning('Reload ${chat.id}', e, s);
        }
      }
    }
  }

  static void _touch(String id) {
    final meta = Stores.chat.fetch(id);
    if (meta != null) Stores.chat.put(meta.copyWith(updatedAt: DateTime.now()));
  }

  // ---------------------------------------------------------------------------
  // The chat list

  static void rename(String id, String title) {
    final meta = Stores.chat.fetch(id);
    if (meta != null) Stores.chat.put(meta.copyWith(title: title));
  }

  static Future<void> setModel(String id, LlmModelRef model) async {
    final meta = Stores.chat.fetch(id);
    if (meta != null) Stores.chat.put(meta.copyWith(model: model));
    final c = _open[id];
    if (c != null) {
      await c.session.setModel(model);
      await c.session.setThinkingLevel(_thinkingFor(model));
    }
  }

  static Future<void> setUseTools(String id, bool use) async {
    final meta = Stores.chat.fetch(id);
    if (meta == null) return;
    final next = meta.copyWith(useTools: use);
    Stores.chat.put(next);
    await _open[id]?.session.setTools(_toolsFor(next));
  }

  static Future<void> trash(String id) async {
    await close(id);
    final meta = Stores.chat.fetch(id);
    if (meta != null) Stores.chat.put(meta.copyWith(trashedAt: DateTime.now()));
  }

  static void restore(String id) {
    final meta = Stores.chat.fetch(id);
    if (meta != null) Stores.chat.put(meta.copyWith(restore: true, updatedAt: DateTime.now()));
  }

  static Future<void> deleteForever(String id) async {
    await close(id);
    Stores.chat.delete(id);
    try {
      await Llm.rt.deleteSession(id);
    } catch (e, s) {
      // A chat that never sent anything has no session.
      Loggers.app.fine('Delete session $id: $e', null, s);
    }
  }

  /// Deletes what has been in the trash longer than the setting allows.
  static Future<void> purgeTrash() async {
    final keep = Duration(days: Stores.setting.trashDays.get());
    final now = DateTime.now();
    for (final m in Stores.chat.all(trashed: true)) {
      if (now.difference(m.trashedAt!) > keep) await deleteForever(m.id);
    }
  }

  /// Chats whose title or conversation contains [query], newest first.
  static Future<List<ChatMeta>> search(String query) async {
    final q = query.toLowerCase();
    final hits = await Llm.sessionsContaining(query);
    final all = Stores.chat.all();
    return [
      for (final m in all)
        if ((m.title?.toLowerCase().contains(q) ?? false) || hits.contains(m.id)) m,
    ];
  }

  // ---------------------------------------------------------------------------
  // Settings applied to open sessions

  /// The system prompt of [meta]'s chat: the user's, and the memory.
  ///
  /// Read when a chat opens or is reconfigured, not on every memory write:
  /// what the model saves mid-chat it already knows, and a prompt that stays
  /// put keeps the provider's prompt cache.
  static String systemPromptFor(ChatMeta? meta) {
    final tools = _toolsFor(meta).isNotEmpty;
    return [
      Stores.llm.systemPrompt.get(),
      if (Tools.memoryOn) ?TfMemory.prompt(tools: tools),
      if (tools) ?McpTools.instructions,
    ].where((e) => e.isNotEmpty).join('\n\n');
  }

  static Timer? _reconfigureTimer;

  /// [reconfigure], once things have stopped changing for a moment.
  static void reconfigureSoon() {
    _reconfigureTimer?.cancel();
    _reconfigureTimer = Timer(const Duration(milliseconds: 300), () => unawaited(reconfigure()));
  }

  /// Applies the system prompt, tools and compaction to every open chat.
  static Future<void> reconfigure() async {
    for (final c in [..._open.values]) {
      try {
        final meta = Stores.chat.fetch(c.id);
        await c.session.setSystemPrompt(systemPromptFor(meta));
        await c.session.setTools(_toolsFor(meta));
        await c.session.setCompaction(
          Stores.llm.compaction.get() ? const CompactionSettings() : CompactionSettings.disabled,
        );
      } catch (e, s) {
        Loggers.app.warning('Reconfigure ${c.id}', e, s);
      }
    }
  }

  static List<LlmTool> _toolsFor(ChatMeta? meta) {
    if (meta?.useTools == false) return const [];
    return Tools.enabled;
  }

  static ThinkingLevel _thinkingFor(LlmModelRef model) {
    if (Llm.info(model)?.reasoning != true) return ThinkingLevel.off;
    return ThinkingLevel.values.firstWhereOrNull((e) => e.name == Stores.llm.thinkingLevel.get()) ??
        ThinkingLevel.medium;
  }

  static Future<void> setThinkingLevel(ThinkingLevel level) async {
    Stores.llm.thinkingLevel.set(level.name);
    for (final c in [..._open.values]) {
      final model = Stores.chat.fetch(c.id)?.model ?? Llm.defaultModel;
      if (model != null) await c.session.setThinkingLevel(_thinkingFor(model));
    }
  }

  static Future<LlmApproval> _approve(LlmToolCall call) async {
    if (Tools.internal(call.name)?.trusted ?? false) return const LlmApproval.allow();
    if (Stores.mcp.permittedTools.get().contains(call.name)) return const LlmApproval.allow();
    // A chat's id is its session's: the question goes where the run is.
    final chat = _open[call.sessionId];
    if (chat == null) return const LlmApproval.deny('The chat is not open');
    final pending = PendingApproval(call);
    chat.approvals.value = [...chat.approvals.value, pending];
    return pending._answer.future;
  }

  // ---------------------------------------------------------------------------
  // Titles

  static const _titlePrompt =
      'Name this conversation in at most 8 words, in the language the user writes in. '
      'Reply with the title only: no quotes, no punctuation at the end.';

  static Future<void> _maybeTitle(OpenChat chat, String firstText) async {
    if (!Stores.setting.genTitle.get()) return;
    final meta = Stores.chat.fetch(chat.id);
    if (meta == null || meta.title != null) return;
    final model = Stores.llm.titleModel.get() ?? meta.model ?? Llm.defaultModel;
    if (model == null) return;
    try {
      final reply = chat.entries.value.lastWhereOrNull((e) => e.message?.role == 'assistant')?.message?.text ?? '';
      final m = await Llm.rt.complete(
        model: model,
        systemPrompt: _titlePrompt,
        messages: [
          LlmMessage({
            'role': 'user',
            'content': 'User: $firstText\n\nAssistant: ${reply.length > 800 ? reply.substring(0, 800) : reply}',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          }),
        ],
      );
      final title = m.text.trim().replaceAll(RegExp(r'^["“《]|["”》]$'), '').split('\n').first;
      // Not over one the user gave it while this was being asked.
      if (title.isNotEmpty && Stores.chat.fetch(chat.id)?.title == null) rename(chat.id, title);
    } catch (e, s) {
      Loggers.app.info('Title of ${chat.id}', e, s);
    }
  }

  // ---------------------------------------------------------------------------
  // Attachments

  /// The prompt text with text files inlined, and the images as pi parts.
  static Future<(String, List<Map<String, Object?>>)> _compose(String text, List<String> files) async {
    final images = <Map<String, Object?>>[];
    final inlined = <String>[];
    for (final path in files) {
      final file = File(path);
      if (!await file.exists()) continue;
      final name = file.uri.pathSegments.last;
      final mime = await file.mimeType ?? '';
      if (mime.startsWith('image/')) {
        images.add(LlmContent.image(base64Encode(await file.readAsBytes()), mime));
        continue;
      }
      if (await file.length() > UnsupportedAttachment.maxBytes) throw UnsupportedAttachment(name);
      try {
        inlined.add('<file name="$name">\n${await file.readAsString()}\n</file>');
      } on FormatException {
        throw UnsupportedAttachment(name);
      }
    }
    return ([...inlined, text].join('\n\n'), images);
  }

  static List<Map<String, Object?>> _imagesOf(LlmMessage? m) {
    final c = m?.json['content'];
    if (c is! List) return const [];
    return [
      for (final p in c.whereType<Map>())
        if (p['type'] == 'image') p.cast<String, Object?>(),
    ];
  }
}
