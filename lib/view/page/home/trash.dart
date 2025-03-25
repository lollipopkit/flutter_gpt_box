part of 'home.dart';

final class _TrashSheetHeader extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 0;

  @override
  double get maxExtent => _historyItemHeight + 11;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _TrashSheet();
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

final class _TrashSheet extends StatefulWidget {
  const _TrashSheet();

  @override
  State<StatefulWidget> createState() => _TrashSheetState();
}

final class _TrashSheetState extends State<_TrashSheet> {
  @override
  Widget build(BuildContext context) {
    return _buildList;
  }

  Widget get _buildList {
    return Stores.trash.historiesVN.listenVal((histories) {
      if (histories.isEmpty) return UIs.placeholder;
      return ListView.builder(
        padding: const EdgeInsets.only(left: 11, right: 11, top: 11),
        scrollDirection: Axis.horizontal,
        itemCount: histories.length,
        itemBuilder: (ctx, idx) {
          final key = histories.keys.elementAt(idx);
          final item = histories[key];
          if (item == null) return UIs.placeholder;
          return _buildItem(item, key);
        },
      );
    });
  }

  Widget _buildItem(ChatHistory item, String key) {
    final lastTime = item.lastTime?.simple();
    final subtitle = lastTime != null
        ? Text(
            lastTime,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        : null;
    return SizedBox(
      width: 200,
      child: ListTile(
        title: Text(
          item.name ?? l10n.untitled,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle,
        onTap: () => _showDialog(item, key),
      ).cardx,
    );
  }
}

extension on _TrashSheetState {
  Future<void> _showDialog(ChatHistory item, String key) {
    return context.showRoundDialog(
      title: libL10n.restore,
      actions: [
        Btn.text(
          text: libL10n.delete,
          onTap: () => _delete(item, key),
          textStyle: UIs.textRed,
        ),
        Btn.ok(onTap: () => _restore(item, key)),
      ],
    );
  }

  void _restore(ChatHistory item, String key) {
    Stores.trash.removeHistory(key);
    Stores.history.put(item);
    _allHistories[key] = item;
    _historyRN.notify();

    context.pop();
  }

  void _delete(ChatHistory item, String key) {
    Stores.trash.removeHistory(key);

    context.pop();
  }
}
