import 'package:flutter_chatgpt/data/model/chat/history.dart';

final class AudioPlayStatus {
  final String id;
  final String source;
  final int playedMilli;
  final int totalMilli;
  final bool playing;

  const AudioPlayStatus({
    required this.id,
    required this.source,
    this.playedMilli = 0,
    this.totalMilli = 0,
    this.playing = false,
  });

  static AudioPlayStatus fromChatItem(ChatHistoryItem item) => AudioPlayStatus(
    id: item.id,
    source: item.content.first.raw,
  );

  AudioPlayStatus copyWith({
    int? playedMilli,
    int? totalMilli,
    bool? playing,
  }) {
    return AudioPlayStatus(
      id: id,
      source: source,
      playedMilli: playedMilli ?? this.playedMilli,
      totalMilli: totalMilli ?? this.totalMilli,
      playing: playing ?? this.playing,
    );
  }
}
