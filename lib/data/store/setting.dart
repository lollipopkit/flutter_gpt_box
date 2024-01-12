import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';

class SettingStore extends Store {
  SettingStore() : super('setting');

  late final themeMode = property('themeMode', 0);

  late final themeColorSeed = property('themeColorSeed', 4287106639);

  late final openaiApiUrl = property(
    'openaiApiUrl',
    'https://api.openai.com/v1',
  );

  late final openaiApiKey = property('openaiApiKey', '');

  late final openaiModel = property('openaiModel', 'gpt-3.5-turbo-1106');

  late final autoGenTitle = property('autoGenTitle', true);

  late final prompt = property('prompt', '');

  late final historyLength = property('historyLength', 7);

  /// Auto scroll to bottom when new message comes.
  late final scrollBottom = property('scrollBottom', true);

  late final fontSize = property('fontSize', 12.0);

  late final locale = property('locale', '');

  late final softWrap = property('softWrap', isMobile);
}
