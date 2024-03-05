import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/data/model/app/audio_play.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/path.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/future.dart';

final _audioPlayer = AudioPlayer();
// Map for audio player value notifiers which stores the current playing status
final _audioPlayerMap = <String, ValueNotifier<AudioPlayStatus>>{};
String? _nowPlayingId;
const _formatSuffix = '.aac';

final class AudioCard extends StatefulWidget {
  static final loadingMap = <String, Completer>{};

  final String id;

  const AudioCard({super.key, required this.id});

  @override
  State<AudioCard> createState() => _AudioCardState();

  static void listenAudioPlayer() {
    _audioPlayer.onPositionChanged.listen((position) {
      final status = _audioPlayerMap[_nowPlayingId];
      if (status == null) return;
      status.value = status.value.copyWith(played: position.inMilliseconds);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      final status = _audioPlayerMap[_nowPlayingId];
      if (status == null) return;
      status.value = status.value.copyWith(playing: false, played: 0);
    });
  }
}

class _AudioCardState extends State<AudioCard> {
  @override
  Widget build(BuildContext context) {
    final listenable = _audioPlayerMap.putIfAbsent(
      widget.id,
      () => ValueNotifier(AudioPlayStatus(id: widget.id)),
    );
    final initWidget = () async {
      await AudioCard.loadingMap[widget.id]?.future;
      AudioCard.loadingMap.remove(widget.id);
      final path = '${await Paths.audio}/${widget.id}$_formatSuffix';
      if (!await File(path).exists()) {
        throw l10n.fileNotFound(path);
      }
      final player = AudioPlayer();
      player.setSource(DeviceFileSource(path));
      return player.getDuration();
    }();
    return FutureWidget(
      future: initWidget,
      error: (error, trace) {
        return Text('$error');
      },
      loading: UIs.centerSizedLoading,
      success: (duration) {
        listenable.value = listenable.value.copyWith(
          total: duration?.inMilliseconds ?? 0,
        );
        return ValueListenableBuilder(
          valueListenable: listenable,
          builder: (_, val, __) {
            return ListTile(
              leading: IconButton(
                icon: val.playing
                    ? const Icon(Icons.stop, size: 19)
                    : const Icon(Icons.play_arrow, size: 19),
                onPressed: () => _onTapAudioCtrl(val, widget.id, listenable),
              ),
              title: Slider(
                value: duration == null ? 0.0 : val.played / val.total,
                onChanged: (v) {
                  final nowMilli = (val.total * v).toInt();
                  final duration = Duration(milliseconds: nowMilli);
                  _audioPlayer.seek(duration);
                  listenable.value = val.copyWith(played: nowMilli);
                },
              ),
            ).card;
          },
        );
      },
    );
  }

  void _onTapAudioCtrl(
    AudioPlayStatus val,
    String id,
    ValueNotifier<AudioPlayStatus> listenable,
  ) async {
    if (val.playing) {
      _audioPlayer.pause();
      _nowPlayingId = null;
      listenable.value = val.copyWith(playing: false);
    } else {
      if (_nowPlayingId == id) {
        _audioPlayer.resume();
        _nowPlayingId = id;
        listenable.value = val.copyWith(playing: true);
        return;
      } else {
        if (_nowPlayingId != null) {
          final last = _audioPlayerMap[_nowPlayingId];
          if (last != null) {
            _audioPlayer.pause();
            _nowPlayingId = null;
            last.value = last.value.copyWith(playing: false);
          }
        }
      }
      _nowPlayingId = id;
      listenable.value = val.copyWith(playing: true);
      _audioPlayer.play(DeviceFileSource(
        '${await Paths.audio}/$id$_formatSuffix',
      ));
    }
  }
}
