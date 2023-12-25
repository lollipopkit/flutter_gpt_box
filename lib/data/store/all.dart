import 'package:flutter_chatgpt/data/store/history.dart';
import 'package:flutter_chatgpt/data/store/setting.dart';

abstract final class Stores {
  static final history = HistoryStore();
  static final setting = SettingStore();
}