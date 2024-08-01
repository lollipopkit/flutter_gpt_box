part of '../tool.dart';

final class TfHistory extends ToolFunc {
  static const instance = TfHistory._();

  const TfHistory._()
      : super(
          name: 'history',
          description: '''
Find the chats including the keywords in the history.
Then send the titles of the history chats to the AI to select the chats that need to be loaded as contexts.
Only call this func if users explicitly ask to load the history chats.
The user's prompt maybe included.''',
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
  String get l10nName => l10n.history;

  @override
  bool get defaultEnabled => false;

  @override
  String help(_CallResp call, _Map args) {
    final keywords = args['keywords'] as List? ?? [];
    return l10n.historyToolTip(keywords);
  }

  @override
  Future<_Ret> run(_CallResp call, _Map args, OnToolLog log) async {
    final keywords_ = args['keywords'] as List? ?? [];
    final keywords = <String>[];
    for (final e in keywords_) {
      if (e is String) keywords.add(e);
    }
    final count = args['count'] as int? ?? 3;
    final prop = Stores.history;
    final chats = prop.take(count, keywords);
    final onlyTitles = args['onlyTitles'] as bool? ?? false;
    return chats
        .map((e) => ChatContent.text(
            onlyTitles ? e.name ?? l10n.untitled : e.toMarkdown))
        .toList();
  }
}
