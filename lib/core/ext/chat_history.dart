import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/res/build.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/code.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

extension ChatHistoryShare on ChatHistory {
  (Widget, String) gen4Share(bool isDark) {
    final mdContent = items
        .map((e) => '##### ${e.role.toSingleChar}${e.toMarkdown}')
        .join('\n\n');
    final widget = Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: isDark ? Colors.black : Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name ?? l10n.untitled,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          UIs.height13,
          MarkdownBody(
            data: mdContent,
            shrinkWrap: true,
            builders: {
              'code': CodeElementBuilder(),
            },
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
    );
    return (widget, mdContent);
  }
}