import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/store/chat.dart';
import 'package:gpt_box/data/store/llm.dart';
import 'package:gpt_box/data/store/memory.dart';
import 'package:gpt_box/data/store/setting.dart';
import 'package:gpt_box/data/store/tool.dart';

abstract final class Stores {
  static final setting = SettingStore.instance;
  static final chat = ChatStore.instance;
  static final llm = LlmStore.instance;
  static final mcp = McpStore.instance;
  static final memory = MemoryStore.instance;

  static final List<SqliteStore> all = [setting, chat, llm, mcp, memory];

  /// Opens the shared database before any store reads it.
  static Future<void> init() async {
    await SqliteStore.openDatabase();
    await Future.wait(all.map((e) => e.init()));
    _migrateMemories();
    // TODO: remove once no device has it: the beta channel is gone.
    if (setting.keys().contains('joinBeta')) setting.remove('joinBeta');
  }

  /// TODO: remove with [McpStore.memories], once no device has the old list.
  /// The list of things to remember, from before the memory was files: into
  /// `notes.md`, listed in the index.
  static void _migrateMemories() {
    final old = mcp.memories.get();
    if (old.isEmpty) return;
    const file = 'notes.md';
    final notes = memory.read(file);
    memory.write(file, [if (notes != null && notes.isNotEmpty) notes.trimRight(), ...old.map((m) => '- $m')].join('\n'));
    final index = memory.read(MemoryStore.index) ?? '';
    if (!index.contains('($file)')) {
      memory.write(
        MemoryStore.index,
        [if (index.isNotEmpty) index.trimRight(), '- [Notes]($file) — things the user asked to remember'].join('\n'),
      );
    }
    mcp.memories.remove();
  }
}
