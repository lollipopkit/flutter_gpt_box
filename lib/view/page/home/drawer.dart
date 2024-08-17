part of 'home.dart';

final class _Drawer extends StatelessWidget {
  const _Drawer();

  List<Widget> getEntries(BuildContext context) => [
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(libL10n.setting),
          onTap: () async {
            final ret = await Routes.setting.go(context);
            if (ret?.rebuild == true) {
              Scaffold.maybeOf(context)?.closeDrawer();
            }
          },
          onLongPress: () => _onLongTapSetting(context, Stores.setting),
        ).cardx,
        ListTile(
          onTap: () => Routes.profile.go(context),
          leading: const Icon(Icons.person),
          title: Text(l10n.profile),
          onLongPress: () => _onLongTapSetting(context, Stores.config),
        ).cardx,
        ListTile(
          leading: const Icon(MingCute.tool_fill),
          title: Text(l10n.tool),
          onTap: () => Routes.tool.go(context),
          onLongPress: () => _onLongTapSetting(context, Stores.tool),
        ).cardx,
        ListTile(
          onTap: () async {
            final ret = await Routes.backup.go(context);

            if (ret?.isRestoreSuc == true) {
              Scaffold.maybeOf(context)?.closeDrawer();
              HomePage.afterRestore();
            }
          },
          leading: const Icon(Icons.backup),
          title: Text(libL10n.backup),
        ).cardx,
        ListTile(
          leading: const Icon(BoxIcons.bxs_videos),
          title: Text(l10n.res),
          onTap: () => Routes.res.go(context),
        ).cardx,
        ListTile(
          onTap: () => Routes.about.go(context),
          leading: const Icon(Icons.info),
          title: Text(libL10n.about),
        ).cardx,
      ];

  @override
  Widget build(BuildContext context) {
    return RNodes.dark.listenVal(
      (isDark) {
        return LayoutBuilder(
          builder: (context, cons) {
            final verticalPad = ((cons.maxHeight - 530) / 2).abs();
            return Container(
              width: _isWide.value ? 270 : (_media?.size.width ?? 300) * 0.7,
              color: UIs.bgColor.fromBool(isDark),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                // Disable overscroll glow on iOS
                physics: const ClampingScrollPhysics(),
                children: [
                  SizedBox(height: verticalPad),
                  SizedBox(
                    height: 47,
                    width: 47,
                    child: UIs.appIcon,
                  ),
                  UIs.height13,
                  const Text(
                    'GPT Box\nv1.0.${Build.build}',
                    textAlign: TextAlign.center,
                  ),
                  UIs.height77,
                  ...getEntries(context),
                  SizedBox(height: verticalPad),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onLongTapSetting(
    BuildContext context,
    PersistentStore store,
  ) async {
    final map = store.box.toJson(includeInternal: false);
    final keys = map.keys;

    /// Encode [map] to String with indent `\t`
    final text = const JsonEncoder.withIndent('  ').convert(map);
    final result = await PlainEditPage.route.go(
      context,
      args: PlainEditPageArgs(
        initialText: text,
        title: store.box.name,
      ),
    );
    if (result == null) return;

    try {
      final newSettings = json.decode(result) as Map<String, dynamic>;
      store.box.putAll(newSettings);
      final newKeys = newSettings.keys;
      final removedKeys = keys.where((e) => !newKeys.contains(e));
      for (final key in removedKeys) {
        Stores.setting.box.delete(key);
      }
    } catch (e, s) {
      context.showErrDialog(e, s);
    }
  }
}
