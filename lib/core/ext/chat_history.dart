import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/util/markdown.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/res/build.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/code.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';

extension ChatHistoryShare on ChatHistory {
  Widget gen4Share(BuildContext context) {
    final children = <Widget>[];
    for (final item in items) {
      children.add(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.grey,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        child: Text(
          item.role.localized,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ));
      children.add(UIs.height13);
      children.add(MarkdownBody(
        data: item.toMarkdown,
        extensionSet: MarkdownUtils.extensionSet,
        builders: {
          'code': CodeElementBuilder(isForCapture: true),
          'latex': LatexElementBuilder(),
        },
      ));
      children.add(UIs.height13);
    }
    final widget = InheritedTheme.captureAll(
      context,
      Material(
        color: UIs.bgColor.fromBool(RNode.dark.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name ?? l10n.untitled,
                style:
                    const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              UIs.height13,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
              UIs.height13,
              Text(
                '${l10n.shareFrom} GPT Box v1.0.${Build.build}',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return widget;
  }
}
