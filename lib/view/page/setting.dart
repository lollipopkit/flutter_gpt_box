import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/res/build.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/openai.dart';
import 'package:gpt_box/data/res/rnode.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shortid/shortid.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, Never? args});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _store = Stores.setting;

  var localeStr = '';
  final _cfgRN = RNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key(localeStr),
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
        _buildTitle(l10n.more),
        _buildMore(),
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
      if (!isWeb) _buildCheckUpdate(),
      _buildAppMore(),
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
            title: l10n.themeMode,
            items: ThemeMode.values,
            name: (e) => e.name,
            initial: ThemeMode.values[val],
          );
          if (result != null) {
            _store.themeMode.put(result.index);

            /// Set delay to true to wait for db update.
            RNodes.app.build(delay: true);
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
              actions: Btns.oks(
                onTap: () {
                  _onSaveColor(ctrl.text);
                  context.pop();
                },
              ),
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
    _store.themeColorSeed.put(color.value);
    RNodes.app.build(delay: true);
  }

  Widget _buildLocale() {
    return ValueListenableBuilder(
      valueListenable: _store.locale.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(MingCute.translate_2_line),
        title: Text(l10n.lang),
        trailing: Text(
          val.isEmpty ? l10n.localeName : val,
          style: UIs.text13Grey,
        ),
        onTap: () async {
          final result = await context.showPickSingleDialog<Locale>(
            title: l10n.lang,
            items: AppLocalizations.supportedLocales,
            name: (e) => e.toLanguageTag(),
            initial: val.toLocale ?? l10n.localeName.toLocale,
          );
          if (result != null) {
            final newLocaleStr = result.toLanguageTag();
            _store.locale.put(newLocaleStr);
            await RNodes.app.build(delay: true);
            setState(() {
              localeStr = newLocaleStr;
            });
          }
        },
      ),
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
      onTap: () => Funcs.throttle(() => AppUpdateIface.doUpdate(
            build: Build.build,
            url: Urls.appUpdateCfg,
            context: context,
          )),
      trailing: StoreSwitch(prop: _store.autoCheckUpdate),
    );
  }

  Widget _buildChat() {
    return ListenableBuilder(
      listenable: _cfgRN,
      builder: (_, __) {
        final cfg = OpenAICfg.current;
        final children = [
          _buildSwitchCfg(cfg),
          _buildOpenAIKey(cfg.key),
          _buildOpenAIUrl(cfg.url),
          _buildOpenAIModels(cfg),
          _buildPrompt(cfg.prompt),
          _buildHistoryLength(cfg.historyLen),
        ];
        return Column(
          children: children.map((e) => CardX(child: e)).toList(),
        );
      },
    );
  }

  Widget _buildSwitchCfg(ChatConfig cfg) {
    final vals = Stores.config.box
        .toJson<ChatConfig>(includeInternal: false)
        .values
        .toList();
    final children = <Widget>[];
    for (int idx = 0; idx < vals.length; idx++) {
      final value = vals[idx];
      final delBtn = IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          if (value.id == ChatConfig.defaultId) return;
          context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.delFmt(value.name, l10n.profile)),
            actions: Btns.oks(
              onTap: () {
                Stores.config.delete(value.id);
                _cfgRN.build();
                context.pop();
                if (cfg.id == value.id) {
                  OpenAICfg.switchToDefault(context);
                  _cfgRN.build();
                }
              },
              red: true,
            ),
          );
        },
      );
      children.add(ListTile(
        leading: Checkbox(
          value: cfg.id == value.id,
          onChanged: (val) {
            if (val != true) return;
            OpenAICfg.setTo(value, context);
            _cfgRN.build();
          },
        ),
        title: Text(value.name.isEmpty ? l10n.defaulT : value.name),
        onTap: () {
          if (cfg.id == value.id) return;
          OpenAICfg.setTo(value, context);
          _cfgRN.build();
        },
        trailing: value.id != ChatConfig.defaultId ? delBtn : null,
      ));
    }
    children.add(ListTile(
      onTap: () async {
        final ctrl = TextEditingController();
        final name = await context.showRoundDialog(
          title: l10n.add,
          child: Input(
            controller: ctrl,
            hint: l10n.name,
            icon: Icons.text_fields,
          ),
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (name == null) return;
        final cfg = ChatConfig.defaultOne.copyWith(
          id: shortid.generate(),
          name: name,
        )..save();
        OpenAICfg.setTo(cfg, context);
        _cfgRN.build();
      },
      title: Text(l10n.add),
      trailing: const Icon(Icons.add),
    ));
    return ExpandTile(
      leading: const Icon(Icons.switch_account),
      title: Text(l10n.profile),
      subtitle: Text(
        '${l10n.current}: ${switch ((cfg.id, cfg.name)) {
          (ChatConfig.defaultId, _) => l10n.defaulT,
          (_, final String name) => name,
        }}',
        style: UIs.text13Grey,
      ),
      children: children,
    );
  }

  Widget _buildOpenAIKey(String val) {
    return ListTile(
      leading: const Icon(Icons.vpn_key),
      title: Text(l10n.secretKey),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 60),
        child: Text(
          val.isEmpty ? l10n.empty : val,
          style: UIs.textGrey,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: l10n.edit,
          child: Input(
            controller: ctrl,
            hint: 'sk-xxx',
            maxLines: 3,
          ),
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (result == null) return;
        OpenAICfg.setTo(OpenAICfg.current.copyWith(key: result), context);
        _cfgRN.build();
      },
    );
  }

  Widget _buildOpenAIUrl(String val) {
    return ListTile(
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
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (result == null) return;
        if (result.contains('/v1') || !ChatConfig.apiUrlReg.hasMatch(result)) {
          final sure = await context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.apiUrlTip),
            actions: Btns.oks(
              onTap: () => context.pop(true),
              red: true,
            ),
          );
          if (sure != true) return;
        }
        OpenAICfg.setTo(OpenAICfg.current.copyWith(url: result), context);
        _cfgRN.build();
      },
    );
  }

  Widget _buildOpenAIModels(ChatConfig cfg) {
    return ValBuilder(
      listenable: OpenAICfg.models,
      builder: (models) {
        return ExpandTile(
          leading: const Icon(Icons.model_training),
          title: Text(l10n.model),
          children: [
            _buildOpenAIChatModel(cfg, models),
            _buildOpenAIImgModel(cfg, models),
            _buildOpenAISpeechModel(cfg, models),
            _buildOpenAITranscribeModel(cfg, models),
          ],
        );
      },
    );
  }

  Widget _buildOpenAIChatModel(ChatConfig cfg, List<String> models) {
    final val = cfg.model;
    return ListTile(
      leading: const Icon(Icons.chat),
      title: Text(l10n.chat),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Text(val, style: UIs.text13Grey),
      onTap: () async {
        if (cfg.key.isEmpty) {
          context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.needOpenAIKey),
            actions: Btns.oks(onTap: context.pop),
          );
          return;
        }
        final modelStrs = List<String>.from(models);
        modelStrs.removeWhere((element) => !element.startsWith('gpt'));
        if (modelStrs.isEmpty) {
          modelStrs.addAll(models);
        }
        final model = await context.showPickSingleDialog(
          items: modelStrs,
          initial: val,
          title: l10n.model,
          actions: [
            TextButton(
              onPressed: () {
                void onSave(String s) {
                  context.pop();
                  OpenAICfg.setTo(
                    OpenAICfg.current.copyWith(model: s),
                    context,
                  );
                  _cfgRN.build();
                }

                context.pop();
                final ctrl = TextEditingController();
                context.showRoundDialog(
                  title: l10n.custom,
                  child: Input(
                    controller: ctrl,
                    hint: kChatModel,
                    onSubmitted: (s) => onSave(s),
                  ),
                  actions: Btns.oks(onTap: () => onSave(ctrl.text)),
                );
              },
              child: Text(l10n.custom),
            ),
          ],
        );
        if (model != null) {
          OpenAICfg.setTo(OpenAICfg.current.copyWith(model: model), context);
          _cfgRN.build();
        }
      },
    );
  }

  Widget _buildOpenAIImgModel(ChatConfig cfg, List<String> models) {
    final val = cfg.imgModel;
    return ListTile(
      leading: const Icon(Icons.photo),
      title: Text(l10n.image),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Text(val, style: UIs.text13Grey),
      onTap: () async {
        if (cfg.key.isEmpty) {
          context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.needOpenAIKey),
            actions: Btns.oks(onTap: context.pop),
          );
          return;
        }

        final modelStrs = List<String>.from(models);
        modelStrs.removeWhere((element) => !element.startsWith('dall-e'));
        if (modelStrs.isEmpty) {
          modelStrs.addAll(models);
        }
        final model = await context.showPickSingleDialog(
          items: modelStrs,
          initial: val,
          title: l10n.model,
          actions: [
            TextButton(
              onPressed: () {
                void onSave(String s) {
                  context.pop();
                  OpenAICfg.setTo(
                    OpenAICfg.current.copyWith(model: s),
                    context,
                  );
                  _cfgRN.build();
                }

                context.pop();
                final ctrl = TextEditingController();
                context.showRoundDialog(
                  title: l10n.custom,
                  child: Input(
                    controller: ctrl,
                    hint: kChatModel,
                    onSubmitted: (s) => onSave(s),
                  ),
                  actions: Btns.oks(onTap: () => onSave(ctrl.text)),
                );
              },
              child: Text(l10n.custom),
            ),
          ],
        );
        if (model != null) {
          OpenAICfg.setTo(OpenAICfg.current.copyWith(model: model), context);
          _cfgRN.build();
        }
      },
    );
  }

  Widget _buildOpenAISpeechModel(ChatConfig cfg, List<String> models) {
    final val = cfg.speechModel;
    return ListTile(
      leading: const Icon(Icons.speaker),
      title: Text(l10n.tts),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Text(val, style: UIs.text13Grey),
      onTap: () async {
        if (cfg.key.isEmpty) {
          context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.needOpenAIKey),
            actions: Btns.oks(onTap: context.pop),
          );
          return;
        }

        final modelStrs = List<String>.from(models);
        modelStrs.removeWhere((element) => !element.startsWith('tts'));
        if (modelStrs.isEmpty) {
          modelStrs.addAll(models);
        }
        final model = await context.showPickSingleDialog(
          items: modelStrs,
          initial: val,
          title: l10n.model,
          actions: [
            TextButton(
              onPressed: () {
                void onSave(String s) {
                  context.pop();
                  OpenAICfg.setTo(
                    OpenAICfg.current.copyWith(model: s),
                    context,
                  );
                  _cfgRN.build();
                }

                context.pop();
                final ctrl = TextEditingController();
                context.showRoundDialog(
                  title: l10n.custom,
                  child: Input(
                    controller: ctrl,
                    hint: kChatModel,
                    onSubmitted: (s) => onSave(s),
                  ),
                  actions: Btns.oks(onTap: () => onSave(ctrl.text)),
                );
              },
              child: Text(l10n.custom),
            ),
          ],
        );
        if (model != null) {
          OpenAICfg.setTo(OpenAICfg.current.copyWith(model: model), context);
          _cfgRN.build();
        }
      },
    );
  }

  Widget _buildOpenAITranscribeModel(ChatConfig cfg, List<String> models) {
    final val = cfg.transcribeModel;
    return ListTile(
      leading: const Icon(Icons.transcribe),
      title: Text(l10n.stt),
      trailing: const Icon(Icons.keyboard_arrow_right),
      subtitle: Text(val, style: UIs.text13Grey),
      onTap: () async {
        if (cfg.key.isEmpty) {
          context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.needOpenAIKey),
            actions: Btns.oks(onTap: context.pop),
          );
          return;
        }

        final modelStrs = List<String>.from(models);
        modelStrs.removeWhere((element) => !element.startsWith('whisper'));
        if (modelStrs.isEmpty) {
          modelStrs.addAll(models);
        }
        final model = await context.showPickSingleDialog(
          items: modelStrs,
          initial: val,
          title: l10n.model,
          actions: [
            TextButton(
              onPressed: () {
                void onSave(String s) {
                  context.pop();
                  OpenAICfg.setTo(
                    OpenAICfg.current.copyWith(model: s),
                    context,
                  );
                  _cfgRN.build();
                }

                context.pop();
                final ctrl = TextEditingController();
                context.showRoundDialog(
                  title: l10n.custom,
                  child: Input(
                    controller: ctrl,
                    hint: kChatModel,
                    onSubmitted: (s) => onSave(s),
                  ),
                  actions: Btns.oks(onTap: () => onSave(ctrl.text)),
                );
              },
              child: Text(l10n.custom),
            ),
          ],
        );
        if (model != null) {
          OpenAICfg.setTo(OpenAICfg.current.copyWith(model: model), context);
          _cfgRN.build();
        }
      },
    );
  }

  Widget _buildPrompt(String val) {
    return ListTile(
      leading: const Icon(Icons.abc),
      title: Text(l10n.promptsSettingsItem),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 60),
        child: Text(
          val.isEmpty ? l10n.empty : val,
          style: UIs.textGrey,
          textAlign: TextAlign.end,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: val);
        final result = await context.showRoundDialog<String>(
          title: l10n.edit,
          child: Input(
            controller: ctrl,
            maxLines: 3,
          ),
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (result == null) return;
        OpenAICfg.setTo(OpenAICfg.current.copyWith(prompt: result), context);
        _cfgRN.build();
      },
    );
  }

  Widget _buildHistoryLength(int val) {
    return ListTile(
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
          actions: Btns.oks(
            onTap: () => context.pop(ctrl.text),
          ),
        );
        if (result == null) return;
        final newVal = int.tryParse(result);
        if (newVal == null) {
          context.showSnackBar('Invalid number: $result');
          return;
        }
        OpenAICfg.setTo(
          OpenAICfg.current.copyWith(historyLen: newVal),
          context,
        );
        _cfgRN.build();
      },
    );
  }

  Widget _buildMore() {
    final children = [
      //_buildFontSize(),
      _buildGenTitle(),
      _buildScrollBottom(),
      _buildSoftWrap(),
      _buildAutoRmDupChat(),
      //_buildCalcTokenLen(),
      _buildReplay(),
    ];
    return Column(
      children: children.map((e) => CardX(child: e)).toList(),
    );
  }

  // Widget _buildFontSize() {
  //   return ValueListenableBuilder(
  //     valueListenable: _store.fontSize.listenable(),
  //     builder: (_, val, __) => ListTile(
  //       leading: const Icon(Icons.text_fields),
  //       title: Text(l10n.fontSize),
  //       trailing: Text(
  //         val.toString(),
  //         style: UIs.text13Grey,
  //       ),
  //       subtitle: Text(l10n.fontSizeSettingTip, style: UIs.text13Grey),
  //       onTap: () async {
  //         final ctrl = TextEditingController(text: val.toString());
  //         final result = await context.showRoundDialog<String>(
  //           title: l10n.fontSize,
  //           child: Input(
  //             icon: Icons.text_fields,
  //             controller: ctrl,
  //             hint: '12',
  //             type: const TextInputType.numberWithOptions(decimal: true),
  //           ),
  //           actions: Btns.oks(onTap: () => context.pop(ctrl.text)),
  //         );
  //         if (result == null) return;
  //         final newVal = double.tryParse(result);
  //         if (newVal == null) {
  //           context.showSnackBar('Invalid number: $result');
  //           return;
  //         }
  //         _store.fontSize.put(newVal);
  //       },
  //     ),
  //   );
  // }

  Widget _buildGenTitle() {
    return ListTile(
      leading: const Icon(Icons.auto_awesome),
      title: Text(l10n.genChatTitle),
      trailing: StoreSwitch(prop: _store.genTitle),
    );
  }

  Widget _buildScrollBottom() {
    return ListTile(
      leading: const Icon(Icons.keyboard_arrow_down),
      title: Text(l10n.autoScrollBottom),
      trailing: StoreSwitch(prop: _store.scrollBottom),
    );
  }

  Widget _buildSoftWrap() {
    return ListTile(
      leading: const Icon(Icons.wrap_text),
      title: Text(l10n.softWrap),
      trailing: StoreSwitch(prop: _store.softWrap),
    );
  }

  Widget _buildAutoRmDupChat() {
    return ListTile(
      leading: const Icon(Icons.delete),
      title: Text(l10n.autoRmDupChat),
      trailing: StoreSwitch(prop: _store.autoRmDupChat),
    );
  }

  // Widget _buildCalcTokenLen() {
  //   return ListTile(
  //     leading: const Icon(Icons.calculate),
  //     title: Text(l10n.calcTokenLen),
  //     trailing: StoreSwitch(prop: _store.calcTokenLen),
  //   );
  // }

  Widget _buildReplay() {
    return ListTile(
      leading: const Icon(Icons.replay),
      title: Text('${l10n.replay} (experimental)'),
      trailing: StoreSwitch(prop: _store.replay),
    );
  }

  Widget _buildAppMore() {
    return ExpandTile(
      leading: const Icon(MingCute.more_3_fill),
      title: Text(l10n.more),
      children: [
        _buildCountly(),
        _buildCupertinoRoute(),
      ],
    );
  }

  Widget _buildCountly() {
    return ListTile(
      leading: const Icon(Icons.analytics),
      title: const Text('Countly'),
      trailing: StoreSwitch(prop: _store.countly),
    );
  }

  Widget _buildCupertinoRoute() {
    return ListTile(
      leading: const Icon(MingCute.route_fill),
      title: Text('Cupertino ${l10n.route}'),
      trailing: StoreSwitch(prop: _store.cupertinoRoute),
    );
  }
}
