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
    return Scaffold(
      body: ListenableBuilder(
        listenable: _historyRN,
        builder: (_, __) {
          final keys = _allHistories.keys.toList();
          final len = keys.length;
          return ListView.builder(
            controller: _historyScrollCtrl,
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 11),
            reverse: true,
            itemExtent: _historyItemHeight,
            itemCount: len,
            itemBuilder: (_, index) {
              final chatId = keys[index];
              return _buildHistoryListItem(chatId).card;
            },
          );
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _curPage,
        builder: (_, page, __) => page.fab,
      ),
    );
  }

  Widget _buildHistoryListItem(String chatId) {
    final entity = _allHistories[chatId];
    if (entity == null) return UIs.placeholder;
    final node = _chatRNMap.putIfAbsent(chatId, () => RebuildNode());
    return ListTile(
      title: ListenableBuilder(
        listenable: node,
        builder: (_, __) => Text(
          entity.name ?? l10n.untitled,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        Funcs.throttle(
          () {
            _switchChat(chatId);
            if (!_isWide.value && _pageCtrl.page == 0) {
              _pageCtrl.animateToPage(
                HomePageEnum.chat.index,
                duration: Durations.medium3,
                curve: Curves.fastEaseInToSlowEaseOut,
              );
            }
          },
          id: 'history_item',
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
