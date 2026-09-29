part of '../tool.dart';

final class TfHistory extends ToolFunc {
  static const instance = TfHistory._();

  const TfHistory._()
      : super(
          name: 'history',
          parametersSchema: const {
            'type': 'object',
            'properties': {
              'keywords': {
                'type': 'array',
                'items': {'type': 'string'},
                'description': '''
Keywords to search in the history.
If empty, send all chats with [count] constraint.''',
              },
              'onlyTitles': {
                'type': 'boolean',
                'description': 'Only send the titles of the history chats.',
              },
              'count': {
                'type': 'integer',
                'description': '''
The count of the history chats to send, default 3.
Only override this if users explicitly ask to load more(users input eg: 'all chats', 'recent 10 chats') chats.
If users want to load all chats, set it to -1.''',
              }
            },
          },
        );

  @override
  String get description => '''
Find the chats including the keywords in the history.
Then send the titles of the history chats to the AI to select the chats that need to be loaded as contexts.
Only call this func if users explicitly ask to load the history chats.
The user's prompt maybe included.''';

  @override
  String get l10nName => l10n.history;

  @override
  String? get l10nTip => l10n.historyToolTip;

  @override
  bool get defaultEnabled => false;

  @override
  String help(_Map args) {
    final keywords = args['keywords'] as List? ?? [];
    return l10n.historyToolHelp(keywords);
  }

  @override
  Future<LlmToolResult> run(_Map args, OnToolLog log) async {
    final keywords = [...?(args['keywords'] as List?)?.whereType<String>()];
    final count = args['count'] as int? ?? 3;
    final onlyTitles = args['onlyTitles'] as bool? ?? false;
    final current = Chats.current.value;
    final found = keywords.isEmpty
        ? Stores.chat.all()
        : {for (final k in keywords) ...Chats.search(k)}.toList();
    final chats = [
      for (final c in found)
        if (c.id != current) c,
    ].take(count <= 0 ? found.length : count).toList();
    if (onlyTitles) {
      return LlmToolResult.text(chats.map((e) => e.title ?? l10n.untitled).join('\n'));
    }
    final parts = <String>[];
    for (final c in chats) {
      parts.add('# ${c.title ?? l10n.untitled}\n\n${await Chats.markdownOf(c.id)}');
    }
    return LlmToolResult.text(parts.join('\n\n---\n\n'));
  }
}
