import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/chat/config.dart';

final class ConfigStore extends PersistentStore {
  ConfigStore() : super('config');

  static const _SELECTED_KEY = 'selectedKey';

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

  Map<String, ChatConfig> fetchAll() {
    final map = <String, ChatConfig>{};
    var errCount = 0;
    for (final key in box.keys) {
      if (key == _SELECTED_KEY) continue;
      final item = box.get(key);
      if (item != null) {
        if (item is ChatConfig) {
          map[key] = item;
        } else if (item is Map) {
          try {
            map[key] = ChatConfig.fromJson(item.cast<String, dynamic>());
          } catch (e) {
            errCount++;
          }
        }
      }
    }
    if (errCount > 0) {
      Loggers.app.warning('fetchAll config: $errCount error(s)');
    }
    return map;
  }
}
