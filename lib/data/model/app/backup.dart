import 'dart:convert';

import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/page/home/home.dart';

const backupFormatVersion = 1;

class Backup {
  final int version;
  final int date;
  final Map<String, dynamic> history;
  final Map<String, dynamic> settings;
  final int? lastModTime;

  const Backup({
    required this.version,
    required this.date,
    required this.settings,
    required this.history,
    this.lastModTime,
  });

  Backup.fromJson(Map<String, dynamic> json)
      : version = json['version'] as int,
        date = json['date'],
        lastModTime = json['lastModTime'],
        settings = json['settings'] ?? {},
        history = json['history'] ?? {};

  Map<String, dynamic> toJson() => {
        'version': version,
        'date': date,
        'settings': settings,
        'history': history,
      };

  Backup.loadFromStore()
      : version = backupFormatVersion,
        date = DateTime.now().millisecondsSinceEpoch,
        lastModTime = Stores.lastModTime,
        settings = Stores.setting.box.toJson(),
        history = Stores.history.box.toJson();

  static Future<String> backup() async {
    final result = _diyEncrypt(json.encode(Backup.loadFromStore()));
    return result;
  }

  /// - Return null if same time
  /// - Return false if local is newer
  /// - Return true if restore success
  Future<bool?> restore({bool force = false}) async {
    final curTime = Stores.lastModTime ?? 0;
    final bakTime = lastModTime ?? 0;
    final shouldRestore = force || curTime < bakTime;

    // Settings
    final nowSettingsKeys = Stores.setting.box.keys.toSet();
    final bakSettingsKeys = settings.keys.toSet();
    final newSettingsKeys = bakSettingsKeys.difference(nowSettingsKeys);
    final delSettingsKeys = nowSettingsKeys.difference(bakSettingsKeys);
    final sameSettingsKeys = nowSettingsKeys.intersection(bakSettingsKeys);
    for (final s in newSettingsKeys) {
      Stores.setting.box.put(s, settings[s]);
    }
    if (shouldRestore) {
      for (final s in sameSettingsKeys) {
        Stores.setting.box.put(s, settings[s]);
      }
      for (final s in delSettingsKeys) {
        Stores.setting.box.delete(s);
      }
    }

    // History
    final nowHistoryKeys = Stores.history.box.keys.toSet();
    final bakHistoryKeys = history.keys.toSet();
    final newHistoryKeys = bakHistoryKeys.difference(nowHistoryKeys);
    final delHistoryKeys = nowHistoryKeys.difference(bakHistoryKeys);
    final sameHistoryKeys = nowHistoryKeys.intersection(bakHistoryKeys);
    for (final s in newHistoryKeys) {
      Stores.history.box.put(s, history[s]);
    }
    if (shouldRestore) {
      for (final s in sameHistoryKeys) {
        Stores.history.box.put(s, history[s]);
      }
      for (final s in delHistoryKeys) {
        Stores.history.box.delete(s);
      }
    }

    loadFromStore();
    RebuildNode.app.rebuild();

    return true;
  }

  Backup.fromJsonString(String raw)
      : this.fromJson(json.decode(_diyDecrypt(raw)));
}

String _diyEncrypt(String raw) => json.encode(
      raw.codeUnits.map((e) => e * 2 + 1).toList(growable: false),
    );

String _diyDecrypt(String raw) {
  try {
    final list = json.decode(raw);
    final sb = StringBuffer();
    for (final e in list) {
      sb.writeCharCode((e - 1) ~/ 2);
    }
    return sb.toString();
  } catch (e, trace) {
    Loggers.app.warning('Backup decrypt failed', e, trace);
    rethrow;
  }
}
