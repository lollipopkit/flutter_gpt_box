import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_box/data/store/all.dart';

part 'backup2.freezed.dart';
part 'backup2.g.dart';

@freezed
abstract class BackupV2 with _$BackupV2 implements Mergeable {
  const BackupV2._();

  /// Construct a backup with the latest format (v2).
  ///
  /// All `Map<String, dynamic>` are:
  /// ```json
  /// {
  ///   "key1": Model{},
  ///   "_lastModTime": {
  ///     "key1": 1234567890,
  ///   },
  /// }
  /// ```
  const factory BackupV2({
    required int version,
    required int date,
    required Map<String, Object?> cfgs,
    required Map<String, Object?> tools,
    required Map<String, Object?> histories,
    required Map<String, Object?> trashes,
  }) = _BackupV2;

  factory BackupV2.fromJson(Map<String, dynamic> json) => _$BackupV2FromJson(json);

  @override
  Future<void> merge({bool force = false}) async {
    Loggers.app.info('Merging...');

    // Merge each store
    await Mergeable.mergeStore(backupData: cfgs, store: Stores.config, force: force);
    await Mergeable.mergeStore(backupData: tools, store: Stores.mcp, force: force);
    await Mergeable.mergeStore(backupData: histories, store: Stores.history, force: force);
    await Mergeable.mergeStore(backupData: trashes, store: Stores.trash, force: force);

    // Reload providers and notify listeners
    Provider.reload();
    RNodes.app.notify();

    Loggers.app.info('Merge completed');
  }

  static const formatVer = 2;

  static Future<BackupV2> loadFromStore() async {
    return BackupV2(
      version: formatVer,
      date: DateTimeX.timestamp,
      cfgs: Stores.config.getAllMap(includeInternalKeys: true),
      tools: Stores.mcp.getAllMap(includeInternalKeys: true),
      histories: Stores.history.getAllMap(includeInternalKeys: true),
      trashes: Stores.trash.getAllMap(includeInternalKeys: true),
    );
  }

  static Future<String> backup([String? name]) async {
    final bak = await BackupV2.loadFromStore();
    final result = json.encode(bak.toJson());
    final path = Paths.doc.joinPath(name ?? Paths.bakName);
    await File(path).writeAsString(result);
    return path;
  }

  factory BackupV2.fromJsonString(String jsonString) {
    final map = json.decode(jsonString) as Map<String, dynamic>;
    return BackupV2.fromJson(map);
  }

  String get dateStr {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return dateTime.simple();
  }
}