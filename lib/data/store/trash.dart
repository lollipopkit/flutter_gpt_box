import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';

final class TrashStore extends HiveStore {
  TrashStore() : super('trash');

  static final instance = TrashStore();

  static const historyKeyPrefix = 'history_';

  void addHistory(ChatHistory history) {
    final key = '$historyKeyPrefix${DateTimeX.timestamp}';
    set(key, history);
  }

  void removeHistory(int timestamp) {
    final key = '$historyKeyPrefix$timestamp';
    remove(key);
  }

  List<ChatHistory> get histories {
    final keys = this.keys().where((e) => e.startsWith(historyKeyPrefix));
    return keys.map((e) => get(e) as ChatHistory).toList();
  }
}
