import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/core/llm/store.dart';
import 'package:gpt_box/data/store/all.dart';

/// Everything a user would miss on a new device, except keys: those stay in
/// the keychain of the device they were entered on.
///
/// Chats are pi sessions, append-only logs, so merging one is a question of
/// which log extends which. See [merge].
final class Backup implements Mergeable {
  const Backup({
    required this.date,
    required this.chats,
    required this.llm,
    required this.tools,
    required this.settings,
    required this.sessions,
  });

  static const formatVersion = 3;

  final int date;
  final Map<String, Object?> chats;
  final Map<String, Object?> llm;
  final Map<String, Object?> tools;
  final Map<String, Object?> settings;

  /// Session files by path: `{text, mtime}`.
  final Map<String, ({String text, int mtime})> sessions;

  static Future<Backup> fromStores() async {
    final files = SqlitePiSessionStore.instance;
    final sessions = <String, ({String text, int mtime})>{};
    for (final MapEntry(key: path, value: text) in files.dump().entries) {
      final stat = await files.stat(path);
      sessions[path] = (text: text, mtime: stat?.modified.millisecondsSinceEpoch ?? 0);
    }
    return Backup(
      date: DateTime.now().millisecondsSinceEpoch,
      chats: Stores.chat.getAllMap(includeInternalKeys: true),
      llm: Stores.llm.getAllMap(includeInternalKeys: true),
      tools: Stores.mcp.getAllMap(includeInternalKeys: true),
      settings: Stores.setting.getAllMap(includeInternalKeys: true),
      sessions: sessions,
    );
  }

  Map<String, Object?> toJson() => {
    'version': formatVersion,
    'date': date,
    'chats': chats,
    'llm': llm,
    'tools': tools,
    'settings': settings,
    'sessions': {
      for (final MapEntry(:key, :value) in sessions.entries) key: {'text': value.text, 'mtime': value.mtime},
    },
  };

  factory Backup.fromJson(Map<String, Object?> j) {
    final v = j['version'];
    if (v != formatVersion) throw FormatException('Unsupported backup version: $v');
    Map<String, Object?> map(String k) => ((j[k] as Map?) ?? const {}).cast<String, Object?>();
    return Backup(
      date: j['date'] as int? ?? 0,
      chats: map('chats'),
      llm: map('llm'),
      tools: map('tools'),
      settings: map('settings'),
      sessions: {
        for (final MapEntry(:key, :value) in map('sessions').entries)
          key: (text: (value as Map)['text'] as String, mtime: value['mtime'] as int? ?? 0),
      },
    );
  }

  factory Backup.fromJsonString(String raw) => Backup.fromJson((json.decode(raw) as Map).cast<String, Object?>());

  String get dateStr => DateTime.fromMillisecondsSinceEpoch(date).simple();

  /// Writes the backup to [Paths.bak] and returns its path.
  static Future<String> toFile() async {
    final bak = await fromStores();
    await File(Paths.bak).writeAsString(json.encode(bak.toJson()));
    return Paths.bak;
  }

  /// Merges this backup into the local data.
  ///
  /// Stores merge per key by modification time. A session is taken from the
  /// backup when it is missing here, or when it extends the local log. Two
  /// logs that have diverged — the same chat continued on two devices — keep
  /// the newer one, or with [force] the backup's.
  @override
  Future<void> merge({bool force = false}) async {
    await Mergeable.mergeStore(backupData: chats, store: Stores.chat, force: force);
    await Mergeable.mergeStore(backupData: llm, store: Stores.llm, force: force);
    await Mergeable.mergeStore(backupData: tools, store: Stores.mcp, force: force);
    await Mergeable.mergeStore(backupData: settings, store: Stores.setting, force: force);

    final files = SqlitePiSessionStore.instance;
    var closed = false;
    for (final MapEntry(key: path, value: remote) in sessions.entries) {
      final local = await files.read(path);
      final localMtime = (await files.stat(path))?.modified.millisecondsSinceEpoch ?? 0;
      final take = switch (local) {
        null => true,
        _ when local == remote.text => false,
        _ when remote.text.startsWith(local) => true,
        _ when local.startsWith(remote.text) => false,
        _ => force || remote.mtime > localMtime,
      };
      if (!take) continue;
      // An open session would keep writing over what is replaced here.
      if (!closed) {
        await Chats.closeAll();
        closed = true;
      }
      await files.write(path, remote.text);
    }

    Stores.chat.changes.notify();
    await Llm.applyCustomProviders();
    await Chats.reconfigure();
    RNodes.app.notify();
  }
}
