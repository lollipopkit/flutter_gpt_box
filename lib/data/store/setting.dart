import 'package:fl_lib/fl_lib.dart';

class SettingStore extends PersistentStore {
  SettingStore() : super('setting');

  late final themeMode = property('themeMode', 0);

  late final themeColorSeed = property('themeColorSeed', 4287106639);

  //late final fontSize = property('fontSize', 12.0);

  late final autoCheckUpdate = property('autoCheckUpdate', true);

  /// Auto scroll to bottom when new message comes.
  late final scrollBottom = property('scrollBottom', true);

  late final locale = property('locale', '');

  late final softWrap = property('softWrap', true);

  late final autoRmDupChat = property('autoRmDupChat', true);

  late final genTitle = property('genTitle', true);

  /// Webdav sync
  late final webdavSync =
      property('webdavSync', false, updateLastModified: false);
  late final webdavUrl = property('webdavUrl', '', updateLastModified: false);
  late final webdavUser = property('webdavUser', '', updateLastModified: false);
  late final webdavPwd = property('webdavPwd', '', updateLastModified: false);

  /// Only valid on iOS and macOS
  late final icloudSync =
      property('icloudSync', false, updateLastModified: false);
  late final onlySyncOnLaunch = property('onlySyncOnLaunch', false);

  late final initHelpShown = property('initHelpShown', false);
  //late final imPro = property('imPro', false);

  /// Calcualte tokens length
  // late final calcTokenLen = property('calcTokenLen', true);

  // late final replay = property('replay', true);

  late final cupertinoRoute = property('cupertinoRoute', isIOS || isMacOS);

  late final hideTitleBar = property('hideTitleBar', false);

  /// If it is false, delete without asking.
  late final confrimDel = property('confrimDel', true);

  late final joinBeta = property('joinBeta', false);

  /// For chat and share
  late final compressImg = property('compressImg', true);

  /// Save the chat after each message sent or received even if it has error.
  late final saveErrChat = property('saveErrChat', false);

  late final scrollSwitchChat = property('scrollSwitchChat', isMobile);

  /// {width}x{height}
  late final windowSize = property('windowSize', '');

  late final avatar = property('avatar', '🧐');

  late final introVer = property('introVer', 0);
}
