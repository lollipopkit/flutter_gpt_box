import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
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
  final _store = Stores.setting;

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
        _buildTitle('Conversation'),
        _buildConversation(),
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
    final children = [
      _buildThemeMode(),
    ];
    return Column(
      children: children.map((e) => CardX(child: e)).toList(),
    );
  }

  Widget _buildThemeMode() {
    return ListTile(
      title: const Text('Theme Mode'),
      onTap: () async {
        final result = await context.showPickSingleDialog(
          items: ThemeMode.values,
          name: (e) => e.name,
        );
        if (result != null) {
          _store.themeMode.put(result.index);
          RebuildNode.app.rebuild();
        }
      },
      trailing: Text(
        ThemeMode.values[_store.themeMode.fetch()].name,
      ),
    );
  }

  Widget _buildConversation() {
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
      title: const Text('Secret Key'),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () => context.showRoundDialog(
        title: 'Edit OpenAI Key',
        child: Input(
          controller: ctrl,
          hint: 'sk-...',
          onSubmitted: (p0) {
            _store.openaiApiKey.put(p0);
            OpenAI.apiKey = p0;
          },
        ),
      ),
    );
  }

  Widget _buildOpenAIUrl() {
    final ctrl =
        TextEditingController(text: Stores.setting.openaiApiUrl.fetch());
    return ListTile(
      title: const Text('API Url'),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () => context.showRoundDialog(
        title: 'Edit URL',
        child: Input(
          controller: ctrl,
          hint: 'https://api.openai.com/v1',
          onSubmitted: (p0) {
            _store.openaiApiUrl.put(p0);
            OpenAI.baseUrl = p0;
          },
        ),
      ),
    );
  }

  Widget _buildOpenAIModel() {
    return ListTile(
      title: const Text('Model'),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () async {
        if (_store.openaiApiKey.fetch().isEmpty) {
          context.showRoundDialog(
            title: 'Please input OpenAI Key first.',
          );
          return;
        }
        context.showLoadingDialog();
        final models = await OpenAI.instance.model.list();
        context.pop();
        final model = await context.showRoundDialog<String>(
          title: 'Select',
          child: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: models.length,
              itemBuilder: (_, idx) {
                final item = models[idx];
                return ListTile(
                  title: Text(item.id),
                  onTap: () => context.pop(item.id),
                );
              },
            ),
          ),
        );

        if (model != null) {
          _store.openaiModel.put(model);
        }
      },
    );
  }
}
