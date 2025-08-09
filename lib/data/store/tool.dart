import 'package:fl_lib/fl_lib.dart';

final class McpStore extends HiveStore {
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
  late final disabledTools = propertyDefault('disabledTools', <String>[]);

  /// MCP tools that are permitted to be used by the user.
  /// A dialog will be shown if the MCP tool has not been permitted.
  late final permittedTools = propertyDefault('permittedTools', <String>[]);

  /// Memories that are saved by the user.
  /// It will be added to prompt when sending a chat req.
  /// {id: memory}
  late final memories = propertyDefault('memories', <String>[]);

  /// Models regexp list, split by ','
  late final mcpRegExp = propertyDefault(
    'toolsRegExp',
    'gpt-4o|gpt-4-turbo|gpt-3.5-turbo|deepseek',
  );

  late final mcpServers = propertyDefault('mcpServers', <String>[]);

  static const jsScriptPrefix = '_jsScripts_';

  String? getJsScript(String name) {
    return box.get('$jsScriptPrefix$name') as String?;
  }

  void setJsScript(String name, String script) {
    box.put('$jsScriptPrefix$name', script);
  }

  Map<String, String> get jsScripts {
    final scripts = <String, String>{};
    for (final key in box.keys) {
      if (key is! String) continue;
      if (key.startsWith(jsScriptPrefix)) {
        final script = box.get(key) as String?;
        if (script == null) continue;
        scripts[key.substring(jsScriptPrefix.length)] = script;
      }
    }
    return scripts;
  }
}
