import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/store/config.dart';
import 'package:gpt_box/data/store/history.dart';
import 'package:gpt_box/data/store/setting.dart';
import 'package:gpt_box/data/store/tool.dart';
import 'package:gpt_box/data/store/trash.dart';

abstract final class Stores {
  static final history = HistoryStore.instance;
  static final setting = SettingStore.instance;
  static final config = ConfigStore.instance;
  static final mcp = McpStore.instance;
  static final trash = TrashStore.instance;

  static final List<HiveStore> all = [
    setting,
    history,
    config,
    mcp,
    trash,
  ];

  static Future<void> init() async {
    await Future.wait(all.map((e) => e.init()));
  }

  static int get lastModTime {
    var lastModTime = DateTime.now().millisecondsSinceEpoch;
    for (final store in all) {
      final last = store.lastUpdateTs ?? {};
      if (last.isEmpty) continue;
      final modTime = last.values.reduce((a, b) => a > b ? a : b);
      if (modTime > lastModTime) {
        lastModTime = modTime;
      }
    }
    return lastModTime;
  }
}
