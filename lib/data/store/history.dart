import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';

class HistoryStore extends Store {
  HistoryStore() : super('history');

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

  void put(ChatHistory history) {
    box.updateLastModified();
    box.put(history.id, history);
  }

  void delete(String id) {
    box.delete(id);
  }
}
