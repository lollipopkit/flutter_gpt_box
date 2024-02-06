import 'package:flutter_chatgpt/core/store.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';

final class ConfigStore extends Store {
  ConfigStore() : super('config');

  ChatConfig? fetch(String id) {
    final val = box.get(id) as ChatConfig?;
    if (val == null && id == ChatConfig.defaultId) {
      put(ChatConfig.defaultOne);
      return ChatConfig.defaultOne;
    }
    return val;
  }

  void put(ChatConfig config) {
    box.put(config.id, config);
  }

  bool delete(String id) {
    /// Cannot delete default config
    if (id == ChatConfig.defaultId) return false;
    box.delete(id);
    return true;
  }
}
