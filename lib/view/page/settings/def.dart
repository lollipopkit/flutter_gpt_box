part of 'setting.dart';

final class SettingsPageRet {
  final bool restored;
  const SettingsPageRet({required this.restored});
}

final class SettingsPageArgs {
  final SettingsTab tabIndex;
  const SettingsPageArgs({this.tabIndex = SettingsTab.app});
}

enum SettingsTab {
  app,
  profile,
  tool,
  bak,
  res,
  about,
  ;

  String get i18n => switch (this) {
        app => libL10n.app,
        profile => l10n.profile,
        tool => l10n.tool,
        bak => libL10n.backup,
        res => l10n.res,
        about => libL10n.about,
      };

  Widget get page => switch (this) {
        app => const AppSettingsPage(),
        profile => const ProfilePage(),
        tool => const ToolPage(),
        bak => const BackupPage(),
        res => const ResPage(),
        about => const AboutPage(),
      };

  static List<Tab> get tabs => values.map((e) => Tab(text: e.i18n)).toList();

  static List<Widget> get pages => values.map((e) => e.page).toList();
}
