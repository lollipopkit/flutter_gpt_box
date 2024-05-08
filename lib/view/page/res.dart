import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/path.dart';
import 'package:gpt_box/view/page/image.dart';
import 'package:gpt_box/view/widget/appbar.dart';
import 'package:gpt_box/view/widget/audio.dart';
import 'package:gpt_box/view/widget/card.dart';
import 'package:gpt_box/view/widget/image.dart';

final class ResPage extends StatefulWidget {
  final Never? args;

  const ResPage({super.key, this.args});

  @override
  State<ResPage> createState() => _ResPageState();
}

const _duration = Durations.medium1;

final class _ResPageState extends State<ResPage> {
  late final _resType = ValueNotifier(_ResType.image)..addListener(_load);
  final _listKey = GlobalKey<AnimatedGridState>();
  final _filesList = <FileSystemEntity>[];

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.res),
        actions: [
          ListenableBuilder(
            listenable: _resType,
            builder: (_, __) {
              return IconButton(
                onPressed: () => _resType.value = _resType.value.next,
                icon: Icon(_resType.value.icon),
              );
            },
          )
        ],
      ),
      body: ListenableBuilder(
        listenable: _resType,
        builder: (_, __) {
          return AnimatedGrid(
            key: _listKey,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 13,
              mainAxisSpacing: 13,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 17),
            itemBuilder: (_, idx, anime) {
              return FadeTransition(
                // Use Curves.easeIn for the animation
                opacity: anime.drive(CurveTween(curve: Curves.easeInOutCubic)),
                child: _buildTile(idx),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTile(int idx) {
    if (idx >= _filesList.length) {
      return ListTile(
        leading: const Icon(Icons.error),
        title: Text(l10n.error),
      );
    }
    final entity = _filesList[idx];
    return _buildCard(entity);
  }

  void _load() async {
    _listKey.currentState?.removeAllItems(_rmCardBuilder, duration: _duration);
    await Future.delayed(_duration);
    _filesList.clear();
    await for (final entity in _resType.value.all) {
      _filesList.add(entity);
      _filesList.sort((a, b) => a.path.compareTo(b.path));
      _listKey.currentState?.insertItem(_filesList.indexOf(entity));
    }
  }

  Widget _rmCardBuilder(BuildContext context, Animation<double> animation) =>
      FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeInOutCubic)),
        child: CardX(
          child: SizedBox(
            height: ImageCard.height,
            width: ImageCard.height,
          ),
        ),
      );

  Widget _buildCard(FileSystemEntity entity) {
    switch (_resType.value) {
      case _ResType.audio:
        final id = entity.path.split('/').last;
        return AudioCard(
          id: id,
          path: entity.path,
          buildSlider: false,
          onDelete: () => _onAudioDelete(entity),
        );
      case _ResType.image:
        return ImageCard(
          imageUrl: entity.path,
          heroTag: entity.path,
          onRet: (p0) => _onImageRet(p0, entity),
        );
    }
  }

  void _onAudioDelete(FileSystemEntity entity) async {
    _listKey.currentState?.removeItem(
      _filesList.indexOf(entity),
      _rmCardBuilder,
      duration: _duration,
    );
    _filesList.remove(entity);
  }

  void _onImageRet(ImagePageRet ret, FileSystemEntity entity) async {
    if (ret.isDeleted) {
      await File(entity.path).delete();
      // Wait for hero anime
      await Future.delayed(_duration + Durations.short3);
      _listKey.currentState?.removeItem(
        _filesList.indexOf(entity),
        _rmCardBuilder,
        duration: _duration,
      );
      _filesList.remove(entity);
    }
  }
}

enum _ResType {
  audio,
  image,
  ;

  Future<Directory> get dir async => switch (this) {
        audio => Directory(await Paths.audio),
        image => Directory(await Paths.image),
      };

  Stream<FileSystemEntity> get all async* {
    final dir = await this.dir;
    await for (final entity in dir.list()) {
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
