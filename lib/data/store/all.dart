import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:gpt_box/data/store/setting.dart';

/// The app's settings; the chats, providers, tools and memory are
/// [LlmStores], fl_pi_llm_ui's.
abstract final class Stores {
  static final setting = SettingStore.instance;

  static final List<SqliteStore> all = [setting, ...LlmStores.all];

  /// Opens the shared database before any store reads it.
  static Future<void> init() async {
    await SqliteStore.openDatabase();
    await Future.wait(all.map((e) => e.init()));
    _migrateMemories();
    // TODO: remove once no device has it: the beta channel is gone.
    if (setting.keys().contains('joinBeta')) setting.remove('joinBeta');
  }

  /// TODO: remove once no device has the old list: the things to remember,
  /// from before the memory was files, into `notes.md`, listed in the index.
  static void _migrateMemories() {
    const key = 'memories';
    final tool = LlmStores.tool;
    final old = [...?tool.get<List>(key)?.whereType<String>()];
    if (old.isEmpty) return;
    final memory = LlmStores.memory;
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
    tool.remove(key);
  }
}
