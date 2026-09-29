import 'package:fl_lib/fl_lib.dart';

final class McpStore extends SqliteStore {
  McpStore._() : super('tool');

  static final instance = McpStore._();

  /// Switch for enabling/disabling all MCP tools.
  ///
  /// It will slow down the resp, so disabled by default.
  late final enabled = propertyDefault('enabled', false);

  /// All enabled MCP tools will be added to the chat req's tool list.
  /// By default, all MCP tools are enabled.
  // late final enabledTools = property(
  //   'enabledTools',
  //   OpenAIFuncCalls.internalTools.map((e) => e.name).toList(),
  // );

  /// Disabled MCP tools
  late final disabledTools = listProperty<String>('disabledTools');

  /// MCP tools that are permitted to be used by the user.
  /// A dialog will be shown if the MCP tool has not been permitted.
  late final permittedTools = listProperty<String>('permittedTools');

  /// Memories that are saved by the user.
  /// It will be added to prompt when sending a chat req.
  /// {id: memory}
  late final memories = listProperty<String>('memories');

  /// Models regexp list, split by ','
  late final mcpRegExp = propertyDefault(
    'toolsRegExp',
    'gpt-4o|gpt-4-turbo|gpt-3.5-turbo|deepseek',
  );

  late final mcpServers = listProperty<String>('mcpServers');

  static const jsScriptPrefix = '_jsScripts_';

  String? getJsScript(String name) {
    return get<String>('$jsScriptPrefix$name');
  }

  void setJsScript(String name, String script) {
    set('$jsScriptPrefix$name', script);
  }

  Map<String, String> get jsScripts {
    final scripts = <String, String>{};
    for (final key in keys()) {
      if (key.startsWith(jsScriptPrefix)) {
        final script = get<String>(key);
        if (script == null) continue;
        scripts[key.substring(jsScriptPrefix.length)] = script;
      }
    }
    return scripts;
  }
}
