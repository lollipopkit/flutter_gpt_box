import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';

class HistoryStore extends Store {
  HistoryStore() : super('history');

  Map<String, ChatHistory> fetchAll() {
    final map = <String, ChatHistory>{};
    for (final key in box.keys) {
      final item = box.get(key);
      if (item != null && item is ChatHistory) {
        map[key] = item;
      }
    }
    // Sort by last modified time
    final now = DateTime.now();
    final sorted = map.entries.toList();
    sorted.sort(
      (a, b) =>
          b.value.items.lastOrNull?.createdAt
              .compareTo(a.value.items.lastOrNull?.createdAt ?? now) ??
          0,
    );
    return Map.fromEntries(sorted);
  }

  void put(ChatHistory history) {
    box.put(history.id, history);
  }

  void delete(String id) {
    box.delete(id);
  }
}
