part of 'home.dart';

class _HistoryPage extends StatefulWidget {
  const _HistoryPage();

  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<_HistoryPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListenableBuilder(
      listenable: _historyRN,
      builder: (_, __) {
        final len = _allChatIds.length;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 11),
          reverse: true,
          itemCount: len,
          itemBuilder: (_, index) {
            final chatId = _allChatIds[index];
            return _buildHistoryListItem(chatId, len - index).card;
          },
        );
      },
    );
  }

  Widget _buildHistoryListItem(String chatId, int leading) {
    final entity = _allHistories[chatId];
    if (entity == null) return UIs.placeholder;
    final node = _chatRNMap.putIfAbsent(chatId, () => RebuildNode());
    return ListTile(
      leading: Text('#$leading', style: UIs.textGrey),
      title: ListenableBuilder(
        listenable: node,
        builder: (_, __) => Text(entity.name ?? l10n.untitled),
      ),
      subtitle: ListenableBuilder(
        listenable: _timeRN,
        builder: (_, __) {
          final len = '${entity.items.length} ${l10n.message}';
          final time = entity.items.lastOrNull?.createdAt.toAgo;
          if (time == null) return Text(len, style: UIs.textGrey);
          return Text(
            '$len · $time',
            style: UIs.textGrey,
          );
        },
      ),
      contentPadding: const EdgeInsets.only(left: 17, right: 11),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _onTapDeleteChat(chatId, context),
            icon: const Icon(Icons.delete, size: 19),
          ),
        ],
      ),
      onTap: () {
        _switchChat(chatId);
        if (!_isWide.value && _pageCtrl.page == 0) {
          _pageCtrl.animateToPage(
            1,
            duration: Durations.medium3,
            curve: Curves.fastEaseInToSlowEaseOut,
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
