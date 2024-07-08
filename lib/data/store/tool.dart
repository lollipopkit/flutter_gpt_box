import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';

final class ToolStore extends PersistentStore {
  ToolStore() : super('tool');

  /// Switch for enabling/disabling all tools.
  late final enabled = property('enabled', true);

  /// All enabled tools will be added to the chat req's tool list.
  /// By default, all tools are enabled.
  late final enabledTools = property(
    'enabledTools',
    OpenAIFuncCalls.internalTools.map((e) => e.name).toList(),
  );

  /// Tools that are permitted to be used by the user.
  /// A dialog will be shown if the tool has not been permitted.
  late final permittedTools = property('permittedTools', <String>[]);
}
