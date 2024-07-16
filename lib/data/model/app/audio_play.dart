import 'package:gpt_box/data/model/chat/history/history.dart';

final class AudioPlayStatus {
  /// [ChatContent]'s id
  final String id;

  /// milliseconds
  final int played;

  /// milliseconds
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

  String get progress {
    final played = Duration(milliseconds: this.played);
    final playedStr =
        '${played.inMinutes.toString().padLeft(2, '0')}:${played.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    final total = Duration(milliseconds: this.total);
    final totalStr =
        '${total.inMinutes.toString().padLeft(2, '0')}:${total.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return '$playedStr / $totalStr';
  }

  @override
  String toString() {
    return 'AudioPlayStatus{id: $id, played: $played, total: $total, playing: $playing}';
  }
}
