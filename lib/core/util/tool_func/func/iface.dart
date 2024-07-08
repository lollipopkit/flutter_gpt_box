part of '../tool.dart';

abstract final class ToolFunc {
  final String name;
  final String? description;
  final _Map parametersSchema;

  const ToolFunc({
    required this.name,
    this.description,
    required this.parametersSchema,
  });

  String get l10nName;

  /// For users to understand what this function does.
  /// Used in permission request dialog.
  String help(_CallResp call, _Map args) {
    return '''

${json.encode(call)}

${json.encode(args)}
''';
  }

  Future<_Ret> run(_CallResp call, _Map args, OnToolLog log) async =>
      throw 'Not implemented';

  OpenAIToolModel get into => OpenAIToolModel(
        type: 'function',
        function: OpenAIFunctionModel(
          name: name,
          description: description,
          parametersSchema: parametersSchema,
        ),
      );
}
