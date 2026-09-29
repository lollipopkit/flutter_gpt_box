import 'package:fl_lib/fl_lib.dart';

final class McpStore extends SqliteStore {
  McpStore._() : super('tool');

  static final instance = McpStore._();

  /// Whether the model is offered tools at all.
  late final enabled = propertyDefault('enabled', false);

  /// Built-in tools turned off.
  late final disabledTools = listProperty<String>('disabledTools');

  /// Tools the user allowed to run without asking every time.
  late final permittedTools = listProperty<String>('permittedTools');

  /// What the user asked the model to remember. Part of every system prompt.
  late final memories = listProperty<String>('memories');

  /// MCP server URLs.
  late final mcpServers = listProperty<String>('mcpServers');
}
