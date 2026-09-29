part of '../tool.dart';

/// A tool built into the app.
abstract class ToolFunc {
  final String name;
  final _Map parametersSchema;

  const ToolFunc({required this.name, required this.parametersSchema});

  String get description;

  String get l10nName;

  /// Off until the user turns it on: kept in [McpStore.enabledTools], where
  /// the others are kept in [McpStore.disabledTools].
  bool get defaultEnabled => true;

  /// The switch this tool is under: its own, or its family's.
  String get group => name;

  /// The name of [group], as the settings show it.
  String get groupLabel => l10nName;

  /// Runs without asking: it touches only the app's own data, which the user
  /// can see and undo.
  bool get trusted => false;

  String? get l10nTip => null;

  /// [args] on one line: what a call does, at a glance.
  String summary(_Map args) => jsonEncode(args);

  /// Runs the tool. Throw to report a failure to the model.
  Future<LlmToolResult> run(_Map args, ToolCtx ctx);

  LlmTool get llmTool => LlmTool(
    name: name,
    description: description,
    parameters: parametersSchema,
    label: l10nName,
    execute: (call, cancel) => Tools.timed(() => run(call.args, ToolCtx(call.sessionId, cancel))),
  );
}

/// What a call knows besides its arguments.
final class ToolCtx {
  const ToolCtx(this.chatId, this.cancel);

  /// The chat the call is made in: a chat's id is its session's.
  final String chatId;

  /// Fires when the user stops the run.
  final LlmCancelToken cancel;
}
