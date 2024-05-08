import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/markdown.dart';
import 'package:gpt_box/data/res/ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final class SimpleMarkdown extends StatelessWidget {
  final String data;
  final MarkdownStyleSheet? style;

  const SimpleMarkdown({
    super.key,
    required this.data,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      styleSheet: (style ?? MarkdownStyleSheet()).copyWith(
        a: TextStyle(color: UIs.primaryColor),
      ),
      extensionSet: MarkdownUtils.extensionSetWithoutCode,
      onTapLink: MarkdownUtils.onLinkTap,
    );
  }
}
