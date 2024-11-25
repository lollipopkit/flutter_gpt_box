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

  static DateTime? get lastModTime {
    DateTime? lastModTime_;
    for (final store in all) {
      final last = store.lastUpdateTs;
      if (last != null) {
        if (lastModTime_ == null || lastModTime_.isBefore(last)) {
          lastModTime_ = last;
        }
      }
    }
    return lastModTime_;
  }
}
