import 'package:fl_pi_llm/fl_pi_llm.dart';

/// What the chat list knows about a chat. The conversation itself is the pi
/// session of the same [id].
final class ChatMeta {
  const ChatMeta({
    required this.id,
    required this.updatedAt,
    this.title,
    this.useTools = true,
    this.model,
    this.trashedAt,
  });

  factory ChatMeta.fromJson(Map<String, Object?> j) => ChatMeta(
    id: j['id'] as String,
    title: j['title'] as String?,
    updatedAt: DateTime.fromMillisecondsSinceEpoch(j['updatedAt'] as int? ?? 0),
    useTools: j['useTools'] as bool? ?? true,
    model: switch (j['model']) {
      final Map m => LlmModelRef.fromJson(m.cast<String, Object?>()),
      _ => null,
    },
    trashedAt: switch (j['trashedAt']) {
      final int t => DateTime.fromMillisecondsSinceEpoch(t),
      _ => null,
    },
  );

  final String id;
  final String? title;
  final DateTime updatedAt;

  /// Whether tools are offered in this chat, when they are on at all.
  final bool useTools;

  /// The model this chat talks to; the default one when null.
  final LlmModelRef? model;

  /// When it went to the trash; null while it is not there.
  final DateTime? trashedAt;

  bool get trashed => trashedAt != null;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': ?title,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
    'useTools': useTools,
    'model': ?model?.toJson(),
    'trashedAt': ?trashedAt?.millisecondsSinceEpoch,
  };

  ChatMeta copyWith({
    String? title,
    DateTime? updatedAt,
    bool? useTools,
    LlmModelRef? model,
    bool clearModel = false,
    DateTime? trashedAt,
    bool restore = false,
  }) => ChatMeta(
    id: id,
    title: title ?? this.title,
    updatedAt: updatedAt ?? this.updatedAt,
    useTools: useTools ?? this.useTools,
    model: clearModel ? null : model ?? this.model,
    trashedAt: restore ? null : trashedAt ?? this.trashedAt,
  );
}
