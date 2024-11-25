part of 'setting.dart';

final class ResPage extends StatefulWidget {
  const ResPage({super.key});

  @override
  State<ResPage> createState() => _ResPageState();
}

final class _ResPageState extends State<ResPage>
    with
        AfterLayoutMixin,
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin {
  late final _resType = ValueNotifier(_ResType.image)..addListener(_load);
  final _listKey = GlobalKey<AnimatedGridState>();
  final _filesList = <FileSystemEntity>[];
  static const _dur = Durations.medium1;
  bool _loading = false;

  @override
  void dispose() {
    _resType.dispose();
    super.dispose();
  }

  // List<Tab> get _tabs =>
  //     _ResType.values.map((e) => Tab(icon: Icon(e.icon))).toList();

  // late final _tabCtrl = TabController(length: _tabs.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: TabBar(
      //   tabs: _tabs,
      //   controller: _tabCtrl,
      //   dividerHeight: 0,
      //   onTap: (value) => _resType.value = _ResType.values[value],
      // ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: ListenBuilder(
          listenable: _resType,
          builder: () {
            return AnimatedGrid(
              key: _listKey,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 17),
              itemBuilder: (_, idx, anime) {
                return _buildTile(idx, anime);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTile(int idx, Animation<double> anime) {
    final entity = _filesList[idx];
    final child = switch (_resType.value) {
      // _ResType.audio => AudioCard(
      //     key: ValueKey(entity.path),
      //     id: entity.path.split('/').last,
      //     path: entity.path,
      //     buildSlider: false,
      //     onDelete: () => _onAudioDelete(idx),
      //   ),
      _ResType.audio => const SizedBox(),
      _ResType.image => ImageCard(
          key: ValueKey(entity.path),
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
    if (_loading) return;
    _loading = true;
    try {
      if (_filesList.isNotEmpty) {
        _listKey.currentState?.removeAllItems(
          (_, anime) => FadeTransition(
            opacity: anime,
            child: const SizedBox(height: 177, width: 177),
          ),
          duration: _dur,
        );
        await Future.delayed(_dur);
      }
      _filesList.clear();
      final items = await _resType.value.all;
      _filesList.addAll(items);
      _listKey.currentState?.insertAllItems(0, items.length, duration: _dur);
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
    }
  }

  // void _onAudioDelete(int idx) async {
  //   _listKey.currentState?.removeItem(
  //     idx,
  //     (_, anime) => _buildTile(idx, anime),
  //     duration: _dur,
  //   );
  //   await Future.delayed(_dur);
  //   _filesList.removeAt(idx);
  // }

  void _onImageRet(ImagePageRet ret, FileSystemEntity entity, int idx) async {
    if (ret.isDeleted) {
      await File(entity.path).delete();
      // Wait for hero anime
      await Future.delayed(_dur + Durations.medium1);
      _listKey.currentState?.removeItem(
        idx,
        (_, anime) {
          return _buildTile(idx, anime);
        },
        duration: _dur,
      );
      await Future.delayed(_dur);
      _filesList.removeAt(idx);
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    _load();
  }

  @override
  bool get wantKeepAlive => true;
}

enum _ResType {
  image,
  audio,
  ;

  Directory get dir => switch (this) {
        audio => Directory(Paths.audio),
        image => Directory(Paths.img),
      };

  Future<List<FileSystemEntity>> get all async {
    final files = dir.list();
    return files.toList();
  }

  IconData get icon => switch (this) {
        audio => Icons.audiotrack,
        image => Icons.image,
      };

  _ResType get next => _ResType
      .values[(_ResType.values.indexOf(this) + 1) % _ResType.values.length];
}
