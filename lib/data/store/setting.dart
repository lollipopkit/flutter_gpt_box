import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/chat/config.dart';

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

  /// Picture upload config
  late final picUploadUrl = property('picUploadUrl', '');

  /// Calcualte tokens length
  // late final calcTokenLen = property('calcTokenLen', true);

  late final replay = property('replay', true);

  late final countly = property('countly', true);

  late final cupertinoRoute = property('cupertinoRoute', isIOS || isMacOS);

  late final hideTitleBar = property('hideTitleBar', false);

  late final profileId = property('profileId', ChatConfig.defaultId);

  /// If [ChatHistory.model] is not null, and the saved model ([followModel])
  /// exists in current models list, then set current model to it.
  late final followModel = property('followModel', true);

  /// If it is false, delete without asking.
  late final confrimDel = property('confrimDel', true);

  late final joinBeta = property('joinBeta', false);

  //late final compressImg = property('compressImg', true);

  late final titlePrompt = property('titlePrompt', '');

  /// Save the chat after each message sent or received even if it has error.
  late final saveErrChat = property('saveErrChat', false);
}
