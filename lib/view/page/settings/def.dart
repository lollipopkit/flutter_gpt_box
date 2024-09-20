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
  res,
  about,
  ;

  String get i18n => switch (this) {
        app => libL10n.app,
        profile => l10n.profile,
        tool => l10n.tool,
        res => l10n.res,
        about => libL10n.about,
      };

  static List<Tab> get tabs => values.map((e) => Tab(text: e.i18n)).toList();
}
