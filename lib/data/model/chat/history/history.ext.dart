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
        return ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.parts(
              content.map((e) => e.toOpenAI).toList()),
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

  Future<OaiHistoryItem> toApi() async {
    final contents = await Future.wait(content.map((e) => e.toApi));
    return copyWith(content: contents).toOpenAI();
  }
}

extension ChatContentX on ChatContent {
  bool get isText => type == ChatContentType.text;
  bool get isImg => type == ChatContentType.image;
  bool get isAudio => type == ChatContentType.audio;
  bool get isFile => type == ChatContentType.file;

  OaiContent get toOpenAI => switch (type) {
        ChatContentType.text => OaiContent.text(text: raw),
        ChatContentType.image =>
          OaiContent.image(imageUrl: ChatCompletionMessageImageUrl(url: raw)),
        ChatContentType.file => OaiContent.text(text: raw),
        _ => throw UnimplementedError('$type.toOpenAI'),
      };

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

  /// {@template img_url_to_api}
  /// Convert local file to base64
  /// {@endtemplate}
  Future<ChatContent> get toApi async {
    if (!isImg && !isFile) return this;
    return copyWith(raw: await ChatContentX.contentToApi(raw));
  }

  /// {@macro img_url_to_api}
  ///
  /// Seperate from [toApi] to decouple the logic
  static Future<String> contentToApi(String raw) async {
    final isLocal = raw.startsWith('/') || raw.startsWith('file://');
    if (isLocal) {
      final file = File(raw);
      final b64 = await file.base64;
      if (b64 != null) raw = b64;
    }
    return raw;
  }

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
