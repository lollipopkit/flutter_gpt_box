import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/path.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/audio.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_chatgpt/view/widget/image.dart';

final class ResPage extends StatefulWidget {
  final Never? args;

  const ResPage({super.key, this.args});

  @override
  State<ResPage> createState() => _ResPageState();
}

const _duration = Durations.short3;

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
              crossAxisSpacing: 17,
              mainAxisSpacing: 17,
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
    return _resType.value.build(entity);
  }

  void _load() async {
    _listKey.currentState?.removeAllItems(
      (context, animation) => FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeInOutCubic)),
        child: CardX(
          child: SizedBox(
            height: ImageCard.height,
            width: ImageCard.height,
          ),
        ),
      ),
      duration: _duration,
    );
    await Future.delayed(_duration);
    _filesList.clear();
    await for (final entity in _resType.value.all) {
      debugPrint('entity: $entity');
      _filesList.add(entity);
      _filesList.sort((a, b) => a.path.compareTo(b.path));
      _listKey.currentState?.insertItem(_filesList.indexOf(entity));
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

  Widget build(FileSystemEntity entity) {
    return switch (this) {
      audio => AudioCard(id: entity.path),
      image => ImageCard(imageUrl: entity.path, heroTag: entity.path),
    };
  }

  IconData get icon => switch (this) {
        audio => Icons.audiotrack,
        image => Icons.image,
      };

  _ResType get next => _ResType
      .values[(_ResType.values.indexOf(this) + 1) % _ResType.values.length];
}
