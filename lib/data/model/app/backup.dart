import 'dart:convert';
import 'dart:io';

import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/res/path.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/page/home/home.dart';
import 'package:logging/logging.dart';

const backupFormatVersion = 2;

class Backup {
  final int version;
  final List<ChatHistory> history;
  final Map<String, dynamic> settings;
  final int lastModTime;

  const Backup({
    required this.version,
    required this.settings,
    required this.history,
    required this.lastModTime,
  });

  Backup.fromJson(Map<String, dynamic> json)
      : version = json['version'] as int,
        lastModTime = json['lastModTime'],
        settings = json['settings'] ?? {},
        history = ((json['history'] ?? []) as List<dynamic>)
            .map((e) => ChatHistory.fromJson(e.cast<String, dynamic>()))
            .toList();

  Map<String, dynamic> toJson() => {
        'version': version,
        'settings': settings,
        'history': history,
        'lastModTime': lastModTime,
      };

  static Backup? fromJsonString(String raw) {
    try {
      return Backup.fromJson(json.decode(raw));
    } catch (e, s) {
      Logger('Backup').warning('Parse backup failed', e, s);
    }
    return null;
  }

  Backup.loadFromStore()
      : version = backupFormatVersion,
        lastModTime = Stores.lastModTime,
        settings = Stores.setting.box.toJson(),
        history = Stores.history.fetchAll().values.toList();

  static Future<String> backup() async {
    final bak = Backup.loadFromStore();
    return json.encode(bak);
  }

  static Future<void> backupToFile() async {
    await File(await Paths.bak).writeAsString(await backup());
  }

  /// Merge logic:
  /// - Same id:
  ///   - If [override], restore
  ///   - If not [override], ignore
  /// - New id: restore
  /// - Deleted id:
  ///   - If [override], delete
  ///   - If not [override], ignore
  Future<void> merge({bool force = false}) async {
    final curTime = Stores.lastModTime;
    final bakTime = lastModTime;
    final override = force || curTime < bakTime;
    if (!override) {
      Logger('Backup').info('Backup is older than current, ignore');
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

    // Settings
    final nowSettingsKeys = Stores.setting.box.keys.toSet();
    final bakSettingsKeys = settings.keys.toSet();
    final settingsNew = bakSettingsKeys.difference(nowSettingsKeys);
    for (final key in settingsNew) {
      Stores.setting.box.put(key, settings[key]);
    }
    final settingsDelete = nowSettingsKeys.difference(bakSettingsKeys);
    final settingsUpdate = nowSettingsKeys.intersection(bakSettingsKeys);
    for (final key in settingsDelete) {
      Stores.setting.box.delete(key);
    }
    for (final key in settingsUpdate) {
      Stores.setting.box.put(key, settings[key]);
    }

    loadFromStore();
    RebuildNode.app.rebuild();

    Logger('Backup').info('Merge success');
  }
}
