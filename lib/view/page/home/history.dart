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
      body: ListenBuilder(
        listenable: _historyRN,
        builder: () {
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
              return _buildHistoryListItem(chatId).cardx;
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
    final node = _historyRNMap.putIfAbsent(chatId, () => RNode());
    return ListTile(
      title: ListenBuilder(
        listenable: node,
        builder: () => Text(
          entity.name ?? l10n.untitled,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: UIs.text15,
        ),
      ),
      subtitle: ListenBuilder(
        listenable: _timeRN,
        builder: () {
          final len = '${entity.items.length} ${l10n.message}';
          final time = entity.items.lastOrNull?.createdAt
              .difference(DateTime.now())
              .toAgoStr;
          if (time == null) return Text(len, style: UIs.textGrey);
          return Text(
            '$len · $time',
            style: UIs.text13Grey,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      contentPadding: const EdgeInsets.only(left: 17, right: 15),
      // trailing: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     isDesktop
      //         ? IconBtn(
      //             onTap: () => _onTapDeleteChat(chatId, context),
      //             icon: Icons.delete,
      //             size: 17,
      //           )
      //         : IconButton(
      //             onPressed: () => _onTapDeleteChat(chatId, context),
      //             icon: const Icon(Icons.delete, size: 17),
      //           ),
      //   ],
      // ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconBtn(
            onTap: () => _onTapRenameChat(chatId, context),
            icon: Icons.abc,
          ),
          IconBtn(
            onTap: () => _onTapDeleteChat(chatId, context),
            icon: Icons.delete,
          ),
        ],
      ),
      onTap: () {
        Funcs.throttle(
          () {
            _switchChat(chatId);
            if (!_isWide.value && _curPage.value != HomePageEnum.chat) {
              _switchPage(HomePageEnum.chat);
            }
          },
          id: 'history_item',
          duration: 70,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
