import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/data/model/app/audio_play.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/future.dart';

final _audioPlayer = AudioPlayer();
// Map for audio player value notifiers which stores the current playing status
final _audioPlayerMap = <String, ValueNotifier<AudioPlayStatus>>{};
String? _nowPlayingId;

final class AudioCard extends StatefulWidget {
  static final loadingMap = <String, Completer>{};

  final String path;
  final String id;
  final bool buildSlider;
  final void Function()? onDelete;

  const AudioCard({
    super.key,
    required this.id,
    required this.path,
    this.buildSlider = true,
    this.onDelete,
  });

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
  late final _file = File(widget.path);

  @override
  Widget build(BuildContext context) {
    var inited = true;
    final listenable = _audioPlayerMap.putIfAbsent(
      widget.id,
      () {
        inited = false;
        return ValueNotifier(AudioPlayStatus(id: widget.id));
      },
    );
    if (inited) {
      return _buildItem(listenable);
    }
    final initWidget = () async {
      await AudioCard.loadingMap[widget.id]?.future;
      AudioCard.loadingMap.remove(widget.id);
      if (!await _file.exists()) {
        throw l10n.fileNotFound(widget.path);
      }
      final player = AudioPlayer();
      player.setSource(DeviceFileSource(widget.path));
      final duration = await player.getDuration();

      listenable.value = listenable.value.copyWith(
        total: duration?.inMilliseconds ?? 0,
      );
    }();
    return FutureWidget(
      future: initWidget,
      error: (error, trace) {
        return Text('$error');
      },
      loading: UIs.centerSizedLoading,
      success: (duration) {
        return _buildItem(listenable);
      },
    );
  }

  Widget _buildItem(ValueNotifier<AudioPlayStatus> listenable) {
    return ValueListenableBuilder(
      valueListenable: listenable,
      builder: (_, val, __) {
        if (!widget.buildSlider) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.id,
                style: UIs.text13Bold,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              Text(listenable.value.progress),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: val.playing
                        ? const Icon(Icons.stop, size: 19)
                        : const Icon(Icons.play_arrow, size: 19),
                    onPressed: () =>
                        _onTapAudioCtrl(val, widget.id, listenable),
                  ),
                  IconButton(
                    onPressed: () async {
                      _audioPlayerMap.remove(widget.id);
                      listenable.dispose();
                      await _file.delete();
                      widget.onDelete?.call();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              )
            ],
          ).card;
        }
        return ListTile(
          leading: IconButton(
            icon: val.playing
                ? const Icon(Icons.stop, size: 19)
                : const Icon(Icons.play_arrow, size: 19),
            onPressed: () => _onTapAudioCtrl(val, widget.id, listenable),
          ),
          title: Slider(
            value: val.played / val.total,
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
      _audioPlayer.play(DeviceFileSource(_file.absolute.path));
    }
  }
}
