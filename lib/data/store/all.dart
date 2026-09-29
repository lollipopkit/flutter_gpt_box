import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/store/chat.dart';
import 'package:gpt_box/data/store/llm.dart';
import 'package:gpt_box/data/store/setting.dart';
import 'package:gpt_box/data/store/tool.dart';

abstract final class Stores {
  static final setting = SettingStore.instance;
  static final chat = ChatStore.instance;
  static final llm = LlmStore.instance;
  static final mcp = McpStore.instance;

  static final List<SqliteStore> all = [setting, chat, llm, mcp];

  /// Opens the shared database before any store reads it.
  static Future<void> init() async {
    await SqliteStore.openDatabase();
    await Future.wait(all.map((e) => e.init()));
  }
}
