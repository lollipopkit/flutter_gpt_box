import 'package:gpt_box/core/store.dart';
import 'package:gpt_box/core/util/platform/base.dart';

class SettingStore extends Store {
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
  late final webdavSync = property('webdavSync', false, updateModTime: false);
  late final webdavUrl = property('webdavUrl', '', updateModTime: false);
  late final webdavUser = property('webdavUser', '', updateModTime: false);
  late final webdavPwd = property('webdavPwd', '', updateModTime: false);

  /// Only valid on iOS and macOS
  late final icloudSync = property('icloudSync', false, updateModTime: false);
  late final onlySyncOnLaunch = property('onlySyncOnLaunch', false);

  late final initHelpShown = property('initHelpShown', false);
  //late final imPro = property('imPro', false);

  /// Picture upload config
  late final picUploadUrl = property('picUploadUrl', '');

  /// Calcualte tokens length
  // late final calcTokenLen = property('calcTokenLen', true);

  late final replay = property('replay', false);

  late final countly = property('countly', true);

  late final cupertinoRoute = property('cupertinoRoute', isIOS || isMacOS);
}
