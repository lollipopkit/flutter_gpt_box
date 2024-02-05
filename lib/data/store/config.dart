import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';

final class ConfigStore extends Store {
  ConfigStore() : super('config');

  ChatConfig? fetch(String id) {
    return box.get(id) as ChatConfig?;
  }

  void put(ChatConfig config) {
    box.put(config.id, config);
  }

  bool delete(String id) {
    /// Cannot delete default config
    if (id.isEmpty) return false;
    box.delete(id);
    return true;
  }
}
