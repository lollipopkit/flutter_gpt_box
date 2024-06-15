import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/view/page/image.dart';
import 'package:gpt_box/view/widget/audio.dart';
import 'package:gpt_box/view/widget/image.dart';

final class ResPage extends StatefulWidget {
  final Never? args;

  const ResPage({super.key, this.args});

  @override
  State<ResPage> createState() => _ResPageState();
}

const _dur = Durations.medium1;

final class _ResPageState extends State<ResPage> {
  late final _resType = ValueNotifier(_ResType.image)..addListener(_load);
  final _listKey = GlobalKey<AnimatedGridState>();
  final _filesList = <FileSystemEntity>[];
  bool _isWide = false;
  bool _loading = false;

  @override
  void dispose() {
    _resType.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    _isWide = size.width / size.height > 1.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.res),
        actions: [
          ListenableBuilder(
            listenable: _resType,
            builder: (_, __) {
              return IconButton(
                onPressed: () {
                  if (_loading) return;
                  _resType.value = _resType.value.next;
                },
                icon: Icon(_resType.value.icon),
              );
            },
          )
        ],
      ),
      body: ListenBuilder(
        listenable: _resType,
        builder: () {
          return AnimatedGrid(
            key: _listKey,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _isWide ? 5 : 2,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 17),
            itemBuilder: (_, idx, anime) {
              return _buildTile(idx, anime);
            },
          );
        },
      ),
    );
  }

  Widget _buildTile(int idx, Animation<double> anime) {
    final entity = _filesList[idx];
    final child = switch (_resType.value) {
      _ResType.audio => AudioCard(
          id: entity.path.split('/').last,
          path: entity.path,
          buildSlider: false,
          onDelete: () => _onAudioDelete(idx),
        ),
      _ResType.image => ImageCard(
          imageUrl: entity.path,
          heroTag: entity.path,
          onRet: (p0) => _onImageRet(p0, entity, idx),
        ),
    };

    return SlideTransitionX(
      position: anime.drive(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
      direction: AxisDirection.left,
      child: FadeTransition(opacity: anime, child: child),
    );
  }

  void _load() async {
    try {
      if (_loading) return;
      _loading = true;
      if (_filesList.isNotEmpty) {
        _listKey.currentState?.removeAllItems(
          (_, anime) => FadeTransition(
            opacity: anime,
            child: SizedBox(height: ImageCard.height, width: ImageCard.height),
          ),
          duration: _dur,
        );
        await Future.delayed(_dur);
      }
      _filesList.clear();
      final items = await _resType.value.all.toList();
      _filesList.addAll(items);
      _listKey.currentState?.insertAllItems(0, items.length, duration: _dur);
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
    }
  }

  void _onAudioDelete(int idx) async {
    _listKey.currentState?.removeItem(
      idx,
      (_, anime) => _buildTile(idx, anime),
      duration: _dur,
    );
    await Future.delayed(_dur);
    _filesList.removeAt(idx);
  }

  void _onImageRet(ImagePageRet ret, FileSystemEntity entity, int idx) async {
    if (ret.isDeleted) {
      await File(entity.path).delete();
      // Wait for hero anime
      await Future.delayed(_dur + Durations.medium1);
      _listKey.currentState?.removeItem(
        _filesList.indexOf(entity),
        (_, anime) => _buildTile(idx, anime),
        duration: _dur,
      );
      await Future.delayed(_dur);
      _filesList.remove(entity);
    }
  }
}

enum _ResType {
  audio,
  image,
  ;

  Future<Directory> get dir async => switch (this) {
        audio => Directory(Paths.audio),
        image => Directory(Paths.img),
      };

  Stream<FileSystemEntity> get all async* {
    await for (final entity in (await dir).list()) {
      yield entity;
    }
  }

  IconData get icon => switch (this) {
        audio => Icons.audiotrack,
        image => Icons.image,
      };

  _ResType get next => _ResType
      .values[(_ResType.values.indexOf(this) + 1) % _ResType.values.length];
}
