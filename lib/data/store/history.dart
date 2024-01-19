import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/store/all.dart';

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
          1,
    );
    final sortedMap = Map.fromEntries(sorted);
    if (sortedMap.isEmpty && !Stores.setting.initHelpShown.fetch()) {
      final initHelp = ChatHistory.example;
      sortedMap[initHelp.id] = initHelp;
    }
    return sortedMap;
  }

  void put(ChatHistory history) {
    box.put(history.id, history);
  }

  void delete(String id) {
    box.delete(id);
  }
}
