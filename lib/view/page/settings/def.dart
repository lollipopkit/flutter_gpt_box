part of 'setting.dart';

enum SettingsTab {
  app,
  providers,
  tool,
  bak,
  about;

  String get i18n => switch (this) {
    app => libL10n.app,
    providers => l10n.providers,
    tool => l10n.toolsAndMcp,
    bak => libL10n.backup,
    about => libL10n.about,
  };

  IconData get icon => switch (this) {
    app => Icons.tune,
    providers => Icons.key_outlined,
    tool => Icons.build_outlined,
    bak => Icons.backup_outlined,
    about => Icons.info_outline,
  };

  /// Filled, for the one open.
  IconData get selectedIcon => switch (this) {
    app => Icons.tune,
    providers => Icons.key,
    tool => Icons.build,
    bak => Icons.backup,
    about => Icons.info,
  };

  Widget get page => switch (this) {
    app => const AppSettingsPage(),
    providers => const ProvidersPage(),
    tool => const ToolsPage(),
    bak => const BackupPage(),
    about => const AboutPage(),
  };
}
