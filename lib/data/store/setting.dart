import 'package:flutter_chatgpt/core/store.dart';

class SettingStore extends Store {
  SettingStore() : super('setting');

  late final openaiApiUrl = property('openaiApiUrl', '');

  late final openaiApiKey = property('openaiApiKey', '');

  late final openaiModel = property('openaiModel', 'gpt-3.5-turbo-1106');
}