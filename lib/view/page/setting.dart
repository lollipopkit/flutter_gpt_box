import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerWidget {
  final Never? args;
  const SettingPage({super.key, this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('GPT'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Setting Page'),
          ],
        ),
      ),
    );
  }
}
