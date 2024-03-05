import 'package:flutter_chatgpt/data/model/chat/history.dart';

final class AudioPlayStatus {
  /// [ChatContent]'s id
  final String id;

  final int played;
  final int total;
  final bool playing;

  const AudioPlayStatus({
    required this.id,
    this.played = 0,
    this.total = 0,
    this.playing = false,
  });

  AudioPlayStatus copyWith({
    int? played,
    int? total,
    bool? playing,
  }) {
    return AudioPlayStatus(
      id: id,
      played: played ?? this.played,
      total: total ?? this.total,
      playing: playing ?? this.playing,
    );
  }
}
