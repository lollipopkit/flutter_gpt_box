import 'package:fl_lib/fl_lib.dart';

class SettingStore extends HiveStore {
  SettingStore() : super('setting');

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

  /// Webdav sync
  late final webdavSync =
      propertyDefault('webdavSync', false, updateLastModified: false);
  late final webdavUrl = propertyDefault('webdavUrl', '', updateLastModified: false);
  late final webdavUser = propertyDefault('webdavUser', '', updateLastModified: false);
  late final webdavPwd = propertyDefault('webdavPwd', '', updateLastModified: false);

  /// Only valid on iOS and macOS
  late final icloudSync =
      propertyDefault('icloudSync', false, updateLastModified: false);

  late final initHelpShown = propertyDefault('initHelpShown', false);
  //late final imPro = property('imPro', false);

  /// Calcualte tokens length
  // late final calcTokenLen = property('calcTokenLen', true);

  // late final replay = property('replay', true);

  late final cupertinoRoute = propertyDefault('cupertinoRoute', isIOS || isMacOS);

  late final hideTitleBar = propertyDefault('hideTitleBar', isDesktop);

  /// If it is false, delete without asking.
  late final confrimDel = propertyDefault('confrimDel', true);

  late final joinBeta = propertyDefault('joinBeta', false);

  /// For chat and share
  late final compressImg = propertyDefault('compressImg', true);

  /// Save the chat after each message sent or received even if it has error.
  late final saveErrChat = propertyDefault('saveErrChat', false);

  late final scrollSwitchChat = propertyDefault('scrollSwitchChat', isMobile);

  /// {width}x{height}
  late final windowSize = property<String>('windowSize');

  late final avatar = propertyDefault('avatar', '🧐');

  late final introVer = propertyDefault('introVer', 0);

  /// Auto scroll to the bottom after switching chat.
  late final scrollAfterSwitch = propertyDefault('scrollAfterSwitch', false);

  /// If true, app will uploads the photo to the server.
  late final usePhotograph = propertyDefault('usePhotograph', true);
}
