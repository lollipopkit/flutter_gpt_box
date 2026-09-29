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
  providers,
  tool,
  bak,
  about,
  ;

  String get i18n => switch (this) {
        app => libL10n.app,
        providers => l10n.providers,
        tool => l10n.tool,
        bak => libL10n.backup,
        about => libL10n.about,
      };

  Widget get page => switch (this) {
        app => const AppSettingsPage(),
        providers => const ProvidersPage(embedded: true),
        tool => const McpPage(),
        bak => const BackupPage(),
        about => const AboutPage(),
      };

  static List<Tab> get tabs => values.map((e) => Tab(text: e.i18n)).toList();

  static List<Widget> get pages => values.map((e) => e.page).toList();
}
