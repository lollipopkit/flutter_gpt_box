import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/chat_list.dart';
import 'package:gpt_box/view/page/home/composer.dart';
import 'package:gpt_box/view/page/home/message.dart';
import 'package:gpt_box/view/page/home/share.dart';
import 'package:gpt_box/view/widget/menu.dart';
import 'package:gpt_box/view/widget/transitions.dart';

/// The chat on screen: its title row (on a wide window), the thread and the
/// composer.
class ChatPane extends StatelessWidget {
  const ChatPane({super.key, this.compact = false});

  /// On a phone: the title is the home page's top bar.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Chats.current.listenVal((id) {
      return Column(
        children: [
          if (!compact) _Header(chatId: id),
          Expanded(
            child: FadeThroughSwitcher(
              child: id == null
                  ? EmptyPane(
                      key: const ValueKey('empty'),
                      icon: Icons.chat_bubble_outline,
                      title: l10n.newChat,
                      label: l10n.startChatTip,
                    )
                  : _Conversation(key: ValueKey(id), chatId: id),
            ),
          ),
          LayoutBuilder(
            builder: (context, cons) {
              final side = (cons.maxWidth * 0.03).clamp(9.0, 20.0);
              return SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(side, 0, side, 13),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Composer(
                      key: ValueKey(id),
                      chatId: id,
                      compact: compact,
                      onChatCreated: (id) => Chats.current.value = id,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.chatId});

  final String? chatId;

  @override
  Widget build(BuildContext context) {
    final id = chatId;
    // The menu's actions carry the meta: kept current with a rename.
    return Stores.chat.changes.listen(() => _build(context, id));
  }

  Widget _build(BuildContext context, String? id) {
    return SizedBox(
      height: 54,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 9, 0),
        child: Row(
          children: [
            const Expanded(child: ChatTitle()),
            if (id != null) ...[
              Btn.icon(icon: const Icon(Icons.ios_share, size: 18), text: l10n.share, onTap: () => shareChat(context, id)),
              if (Stores.chat.fetch(id) case final meta?)
                MenuBtn(
                  actions: chatActions(context, meta),
                  builder: (toggle) => Btn.icon(icon: const Icon(Icons.more_vert, size: 18), text: l10n.more, onTap: toggle),
                ),
            ],
          ].joinWith(const SizedBox(width: 3)),
        ),
      ),
    );
  }
}

/// The chat's name, a spinner while it replies, and under it the model — and
/// how long the chat is, when [center] is off.
class ChatTitle extends StatelessWidget {
  const ChatTitle({super.key, this.center = false});

  /// Centred in a phone's top bar, with only the model under it.
  final bool center;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([Chats.current, Stores.chat.changes, Llm.providers]),
      builder: (context, _) {
        final id = Chats.current.value;
        final meta = id == null ? null : Stores.chat.fetch(id);
        final model = meta?.model ?? Llm.defaultModel;
        final modelName = Llm.info(model)?.name ?? model?.id ?? '';
        final title = id == null ? l10n.newChat : meta?.title ?? l10n.untitled;
        if (id == null) return _build(title, modelName, running: false);
        Widget live(OpenChat chat) => ListenableBuilder(
          listenable: Listenable.merge([chat.running, chat.entries]),
          builder: (_, _) {
            final n = threadBlocks(chat.entries.value).where((b) => b is! SummaryBlock).length;
            final sub = center || n == 0 ? modelName : '$modelName · ${l10n.messagesCountFmt(n)}';
            return _build(title, sub, running: chat.running.value);
          },
        );
        if (Chats.openOf(id) case final chat?) return live(chat);
        // The thread opens it; until then, what the list knows.
        return FutureBuilder<OpenChat>(
          future: Chats.open(id),
          builder: (_, snap) => snap.data == null ? _build(title, modelName, running: false) : live(snap.data!),
        );
      },
    );
  }

  Widget _build(String title, String sub, {required bool running}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w500),
              ),
            ),
            if (running) ...[
              const SizedBox(width: 7),
              const SizedLoading(20, padding: 3, builder: SizedLoading.circularBuilder),
            ],
          ],
        ),
        if (sub.isNotEmpty) Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: UIs.text12Grey),
      ],
    );
  }
}

class _Conversation extends StatefulWidget {
  const _Conversation({super.key, required this.chatId});

  final String chatId;

