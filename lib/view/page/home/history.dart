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
      body: _buildBody,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _curPage,
        builder: (_, page, __) => page.fab,
      ),
    );
  }

  Widget get _buildBody {
    return CustomScrollView(
      controller: _historyScrollCtrl,
      slivers: [
        _buildTrash,
        _buildHisotry,
      ],
    );
  }

  Widget get _buildTrash {
    return Stores.trash.historiesVN.listenVal((vals) {
      if (vals.isEmpty) return SliverToBoxAdapter(child: UIs.placeholder);
      return SliverPersistentHeader(
        delegate: _TrashSheetHeader(),
      );
    });
  }

  Widget get _buildHisotry {
    return _historyRN.listen(() {
      final keys = _allHistories.keys.toList();
      final len = keys.length;
      return SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 11),
        sliver: SliverList.builder(
          // itemExtent: _historyItemHeight,
          itemCount: len,
          itemBuilder: (_, index) {
            final chatId = keys[index];
            return _buildHistoryListItem(chatId).cardx;
          },
        ),
      );
    });
  }

  Widget _buildHistoryListItem(String chatId) {
    final entity = _allHistories[chatId];
    if (entity == null) return UIs.placeholder;

    return ListTile(
      title: Text(
        entity.name ?? l10n.untitled,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: UIs.text15,
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
          Btn.icon(
            onTap: () => _onTapRenameChat(chatId, context),
            icon: const Icon(BoxIcons.bx_rename, size: 19),
          ),
          Btn.icon(
            onTap: () => _onTapDeleteChat(chatId, context),
            icon: const Icon(Icons.delete, size: 19),
          ),
        ],
      ),
      onTap: () {
        Fns.throttle(
          () {
            _switchChat(chatId);
            if (!_isDesktop.value && _curPage.value != HomePageEnum.chat) {
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
