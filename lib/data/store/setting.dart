import 'package:flutter_chatgpt/core/store.dart';

class SettingStore extends Store {
  SettingStore() : super('setting');

  late final themeMode = property('themeMode', 0);
  late final themeColorSeed = property('themeColorSeed', 4287106639);
  late final fontSize = property('fontSize', 12.0);
  late final autoCheckUpdate = property('autoCheckUpdate', true);


  late final openaiApiUrl = property(
    'openaiApiUrl',
    'https://api.openai.com',
  );
  late final openaiApiKey = property('openaiApiKey', '');
  late final openaiModel = property('openaiModel', 'gpt-3.5-turbo-1106');
  late final autoGenTitle = property('autoGenTitle', true);
  late final openaiGenTitleModel = property(
    'openaiGenTitleModel',
    'gpt-3.5-turbo',
  );
  late final prompt = property('prompt', '');
  late final historyLength = property('historyLength', 7);


  /// Auto scroll to bottom when new message comes.
  late final scrollBottom = property('scrollBottom', true);
  late final locale = property('locale', '');
  late final softWrap = property('softWrap', true);
  late final autoRmDupChat = property('autoRmDupChat', true);

  /// Webdav sync
  late final webdavSync = property('webdavSync', false);
  late final webdavUrl = property('webdavUrl', '');
  late final webdavUser = property('webdavUser', '');
  late final webdavPwd = property('webdavPwd', '');

  /// Only valid on iOS and macOS
  late final icloudSync = property('icloudSync', false);
  late final onlySyncOnLaunch = property('onlySyncOnLaunch', true);


  late final initHelpShown = property('initHelpShown', false);
  //late final imPro = property('imPro', false);
}
