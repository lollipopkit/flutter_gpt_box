import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/build.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/rnode.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:icons_plus/icons_plus.dart';

final class SettingsPageRet {
  final bool rebuild;
  const SettingsPageRet({this.rebuild = false});
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, Never? args});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _store = Stores.setting;
  var _localeStr = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key(_localeStr),
      appBar: CustomAppBar(title: Text(libL10n.setting)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return MultiList(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      children: [
        [
          const CenterGreyTitle('App'),
          _buildApp(),
        ],
        [
          CenterGreyTitle(l10n.chat),
          _buildChat(),
        ]
      ],
    );
  }

  Widget _buildApp() {
    final children = [
      _buildLocale(),
      _buildColorSeed(),
      _buildThemeMode(),
      _buildCheckUpdate(),
      _buildAppMore(),
    ];
    return Column(children: children.map((e) => e.cardx).toList());
  }

  Widget _buildChat() {
    final children = [
      _buildUserName(),
      if (isMobile) _buildScrollSwitchChat(),
      //_buildFontSize(),
      _buildGenTitle(),
      _buildScrollBottom(),
      _buildSoftWrap(),
      //_buildCalcTokenLen(),
      //_buildReplay(),
      _buildMoreMore(),
    ];
    return Column(children: children.map((e) => e.cardx).toList());
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
            context.pop(const SettingsPageRet(rebuild: true));

            /// Set delay to true to wait for db update.
            RNodes.app.notify(delay: true);
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
              title: libL10n.select,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Input(
                    onSubmitted: _onSaveColor,
                    controller: ctrl,
                    hint: '#8b2252',
                    icon: Icons.colorize,
                    autoFocus: true,
                  ),
                  ColorPicker(
                    color: primaryColor,
                    onColorChanged: (c) => ctrl.text = c.toHex,
                  )
                ],
              ),
              actions: Btn.ok(onTap: () {
                _onSaveColor(ctrl.text);
                context.pop();
              }).toList,
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
    RNodes.app.notify(delay: true);
  }

  Widget _buildLocale() {
    return ValueListenableBuilder(
      valueListenable: _store.locale.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(MingCute.translate_2_line),
        title: Text(libL10n.language),
        trailing: Text(
          val.isEmpty ? context.localeNativeName : val,
          style: UIs.text13Grey,
        ),
        onTap: () async {
          final result = await context.showPickSingleDialog<Locale>(
            title: libL10n.language,
            items: AppLocalizations.supportedLocales,
            name: (e) => e.nativeName,
            initial: val.toLocale ?? l10n.localeName.toLocale,
          );
          if (result != null) {
            final newLocaleStr = result.toLanguageTag();
            _store.locale.put(newLocaleStr);
            await RNodes.app.notify(delay: true);
            setState(() {
              _localeStr = newLocaleStr;
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
            > Build.build => libL10n.versionHasUpdate(val),
            _ => libL10n.versionUpdated(Build.build),
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
      leading: const Icon(Icons.auto_awesome, size: 21),
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
      title: TipText(l10n.softWrap, l10n.codeBlock),
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

  // Widget _buildReplay() {
  //   return ListTile(
  //     leading: const Icon(Icons.replay),
  //     title: Text(l10n.replay),
  //     trailing: StoreSwitch(prop: _store.replay),
  //   );
  // }

  Widget _buildAppMore() {
    return ExpandTile(
      leading: const Icon(MingCute.more_3_fill),
      title: Text(l10n.more),
      children: [
        _buildJoinBeta(),
        _buildCupertinoRoute(),
        if (isDesktop) _buildHideTitleBar(),
      ],
    );
  }

  Widget _buildCupertinoRoute() {
    return ListTile(
      leading: const Icon(MingCute.route_fill),
      title: Text('Cupertino ${l10n.route}'),
      trailing: StoreSwitch(prop: _store.cupertinoRoute),
    );
  }

  Widget _buildDeleteConfrim() {
    return ListTile(
      leading: const Icon(MingCute.check_circle_fill),
      title: Text(l10n.deleteConfirm),
      trailing: StoreSwitch(prop: _store.confrimDel),
    );
  }

  Widget _buildJoinBeta() {
    return ListTile(
      leading: const Icon(Clarity.beta_solid),
      title: Text(l10n.joinBeta),
      trailing: StoreSwitch(
        prop: _store.joinBeta,
        callback: (val) async {
          if (val) {
            AppUpdate.chan = AppUpdateChan.beta;
          } else {
            AppUpdate.chan = AppUpdateChan.stable;
          }
          await AppUpdateIface.doUpdate(
            context: context,
            build: Build.build,
            url: Urls.appUpdateCfg,
          );
        },
      ),
    );
  }

  Widget _buildCompressImg() {
    return ListTile(
      leading: const Icon(Icons.compress),
      title: TipText(l10n.compress, l10n.compressImgTip),
      trailing: StoreSwitch(prop: _store.compressImg),
    );
  }

  Widget _buildSaveErrChat() {
    return ListTile(
      leading: const Icon(Icons.save),
      title: TipText(l10n.saveErrChat, l10n.saveErrChatTip),
      trailing: StoreSwitch(prop: _store.saveErrChat),
    );
  }

  Widget _buildScrollSwitchChat() {
    return ListTile(
      leading: const Icon(Icons.swap_vert),
      title: TipText(l10n.scrollSwitchChat, l10n.needRestart),
      trailing: StoreSwitch(prop: _store.scrollSwitchChat),
    );
  }

  Widget _buildUserName() {
    final property = _store.avatar;
    return ListTile(
      leading: const Icon(Bootstrap.person_vcard_fill, size: 22),
      title: Text(libL10n.name),
      trailing: ValBuilder(
        listenable: _store.avatar.listenable(),
        builder: (val) => Text(val, style: const TextStyle(fontSize: 18)),
      ),
      onTap: () async {
        final ctrl = TextEditingController(text: property.fetch());
        void onSave(String s) {
          property.put(s);
          context.pop();
        }

        await context.showRoundDialog(
          title: libL10n.name,
          child: Input(
            controller: ctrl,
            type: TextInputType.name,
            maxLength: 7,
            autoFocus: true,
            onSubmitted: (s) => onSave(s),
          ),
          actions: Btn.ok(onTap: () => onSave(ctrl.text)).toList,
        );
      },
    );
  }

  Widget _buildMoreMore() {
    return ExpandTile(
      leading: const Icon(MingCute.more_3_fill),
      title: Text(l10n.more),
      children: [
        _buildSaveErrChat(),
        _buildAutoRmDupChat(),
        _buildDeleteConfrim(),
        _buildCompressImg(),
      ],
    );
  }

  Widget _buildHideTitleBar() {
    return ListTile(
      leading: const Icon(Bootstrap.window_sidebar, size: 20),
      title: Text(libL10n.hideTitleBar),
      trailing: StoreSwitch(prop: _store.hideTitleBar),
    );
  }
}
