import 'dart:convert';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_markdown_plus_latex/flutter_markdown_plus_latex.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/widget/code.dart';
import 'package:gpt_box/view/widget/section_list.dart';
import 'package:intl/intl.dart';

/// Markdown as every message draws it.
class ChatMarkdown extends StatelessWidget {
  const ChatMarkdown(this.data, {super.key, this.forCapture = false, this.muted = false});

  final String data;

  /// Drawn for a screenshot: nothing interactive.
  final bool forCapture;

  /// Thinking: smaller and grey.
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final base = muted
        ? TextStyle(fontSize: 13, height: 1.55, color: UIs.textGrey.color)
        : const TextStyle(fontSize: 14, height: 1.6);
    return MarkdownBody(
      data: data,
      builders: {
        'code': CodeElementBuilder(onCopy: forCapture ? null : Pfs.copy, isForCapture: forCapture),
        'latex': LatexElementBuilder(),
      },
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: base,
        listBullet: base,
        a: base.copyWith(color: theme.colorScheme.primary),
        code: CodeElementBuilder.inlineStyle(context),
        codeblockDecoration: const BoxDecoration(),
        codeblockPadding: EdgeInsets.zero,
      ),
      extensionSet: MarkdownUtils.extensionSet,
      onTapLink: MarkdownUtils.onLinkTap,
      selectable: isDesktop && !forCapture,
    );
  }
}

/// What the thread is drawn as: a user's message, the reply to it (every
/// assistant and tool entry up to the next user message), or a summary.
sealed class ThreadBlock {
  const ThreadBlock();
}

final class UserBlock extends ThreadBlock {
  const UserBlock(this.entry);
  final LlmEntry entry;
}

final class ReplyBlock extends ThreadBlock {
  ReplyBlock(this.entries);
  final List<LlmEntry> entries;
}

final class SummaryBlock extends ThreadBlock {
  const SummaryBlock(this.entry);
  final LlmEntry entry;
}

/// [entries] as blocks, in order.
List<ThreadBlock> threadBlocks(List<LlmEntry> entries) {
  final out = <ThreadBlock>[];
  for (final e in entries) {
    switch (e.type) {
      case 'message':
        switch (e.message?.role) {
          case 'user':
            out.add(UserBlock(e));
          case 'assistant' || 'toolResult':
            if (out.lastOrNull case final ReplyBlock r) {
              r.entries.add(e);
            } else {
              out.add(ReplyBlock([e]));
            }
        }
      case 'compaction' || 'branch_summary':
        out.add(SummaryBlock(e));
    }
  }
  return out;
}

/// A block of the thread, as the chat view draws it.
class ThreadBlockView extends StatelessWidget {
  const ThreadBlockView({
    super.key,
    required this.chat,
    required this.block,
    this.streaming,
    this.live = false,
    this.forCapture = false,
  });

  final OpenChat? chat;
  final ThreadBlock block;

  /// The reply being written, when it continues this block.
  final StreamingReply? streaming;

  /// The run is still in this block — between steps, or waiting on the
  /// user: no footer yet.
  final bool live;
  final bool forCapture;

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      UserBlock(:final entry) => _UserMessage(chat: chat, entry: entry, forCapture: forCapture),
      ReplyBlock(:final entries) => _Reply(
        entries: entries,
        chat: chat,
        streaming: streaming,
        live: live,
        forCapture: forCapture,
      ),
      SummaryBlock(:final entry) => _Thinking(label: l10n.compacted, text: entry.summary ?? '', icon: Icons.compress),
    };
  }
}

/// A reply still being written, with nothing before it in its block.
class StreamingView extends StatelessWidget {
  const StreamingView({super.key, required this.reply});

  final StreamingReply reply;

  @override
  Widget build(BuildContext context) => _Reply(entries: const [], streaming: reply);
}

class _UserMessage extends StatelessWidget {
  const _UserMessage({required this.chat, required this.entry, required this.forCapture});

  final OpenChat? chat;
  final LlmEntry entry;
  final bool forCapture;

