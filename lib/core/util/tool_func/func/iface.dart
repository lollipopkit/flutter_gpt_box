part of '../tool.dart';

abstract final class ToolFunc {
  final String name;
  final _Map parametersSchema;

  const ToolFunc({
    required this.name,
    required this.parametersSchema,
  });

  String get description;

  String get l10nName;

  bool get defaultEnabled => true;

  /// For users to understand what this function does.
  /// Used in permission request dialog.
  String help(_CallResp call, _Map args) {
    return '''

${json.encode(call)}

${json.encode(args)}
''';
  }

  String? get l10nTip => null;

  Future<_Ret?> run(_CallResp call, _Map args, OnToolLog log);

  ChatCompletionTool get into => ChatCompletionTool(
      type: ChatCompletionToolType.function,
      function: FunctionObject(
        name: name,
        description: description,
        parameters: parametersSchema,
      ));
}
