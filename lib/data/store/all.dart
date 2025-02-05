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
  static final tool = ToolStore.instance;
  static final trash = TrashStore.instance;

  static final List<HiveStore> all = [
    setting,
    history,
    config,
    tool,
    trash,
  ];

  static Future<void> init() async {
    await Future.wait(all.map((e) => e.init()));
  }

  static int get lastModTime {
    var lastModTime = DateTime.now().millisecondsSinceEpoch;
    for (final store in all) {
      final last = store.lastUpdateTs?.millisecondsSinceEpoch ?? 0;
      if (last > lastModTime) {
        lastModTime = last;
      }
    }
    return lastModTime;
  }
}