  @override
  Widget build(BuildContext context) {
    final m = entry.message!;
    final images = _imagesOf(m);
    final chat = this.chat;
    final scheme = context.theme.colorScheme;
    return LayoutBuilder(
      builder: (context, cons) {
        final maxWidth = cons.maxWidth * 0.86 < 560 ? cons.maxWidth * 0.86 : 560.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  alignment: WrapAlignment.end,
                  children: [for (final i in images) _ImageThumb(data: i.$1)],
                ),
              ),
            if (m.text.isNotEmpty)
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: CardX.borderRadius,
                ),
                child: forCapture
                    ? Text(m.text, style: const TextStyle(fontSize: 14, height: 1.5))
                    : SelectableText(m.text, style: const TextStyle(fontSize: 14, height: 1.5)),
              ),
            if (!forCapture && chat != null) ...[
              const SizedBox(height: 2),
              _actions(context, chat, m),
            ],
          ],
        );
      },
    );
  }

  Widget _actions(BuildContext context, OpenChat chat, LlmMessage m) {
    final versions = chat.versionsOf(entry);
    final idx = versions.indexWhere((e) => e.id == entry.id);
    return chat.running.listenVal((running) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (versions.length > 1) ...[
            _SmallBtn(
              Icons.chevron_left,
              libL10n.previous,
              idx > 0 && !running ? () => Chats.switchTo(chat.id, versions[idx - 1]) : null,
            ),
            Text('${idx + 1}/${versions.length}', style: _tabular12),
            _SmallBtn(
              Icons.chevron_right,
              libL10n.next,
              idx < versions.length - 1 && !running ? () => Chats.switchTo(chat.id, versions[idx + 1]) : null,
            ),
          ],
          _SmallBtn(Icons.content_copy, libL10n.copy, () {
            Pfs.copy(m.text);
            Toast.show(l10n.copied);
          }),
          if (!running) ...[
            _SmallBtn(Icons.edit_outlined, libL10n.edit, () => _edit(context, chat)),
            _SmallBtn(Icons.refresh, l10n.regenerate, () => Chats.regenerate(chat.id, entry)),
          ],
        ],
      );
    });
  }

  Future<void> _edit(BuildContext context, OpenChat chat) async {
    final ctrl = TextEditingController(text: entry.message!.text);
    final text = await context.showRoundDialog<String>(
      title: libL10n.edit,
      child: SizedBox(width: 500, child: Input(controller: ctrl, maxLines: 10, minLines: 3, autoFocus: true)),
      actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
    );
    ctrl.dispose();
    if (text == null || text.trim().isEmpty) return;
    await Chats.edit(chat.id, entry, text);
  }
}

/// One reply: its thinking, the tools it called, what it said, and a footer.
class _Reply extends StatelessWidget {
  const _Reply({required this.entries, this.chat, this.streaming, this.live = false, this.forCapture = false});

  final List<LlmEntry> entries;
  final OpenChat? chat;
  final StreamingReply? streaming;
  final bool live;
  final bool forCapture;

  @override
  Widget build(BuildContext context) {
    final results = <String, LlmMessage>{};
    for (final e in entries) {
      final m = e.message;
      if (m?.role == 'toolResult') results[m!.json['toolCallId'] as String? ?? ''] = m;
    }
    final called = <String>{};
    final children = <Widget>[];
    LlmMessage? last;
    for (final e in entries) {
      final m = e.message;
      if (m == null) continue;
      if (m.role == 'toolResult') {
        // Drawn with its call; one whose call is not in this block alone.
        final id = m.json['toolCallId'] as String? ?? '';
        if (!called.contains(id)) {
          children.add(_ToolCard(name: m.json['toolName'] as String? ?? '?', args: const {}, result: m));
        }
        continue;
      }
      last = m;
      if (m.thinking.isNotEmpty && !forCapture) {
        // Measured while it streamed; else, a step that only thought and
        // called tools took as long as its message was open.
        final ms = chat?.thoughtMs[e.id] ??
            (m.text.isEmpty && m.json['timestamp'] is int ? e.timestamp - (m.json['timestamp'] as int) : null);
        children.add(_Thinking(
          label: ms == null || ms <= 0 ? l10n.thought : l10n.thoughtForFmt(formatSeconds(ms)),
          text: m.thinking,
        ));
      }
      for (final c in m.toolCalls) {
        final id = c['id'] as String? ?? '';
        called.add(id);
        children.add(_ToolCard(
          name: c['name'] as String? ?? '?',
          args: (c['arguments'] as Map?)?.cast<String, Object?>() ?? const {},
          result: results[id],
        ));
      }
      if (m.text.isNotEmpty) children.add(ChatMarkdown(m.text, forCapture: forCapture));
      if (m.stopReason == 'aborted') children.add(Text(libL10n.stopped, style: UIs.text13Grey));
      if (m.stopReason == 'error' && (m.errorMessage ?? '').isNotEmpty) {
        children.add(Text(m.errorMessage!, style: TextStyle(fontSize: 13, color: context.theme.colorScheme.error)));
      }
    }
    final s = streaming;
    if (s != null) {
      if (s.thinking.isNotEmpty) {
        children.add(_Thinking(label: libL10n.thinking, text: s.thinking, open: s.text.isEmpty));
      }
      for (final t in s.tools) {
        children.add(_ToolCard(name: t, args: const {}, running: true));
      }
      if (s.text.isNotEmpty) children.add(ChatMarkdown(s.text));
      if (s.text.isEmpty && s.thinking.isEmpty && s.tools.isEmpty) {
        children.add(const SizedLoading(20, padding: 3, builder: SizedLoading.circularBuilder));
      }
    } else if (last != null && !live && !forCapture) {
      children.add(_footer(context));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children.joinWith(const SizedBox(height: 9)));
  }

