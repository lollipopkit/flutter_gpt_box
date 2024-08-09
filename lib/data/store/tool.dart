import 'package:fl_lib/fl_lib.dart';

final class ToolStore extends PersistentStore {
  ToolStore() : super('tool');

  /// Switch for enabling/disabling all tools.
  late final enabled = property('enabled', true);

  /// All enabled tools will be added to the chat req's tool list.
  /// By default, all tools are enabled.
  // late final enabledTools = property(
  //   'enabledTools',
  //   OpenAIFuncCalls.internalTools.map((e) => e.name).toList(),
  // );

  /// Disabled tools
  late final disabledTools = property('disabledTools', <String>[]);

  /// Tools that are permitted to be used by the user.
  /// A dialog will be shown if the tool has not been permitted.
  late final permittedTools = property('permittedTools', <String>[]);

  /// Memories that are saved by the user.
  /// It will be added to prompt when sending a chat req.
  /// {id: memory}
  late final memories = property('memories', <String>[]);

  /// Models regexp list, split by ','
  late final toolsRegExp = property(
    'toolsRegExp',
    'gpt-4o|gpt-4-turbo|gpt-3.5-turbo|deepseek',
  );

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
