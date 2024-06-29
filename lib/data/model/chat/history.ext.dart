import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/model/chat/history.dart';
import 'package:gpt_box/view/widget/audio.dart';
import 'package:gpt_box/view/widget/code.dart';
import 'package:gpt_box/view/widget/image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';

final class ChatRoleTitle extends StatelessWidget {
  final ChatRole role;

  const ChatRoleTitle._({required this.role});

  static final _cache = <ChatRole, ChatRoleTitle>{};

  factory ChatRoleTitle(ChatRole role) {
    return _cache.putIfAbsent(role, () => ChatRoleTitle._(role: role));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final text = Text(
      role.localized,
      style: const TextStyle(fontSize: 15),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: isDark
            ? const Color.fromARGB(37, 203, 203, 203)
            : const Color.fromARGB(29, 84, 84, 84),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: role.color,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          ),
          const SizedBox(width: 5),
          Transform.translate(offset: const Offset(0, -0.8), child: text),
        ],
      ),
    );
  }
}

final class ChatHistoryContentView extends StatelessWidget {
  final ChatHistoryItem chatItem;
  final List<String> loadingToolReplies;

  const ChatHistoryContentView._(
      {required this.chatItem, required this.loadingToolReplies});

  static final _cache = <ChatHistoryItem, ChatHistoryContentView>{};

  factory ChatHistoryContentView(
    ChatHistoryItem chatItem,
    List<String> loadingToolReplies,
  ) =>
      _cache.putIfAbsent(
          chatItem,
          () => ChatHistoryContentView._(
                chatItem: chatItem,
                loadingToolReplies: loadingToolReplies,
              ));

  @override
  Widget build(BuildContext context) {
    if (loadingToolReplies.contains(chatItem.id)) {
      return const LinearProgressIndicator();
    }

    if (chatItem.role.isTool) {
      return Text(
        chatItem.toMarkdown,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: chatItem.content
          .map((e) => switch (e.type) {
                ChatContentType.audio => _buildAudio(e),
                ChatContentType.image => _buildImage(e),
                _ => _buildText(context, e),
              })
          .toList()
          .joinWith(UIs.height13),
    );
  }

  Widget _buildText(BuildContext context, ChatContent content) {
    return MarkdownBody(
      data: content.raw,
      builders: {
        'code': CodeElementBuilder(onCopy: Pfs.copy),
        'latex': LatexElementBuilder(),
      },
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        codeblockDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      extensionSet: MarkdownUtils.extensionSet,
      onTapLink: MarkdownUtils.onLinkTap,
      shrinkWrap: false,

      /// Keep it false, or the ScrollView's height calculation will be wrong.
      fitContent: false,

      /// User experience is better when this is false.
      selectable: false,
    );
  }

  Widget _buildImage(ChatContent content) {
    return ImageCard(
      imageUrl: content.raw,
      heroTag: content.hashCode.toString(),
    );
  }

  Widget _buildAudio(ChatContent content) {
    return AudioCard(id: content.id, path: content.raw);
  }
}
