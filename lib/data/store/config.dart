import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/chat/config.dart';

final class ConfigStore extends SqliteStore {
  ConfigStore._() : super('config');

  static final instance = ConfigStore._();

  static const _SELECTED_KEY = 'selectedKey';

  late final profileId = propertyDefault('profileId', ChatConfigX.defaultId);

  /// If [ChatHistory.model] is not null, and the saved model ([followModel])
  /// exists in current models list, then set current model to it.
  // late final followModel = property('followModel', true);

  /// Keys in this store that are not a [ChatConfig].
  late final nonProfileKeys = {_SELECTED_KEY, profileId.key};

  ChatConfig? fetch(String id) {
    final val = get(id, fromObj: _fromObj);
    if (val == null && id == ChatConfigX.defaultId) {
      put(ChatConfigX.defaultOne);
      return ChatConfigX.defaultOne;
    }
    return val;
  }

  void put(ChatConfig config) {
    set(config.id, config);
  }

  bool delete(String id) {
    /// Cannot delete default config
    if (id == ChatConfigX.defaultId) return false;
    remove(id);
    return true;
  }

  Map<String, ChatConfig> fetchAll() {
    final map = <String, ChatConfig>{};
    var errCount = 0;
    for (final key in keys()) {
      if (nonProfileKeys.contains(key)) continue;
      final item = get<Object>(key);
      if (item is! Map) continue;
      try {
        map[key] = ChatConfig.fromJson(item.cast<String, dynamic>());
      } catch (e) {
        errCount++;
      }
    }
    if (errCount > 0) {
      Loggers.app.warning('fetchAll config: $errCount error(s)');
    }
    return map;
  }

  static ChatConfig? _fromObj(Object? obj) => switch (obj) {
    final Map map => ChatConfig.fromJson(map.cast<String, dynamic>()),
    _ => null,
  };
}
