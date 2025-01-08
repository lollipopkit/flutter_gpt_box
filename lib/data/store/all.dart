import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/store/config.dart';
import 'package:gpt_box/data/store/history.dart';
import 'package:gpt_box/data/store/setting.dart';
import 'package:gpt_box/data/store/tool.dart';

abstract final class Stores {
  static final history = HistoryStore();
  static final setting = SettingStore();
  static final config = ConfigStore();
  static final tool = ToolStore();

  static final List<HiveStore> all = [
    setting,
    history,
    config,
    tool,
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
