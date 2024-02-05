import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/store/config.dart';
import 'package:flutter_chatgpt/data/store/history.dart';
import 'package:flutter_chatgpt/data/store/setting.dart';

abstract final class Stores {
  static final history = HistoryStore();
  static final setting = SettingStore();
  static final config = ConfigStore();

  static final List<Store> all = [
    setting,
    history,
    config,
  ];

  static int get lastModTime {
    int lastModTime = 0;
    for (final store in all) {
      final last = store.box.lastModified ?? 0;
      if (last > (lastModTime)) {
        lastModTime = last;
      }
    }
    return lastModTime;
  }
}
