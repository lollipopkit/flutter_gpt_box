part of 'home.dart';

enum HomePageEnum {
  history,
  chat,
  ;

  static HomePageEnum fromIdx(int idx) => HomePageEnum.values[idx];

  Widget get fab {
    return switch ((this, _isWide.value)) {
      /// Find current chat in history list
      (HomePageEnum.history, _) || (_, true) => ValueListenableBuilder(
          valueListenable: _locateHistoryBtn,
          builder: (_, display, __) {
            return AnimatedSwitcher(
              duration: Durations.short3,
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: display
                  ? FloatingActionButton(
                      key: const Key('locate-history-btn'),
                      onPressed: () => _gotoHistory(_curChatId),
                      child: const Icon(Icons.location_on),
                    )
                  : const SizedBox(key: Key('locate-history-btn-placeholder')),
            );
          },
        ),
      _ => UIs.placeholder,
    };
  }

  Widget buildAppbarActions(BuildContext context) {
    final items = <IconButton>[
      IconButton(
        onPressed: () => Routes.debug.go(context),
        icon: const Icon(Icons.developer_board),
        tooltip: 'Debug',
      ),
    ];

    /// Put it here, or it's l10n string won't rebuild every time
    for (final item in [
      _MoreAction(
        title: l10n.share,
        icon: Icons.share,
        onTap: () => _onShareChat(context),
        onHomePage: [HomePageEnum.chat],
      ),
      _MoreAction(
        title: l10n.delete,
        icon: Icons.delete,
        onTap: () => _onTapDeleteChat(_curChatId, context),
        onHomePage: [HomePageEnum.chat],
      ),
      _MoreAction(
        title: l10n.search,
        icon: Icons.search,
        onHomePage: [HomePageEnum.history],
        onTap: () => showSearch(
          context: context,
          delegate: ChatSearchDelegate(),
        ),
      ),
    ]) {
      if (!_isWide.value && !item.onHomePage.contains(this)) {
        continue;
      }
      items.add(IconButton(
        onPressed: () => Funcs.throttle(() {
          item.onTap();
        }),
        icon: Icon(item.icon),
        tooltip: item.title,
      ));
    }

    return Row(children: items);
  }
}
