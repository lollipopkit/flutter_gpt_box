import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/color.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/string.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_chatgpt/view/widget/color_picker.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';
import 'package:flutter_chatgpt/view/widget/switch.dart';

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
      _buildColorSeed(),
      _buildThemeMode(),
      _buildScrollBottom(),
    ];
    return Column(
      children: children.map((e) => CardX(child: e)).toList(),
    );
  }

  Widget _buildThemeMode() {
    return ValueListenableBuilder(
      valueListenable: _store.themeMode.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.sunny),
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
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(
          ThemeMode.values[val].name,
          style: UIs.text13Grey,
        ),
      ),
    );
  }

  Widget _buildColorSeed() {
    return ValueListenableBuilder(
      valueListenable: _store.themeColorSeed.listenable(),
      builder: (_, val, __) {
        final primaryColor = Color(val);
        return ListTile(
          leading: const Icon(Icons.colorize),
          title: const Text('Theme color seed'),
          subtitle: Text(
            primaryColor.toHex,
            style: UIs.text13Grey,
          ),
          trailing: ClipOval(
            child: Container(color: primaryColor, height: 27, width: 27),
          ),
          onTap: () async {
            final ctrl = TextEditingController(text: primaryColor.toHex);
            await context.showRoundDialog(
              title: 'Select',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Input(
                    onSubmitted: _onSaveColor,
                    controller: ctrl,
                    hint: '#8b2252',
                    icon: Icons.colorize,
                  ),
                  ColorPicker(
                    color: primaryColor,
                    onColorChanged: (c) => ctrl.text = c.toHex,
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => _onSaveColor(ctrl.text),
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onSaveColor(String s) {
    final color = s.hexToColor;
    if (color == null) {
      context.showSnackBar('Invalid color code: $s');
      return;
    }
    // Change [primaryColor] first, then change [_selectedColorValue],
    // So the [ValueBuilder] will be triggered with the new value
    _store.themeColorSeed.put(color.value);
    context.pop();
    RebuildNode.app.rebuild();
  }

  Widget _buildScrollBottom() {
    return ListTile(
      leading: const Icon(Icons.keyboard_arrow_down),
      title: const Text('Auto scroll to bottom'),
      subtitle: const Text('Restart app to take effect', style: UIs.textGrey),
      trailing: StoreSwitch(
        prop: _store.scrollBottom,
      ),
    );
  }

  Widget _buildConversation() {
    final children = [
      _buildOpenAIKey(),
      _buildOpenAIUrl(),
      _buildOpenAIModel(),
      _buildPrompt(),
      _buildHistoryLength(),
    ];
    return Column(
      children: children.map((e) => CardX(child: e)).toList(),
    );
  }

  Widget _buildOpenAIKey() {
    return ValueListenableBuilder(
      valueListenable: _store.openaiApiKey.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.vpn_key),
        title: const Text('Secret Key'),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(val, style: UIs.text13Grey),
        onTap: () async {
          final ctrl = TextEditingController(text: val);
          final result = await context.showRoundDialog<String>(
            title: 'Edit Key',
            child: Input(
              controller: ctrl,
              hint: 'sk-xxx',
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: const Text('Ok'),
              ),
            ],
          );
          if (result == null) return;
          _store.openaiApiKey.put(result);
          OpenAI.apiKey = result;
        },
      ),
    );
  }

  Widget _buildOpenAIUrl() {
    return ValueListenableBuilder(
      valueListenable: _store.openaiApiUrl.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.link),
        title: const Text('API Url'),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(val, style: UIs.text13Grey),
        onTap: () async {
          final ctrl = TextEditingController(text: val);
          final result = await context.showRoundDialog<String>(
            title: 'Edit URL',
            child: Input(
              controller: ctrl,
              hint: 'https://api.openai.com/v1',
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: const Text('Ok'),
              ),
            ],
          );
          if (result == null) return;
          _store.openaiApiUrl.put(result);
          OpenAI.baseUrl = result;
        },
      ),
    );
  }

  Widget _buildOpenAIModel() {
    return ValueListenableBuilder(
      valueListenable: _store.openaiModel.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.model_training),
        title: const Text('Model'),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(
          val,
          style: UIs.text13Grey,
        ),
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
      ),
    );
  }

  Widget _buildPrompt() {
    return ValueListenableBuilder(
      valueListenable: _store.prompt.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.text_fields),
        title: const Text('Prompt'),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(val.isEmpty ? 'Empty' : val, style: UIs.text13Grey),
        onTap: () async {
          final ctrl = TextEditingController(text: val);
          final result = await context.showRoundDialog<String>(
            title: 'Edit Prompt',
            child: Input(
              controller: ctrl,
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: const Text('Ok'),
              ),
            ],
          );
          if (result == null) return;
          _store.prompt.put(result);
        },
      ),
    );
  }

  Widget _buildHistoryLength() {
    return ValueListenableBuilder(
      valueListenable: _store.historyLength.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.history),
        title: const Text('History Length'),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(
          val.toString(),
          style: UIs.text13Grey,
        ),
        onTap: () async {
          final ctrl = TextEditingController(text: val.toString());
          final result = await context.showRoundDialog<String>(
            title: 'History Length',
            child: Input(
              controller: ctrl,
              hint: '7',
              type: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: const Text('Ok'),
              ),
            ],
          );
          if (result == null) return;
          final newVal = int.tryParse(result);
          if (newVal == null) {
            context.showSnackBar('Invalid number: $result');
            return;
          }
          _store.historyLength.put(newVal);
        },
      ),
    );
  }
}