  Widget _footer(BuildContext context) {
    final texts = <String>[];
    var tokens = 0;
    String? model;
    for (final e in entries) {
      final m = e.message;
      if (m?.role != 'assistant') continue;
      if (m!.text.isNotEmpty) texts.add(m.text);
      if (m.usage?['totalTokens'] case final int t) tokens += t;
      final id = m.json['model'] as String?;
      final provider = m.json['provider'] as String?;
      if (id != null) model = (provider == null ? null : Llm.info(LlmModelRef(provider, id))?.name) ?? id;
    }
    return DefaultTextStyle.merge(
      style: _tabular12,
      child: Row(
        children: [
          if (texts.isNotEmpty)
            _SmallBtn(Icons.content_copy, libL10n.copy, () {
              Pfs.copy(texts.join('\n\n'));
              Toast.show(l10n.copied);
            }),
          if (tokens > 0) Text(l10n.tokensFmt(NumberFormat.decimalPattern(l10n.localeName).format(tokens))),
          if (tokens > 0 && model != null) const Text('·'),
          if (model != null) Flexible(child: Text(model, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ].joinWith(const SizedBox(width: 5)),
      ),
    );
  }
}

/// A tool the reply called: what, with what, and how it went. Opens to the
/// result.
class _ToolCard extends StatefulWidget {
  const _ToolCard({required this.name, required this.args, this.result, this.running = false});

  final String name;
  final Map<String, Object?> args;
  final LlmMessage? result;
  final bool running;

  @override
  State<_ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<_ToolCard> {
  var _open = false;

  static IconData iconOf(String name) => switch (Tools.internal(name)) {
    TfHttpReq() => Icons.language,
    TfHistory() => Icons.history,
    TfMemory() => Icons.psychology_alt_outlined,
    _ => Icons.extension_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;
    final result = widget.result;
    final failed = result?.json['isError'] == true;
    final summary = widget.args.isEmpty ? '' : Tools.summaryOf(widget.name, widget.args);
    final Widget state = widget.running || result == null
        ? const SizedLoading(17, padding: 1, builder: SizedLoading.circularBuilder)
        : Icon(
            failed ? Icons.error : Icons.check_circle,
            size: 17,
            color: failed ? StateColors.failed : StateColors.running,
          );
    final text = result?.text ?? '';
    final details = (result?.json['details'] as Map?)?.cast<String, Object?>();
    final facts = [
      if (details?['status'] case final Object status) '$status',
      if (details?['ms'] case final int ms) formatSeconds(ms),
    ].join(' · ');
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(9),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: text.isEmpty ? null : () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(iconOf(widget.name), size: 19, color: scheme.onSurfaceVariant),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Tools.labelOf(widget.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w500),
                          ),
                          if (summary.isNotEmpty)
                            Text(
                              summary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _mono12.copyWith(color: UIs.textGrey.color),
                            ),
                        ],
                      ),
                    ),
                    if (facts.isNotEmpty) Text(facts, style: _tabular12),
                    state,
                  ].joinWith(const SizedBox(width: 11)),
                ),
                if (_open && text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 9),
                    child: SelectableText(text.length > 20000 ? '${text.substring(0, 20000)}\n…' : text, style: _mono12),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Thinking — or a summary: a line that opens to the text under it.
