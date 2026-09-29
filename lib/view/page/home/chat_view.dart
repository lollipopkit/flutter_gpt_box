import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/composer.dart';
import 'package:gpt_box/view/page/home/message.dart';

/// The conversation on screen and the composer under it.
class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Chats.current.listenVal((id) {
      return Column(
        children: [
          Expanded(
            child: id == null
                ? EmptyPane(icon: Icons.chat_bubble_outline, title: l10n.newChat, label: l10n.startChatTip)
                : _Conversation(key: ValueKey(id), chatId: id),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 5, 11, 11),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Composer(
                  key: ValueKey(id),
                  chatId: id,
                  onChatCreated: (id) => Chats.current.value = id,
                ),
              ),
            ),
          ),
        ],
      );
    });
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
      _jumpToEnd();
    }, onError: (_) {});
  }

  @override
  void dispose() {
    _open.then((c) {
      c.streaming.removeListener(_follow);
      c.entries.removeListener(_follow);
    }, onError: (_) {});
    _scroll.dispose();
    super.dispose();
  }

  void _follow() {
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
        if (chat == null) return const Center(child: CircularProgressIndicator());
        return ListenableBuilder(
          listenable: Listenable.merge([chat.entries, chat.streaming, chat.error]),
          builder: (context, _) {
            final entries = [
              for (final e in chat.entries.value)
                if (_visible(e)) e,
            ];
            final streaming = chat.streaming.value;
            final error = chat.error.value;
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  itemCount: entries.length + (streaming == null ? 0 : 1) + (error == null ? 0 : 1),
                  itemBuilder: (_, i) {
                    if (i < entries.length) {
                      return MessageView(key: ValueKey(entries[i].id), chat: chat, entry: entries[i]);
                    }
                    if (streaming != null && i == entries.length) return StreamingView(reply: streaming);
                    return Padding(
                      padding: const EdgeInsets.all(13),
                      child: Text('❌ $error', style: TextStyle(color: context.theme.colorScheme.error)),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  static bool _visible(LlmEntry e) => switch (e.type) {
    'message' => const {'user', 'assistant', 'toolResult'}.contains(e.message?.role),
    'compaction' || 'branch_summary' => true,
    _ => false,
  };
}
