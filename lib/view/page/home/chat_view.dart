import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/view/page/home/chat_list.dart';
import 'package:gpt_box/view/page/home/share.dart';
import 'package:gpt_box/view/widget/transitions.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';

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
                  : LlmConversation(key: ValueKey(id), chatId: id),
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
    return LlmStores.chat.changes.listen(() => _build(context, id));
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
              if (LlmStores.chat.fetch(id) case final meta?)
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
      listenable: Listenable.merge([Chats.current, LlmStores.chat.changes, Llm.providers]),
      builder: (context, _) {
        final id = Chats.current.value;
        final meta = id == null ? null : LlmStores.chat.fetch(id);
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