class _Thinking extends StatefulWidget {
  const _Thinking({required this.label, required this.text, this.open = false, this.icon = Icons.psychology_outlined});

  final String label;
  final String text;
  final bool open;
  final IconData icon;

  @override
  State<_Thinking> createState() => _ThinkingState();
}

class _ThinkingState extends State<_Thinking> {
  late var _open = widget.open;

  @override
  void didUpdateWidget(covariant _Thinking old) {
    super.didUpdateWidget(old);
    // Closes by itself once the answer starts, unless the user opened it.
    if (old.open && !widget.open) _open = false;
  }

  @override
  Widget build(BuildContext context) {
    final grey = UIs.textGrey.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () => setState(() => _open = !_open),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(widget.icon, size: 19, color: grey),
              Text(widget.label, style: TextStyle(fontSize: 13, color: grey)),
              Icon(_open ? Icons.expand_more : Icons.chevron_right, size: 17, color: grey),
            ].joinWith(const SizedBox(width: 7)),
          ),
        ),
        if (_open)
          Padding(
            padding: const EdgeInsets.only(left: 26, top: 9),
            child: ChatMarkdown(widget.text, muted: true),
          ),
      ],
    );
  }
}

/// A tool call waiting on the user, where the reply stopped for it.
class ApprovalCard extends StatelessWidget {
  const ApprovalCard({super.key, required this.chatId, required this.pending});

  final String chatId;
  final PendingApproval pending;

  @override
  Widget build(BuildContext context) {
    final scheme = context.theme.colorScheme;
    final call = pending.call;
    final detail = call.args.isEmpty ? call.name : Tools.summaryOf(call.name, call.args);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: scheme.surfaceContainerHigh, borderRadius: CardX.borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.gpp_maybe_outlined, size: 20, color: scheme.primary),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    l10n.allowToolFmt(Tools.labelOf(call.name)),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(9)),
              child: SelectableText(detail, style: _mono12.copyWith(height: 1.5)),
            ),
            Row(
              children: [
                Expanded(child: Text(l10n.replyWaits, style: UIs.text12Grey)),
                Btn.text(text: l10n.deny, onTap: () => Chats.answer(chatId, ApprovalAnswer.deny)),
                Btn.text(text: l10n.allowAlways, onTap: () => Chats.answer(chatId, ApprovalAnswer.always)),
                Btn.text(text: l10n.allow, onTap: () => Chats.answer(chatId, ApprovalAnswer.once)),
              ].joinWith(const SizedBox(width: 3)),
            ),
          ].joinWith(const SizedBox(height: 9)),
        ),
      ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  const _SmallBtn(this.icon, this.tip, this.onTap);

  final IconData icon;
  final String tip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Btn.icon(icon: Icon(icon, size: 17), text: tip, onTap: onTap);
}

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    final bytes = base64Decode(data);
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () => showDialog<void>(
        context: context,
        builder: (ctx) => GestureDetector(
          onTap: () => Navigator.of(ctx).pop(),
          child: InteractiveViewer(child: Image.memory(bytes)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(width: 120, height: 120, child: Image.memory(bytes, fit: BoxFit.cover)),
      ),
    );
  }
}

/// `0.4 s`, `6 s`, `1 min 5 s`.
String formatSeconds(int ms) {
  final s = ms / 1000;
  if (s < 10) return l10n.secondsFmt(s.toStringAsFixed(1).replaceFirst(RegExp(r'\.0$'), ''));
  if (s < 60) return l10n.secondsFmt('${s.round()}');
  return l10n.minutesSecondsFmt(s ~/ 60, (s % 60).round());
}

final _mono12 = Mono.style(height: 16 / 12);
final _tabular12 = UIs.text12Grey.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

List<(String, String)> _imagesOf(LlmMessage m) {
  final c = m.json['content'];
  if (c is! List) return const [];
  return [
    for (final p in c.whereType<Map>())
      if (p['type'] == 'image') (p['data'] as String, p['mimeType'] as String? ?? 'image/png'),
  ];
}

/// The user's avatar, for the few places that show one.
String get userAvatar => Stores.setting.avatar.get();
