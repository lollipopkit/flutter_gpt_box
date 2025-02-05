part of 'home.dart';

final class _TrashSheet extends StatefulWidget {
  final ScrollController scrollCtrl;

  const _TrashSheet({required this.scrollCtrl});

  @override
  State<StatefulWidget> createState() => _TrashSheetState();
}

final class _TrashSheetState extends State<_TrashSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Stores.trash.historiesVN.listenVal((histories) {
        return CustomScrollView(
          controller: widget.scrollCtrl,
          slivers: [
            SliverPersistentHeader(
              delegate: _SliverPersistentHeadDragger(),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, idx) {
                  if (idx >= histories.length) return UIs.placeholder;
                  final key = histories.keys.elementAt(idx);
                  final item = histories[key];
                  if (item == null) return UIs.placeholder;
                  final lastTime = item.lastTime?.simple();
                  return ListTile(
                    title: Text(item.name ?? l10n.untitled),
                    subtitle: lastTime != null ? Text(lastTime) : null,
                    trailing: _buildRestoreBtn(item, key),
                  );
                },
                childCount: histories.length,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRestoreBtn(ChatHistory item, String key) {
    return Btn.icon(
      icon: Icon(Icons.restore),
      text: libL10n.restore,
      onTap: () => _restore(item, key),
    );
  }
}

extension on _TrashSheetState {
  void _restore(ChatHistory item, String key) {
    Stores.trash.removeHistory(key);
    Stores.history.put(item);
    _allHistories[key] = item;
    _historyRN.notify();
  }
}

final class _SliverPersistentHeadDragger
    extends SliverPersistentHeaderDelegate {
  const _SliverPersistentHeadDragger();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        height: 4,
        width: 40,
        margin: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
