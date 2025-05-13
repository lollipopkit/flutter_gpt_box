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

    final children = chatItem.content.map((e) {
      final fn = switch (e.type) {
        // ChatContentType.audio => _buildAudio(e),
        ChatContentType.image => _buildImage,
        ChatContentType.file => _buildFile,
        _ => _buildText,
      };
      return fn(context, e);
    }).toList();

    final reasoningContent = chatItem.reasoning;
    if (reasoningContent != null) {
      final reasoning = ExpandTile(
        title: Text(
          libL10n.thinking,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        tilePadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 0),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        children: [
          _buildMarkdown(context, reasoningContent),
        ],
      ).cardx;
      children.insert(0, reasoning);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children.joinWith(UIs.height13),
    );
  }

  Widget _buildText(BuildContext context, ChatContent content) {
    return _buildMarkdown(context, content.raw);
  }

  Widget _buildImage(BuildContext context, ChatContent content) {
    return LayoutBuilder(builder: (_, cons) {
      return ImageCard(
        key: ValueKey(content.hashCode),
        imageUrl: content.raw,
        heroTag: content.hashCode.toString(),
        onRet: (ret) => _onImgRet(ret, content.raw),
        size: cons.maxWidth / 3,
      );
    });
  }

  Widget _buildFile(BuildContext context, ChatContent content) {
    return FileCardView(
      path: content.raw,
    );
  }

  // Widget _buildAudio(ChatContent content) {
  //   return AudioCard(id: content.id, path: content.raw);
  // }

  Widget _buildMarkdown(BuildContext context, String content) {
    return MarkdownBody(
      data: content,
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
}

extension on ChatHistoryContentView {
  void _onImgRet(ImagePageRet ret, String raw) async {
    if (ret.isDeleted) {
      FileApi.delete([raw]);
    }
  }
}
