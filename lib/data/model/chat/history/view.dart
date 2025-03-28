import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/view/widget/code.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';

final class ChatRoleTitle extends StatelessWidget {
  final ChatRole role;
  final bool loading;

  const ChatRoleTitle({
    required this.role,
    required this.loading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final text = Text(
      role.localized,
      style: const TextStyle(fontSize: 15),
    );
    final label = Container(
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
    if (!loading) return label;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        label,
        UIs.width13,
        const SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}

final class ChatHistoryContentView extends StatelessWidget {
  final ChatHistoryItem chatItem;

  const ChatHistoryContentView({
    required this.chatItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (chatItem.role.isTool) {
      final md = chatItem.toMarkdown;
      final text = Text(
        md,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: UIs.textGrey,
      );
      return text;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: chatItem.content
          .map((e) => switch (e.type) {
                // ChatContentType.audio => _buildAudio(e),
                ChatContentType.image => _buildImage,
                ChatContentType.file => _buildFile,
                _ => _buildText,
              }(context, e))
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
      styleSheet: MarkdownStyleSheet.fromTheme(context.theme).copyWith(
        a: TextStyle(color: UIs.primaryColor),
      ),
      extensionSet: MarkdownUtils.extensionSet,
      onTapLink: MarkdownUtils.onLinkTap,
      shrinkWrap: false,
      // Keep it false, or the ScrollView's height calculation will be wrong.
      fitContent: false,
      // User experience is better when this is false.
      selectable: isDesktop,
    );
  }

  Widget _buildImage(BuildContext context, ChatContent content) {
    return ImageCard(
      key: ValueKey(content.hashCode),
      imageUrl: content.raw,
      heroTag: content.hashCode.toString(),
      onRet: (ret) => _onImgRet(ret, content.raw),
    );
  }

  Widget _buildFile(BuildContext context, ChatContent content) {
    return FileCardView(
      path: content.raw,
    );
  }

  // Widget _buildAudio(ChatContent content) {
  //   return AudioCard(id: content.id, path: content.raw);
  // }

  void _onImgRet(ImagePageRet ret, String raw) async {
    if (ret.isDeleted) {
      FileApi.delete([raw]);
    }
  }
}
