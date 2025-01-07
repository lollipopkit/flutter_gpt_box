import 'dart:async';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/api_balance.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/res/build_data.dart';
import 'package:gpt_box/data/res/github_id.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/openai.dart';
import 'package:gpt_box/data/res/rnode.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/generated/l10n/l10n.dart';
import 'package:gpt_box/view/page/backup/view.dart';
import 'package:gpt_box/view/widget/audio.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shortid/shortid.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'tool.dart';
part 'profile.dart';
part 'res.dart';
part 'about.dart';
part 'def.dart';

class SettingsPage extends StatefulWidget {
  final SettingsPageArgs? args;

  const SettingsPage({super.key, this.args});

  static const route = AppRoute<SettingsPageRet, SettingsPageArgs>(
    page: SettingsPage.new,
    path: '/settings',
  );

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late final _tabCtrl = TabController(
      length: SettingsTab.values.length,
      vsync: this,
      initialIndex: widget.args?.tabIndex.index ?? 0);

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: CustomAppBar(
        title: Text(libL10n.setting),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: SettingsTab.tabs,
          dividerHeight: 0,
          tabAlignment: TabAlignment.center,
          isScrollable: true,
        ),
      ),
      body: TabBarView(controller: _tabCtrl, children: SettingsTab.pages),
    );
  }
}

final class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

final class _AppSettingsPageState extends State<AppSettingsPage> {
  final _setStore = Stores.setting;

  @override
  Widget build(BuildContext context) {
    return MultiList(
      children: [
        [
          const CenterGreyTitle('App'),
          const UserCard(),
          UIs.height13,
          _buildApp()
        ],
        [CenterGreyTitle(l10n.chat), _buildAppChat()]
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

  Widget _buildAppChat() {
    final children = [
      _buildUserName(),
      if (isMobile) _buildScrollSwitchChat(),
      //_buildFontSize(),
      _buildGenTitle(),
      _buildAutoScrollBottom(),
      _buildSoftWrap(),
      //_buildCalcTokenLen(),
      //_buildReplay(),
      _buildMoreMore(),
    ];
    return Column(children: children.map((e) => e.cardx).toList());
  }

  Widget _buildThemeMode() {
    return ValueListenableBuilder(
      valueListenable: _setStore.themeMode.listenable(),
      builder: (_, val, __) => ListTile(
        leading: const Icon(Icons.sunny),
        title: Text(l10n.themeMode),
        onTap: () async {
          final result = await context.showPickSingleDialog(
            title: l10n.themeMode,
            items: ThemeMode.values,
            display: (e) => e.i18n,
            initial: ThemeMode.values[val],
          );
          if (result != null) {
            _setStore.themeMode.put(result.index);
            context.pop();

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
      valueListenable: _setStore.themeColorSeed.listenable(),
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
    final color = s.fromColorHex;
    if (color == null) {
      context.showSnackBar('Invalid color code: $s');
      return;
    }
    _setStore.themeColorSeed.put(color.value255);
    RNodes.app.notify(delay: true);
  }

  Widget _buildLocale() {
    return ValueListenableBuilder(
      valueListenable: _setStore.locale.listenable(),
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
            display: (e) => e.nativeName,
            initial: val.toLocale ?? l10n.localeName.toLocale,
          );
          if (result != null) {
            _setStore.locale.put(result.code);
            await RNodes.app.notify(delay: true);
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
            null => '${l10n.current} v${BuildData.build}, ${l10n.clickToCheck}',
            > BuildData.build => libL10n.versionHasUpdate(val),
            _ => libL10n.versionUpdated(BuildData.build),
          };
          return Text(text, style: UIs.textGrey);
        },
      ),
      onTap: () => Funcs.throttle(
        () => AppUpdateIface.doUpdate(
          url: Urls.appUpdateCfg,
          context: context,
          build: BuildData.build,
        ),
      ),
      trailing: StoreSwitch(prop: _setStore.autoCheckUpdate),
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
      trailing: StoreSwitch(prop: _setStore.genTitle),
    );
  }

  Widget _buildAutoScrollBottom() {
    return ExpandTile(
      leading: const Icon(Icons.keyboard_arrow_down),
      title: Text(l10n.autoScrollBottom),
      children: [
        _buildScrollBottomOnMsg(),
        _buildScrollAfterSwitch(),
      ],
    );
  }

  Widget _buildScrollBottomOnMsg() {
    return ListTile(
      title: Text(l10n.onMsgCome),
      trailing: StoreSwitch(prop: _setStore.scrollBottom),
    );
  }

  Widget _buildSoftWrap() {
    return ListTile(
      leading: const Icon(Icons.wrap_text),
      title: TipText(l10n.softWrap, l10n.codeBlock),
      trailing: StoreSwitch(prop: _setStore.softWrap),
    );
  }

  Widget _buildAutoRmDupChat() {
    return ListTile(
      leading: const Icon(Icons.delete),
      title: Text(l10n.autoRmDupChat),
      trailing: StoreSwitch(prop: _setStore.autoRmDupChat),
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
      trailing: StoreSwitch(prop: _setStore.cupertinoRoute),
    );
  }

  Widget _buildDeleteConfrim() {
    return ListTile(
      leading: const Icon(MingCute.check_circle_fill),
      title: Text(l10n.deleteConfirm),
      trailing: StoreSwitch(prop: _setStore.confrimDel),
    );
  }

  Widget _buildJoinBeta() {
    return ListTile(
      leading: const Icon(Clarity.beta_solid),
      title: Text(l10n.joinBeta),
      trailing: StoreSwitch(
        prop: _setStore.joinBeta,
        callback: (val) async {
          if (val) {
            AppUpdate.chan = AppUpdateChan.beta;
          } else {
            AppUpdate.chan = AppUpdateChan.stable;
          }
          await AppUpdateIface.doUpdate(
            context: context,
            url: Urls.appUpdateCfg,
            build: BuildData.build,
          );
        },
      ),
    );
  }

  Widget _buildCompressImg() {
    return ListTile(
      leading: const Icon(Icons.compress),
      title: TipText(l10n.compress, l10n.compressImgTip),
      trailing: StoreSwitch(prop: _setStore.compressImg),
    );
  }

  Widget _buildSaveErrChat() {
    return ListTile(
      leading: const Icon(Icons.save),
      title: TipText(l10n.saveErrChat, l10n.saveErrChatTip),
      trailing: StoreSwitch(prop: _setStore.saveErrChat),
    );
  }

  Widget _buildScrollSwitchChat() {
    return ListTile(
      leading: const Icon(Icons.swap_vert),
      title: TipText(l10n.scrollSwitchChat, l10n.needRestart),
      trailing: StoreSwitch(prop: _setStore.scrollSwitchChat),
    );
  }

  Widget _buildUserName() {
    final property = _setStore.avatar;
    return ListTile(
      leading: const Icon(Bootstrap.person_vcard_fill, size: 22),
      title: Text(libL10n.name),
      trailing: ValBuilder(
        listenable: _setStore.avatar.listenable(),
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
      trailing: StoreSwitch(prop: _setStore.hideTitleBar),
    );
  }

  Widget _buildScrollAfterSwitch() {
    return ListTile(
      title: Text(l10n.onSwitchChat),
      trailing: StoreSwitch(prop: _setStore.scrollAfterSwitch),
    );
  }
}
