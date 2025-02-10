import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/core/util/json.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/res/rnode.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/home.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Backup');

class Backup implements Mergeable {
  static const validVer = 2;

  final int version;
  final List<ChatHistory> history;
  final List<ChatConfig> configs;
  final Map<String, dynamic> tools;
  // TODO: It's optional
  final Map<String, ChatHistory> trashes;
  final int lastModTime;

  const Backup({
    required this.version,
    required this.history,
    required this.configs,
    required this.tools,
    required this.trashes,
    required this.lastModTime,
  });

  static Backup fromJson(Map<String, dynamic> json) {
    final version = () {
      try {
        return json['version'] as int;
      } catch (e) {
        return 1;
      }
    }();
    final lastModTime = () {
      try {
        return json['lastModTime'] as int;
      } catch (e) {
        return 0;
      }
    }();
    final configs = fromJsonList(json['configs'], ChatConfig.fromJson);
    final history = fromJsonList(json['history'], ChatHistory.fromJson);
    final tools = switch (json['tools']) {
      final Map map => map.cast<String, dynamic>(),
      _ => <String, dynamic>{},
    };
    final trashes = fromJsonMap(json['trashes'], ChatHistory.fromJson);
    return Backup(
      version: version,
      lastModTime: lastModTime,
      configs: configs,
      history: history,
      tools: tools,
      trashes: trashes,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'history': history,
        'configs': configs,
        'lastModTime': lastModTime,
      };

  static Backup fromJsonString(String raw) {
    return Backup.fromJson(json.decode(raw));
  }

  static Future<Backup> loadFromStore() async {
    return Backup(
      version: validVer,
      lastModTime: Stores.lastModTime,
      history: Stores.history.fetchAll().values.toList(),
      configs: Stores.config.fetchAll().values.toList(),
      tools: await Stores.tool.getAllMap(),
      trashes: Stores.trash.histories,
    );
  }

  static Future<String> backup() async {
    final bak = await Backup.loadFromStore();
    return json.encode(bak);
  }

  static Future<void> backupToFile() async {
    await File(Paths.bak).writeAsString(await backup());
  }

  @override
  Future<void> merge({bool force = false}) async {
    final curTime = Stores.lastModTime;
    final bakTime = lastModTime;
    final override = force || curTime < bakTime;
    if (!override) {
      _logger.info('Skip merge, local is newer');
      return;
    }

    // History
    final nowHistoryKeys = Stores.history.box.keys.toSet();
    final bakHistoryKeys = history.map((e) => e.id).toSet();
    final historyNew = bakHistoryKeys.difference(nowHistoryKeys);
    for (final id in historyNew) {
      Stores.history.put(history.firstWhere((e) => e.id == id));
    }
    final historyDelete = nowHistoryKeys.difference(bakHistoryKeys);
    final historyUpdate = nowHistoryKeys.intersection(bakHistoryKeys);
    for (final id in historyDelete) {
      Stores.history.delete(id);
    }
    for (final id in historyUpdate) {
      Stores.history.put(history.firstWhere((e) => e.id == id));
    }

    // Config
    final nowConfigKeys = Stores.config.box.keys.toSet();
    final bakConfigKeys = configs.map((e) => e.id).toSet();
    final configNew = bakConfigKeys.difference(nowConfigKeys);
    for (final id in configNew) {
      Stores.config.put(configs.firstWhere((e) => e.id == id));
    }
    final configDelete = nowConfigKeys.difference(bakConfigKeys);
    final configUpdate = nowConfigKeys.intersection(bakConfigKeys);
    for (final id in configDelete) {
      Stores.config.delete(id);
    }
    for (final id in configUpdate) {
      Stores.config.put(configs.firstWhere((e) => e.id == id));
    }

    // Tool
    final nowToolKeys = Stores.tool.box.keys.toSet();
    final bakToolKeys = tools.keys.toSet();
    final toolNew = bakToolKeys.difference(nowToolKeys);
    for (final key in toolNew) {
      Stores.tool.box.put(key, tools[key]);
    }
    final toolDelete = nowToolKeys.difference(bakToolKeys);
    final toolUpdate = nowToolKeys.intersection(bakToolKeys);
    for (final key in toolDelete) {
      Stores.tool.box.delete(key);
    }
    for (final key in toolUpdate) {
      Stores.tool.box.put(key, tools[key]);
    }

    // Trash
    final nowTrashKeys = Stores.trash.box.keys.toSet();
    final bakTrashKeys = trashes.keys.toSet();
    final trashNew = bakTrashKeys.difference(nowTrashKeys);
    for (final key in trashNew) {
      Stores.trash.box.put(key, trashes[key]);
    }
    final trashDelete = nowTrashKeys.difference(bakTrashKeys);
    final trashUpdate = nowTrashKeys.intersection(bakTrashKeys);
    for (final key in trashDelete) {
      Stores.trash.box.delete(key);
    }
    for (final key in trashUpdate) {
      Stores.trash.box.put(key, trashes[key]);
    }

    RNodes.app.notify();
    HomePage.afterRestore();
    _logger.info('Merge done');
  }
}
