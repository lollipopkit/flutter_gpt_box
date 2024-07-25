part of '../tool.dart';

final class TfMemory extends ToolFunc {
  static const instance = TfMemory._();

  const TfMemory._()
      : super(
          name: 'memory',
          description: '''
Memorise the input and add what memorised to the prompt.
If users want to memorise something, you(AI models) should call this function.''',
          parametersSchema: const {
            'type': 'object',
            'properties': {
              'memory': {
                'type': 'string',
                'description': 'What to memorise, will be persisted in db.',
              },
            },
          },
        );

  @override
  String get l10nName => l10n.memory;

  @override
  String help(_CallResp call, _Map args) {
    return l10n.memoryTip(args['memory'] as String? ?? '<?>');
  }

  @override
  Future<_Ret> run(_CallResp call, _Map args, OnToolLog log) async {
    final memory = args['memory'] as String?;
    if (memory == null) {
      return [ChatContent.text(l10n.empty)];
    }
    final prop = Stores.tool.memories;
    final memories = prop.fetch();
    prop.put(memories..add(memory));
    await Future.delayed(Durations.medium1);
    return [ChatContent.text(l10n.memoryAdded(memory))];
  }
}