  @override
  State<_Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<_Conversation> {
  late final Future<OpenChat> _open = Chats.open(widget.chatId);
  final _scroll = ScrollController();

  /// Whether the view is at the bottom, and so follows new content.
  var _atBottom = true;

  /// The last entry seen: a new message from the user scrolls down to it
  /// wherever the view was.
  String? _lastEntry;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (!_scroll.hasClients) return;
      _atBottom = _scroll.position.pixels >= _scroll.position.maxScrollExtent - 48;
    });
    _open.then((c) {
      c.streaming.addListener(_follow);
      c.entries.addListener(_follow);
      c.approvals.addListener(_follow);
      _lastEntry = c.entries.value.lastOrNull?.id;
      if (Stores.setting.scrollAfterSwitch.get() || c.entries.value.length < 3) _jumpToEnd();
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _open.then((c) {
      c.streaming.removeListener(_follow);
      c.entries.removeListener(_follow);
      c.approvals.removeListener(_follow);
    }, onError: (_) {});
    _scroll.dispose();
    super.dispose();
  }

  void _follow() {
    final chat = Chats.openOf(widget.chatId);
    final last = chat?.entries.value.lastOrNull;
    if (last != null && last.id != _lastEntry) {
      _lastEntry = last.id;
      if (last.message?.role == 'user') {
        _jumpToEnd();
        return;
      }
    }
    if (_atBottom && Stores.setting.scrollBottom.get()) _jumpToEnd();
  }

  void _jumpToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OpenChat>(
      future: _open,
      builder: (context, snap) {
        if (snap.hasError) {
          return EmptyPane(icon: Icons.error_outline, title: libL10n.error, label: '${snap.error}');
        }
        final chat = snap.data;
        if (chat == null) return const Center(child: SizedLoading(25, builder: SizedLoading.circularBuilder));
        // Not on each streamed token: that is the last block's alone.
        return ListenableBuilder(
          listenable: Listenable.merge([chat.entries, chat.error, chat.approvals, chat.running, chat.interrupted]),
          builder: (context, _) {
            final blocks = threadBlocks(chat.entries.value);
            final error = chat.error.value;
            final pending = chat.approvals.value.firstOrNull;
            final lastIsReply = blocks.lastOrNull is ReplyBlock;
            Widget view(int i, ThreadBlock b, [StreamingReply? streaming]) => ThreadBlockView(
              key: ValueKey(switch (b) {
                UserBlock(:final entry) || SummaryBlock(:final entry) => entry.id,
                ReplyBlock(:final entries) => entries.first.id,
              }),
              chat: chat,
              block: b,
              streaming: streaming,
              live: chat.running.value && i == blocks.length - 1,
            );
            final items = <Widget>[
              for (final (i, b) in blocks.indexed)
                if (i < blocks.length - 1) view(i, b),
              // The reply being written continues the last reply, or starts
              // one under the last block.
              chat.streaming.listenVal((s) {
                final last = blocks.lastOrNull;
                final lastView = last == null ? null : view(blocks.length - 1, last, lastIsReply ? s : null);
                if (s == null || lastIsReply) return lastView ?? UIs.placeholder;
                final stream = StreamingView(reply: s);
                if (lastView == null) return stream;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [lastView, const SizedBox(height: 20), stream],
                );
              }),
              if (pending != null) ApprovalCard(chatId: chat.id, pending: pending),
              if (!chat.running.value && error != null)
                _Notice(
                  text: error,
                  color: context.theme.colorScheme.error,
                  action: libL10n.retry,
                  onTap: () => _guard(Chats.retry(chat.id)),
                )
              else if (!chat.running.value && chat.interrupted.value)
                _Notice(
                  text: l10n.replyInterrupted,
                  action: l10n.resumeReply,
                  onTap: () => _guard(Chats.resume(chat.id)),
                ),
            ];
            return LayoutBuilder(
              builder: (context, cons) {
                final side = (cons.maxWidth * 0.04).clamp(13.0, 26.0);
                return ListView.separated(
                  controller: _scroll,
                  padding: EdgeInsets.fromLTRB(side, 17, side, 26),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 20),
                  itemBuilder: (_, i) => Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: SizedBox(width: double.infinity, child: items[i]),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// A failure is a toast, not an unhandled error.
void _guard(Future<void> f) => f.catchError((Object e) {
  Loggers.app.warning('Chat', e);
  Toast.show('$e');
});

/// A line under the conversation, with what can be done about it.
class _Notice extends StatelessWidget {
  const _Notice({required this.text, required this.action, required this.onTap, this.color});

  final String text;
  final String action;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: color ?? context.theme.hintColor))),
        Btn.text(text: action, onTap: onTap),
      ],
    );
  }
}
