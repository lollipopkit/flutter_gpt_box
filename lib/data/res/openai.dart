import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/api_balance.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/github_model.dart';
import 'package:gpt_box/data/model/chat/type.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:dio/dio.dart';

abstract final class Cfg {
  static var client = OpenAIClient(
    apiKey: vn.value.key,
    baseUrl: vn.value.url,
  );
  static final models = nvn<List<String>>();

  // ignore: deprecated_member_use_from_same_package
  static final vn = _init.vn;

  static ChatConfig get current => vn.value;

  static final _store = Stores.config;

  static final chatType = ChatType.text.vn;

  static Future<void> setTo({ChatConfig? cfg, String? id}) async {
    if (cfg == null) {
      cfg = _store.fetch(id ?? _store.profileId.get());
      if (cfg == null) {
        Loggers.app.warning('Profile not found: $id');
        return;
      }
    }

    final old = vn.value;
    vn.value = cfg;
    Loggers.app.info('Switch to profile $cfg');
    applyClient();
    cfg.save();
    _store.profileId.set(cfg.id);

    if (cfg.shouldUpdateRelated(old)) {
      await updateModels(diffUrl: old.url != cfg.url);
      ApiBalance.refresh();
    }
  }

  static RegExp? _modelsUseMcpReExp;
  static bool isMcpCompatible({String? model}) {
    model ??= current.model;
    if (model.isEmpty) return false;
    return _modelsUseMcpReExp?.hasMatch(model) ?? false;
  }

  /// Update models list
  /// - [force] force update, ignore cache
  /// - [diffUrl] abbreviation for `isDifferentUrl`.
  /// if true, skip setting [models.value] to empty list if failed
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

  /// Apply the current profile to the openai client.
  static void applyClient() {
    client = OpenAIClient(
      apiKey: vn.value.key,
      baseUrl: vn.value.url,
    );
  }

  /// Show the dialog to pick the model.
  ///
  /// - [context] the context to show the dialog.
  /// - [onSelected] the callback when a model is selected.
  /// - [initial] the initial model to show.
  ///
  /// Return the model name if any model is picked, otherwise return null.
  static Future<void> showPickModelDialog(
    BuildContext context, {
    required void Function(String model) onSelected,
    required String? initial,
  }) async {
    if (Cfg.current.key.isEmpty) {
      context.showRoundDialog(
        title: l10n.attention,
        child: Text(l10n.needOpenAIKey),
        actions: Btnx.oks,
      );
      return;
    }

    final selected = await context.showPickSingleDialog(
      items: Cfg.models.value ?? [],
      initial: initial,
      title: l10n.model,
      actions: [
        TextButton(
          onPressed: () async {
            context.pop();
            await context.showLoadingDialog(
              fn: () => Cfg.updateModels(force: true),
            );
            await showPickModelDialog(
              context,
              onSelected: onSelected,
              initial: initial,
            );
          },
          child: Text(l10n.refresh),
        ),
        TextButton(
          onPressed: () {
            void onSave(String s) {
              context.pop();
              if (s.isEmpty) {
                context.showSnackBar(l10n.emptyFields(l10n.model));
                return;
              }
              onSelected(s);
            }

            context.pop();
            final ctrl = TextEditingController();
            context.showRoundDialog(
              title: l10n.custom,
              child: Input(
                controller: ctrl,
                autoFocus: true,
                onSubmitted: onSave,
              ),
              actions: Btn.ok(onTap: () => onSave(ctrl.text)).toList,
            );
          },
          child: Text(l10n.custom),
        ),
      ],
    );

    if (selected == null) return;
    onSelected(selected);
  }

  /// Show the dialog to pick the profile.
  ///
  /// - [actions] additional actions
  static Future<void> showPickProfileDialog(
    BuildContext context, {
    List<Widget>? actions,
  }) async {
    final map =
        Stores.config.getAllMapTyped<ChatConfig>(includeInternalKeys: false);
    final vals = map.values.toList();
    final newCfg = await context.showPickSingleDialog(
      items: vals,
      initial: Cfg.current,
      title: l10n.profile,
      display: (p0) => p0.displayName,
      actions: actions,
    );

    if (newCfg == null) return;
    await context.showLoadingDialog(fn: () => Cfg.setTo(cfg: newCfg));
  }

  static Future<void> switchToDefault(BuildContext context) async {
    final cfg = _store.fetch(ChatConfigX.defaultId);
    if (cfg != null) return setTo(cfg: cfg);

    Loggers.app.warning('Default config not found');
    return setTo(cfg: ChatConfigX.defaultOne);
  }

  static void _initMcpRegexp() {
    final prop = Stores.mcp.mcpRegExp;

    void setExp() {
      final val = prop.get();
      _modelsUseMcpReExp = RegExp(val);
    }

    setExp();
    prop.listenable().addListener(setExp);
  }

  @Deprecated('Mark it as deprecated to avoid using it directly')
  static final _init = () {
    _initMcpRegexp();
    final selectedKey = _store.profileId.fetch();
    final selected = _store.fetch(selectedKey);
    return selected ?? ChatConfigX.defaultOne;
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

    final endpoint = Cfg.current.url;
    // For most compatibility, use dio instead of openai_dart
    final url = switch (endpoint) {
      _ when endpoint.startsWith('https://api.deepseek.com') =>
        'https://api.deepseek.com/v1/models',
      _ when endpoint.startsWith('https://models.inference.ai.azure.com') =>
        'https://models.inference.ai.azure.com/models',
      _ => '$endpoint/models',
    };
    final val = await myDio.get(
      url,
      options: Options(
        headers: {'Authorization': 'Bearer ${Cfg.current.key}'},
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
