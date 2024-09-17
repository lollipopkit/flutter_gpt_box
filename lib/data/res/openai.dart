import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/api_balance.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:dio/dio.dart';

abstract final class OpenAICfg {
  static OpenAIClient? client;
  static final models = <String>[].vn;

  // ignore: deprecated_member_use_from_same_package
  static final vn = _init.vn;

  static ChatConfig get current => vn.value;

  static final _store = Stores.config;

  static void setTo(ChatConfig config) {
    final old = vn.value;
    vn.value = config;
    apply();
    config.save();
    _store.profileId.put(config.id);

    if (config.shouldUpdateRelavance(old)) {
      updateModels(diffUrl: old.url != config.url);
      ApiBalance.refresh();
    }
  }

  static void setToId([String? id]) {
    final cfg = _store.fetch(id ?? _store.profileId.fetch());
    if (cfg != null) {
      setTo(cfg);
    } else {
      Loggers.app.warning('Config [$id] not found');
    }
  }

  static RegExp? _modelsUseToolReExp;
  static bool isToolCompatible({String? model}) {
    model ??= current.model;
    if (model.isEmpty) return false;
    return _modelsUseToolReExp?.hasMatch(model) ?? false;
  }

  /// Update models list
  /// - [force] force update, ignore cache
  /// - [diffUrl] if true, not set [models.value] to empty list if failed
  static Future<bool> updateModels({
    bool force = false,
    bool diffUrl = false,
  }) async {
    if (current.url.startsWith('https://api.openai.com') &&
        current.key.isEmpty) {
      return false;
    }
    try {
      models.value = await _ModelsCacher.fetch(current.id, refresh: force);
      return true;
    } catch (e, s) {
      Loggers.app.warning('Failed to update models', e, s);
      if (diffUrl) models.value = [];
      return false;
    }
  }

  static void apply() {
    if (vn.value.id == ChatConfig.defaultId) {
      Loggers.app.info('Using default profile');
    } else {
      Loggers.app.info('Profile [${vn.value.name}]');
    }
    client = OpenAIClient(
      apiKey: vn.value.key,
      baseUrl: vn.value.url,
    );
  }

  static void switchToDefault(BuildContext context) {
    final cfg = _store.fetch(ChatConfig.defaultId);
    if (cfg != null) return setTo(cfg);

    setTo(ChatConfig.defaultOne);
    Loggers.app.warning('Default config not found');
  }

  static void _initToolRegexp() {
    final prop = Stores.tool.toolsRegExp;

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
    final selectedKey = _store.profileId.fetch();
    final selected = _store.fetch(selectedKey);
    return selected ?? ChatConfig.defaultOne;
  }();
}

abstract final class _ModelsCacher {
  static final models = <String, List<String>>{};
  static final updateTime = <String, DateTime>{};

  static Future<List<String>> fetch(String key, {bool refresh = false}) async {
    final now = DateTime.now();
    final last = updateTime[key];
    if (!refresh && (last != null && now.difference(last).inMinutes < 5)) {
      final models_ = models[key];
      if (models_ != null) return models_;
    }

    // For most compatibility, use dio instead of openai_dart
    final val = await myDio.get<Map>(
      '${OpenAICfg.current.url}/models',
      options: Options(
        headers: {'Authorization': 'Bearer ${OpenAICfg.current.key}'},
      ),
    );
    final resp = val.data?['data'] as List?;
    final strs = resp?.map((e) => e['id']).whereType<String>().toList();
    if (strs == null) {
      throw 'get models list failed';
    }
    models[key] = strs;
    updateTime[key] = now;
    return strs;
  }
}
