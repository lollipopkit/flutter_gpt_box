import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/app/backup.dart';
import 'package:gpt_box/data/model/app/backup2.dart';

abstract final class MergeableUtils {
  static (Mergeable, String) fromJsonString(String json) {
    try {
      final bak = BackupV2.fromJsonString(json);
      return (bak, bak.dateStr);
    } catch (e) {
      final bak = Backup.fromJsonString(json);
      return (bak, bak.date);
    }
  }
}
