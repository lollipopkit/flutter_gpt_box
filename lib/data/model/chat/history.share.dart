import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/model/chat/history.dart';
import 'package:gpt_box/data/model/chat/history.view.dart';
import 'package:gpt_box/data/res/build.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/rnode.dart';
import 'package:gpt_box/view/widget/code.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';

extension ChatHistoryShare on ChatHistory {
  Widget gen4Share(BuildContext context) {
    final children = <Widget>[];
    for (final item in items) {
      final md = switch (item.role) {
        ChatRole.tool => Text(
            item.toMarkdown,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        _ => MarkdownBody(
            data: item.toMarkdown,
            extensionSet: MarkdownUtils.extensionSet,
            builders: {
              'code': CodeElementBuilder(isForCapture: true),
              'latex': LatexElementBuilder(),
            },
            fitContent: false,
            selectable: false,
            shrinkWrap: false,
          ),
      };
      children.add(ChatRoleTitle(role: item.role, loading: false));
      children.add(UIs.height13);
      children.add(md);
      children.add(UIs.height13);
    }
    final widget = InheritedTheme.captureAll(
      context,
      Material(
        color: UIs.bgColor.fromBool(RNodes.dark.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name ?? l10n.untitled,
                textAlign: TextAlign.center,
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
