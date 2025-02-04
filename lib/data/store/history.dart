import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';

class HistoryStore extends HiveStore {
  HistoryStore._() : super('history');

  static final instance = HistoryStore._();

  Map<String, ChatHistory> fetchAll() {
    final map = <String, ChatHistory>{};
    var errCount = 0;
    for (final key in box.keys) {
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
    if (errCount > 0) Loggers.app.warning('Init history: $errCount error(s)');
    // Sort by last modified time ASC
    final now = DateTime.now();
    final sorted = map.entries.toList();
    sorted.sort(
      (a, b) =>
          b.value.items.lastOrNull?.createdAt
              .compareTo(a.value.items.lastOrNull?.createdAt ?? now) ??
          1,
    );
    return Map.fromEntries(sorted);
  }

  /// Returns the chats containing the keywords with maximum number of [n].
  /// - [n] is the maximum number of items to take. If there are not enough items,
  /// the number of returned items will be less than [n]. If [n] <= 0, all items
  /// will be returned.
  /// - [keywords] is a list of keywords to filter the history items. If [keywords]
  /// is not empty, only items that contain at least one keyword will be returned.
  /// If [keywords] is empty, all items will be returned.
  /// - [skipCurrent] is a flag to skip the most recent item. If [skipCurrent] is
  /// true, the most recent item will be skipped.
  List<ChatHistory> take(
    int n,
    List<String> keywords, {
    bool skipCurrent = true,
  }) {
    final vals = fetchAll().values.toList();
    if (n <= 0) return vals;

    final list = <ChatHistory>[];
    for (final item in vals.skip(skipCurrent ? 1 : 0)) {
      if (keywords.isEmpty || item.containsKeywords(keywords)) {
        list.add(item);
        if (list.length >= n) break;
      }
    }
    return list;
  }

  void put(ChatHistory history, [bool update = true]) {
    box.put(history.id, history);
  }

  void delete(String id) {
    box.delete(id);
  }
}
