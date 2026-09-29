import 'package:fl_lib/fl_lib.dart';

class SettingStore extends SqliteStore {
  SettingStore._() : super('setting');

  static final instance = SettingStore._();

  late final themeMode = propertyDefault('themeMode', 0);

  late final themeColorSeed = propertyDefault('themeColorSeed', 4287106639);

  //late final fontSize = property('fontSize', 12.0);

  late final autoCheckUpdate = propertyDefault('autoCheckUpdate', true);

  /// Auto scroll to bottom when new message comes.
  late final scrollBottom = propertyDefault('scrollBottom', true);

  late final locale = propertyDefault('locale', '');

  late final softWrap = propertyDefault('softWrap', true);

  late final autoRmDupChat = propertyDefault('autoRmDupChat', true);

  late final genTitle = propertyDefault('genTitle', true);

  late final initHelpShown = propertyDefault('initHelpShown', false);
  //late final imPro = property('imPro', false);

  /// Calcualte tokens length
  // late final calcTokenLen = property('calcTokenLen', true);

  // late final replay = property('replay', true);

  late final hideTitleBar = propertyDefault('hideTitleBar', isDesktop);

  /// If it is false, delete without asking.
  late final confrimDel = propertyDefault('confrimDel', true);

  late final joinBeta = propertyDefault('joinBeta', false);

  /// For chat and share
  late final compressImg = propertyDefault('compressImg', true);

  /// Save the chat after each message sent or received even if it has error.
  late final saveErrChat = propertyDefault('saveErrChat', false);

  late final scrollSwitchChat = propertyDefault('scrollSwitchChat', isMobile);

  /// For desktop only.
  /// Record the position and size of the window.
  late final windowState = property<WindowState>(
    'windowState',
    fromObj: (obj) => switch (obj) {
      final Map map => WindowState.fromJson(map.cast<String, dynamic>()),
      _ => null,
    },
    toObj: (state) => state?.toJson(),
  );

  late final avatar = propertyDefault('avatar', '🧐');

  late final introVer = propertyDefault('introVer', 0);

  /// Auto scroll to the bottom after switching chat.
  late final scrollAfterSwitch = propertyDefault('scrollAfterSwitch', false);

  /// If true, app will uploads the photo to the server.
  late final usePhotograph = propertyDefault('usePhotograph', true);

  /// Days to keep the chat history trashes.
  late final trashDays = propertyDefault('trashDays', 7);

  /// Width of the history list beside the chat, in the two-column layout.
  late final paneListWidth = propertyDefault('paneListWidth', 280.0);

  /// Whether the history list beside the chat is folded away.
  late final paneListCollapsed = propertyDefault('paneListCollapsed', false);
}
