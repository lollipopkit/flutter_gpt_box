import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/store/memory.dart';

final class McpStore extends SqliteStore {
  McpStore._() : super('tool');

  static final instance = McpStore._();

  /// Whether the model is offered tools at all.
  late final enabled = propertyDefault('enabled', false);

  /// Built-in tools turned off.
  late final disabledTools = listProperty<String>('disabledTools');

  /// Tools the user allowed to run without asking every time.
  late final permittedTools = listProperty<String>('permittedTools');

  /// TODO: remove after the migration to files in `Stores._migrateMemories`.
  /// What the user asked the model to remember, before [MemoryStore].
  late final memories = listProperty<String>('memories');

  /// MCP server URLs.
  late final mcpServers = listProperty<String>('mcpServers');
}
