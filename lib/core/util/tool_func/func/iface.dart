part of '../tool.dart';

/// A tool built into the app.
abstract class ToolFunc {
  final String name;
  final _Map parametersSchema;

  const ToolFunc({required this.name, required this.parametersSchema});

  String get description;

  String get l10nName;

  bool get defaultEnabled => true;

  /// For users to understand what a call does. Shown when asking for approval.
  String help(_Map args) => '```json\n${const JsonEncoder.withIndent('  ').convert(args)}\n```';

  String? get l10nTip => null;

  /// [args] on one line: what a call does, at a glance.
  String summary(_Map args) => jsonEncode(args);

  /// Runs the tool. Throw to report a failure to the model.
  Future<LlmToolResult> run(_Map args, OnToolLog log);

  LlmTool get llmTool => LlmTool(
    name: name,
    description: description,
    parameters: parametersSchema,
    label: l10nName,
    execute: (call, _) => Tools.timed(() => run(call.args, _log)),
  );
}
