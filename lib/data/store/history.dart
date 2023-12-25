import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';

class HistoryStore extends Store {
  HistoryStore() : super('history');

  Map<String, List<ChatHistory>> fetchAll() {
    return {
      for (final key in box.keys)
        key as String: fetch(key) ?? []
    };
  }

  List<ChatHistory>? fetch(String id) {
    final val = box.get(id) as List?;
    if (val == null) {
      return null;
    }
    return List<ChatHistory>.from(val);
  }

  void put(String id, List<ChatHistory> history) {
    box.put(id, history);
  }

  void delete(String id) {
    box.delete(id);
  }

  void clear() {
    box.clear();
  }
}
