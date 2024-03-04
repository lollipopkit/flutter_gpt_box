import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';
import 'package:flutter_chatgpt/data/store/all.dart';

abstract final class OpenAICfg {
  static final nameNotifier = ValueNotifier(_cfg.name);
  static ChatConfig _cfg =
      Stores.config.fetch(ChatConfig.defaultId) ?? ChatConfig.defaultOne;
  static ChatConfig get current => _cfg;
  static set current(ChatConfig config) {
    _cfg = config;
    apply();
    config.save();
    nameNotifier.value = config.name;
  }

  static void apply() {
    OpenAI.apiKey = _cfg.key;
    OpenAI.baseUrl = _cfg.url;
  }
  
  static bool switchTo(String id) {
    final cfg = Stores.config.fetch(id);
    if (cfg != null) {
      _cfg = cfg;
      apply();
      return true;
    }
    Loggers.app.warning('Config not found: $id');
    return false;
  }
}
