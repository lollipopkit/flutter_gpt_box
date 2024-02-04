import 'package:flutter_chatgpt/data/model/chat/history.dart';

final class AudioPlayStatus {
  final String id;
  final String source;
  final int played;
  final int total;
  final bool playing;

  const AudioPlayStatus({
    required this.id,
    required this.source,
    this.played = 0,
    this.total = 0,
    this.playing = false,
  });

  static AudioPlayStatus fromChatItem(ChatHistoryItem item) => AudioPlayStatus(
    id: item.id,
    source: item.content.first.raw,
  );

  AudioPlayStatus copyWith({
    int? played,
    int? total,
    bool? playing,
  }) {
    return AudioPlayStatus(
      id: id,
      source: source,
      played: played ?? this.played,
      total: total ?? this.total,
      playing: playing ?? this.playing,
    );
  }
}
