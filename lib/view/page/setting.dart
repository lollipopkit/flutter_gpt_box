import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, Never? args});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Settings'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      children: [
        _buildTitle('App'),
        _buildApp(),
        _buildTitle('OpenAI'),
        _buildOpenAI(),
        const SizedBox(height: 37),
      ],
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 23, bottom: 17),
      child: Center(
        child: Text(
          text,
          style: UIs.textGrey,
        ),
      ),
    );
  }

  Widget _buildApp() {
    final children = [];
    return Column(
      children: children.map((e) => CardX(child: e)).toList(),
    );
  }

  Widget _buildOpenAI() {
    final children = [
      _buildOpenAIKey(),
      _buildOpenAIUrl(),
      _buildOpenAIModel(),
    ];
    return Column(
      children: children.map((e) => CardX(child: e)).toList(),
    );
  }

  Widget _buildOpenAIKey() {
    final ctrl =
        TextEditingController(text: Stores.setting.openaiApiKey.fetch());
    return ListTile(
      title: const Text('Key'),
      trailing: const Icon(Icons.edit),
      onTap: () => context.showRoundDialog(
        title: 'Edit OpenAI Key',
        child: Input(
          controller: ctrl,
          hint: 'sk-...',
          onSubmitted: (p0) {
            Stores.setting.openaiApiKey.put(p0);
            OpenAI.apiKey = p0;
          },
        ),
      )
    );
  }

  Widget _buildOpenAIUrl() {
    final ctrl =
        TextEditingController(text: Stores.setting.openaiApiUrl.fetch());
    return ListTile(
      title: const Text('URL'),
      trailing: const Icon(Icons.edit),
      onTap: () => context.showRoundDialog(
        title: 'Edit OpenAI URL',
        child: Input(
          controller: ctrl,
          hint: 'https://api.openai.com/v1',
          onSubmitted: (p0) {
            Stores.setting.openaiApiUrl.put(p0);
            OpenAI.baseUrl = p0;
          },
        ),
      )
    );
  }

  Widget _buildOpenAIModel() {
    final ctrl =
        TextEditingController(text: Stores.setting.openaiModel.fetch());
    return ListTile(
      title: const Text('Model'),
      trailing: const Icon(Icons.edit),
      onTap: () => context.showRoundDialog(
        title: 'Edit OpenAI Model',
        child: Input(
          controller: ctrl,
          hint: '...',
          onSubmitted: (p0) {
            Stores.setting.openaiModel.put(p0);
          },
        ),
      )
    );
  }
}
