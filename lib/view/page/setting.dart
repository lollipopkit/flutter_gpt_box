import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/color.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/locale.dart';
import 'package:flutter_chatgpt/core/ext/string.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/update.dart';
import 'package:flutter_chatgpt/core/util/func.dart';
import 'package:flutter_chatgpt/data/res/build.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_chatgpt/view/widget/color_picker.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';
import 'package:flutter_chatgpt/view/widget/switch.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
      appBar: CustomAppBar(
        title: Text(l10n.settings),
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
        _buildTitle(l10n.chat),
        _buildChat(),
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
      _buildLocale(),
      _buildColorSeed(),
      _buildThemeMode(),
      _buildCheckUpdate(),
      _buildFontSize(),
      _buildScrollBottom(),
      _buildAutoGenTitle(),
      _buildSoftWrap(),
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
        title: Text(l10n.themeMode),
        onTap: () async {
          final result = await context.showPickSingleDialog(
            items: ThemeMode.values,
            name: (e) => e.name,
            initial: ThemeMode.values[val],
          );
          if (result != null) {
            _store.themeMode.put(result.index);
            RebuildNode.app.rebuild();
          }
        },
        trailing: Text(
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
          title: Text(l10n.themeColorSeed),
          trailing: ClipOval(
            child: Container(color: primaryColor, height: 27, width: 27),
          ),
          onTap: () async {
            final ctrl = TextEditingController(text: primaryColor.toHex);
            await context.showRoundDialog(
              title: l10n.select,
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
      title: Text(l10n.autoScrollBottom),
      trailing: StoreSwitch(prop: _store.scrollBottom),
    );
  }

  Widget _buildFontSize() {
    return ValueListenableBuilder(
      valueListenable: _store.fontSize.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.text_fields),
        title: Text(l10n.fontSize),
        trailing: Text(
          val.toString(),
          style: UIs.text13Grey,
        ),
        subtitle: Text(l10n.fontSizeSettingTip, style: UIs.text13Grey),
        onTap: () async {
          final ctrl = TextEditingController(text: val.toString());
          final result = await context.showRoundDialog<String>(
            title: l10n.fontSize,
            child: Input(
              controller: ctrl,
              hint: '13',
              type: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
              ),
            ],
          );
          if (result == null) return;
          final newVal = double.tryParse(result);
          if (newVal == null) {
            context.showSnackBar('Invalid number: $result');
            return;
          }
          _store.fontSize.put(newVal);
        },
      ),
    );
  }

  Widget _buildLocale() {
    return ValueListenableBuilder(
      valueListenable: _store.locale.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.language),
        title: Text(l10n.lang),
        trailing: Text(
          val.isEmpty ? l10n.localeName : val,
          style: UIs.text13Grey,
        ),
        onTap: () async {
          final result = await context.showPickSingleDialog<Locale>(
            items: AppLocalizations.supportedLocales,
            name: (e) => e.toLanguageTag(),
            initial: val.toLocale,
          );
          if (result != null) {
            _store.locale.put(result.toLanguageTag());
            RebuildNode.app.rebuild();
          }
        },
      ),
    );
  }

  Widget _buildAutoGenTitle() {
    return ListTile(
      leading: const Icon(Icons.title),
      title: Text(l10n.genChatTitle),
      trailing: StoreSwitch(prop: _store.autoGenTitle),
    );
  }

  Widget _buildSoftWrap() {
    return ListTile(
      leading: const Icon(Icons.wrap_text),
      title: Text(l10n.softWrap),
      trailing: StoreSwitch(prop: _store.softWrap),
    );
  }

  Widget _buildCheckUpdate() {
    return ListTile(
      leading: const Icon(Icons.update),
      title: Text(l10n.autoCheckUpdate),
      subtitle: ValueListenableBuilder(
        valueListenable: AppUpdateIface.newestBuild,
        builder: (_, val, __) {
          final text = switch (val) {
            null => '${l10n.current} v1.0.${Build.build}, ${l10n.clickToCheck}',
            > Build.build => l10n.versionHaveUpdate(val),
            _ => l10n.versionUpdated(Build.build),
          };
          return Text(text, style: UIs.textGrey);
        },
      ),
      onTap: () => Funcs.throttle(() => AppUpdateIface.doUpdate(context)),
      trailing: StoreSwitch(prop: _store.autoCheckUpdate),
    );
  }

  Widget _buildChat() {
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
        title: Text(l10n.secretKey),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(val.isEmpty ? l10n.empty : val, style: UIs.text13Grey),
        onTap: () async {
          final ctrl = TextEditingController(text: val);
          final result = await context.showRoundDialog<String>(
            title: l10n.edit,
            child: Input(
              controller: ctrl,
              hint: 'sk-xxx',
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
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
        title: Text(l10n.apiUrl),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(
          val.isEmpty ? l10n.empty : val,
          style: UIs.text13Grey,
        ),
        onTap: () async {
          final ctrl = TextEditingController(text: val);
          final result = await context.showRoundDialog<String>(
            title: l10n.edit,
            child: Input(
              controller: ctrl,
              hint: 'https://api.openai.com',
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
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
        title: Text(l10n.model),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(
          val,
          style: UIs.text13Grey,
        ),
        onTap: () async {
          if (_store.openaiApiKey.fetch().isEmpty) {
            context.showRoundDialog(
              title: l10n.attention,
              child: Text(l10n.needOpenAIKey),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.ok),
                ),
              ],
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
        leading: const Icon(Icons.abc),
        title: const Text('Prompt'),
        trailing: const Icon(Icons.keyboard_arrow_right),
        subtitle: Text(val.isEmpty ? l10n.empty : val, style: UIs.text13Grey),
        onTap: () async {
          final ctrl = TextEditingController(text: val);
          final result = await context.showRoundDialog<String>(
            title: l10n.edit,
            child: Input(
              controller: ctrl,
              maxLines: 3,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
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
        title: Text(l10n.chatHistoryLength),
        trailing: Text(
          val.toString(),
          style: UIs.text13Grey,
        ),
        subtitle: Text(l10n.chatHistoryTip, style: UIs.textGrey),
        onTap: () async {
          final ctrl = TextEditingController(text: val.toString());
          final result = await context.showRoundDialog<String>(
            title: l10n.edit,
            child: Input(
              controller: ctrl,
              hint: '7',
              type: TextInputType.number,
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(ctrl.text),
                child: Text(l10n.ok),
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
