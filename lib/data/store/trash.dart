import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/store/all.dart';

final class TrashStore extends HiveStore {
  TrashStore._() : super('trash');

  static final instance = TrashStore._();

  /// All the hitories in the trash should have a key starting with this prefix.
  static const historyKeyPrefix = 'history_';

  /// Get all the histories in the trash as a [VNode].
  late final historiesVN = _histories.vn;

  /// Get all the histories in the trash.
  Map<String, ChatHistory> get histories => historiesVN.value;

  /// Add a history item to the trash.
  void addHistory(ChatHistory history) {
    final key = '$historyKeyPrefix${DateTimeX.timestamp}';
    set(key, history);
    histories[key] = history;
    historiesVN.notify();
  }

  /// Remove the history item with the given [key].
  ///
  /// - [key] is the key of the history item to remove. Example: 'history_1234567890'.
  void removeHistory(String key) {
    remove(key);
    histories.remove(key);
    historiesVN.notify();
  }

  /// Get all the histories in the trash.
  Map<String, ChatHistory> get _histories {
    final map = <String, ChatHistory>{};
    var errCount = 0;
    for (final key in keys()) {
      if (key.startsWith(historyKeyPrefix)) {
        final item = box.get(key);
        if (item != null) {
          if (item is ChatHistory) {
            map[key] = item;
          } else if (item is Map) {
            try {
              map[key] = ChatHistory.fromJson(item.cast<String, dynamic>());
            } catch (e) {
              errCount++;
            }
          }
        }
      }
    }

    if (errCount > 0) {
      Loggers.app.warning('Init trash: $errCount error(s)');
    }

    return map;
  }

  /// Auto delete histories older than [days] days.
  ///
  /// - [days] is the number of days to keep the histories.
  void autoDelete({int? days, bool refresh = true}) {
    days ??= Stores.setting.trashDays.get();

    final now = DateTime.now();
    final ts = now.subtract(Duration(days: days)).millisecondsSinceEpoch;
    for (final key in keys()) {
      if (key.startsWith(historyKeyPrefix)) {
        final item = box.get(key);
        if (item is ChatHistory) {
          final lastTimeTs = item.lastTime?.millisecondsSinceEpoch ?? 0;
          if (lastTimeTs < ts) {
            remove(key);
          }
        }
      }
    }

    if (refresh) historiesVN.value = _histories;
  }
}
