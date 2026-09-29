import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/core/util/json.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
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
  final Map<String, ChatHistory>? trashes;
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
    // Null when absent: an older backup without trashes must not empty them.
    final trashes = switch (json['trashes']) {
      final Map map => fromJsonMap(map, ChatHistory.fromJson),
      _ => null,
    };
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
    'tools': tools,
    'trashes': ?trashes,
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
      tools: Stores.mcp.getAllMap(),
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

    _sync(Stores.history, {for (final e in history) e.id: e});
    _sync(
      Stores.config,
      {for (final e in configs) e.id: e},
      keep: Stores.config.nonProfileKeys,
    );
    _sync(Stores.mcp, tools);
    final trashes_ = trashes;
    if (trashes_ != null) _sync(Stores.trash, trashes_);

    RNodes.app.notify();
    HomePage.afterRestore();
    _logger.info('Merge done');
  }

  /// Makes [store] hold exactly [data]: adds and updates every entry in it,
  /// removes every key not in it except those in [keep].
  static void _sync(
    SqliteStore store,
    Map<String, Object?> data, {
    Set<String> keep = const {},
  }) {
    for (final key in store.keys().difference(data.keys.toSet())) {
      if (keep.contains(key)) continue;
      store.remove(key);
    }
    for (final MapEntry(:key, :value) in data.entries) {
      if (value != null) store.set(key, value);
    }
  }

  String get date {
    return DateTime.fromMillisecondsSinceEpoch(lastModTime).simple();
  }
}
