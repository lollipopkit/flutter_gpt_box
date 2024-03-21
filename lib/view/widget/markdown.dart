import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final class MarkdownWidget extends StatelessWidget {
  final String data;

  const MarkdownWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      styleSheet: MarkdownStyleSheet(
        a: TextStyle(color: UIs.primaryColor),
      ),
    );
  }
}
