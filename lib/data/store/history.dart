import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';

class HistoryStore extends Store {
  HistoryStore() : super('history');

  void createDefault() {
    if (box.keys.isEmpty) {
      put(ChatHistory.noid(name: 'Default', items: []));
    }
  }

  List<ChatHistory> fetchAll() {
    createDefault();
    final val = List<ChatHistory>.from(box.values);
    return val;
  }

  void put(ChatHistory history) {
    box.put(history.id, history);
  }

  void delete(String id) {
    box.delete(id);
  }
}
