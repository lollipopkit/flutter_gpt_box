import 'dart:convert';

import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/store/all.dart';

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
    if (curTime == bakTime) {
      return null;
    }
    if (curTime > bakTime && !force) {
      return false;
    }
    for (final s in settings.keys) {
      Stores.setting.box.put(s, settings[s]);
    }
    for (final s in history.keys) {
      Stores.history.box.put(s, history[s]);
    }

    // update last modified time, avoid restore again
    Stores.setting.box.updateLastModified(lastModTime);

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
