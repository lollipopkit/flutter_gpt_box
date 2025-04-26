import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/chat/config.dart';

final class ConfigStore extends HiveStore {
  ConfigStore._() : super('config');

  static final instance = ConfigStore._();

  static const _SELECTED_KEY = 'selectedKey';

  late final profileId = propertyDefault('profileId', ChatConfigX.defaultId);

  /// If [ChatHistory.model] is not null, and the saved model ([followModel])
  /// exists in current models list, then set current model to it.
  // late final followModel = property('followModel', true);

  ChatConfig? fetch(String id) {
    final val = box.get(id) as ChatConfig?;
    if (val == null && id == ChatConfigX.defaultId) {
      put(ChatConfigX.defaultOne);
      return ChatConfigX.defaultOne;
    }
    return val;
  }

  void put(ChatConfig config) {
    box.put(config.id, config);
  }

  bool delete(String id) {
    /// Cannot delete default config
    if (id == ChatConfigX.defaultId) return false;
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
