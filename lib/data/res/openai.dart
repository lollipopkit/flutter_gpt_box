import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:gpt_box/core/logger.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/store/all.dart';

abstract final class OpenAICfg {
  static final nameNotifier = ValueNotifier(_cfg.name);

  static ChatConfig _cfg = () {
    final selectedKey = Stores.config.selectedKey.fetch();
    final selected = Stores.config.fetch(selectedKey);
    return selected ?? ChatConfig.defaultOne;
  }();

  static ChatConfig get current => _cfg;
  static set current(ChatConfig config) {
    _cfg = config;
    apply();
    config.save();
    Stores.config.selectedKey.put(config.id);
    nameNotifier.value = config.name;
  }

  static void apply() {
    Loggers.app.info('Switch profile [${_cfg.name}]');
    OpenAI.apiKey = _cfg.key;
    OpenAI.baseUrl = _cfg.url;
  }

  static void switchToDefault() {
    final cfg = Stores.config.fetch(ChatConfig.defaultId);
    if (cfg != null) {
      current = cfg;
    } else {
      current = ChatConfig.defaultOne;
      Loggers.app.warning('Default config not found');
    }
  }
}
