part of 'home.dart';

CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: false,
      title: ListenableBuilder(
        listenable: _appbarTitleRN,
        builder: (_, __) {
          return AnimatedSwitcher(
            duration: Durations.medium1,
            switchInCurve: Easing.standardDecelerate,
            switchOutCurve: Easing.standardDecelerate,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransitionX(
                position: animation,
                direction: AxisDirection.right,
                child: child,
              ),
            ),
            child: Column(
              key: Key(_curChatId),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  _curChat?.name ?? l10n.untitled,
                  style: UIs.text15,
                ),
                ListenableBuilder(
                  listenable: _timeRN,
                  builder: (_, __) {
                    final entity = _curChat;
                    if (entity == null) return Text(l10n.empty);
                    final len = '${entity.items.length} ${l10n.message}';
                    final time = entity.items.lastOrNull?.createdAt.toAgo;
                    return Text(
                      '$len · ${time ?? l10n.empty}',
                      style: UIs.text11Grey,
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: _curPage,
          builder: (_, page, __) => page.buildAppbarActions(context),
        )
      ],
    );
  }