import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/api_balance.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/github_model.dart';
import 'package:gpt_box/data/res/url.dart';
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

    if (config.shouldUpdateRelated(old)) {
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
  /// - [diffUrl] abbreviation for `isDifferentUrl`.
  /// if true, not set [models.value] to empty list if failed
  static Future<bool> updateModels({
    bool force = false,
    bool diffUrl = false,
  }) async {
    // Some private sites may not need key
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

    final endpoint = OpenAICfg.current.url;
    // For most compatibility, use dio instead of openai_dart
    final val = await myDio.get(
      '$endpoint/models',
      options: Options(
        headers: {'Authorization': 'Bearer ${OpenAICfg.current.key}'},
      ),
    );
    final strs = _decodeModels(val, endpoint);
    models[key] = strs;
    updateTime[key] = now;
    return strs;
  }

  static List<String> _decodeModels(Response resp, String endpoint) {
    final respData = resp.data;
    if (resp.statusCode != 200 || respData == null) {
      throw 'get models list failed';
    }
    final modelStrs = <String>[];
    switch (endpoint) {
      // Using Github models
      case Urls.githubModels:
        final data = respData as List;
        final models = GithubModelsList.fromJson(data);
        modelStrs.addAll(models.models.map((e) => e.name));
      default:
        final data = respData as Map;
        final resp = data['data'] as List;
        modelStrs.addAll(resp.map((e) => e['id']).whereType<String>());
    }
    return modelStrs;
  }
}
