import 'package:dart_openai/dart_openai.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/api_balance.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/store/all.dart';

abstract final class OpenAICfg {
  static final models = <String>[].vn;

  // ignore: deprecated_member_use_from_same_package
  static final vn = _init.vn;

  static ChatConfig get current => vn.value;

  static void setTo(ChatConfig config) {
    final old = vn.value;
    vn.value = config;
    apply();
    config.save();
    Stores.config.profileId.put(config.id);

    if (config.shouldUpdateRelavance(old)) {
      updateModels();
      ApiBalance.refresh();
    }
  }

  static void setToId(String id) {
    final cfg = Stores.config.fetch(id);
    if (cfg != null) {
      setTo(cfg);
    } else {
      Loggers.app.warning('Config [$id] not found');
    }
  }

  static RegExp? _modelsUseToolReExp;
  static bool canUseTool(String model) {
    if (model.isEmpty) return false;
    return _modelsUseToolReExp?.hasMatch(model) ?? false;
  }

  static bool get canUseToolNow => canUseTool(current.model);

  static Future<bool> updateModels({bool force = false}) async {
    try {
      models.value = await ModelsCacher.fetch(vn.value.id, refresh: force);
      return true;
    } catch (e) {
      Loggers.app.warning('Failed to update models', e);
      models.value = [];
      return false;
    }
  }

  static void apply() {
    if (vn.value.id == ChatConfig.defaultId) {
      Loggers.app.info('Using default profile');
    } else {
      Loggers.app.info('Profile [${vn.value.name}]');
    }
    OpenAI.apiKey = vn.value.key;
    OpenAI.baseUrl = vn.value.url;
  }

  static void switchToDefault(BuildContext context) {
    final cfg = Stores.config.fetch(ChatConfig.defaultId);
    if (cfg != null) return setTo(cfg);

    setTo(ChatConfig.defaultOne);
    Loggers.app.warning('Default config not found');
  }

  static void _initToolRegexp() {
    final prop = Stores.setting.modelsUseTool;

    void setExp() {
      final val = prop.fetch();
      _modelsUseToolReExp = RegExp(val);
    }

    setExp();
    prop.listenable().addListener(setExp);
  }

  @Deprecated('Mark it as deprecated to avoid using it directly')
  static final _init = () {
    _initToolRegexp();
    final selectedKey = Stores.config.profileId.fetch();
    final selected = Stores.config.fetch(selectedKey);
    return selected ?? ChatConfig.defaultOne;
  }();
}

abstract final class ModelsCacher {
  static final models = <String, List<String>>{};
  static final updateTime = <String, DateTime>{};

  static Future<List<String>> fetch(String key, {bool refresh = false}) async {
    final now = DateTime.now();
    final last = updateTime[key];
    if (!refresh && (last != null && now.difference(last).inMinutes < 5)) {
      final models_ = models[key];
      if (models_ != null) return models_;
    }

    final val = await OpenAI.instance.model.list();
    final strs = val.map((e) => e.id).toList();
    models[key] = strs;
    updateTime[key] = now;
    return strs;
  }
}
