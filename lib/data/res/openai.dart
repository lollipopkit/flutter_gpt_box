import 'package:dart_openai/dart_openai.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';

abstract final class OpenAICfg {
  static final models = <String>[].vn;

  static final vn = () {
    final selectedKey = Stores.config.selectedKey.fetch();
    final selected = Stores.config.fetch(selectedKey);
    return selected ?? ChatConfig.defaultOne;
  }()
      .vn;

  static ChatConfig get current => vn.value;

  static void setTo(ChatConfig config, BuildContext context) {
    final old = vn.value;
    vn.value = config;
    apply();
    config.save();
    Stores.config.selectedKey.put(config.id);

    if (old.id != config.id) {
      Funcs.throttle(
        updateModels,
        id: 'setTo-${config.id}',
        duration: 1000 * 30,
      )?.then((ok) {
        if (!ok && context.mounted) {
          context.showSnackBar('${l10n.failed}: update models list');
        }
      });
    }
  }

  static Future<bool> updateModels() async {
    try {
      final val = await OpenAI.instance.model.list();
      models.value = val.map((e) => e.id).toList();
      return true;
    } catch (e) {
      Loggers.app.warning('Failed to update models', e);
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
    if (cfg != null) {
      setTo(cfg, context);
    } else {
      setTo(ChatConfig.defaultOne, context);
      Loggers.app.warning('Default config not found');
    }
  }
}
