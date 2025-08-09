part of 'history.dart';

typedef OaiHistoryItem = ChatCompletionMessage;
typedef OaiContent = ChatCompletionMessageContentPart;

extension ChatHistoryX on ChatHistory {
  static ChatHistory get empty => ChatHistory.noid(items: []);

  String get toMarkdown {
    final sb = StringBuffer();
    for (final item in items) {
      sb.writeln(item.role.localized);
      sb.writeln(item.toMarkdown);
    }
    return sb.toString();
  }

  static ChatHistory get example => ChatHistory.noid(
        name: l10n.help,
        items: [
          ChatHistoryItem.single(
            role: ChatRole.system,
            type: ChatContentType.text,
            raw: l10n.initChatHelp(Urls.repoIssue, Urls.unilinkDoc),
          ),
        ],
      );

  bool get isInitHelp =>
      name == l10n.help &&
      items.length == 1 &&
      items.first.role.isSystem &&
      items.first.content.length == 1 &&
      items.first.content.first.raw.contains(Urls.repoIssue);

  ChatHistory copyWith({
    List<ChatHistoryItem>? items,
    String? name,
    ChatSettings? settings,
  }) {
    return ChatHistory(
      id: id,
      items: items ?? this.items,
      name: name ?? this.name,
      settings: settings ?? this.settings,
    );
  }

  void save() => Stores.history.put(this);

  bool containsKeywords(List<String> keywords) {
    return items.any(
      (e) => e.content.any(
        (e) => keywords.any((e) => e.contains(e)),
      ),
    );
  }
}

extension ChatHistoryItemX on ChatHistoryItem {
  String get toMarkdown {
    return content
        .map((e) => switch (e.type) {
              ChatContentType.text => e.raw,
              ChatContentType.image => '![$id](${e.raw})',
              ChatContentType.audio => '[$id](${e.raw})',
              ChatContentType.file => '[$id](file://${e.raw})',
            })
        .join('\n');
  }

  ChatHistoryItem copyWith({
    ChatRole? role,
    List<ChatContent>? content,
    DateTime? createdAt,
    @protected String? id,
    String? toolCallId,
    String? reasoning,
  }) {
    return ChatHistoryItem(
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      toolCallId: toolCallId ?? this.toolCallId,
      reasoning: reasoning ?? this.reasoning,
    );
  }

  Future<OaiHistoryItem> toOpenAI() async {
    switch (role) {
      case ChatRole.user:
        final contents = await Future.wait(content.map((e) => e.toOpenAI));
        return ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.parts(contents),
        );
      case ChatRole.assist:
        return ChatCompletionMessage.assistant(
          toolCalls: toolCalls,
          content: content.map((e) => e.raw).join('\n'),
        );
      case ChatRole.system:
        return ChatCompletionMessage.system(
          content: content.map((e) => e.raw).join('\n'),
        );
      case ChatRole.tool:
        return ChatCompletionMessage.tool(
          toolCallId: toolCallId ?? '',
          content: content.map((e) => e.raw).join('\n'),
        );
    }
  }
}

extension ChatContentX on ChatContent {
  bool get isText => type == ChatContentType.text;
  bool get isImg => type == ChatContentType.image;
  bool get isAudio => type == ChatContentType.audio;
  bool get isFile => type == ChatContentType.file;

  /// Cacher for mime type
  static final _cachedMimeMap = <String, String>{};

  /// Convert to OpenAI request content
  Future<OaiContent> get toOpenAI async {
    switch (type) {
      case ChatContentType.text:
        return OaiContent.text(text: raw);
      case ChatContentType.image:
        return OaiContent.image(
            imageUrl: ChatCompletionMessageImageUrl(url: raw));
      case ChatContentType.file:
        final file = File(raw);
        final cachedMime = _cachedMimeMap[raw];
        final mime = cachedMime ?? await file.mimeType;
        if (mime != null && cachedMime == null) {
          _cachedMimeMap[raw] = mime;
        }
        // If imgs, use image url
        if (mime != null && mime.startsWith('image/')) {
          final b64 = await _getBase64(file, mime);
          if (b64 != null) {
            return OaiContent.image(
                imageUrl: ChatCompletionMessageImageUrl(url: b64));
          }
        }
        return OaiContent.text(text: raw);
      default:
        throw UnimplementedError('$type.toOpenAI');
    }
  }

  ChatContent copyWith({
    ChatContentType? type,
    String? raw,
    String? id,
  }) {
    return ChatContent(
      type: type ?? this.type,
      raw: raw ?? this.raw,
      id: id ?? this.id,
    );
  }

  /// Delete the file inside the content.
  void deleteFile() async {
    if (isText) return;
    final isLocal = raw.startsWith('/');
    if (isLocal) {
      final file = File(raw);
      try {
        await file.delete();
      } catch (e) {
        Loggers.app.warning('Delete file failed', e);
      }
    } else {
      await FileApi.delete([raw]);
    }
  }
}

Future<String?> _getBase64(File file, String format) async {
  final bytes = await file.readAsBytes();
  return 'data:$format;base64,${base64Encode(bytes)}';
}
