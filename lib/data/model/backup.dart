import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/core/llm/store.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/data/store/setting.dart';

/// A backup is encrypted and there is no password to open it with.
final class BackupPasswordNeeded implements Exception {
  const BackupPasswordNeeded();

  @override
  String toString() => 'The backup is encrypted';
}

/// A backup written by a newer build, in a format this one cannot read.
/// Merging it would lose what this build does not know about.
final class BackupTooNew implements Exception {
  const BackupTooNew(this.version);

  final int version;

  @override
  String toString() => 'The backup is from a newer version of the app (format $version)';
}

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
    required this.memory,
    required this.settings,
    required this.sessions,
  });

  static const formatVersion = 3;

  final int date;
  final Map<String, Object?> chats;
  final Map<String, Object?> llm;
  final Map<String, Object?> tools;

  /// The memory's files, as [MemoryStore] keeps them.
  final Map<String, Object?> memory;

  /// Empty when the backup leaves the settings out (sync without "sync app
  /// settings"): then they are not touched on merge either.
  final Map<String, Object?> settings;

  /// Session files by path: `{text, mtime}`.
  final Map<String, ({String text, int mtime})> sessions;

  static Future<Backup> fromStores({bool includeSettings = true}) async {
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
      memory: Stores.memory.getAllMap(includeInternalKeys: true),
      settings: includeSettings ? _withoutDeviceLocal(Stores.setting.getAllMap(includeInternalKeys: true)) : const {},
      sessions: sessions,
    );
  }

  /// [data] without this device's own settings, values and timestamps both.
  static Map<String, Object?> _withoutDeviceLocal(Map<String, Object?> data) {
    final ts = data[Stores.setting.lastUpdateTsKey];
    return {
      for (final MapEntry(:key, :value) in data.entries)
        if (!SettingStore.deviceLocalKeys.contains(key)) key: value,
      if (ts is Map)
        Stores.setting.lastUpdateTsKey: {
          for (final MapEntry(:key, :value) in ts.entries)
            if (!SettingStore.deviceLocalKeys.contains(key)) key: value,
        },
    };
  }

  /// A stamp of everything [fromStores] reads: it changes whenever a backup
  /// would. Cheap, for deciding whether a sync has anything to do.
  static String localStamp({required bool includeSettings}) {
    int newest(Map<String, int>? ts) => ts == null || ts.isEmpty ? 0 : ts.values.reduce((a, b) => a > b ? a : b);
    return [
      newest(Stores.chat.lastUpdateTs),
      newest(Stores.llm.lastUpdateTs),
      newest(Stores.mcp.lastUpdateTs),
      newest(Stores.memory.lastUpdateTs),
      if (includeSettings)
        newest({
          for (final MapEntry(:key, :value) in (Stores.setting.lastUpdateTs ?? const <String, int>{}).entries)
            if (!SettingStore.deviceLocalKeys.contains(key)) key: value,
        }),
      SqlitePiSessionStore.instance.latestMtime(),
    ].join('.');
  }

  Backup withoutSettings() =>
      Backup(date: date, chats: chats, llm: llm, tools: tools, memory: memory, settings: const {}, sessions: sessions);

  Map<String, Object?> toJson() => {
    'version': formatVersion,
    'date': date,
    'chats': chats,
    'llm': llm,
    'tools': tools,
    'memory': memory,
    'settings': settings,
    'sessions': {
      for (final MapEntry(:key, :value) in sessions.entries) key: {'text': value.text, 'mtime': value.mtime},
    },
  };

  factory Backup.fromJson(Map<String, Object?> j) {
    final v = j['version'];
    if (v is int && v > formatVersion) throw BackupTooNew(v);
    if (v != formatVersion) throw FormatException('Unsupported backup version: $v');
    Map<String, Object?> map(String k) => ((j[k] as Map?) ?? const {}).cast<String, Object?>();
    return Backup(
      date: j['date'] as int? ?? 0,
      chats: map('chats'),
      llm: map('llm'),
      tools: map('tools'),
      memory: map('memory'),
      settings: map('settings'),
      sessions: {
        for (final MapEntry(:key, :value) in map('sessions').entries)
          key: (text: (value as Map)['text'] as String, mtime: value['mtime'] as int? ?? 0),
      },
    );
  }

  /// Reads a backup file's text: plain JSON, or encrypted with [password].
  /// Decryption and decoding run off this isolate.
  static Future<Backup> parse(String text, {String? password}) async {
    final trimmed = text.trim();
    if (Cryptor.isEncrypted(trimmed) && (password == null || password.isEmpty)) {
      throw const BackupPasswordNeeded();
    }
    final map = await compute(_decode, (trimmed, password));
    return Backup.fromJson(map);
  }

  static bool isEncrypted(String text) => Cryptor.isEncrypted(text.trim());

  static Map<String, Object?> _decode((String, String?) args) {
    final (text, password) = args;
    String raw;
    if (Cryptor.isEncrypted(text)) {
      final bytes = Cryptor.decryptBytes(text, password!);
      // Compressed inside the envelope: gzip's magic first.
      raw = bytes.length > 1 && bytes[0] == 0x1f && bytes[1] == 0x8b
          ? utf8.decode(gzip.decode(bytes))
          : utf8.decode(bytes);
    } else {
      raw = text;
    }
    return (json.decode(raw) as Map).cast<String, Object?>();
  }

  /// The backup as file text: with a [password], gzipped JSON in fl_lib's
  /// AES-GCM envelope; without, plain JSON.
  String encode({String? password}) {
    final raw = json.encode(toJson());
    if (password == null || password.isEmpty) return raw;
    return Cryptor.encryptBytes(gzip.encode(utf8.encode(raw)), password);
  }

  String get dateStr => DateTime.fromMillisecondsSinceEpoch(date).simple();

  /// Writes a backup of the stores to [name] in [Paths.doc] (the sync file,
  /// [Paths.bakName], by default) and returns its path.
  static Future<String> toFile({String? password, bool includeSettings = true, String? name}) async {
    final bak = await fromStores(includeSettings: includeSettings);
    final path = name == null ? Paths.bak : Paths.doc.joinPath(name);
    await File(path).writeAsString(bak.encode(password: password));
    return path;
  }

  /// Merges this backup into the local data.
  ///
  /// Each store merges per key, newest write wins; a key the backup has a
  /// timestamp for but no value is one deleted there, and is deleted here if
  /// that happened after the local write. [force] (a restore the user asked
  /// for) takes the backup's side wherever both have the key, but never
  /// deletes what only this device has.
  ///
  /// A session is taken from the backup when it is missing here, or when it
  /// extends the local log; two logs that have diverged — the same chat
  /// continued on two devices — keep the newer, or with [force] the backup's.
  /// Sessions of chats the merge deleted go with them.
  @override
  Future<void> merge({bool force = false}) async {
    final before = Stores.chat.keys().toSet();
    _mergeStore(Stores.chat, chats, force: force);
    _mergeStore(Stores.llm, llm, force: force);
    _mergeStore(Stores.mcp, tools, force: force);
    _mergeStore(Stores.memory, memory, force: force);
    if (settings.isNotEmpty) {
      _mergeStore(Stores.setting, _withoutDeviceLocal(settings), force: force, keep: SettingStore.deviceLocalKeys);
    }
    final alive = Stores.chat.keys().toSet();
    final gone = before.difference(alive);

    final files = SqlitePiSessionStore.instance;
    var closed = false;
    Future<void> closeChats() async {
      // An open session would keep writing over what is replaced here.
      if (closed) return;
      closed = true;
      await Chats.closeAll();
    }

    for (final MapEntry(key: path, value: remote) in sessions.entries) {
      // A chat deleted here, or never synced: its session is not wanted.
      if (SqlitePiSessionStore.chatIdOf(path, alive) == null) continue;
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
      await closeChats();
      await files.write(path, remote.text);
    }
    if (gone.isNotEmpty) {
      for (final path in files.dump().keys) {
        if (SqlitePiSessionStore.chatIdOf(path, gone) == null) continue;
        await closeChats();
        await files.remove(path);
      }
      if (gone.contains(Chats.current.value)) Chats.current.value = null;
    }

    Stores.chat.changes.notify();
    await Llm.applyCustomProviders();
    await Chats.reconfigure();
    RNodes.app.notify();
  }

  /// One store, per key: see [merge]. Keys in [keep] are this device's alone
  /// and never touched.
  static void _mergeStore(
    SqliteStore store,
    Map<String, Object?> data, {
    required bool force,
    Set<String> keep = const {},
  }) {
    final tsKey = store.lastUpdateTsKey;
    final bakTs = <String, int>{
      for (final MapEntry(:key, :value) in ((data[tsKey] as Map?) ?? const {}).entries)
        if (value is int) '$key': value,
    };
    final curTs = store.lastUpdateTs ?? const <String, int>{};
    final curKeys = store.keys(includeInternalKeys: true)..remove(tsKey);
    final bakKeys = data.keys.toSet()..remove(tsKey);

    SqliteStore.transact(() {
      for (final key in {...bakKeys, ...curKeys, ...bakTs.keys}) {
        // This build's bookkeeping (migration markers) and this device's own
        // settings are never another device's to set.
        if (keep.contains(key) || key == tsKey || store.isInternalKey(key)) continue;
        final b = bakTs[key] ?? 0;
        final c = curTs[key] ?? 0;
        final inBak = bakKeys.contains(key);
        final inCur = curKeys.contains(key);
        if (inBak) {
          // Missing here and not deleted here since: take it. Present on
          // both: the newer, or with force the backup's.
          final take = inCur ? force || b > c : b >= c || force;
          final value = data[key];
          if (!take || value == null) continue;
          store.set(key, value, updateLastUpdateTsOnSet: false);
          if (b > 0) unawaited(store.updateLastUpdateTs(ts: b, key: key));
        } else if (inCur && bakTs.containsKey(key) && b > c) {
          // Deleted there after it was last written here.
          store.remove(key, updateLastUpdateTsOnRemove: false);
          unawaited(store.updateLastUpdateTs(ts: b, key: key));
        }
      }
    });
  }
}
