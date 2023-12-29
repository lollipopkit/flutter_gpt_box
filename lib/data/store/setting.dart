import 'package:flutter_chatgpt/core/store.dart';

class SettingStore extends Store {
  SettingStore() : super('setting');

  late final themeMode = property('themeMode', 0);

  late final themeColorSeed = property('themeColorSeed', 4287106639);

  late final openaiApiUrl = property('openaiApiUrl', '');

  late final openaiApiKey = property('openaiApiKey', '');

  late final openaiModel = property('openaiModel', 'gpt-3.5-turbo-1106');

  late final autoGenTitle = property('autoGenTitle', true);

  late final prompt = property('prompt', '');

  late final historyLength = property('historyLength', 7);

  /// Auto scroll to bottom when new message comes.
  late final scrollBottom = property('scrollBottom', true);
}
