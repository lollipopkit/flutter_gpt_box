import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerWidget {
  final Never? args;

  const ChatPage({super.key, this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Text('Chat Page'),
      ),
    );
  }

  static bool hasCfgApi<T>(MiddlewareArgs args) {
    final ok = Stores.setting.openaiApiKey.fetch().isNotEmpty;
    if (!ok) {
      args.context.showRoundDialog(
        title: 'Missing API Key',
        child: const Text('Please set your OpenAI API key first.'),
        actions: [
          TextButton(
            onPressed: () {
              args.context.pop();
              Routes.setting.go(args.context);
            },
            child: const Text('Setup'),
          ),
        ],
      );
    }
    return ok;
  }
}
