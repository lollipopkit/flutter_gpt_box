import 'package:flutter_chatgpt/core/store.dart';

class SettingStore extends Store {
  SettingStore() : super('setting');

  late final openaiApiUrl = property<String>('openaiApiUrl', '');

  late final openaiApiKey = property<String>('openaiApiKey', '');
}