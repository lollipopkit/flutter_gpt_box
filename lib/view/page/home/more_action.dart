part of 'home.dart';

class _MoreActionsBtn extends StatelessWidget {
  const _MoreActionsBtn();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MoreAction>(
      icon: const Icon(Icons.more_vert),
      tooltip: l10n.more,
      onSelected: (value) => value.onTap(),
      itemBuilder: (context) {
        /// Put it here, or it's l10n string won't rebuild every time
        final moreActions = [
          _MoreAction(
            title: l10n.rmDuplication,
            icon: Icons.delete,
            onTap: () => _onRmDup(context),
            onPageIdxs: [0],
          ),
          _MoreAction(
            title: l10n.share,
            icon: Icons.share,
            onTap: () => _onShareChat(context),
            onPageIdxs: [1],
          ),
        ];

        final items = <PopupMenuEntry<_MoreAction>>[];
        for (final item in moreActions) {
          if (!item.onPageIdxs.contains(_curPageIdx)) continue;
          items.add(
            PopupMenuItem(
              value: item,
              child: Row(
                children: [
                  Icon(item.icon),
                  UIs.width13,
                  Text(item.title),
                ],
              ),
            ),
          );
        }
        return items;
      },
    );
  }
}
