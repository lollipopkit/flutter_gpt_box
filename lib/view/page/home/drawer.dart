part of 'home.dart';

final class _Drawer extends StatelessWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _isWide.value ? 270 : (_media?.size.width ?? 300) * 0.7,
      color: UIs.bgColor.fromBool(RNodes.dark.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UIs.height13,
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
            ListTile(
              onTap: () async {
                final ret = await Routes.setting.go(context);
                if (ret?.rebuild == true) {
                  Scaffold.maybeOf(context)?.closeDrawer();
                }
              },
              onLongPress: () => _onLongTapSetting(context),
              leading: const Icon(Icons.settings),
              title: Text(l10n.settings),
            ).cardx,
            ListTile(
              leading: const Icon(MingCute.tool_fill),
              title: Text(l10n.tool),
              onTap: () => Routes.tool.go(context),
            ).cardx,
            ListTile(
              onTap: () async {
                final ret = await Routes.backup.go(context);
                Scaffold.maybeOf(context)?.closeDrawer();

                if (ret?.isRestoreSuc == true) {
                  HomePage.afterRestore();
                }
              },
              leading: const Icon(Icons.backup),
              title: Text('${l10n.backup} & ${l10n.restore}'),
            ).cardx,
            ListTile(
              leading: const Icon(BoxIcons.bxs_videos),
              title: Text(l10n.res),
              onTap: () => Routes.res.go(context),
            ).cardx,
            ListTile(
              onTap: () => Routes.about.go(context),
              leading: const Icon(Icons.info),
              title: Text(l10n.about),
            ).cardx,
            SizedBox(height: (_media?.padding.bottom ?? 0) + 13),
          ],
        ),
      ),
    );
  }
}
