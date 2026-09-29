part of '../tool.dart';

/// Other chats, for the model to look things up in: [TfChatSearch] finds
/// them, [TfChatRead] reads one. Off until the user turns them on — what was
/// said in one chat then reaches the model of another — and, being read-only,
/// run unasked once on.
sealed class TfHistory extends ToolFunc {
  const TfHistory({required super.name, required super.parametersSchema});

  /// The switch for both; the name of the one tool they replaced.
  static const groupName = 'history';

  static const all = <TfHistory>[TfChatSearch.instance, TfChatRead.instance];

  @override
  String get group => groupName;

  @override
  bool get defaultEnabled => false;

  @override
  bool get trusted => true;

  @override
  String get groupLabel => l10n.history;

  @override
  String? get l10nTip => l10n.historyToolTip;
}

final class TfChatSearch extends TfHistory {
  static const instance = TfChatSearch._();

  const TfChatSearch._()
    : super(
        name: 'chat_search',
        parametersSchema: const {
          'type': 'object',
          'properties': {
            'query': {
              'type': 'string',
              'description': 'Text to find in chat titles and messages. Empty: the most recent chats.',
            },
            'limit': {'type': 'integer', 'description': 'Chats to return. Default 5, at most $_maxLimit.'},
          },
        },
      );

  static const _maxLimit = 20;
  static const _snippets = 2;
  static const _around = 100;

  @override
  String get description => '''
Search the user's other chats with you, newest first. Returns each chat's id, title, date and matching excerpts.
Use it when the user refers to an earlier conversation. Read a whole chat with chat_read.''';

  @override
  String get l10nName => l10n.chatSearch;

  @override
  String summary(_Map args) => '${args['query'] ?? ''}';

  @override
  Future<LlmToolResult> run(_Map args, ToolCtx ctx) async {
    final query = (args['query'] as String? ?? '').trim();
    final limit = (args['limit'] as num? ?? 5).toInt().clamp(1, _maxLimit);
    final found = [
      for (final c in query.isEmpty ? Stores.chat.all() : await Chats.search(query))
        if (c.id != ctx.chatId) c,
    ].take(limit).toList();
    if (found.isEmpty) return LlmToolResult.text('No chats found.');
    final out = <String>[];
    for (final c in found) {
      final head = '- id: ${c.id} · ${c.title ?? l10n.untitled} · ${c.updatedAt.ymd()}';
      if (query.isEmpty) {
        out.add(head);
        continue;
      }
      final text = await Chats.markdownOf(c.id);
      out.add([head, ..._excerpts(text, query).map((e) => '  > $e')].join('\n'));
    }
    return LlmToolResult.text(out.join('\n'));
  }

  static Iterable<String> _excerpts(String text, String query) sync* {
    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    var from = 0;
    for (var n = 0; n < _snippets; n++) {
      final i = lower.indexOf(q, from);
      if (i < 0) return;
      final s = (i - _around).clamp(0, text.length);
      final e = (i + q.length + _around).clamp(0, text.length);
      yield '${s > 0 ? '…' : ''}${text.substring(s, e).replaceAll(RegExp(r'\s+'), ' ').trim()}${e < text.length ? '…' : ''}';
      from = e;
    }
  }
}

final class TfChatRead extends TfHistory {
  static const instance = TfChatRead._();

  const TfChatRead._()
    : super(
        name: 'chat_read',
        parametersSchema: const {
          'type': 'object',
          'properties': {
            'id': {'type': 'string', 'description': 'The chat id, from chat_search.'},
            'start_index': {'type': 'integer', 'description': 'Start at this character. Default 0.'},
            'max_length': {'type': 'integer', 'description': 'At most this many characters. Default $_defaultLength.'},
          },
          'required': ['id'],
        },
      );

  static const _defaultLength = 20000;
  static const _maxLength = 100000;

  @override
  String get description => 'Read another chat with the user as Markdown, from its id (see chat_search).';

  @override
  String get l10nName => l10n.chatRead;

  @override
  String summary(_Map args) {
    final id = args['id'] as String?;
    return (id == null ? null : Stores.chat.fetch(id)?.title) ?? id ?? '';
  }

  @override
  Future<LlmToolResult> run(_Map args, ToolCtx ctx) async {
    final id = args['id'];
    if (id is! String) throw ArgumentError('id is required');
    final meta = Stores.chat.fetch(id);
    if (meta == null || meta.trashed) throw ArgumentError('No chat with id $id');
    final text = await Chats.markdownOf(id);
    final start = (args['start_index'] as num? ?? 0).toInt().clamp(0, text.length);
    final max = (args['max_length'] as num? ?? _defaultLength).toInt().clamp(1, _maxLength);
    final end = (start + max).clamp(0, text.length);
    return LlmToolResult.text(
      [
        '# ${meta.title ?? l10n.untitled} (${meta.updatedAt.ymd()})',
        text.substring(start, end),
        if (end < text.length) 'Truncated: ${text.length - end} more characters; call again with start_index $end.',
      ].join('\n\n'),
    );
  }
}
