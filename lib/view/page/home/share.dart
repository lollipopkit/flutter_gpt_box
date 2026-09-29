import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/message.dart';
import 'package:screenshot/screenshot.dart';

final _screenshot = ScreenshotController();

/// Shares the chat's current branch as an image or as markdown.
Future<void> shareChat(BuildContext context, String chatId) async {
  final type = await context.showPickSingleDialog(
    title: l10n.share,
    items: const ['img', 'md'],
    display: (p0) => p0 == 'md' ? l10n.text : l10n.image,
  );
  if (type == null || !context.mounted) return;

  final title = Stores.chat.fetch(chatId)?.title ?? l10n.untitled;
  final wasOpen = Chats.openOf(chatId) != null;
  final chat = await Chats.open(chatId);
  try {
    if (type == 'md') {
      await Pfs.shareStr('# $title\n\n${Chats.toMarkdown(chat.entries.value)}', title: title);
      return;
    }
    if (!context.mounted) return;
    final widget = InheritedTheme.captureAll(
      context,
      Material(
        color: context.theme.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 17),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              UIs.height13,
              for (final e in chat.entries.value)
                if (e.message?.role == 'user' || e.message?.role == 'assistant')
                  MessageView(chat: null, entry: e, forCapture: true),
              UIs.height13,
              Text(
                '${l10n.shareFrom} ${BuildData.name} v1.0.${BuildData.build}',
                style: const TextStyle(fontSize: 9, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
    final (pic, err) = await context.showLoadingDialog(
      fn: () => _screenshot.captureFromLongWidget(
        widget,
        context: context,
        constraints: const BoxConstraints(maxWidth: 600),
        pixelRatio: MediaQuery.devicePixelRatioOf(context),
        delay: Durations.short4,
      ),
    );
    if (err != null || pic == null) return;
    await Pfs.shareBytes(bytes: pic, title: title, fileName: '$title.png', mime: 'image/png');
  } finally {
    if (!wasOpen && !chat.running.value) await Chats.close(chatId);
  }
}
