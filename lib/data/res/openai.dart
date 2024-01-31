import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_chatgpt/data/store/all.dart';

abstract final class OpenAICfg {
  static String _url = Stores.setting.openaiApiUrl.fetch();
  static String _key = Stores.setting.openaiApiKey.fetch();

  static void apply() {
    OpenAI.baseUrl = _url;
    OpenAI.apiKey = _key;
  }

  static String get url => _url;
  static String get key => _key;

  static set url(String url) {
    if (url == _url || url.isEmpty) return;
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);
    _url = url;
    OpenAI.baseUrl = url;
  }

  static set key(String key) {
    if (key == _key || key.isEmpty) return;
    _key = key;
    OpenAI.apiKey = key;
  }

  static final apiUrlReg = RegExp(r'^https?://[0-9A-Za-z\.]+(:\d+)?$');
}
