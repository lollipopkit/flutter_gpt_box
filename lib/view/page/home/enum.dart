part of 'home.dart';

enum HomePageEnum {
  history,
  chat,
  ;

  static HomePageEnum fromIdx(int idx) => HomePageEnum.values[idx];

  HomePageEnum get next =>
      HomePageEnum.values[(index + 1) % HomePageEnum.values.length];

  Widget get fab {
    return switch ((this, _isWide.value)) {
      /// Find current chat in history list
      (HomePageEnum.history, _) || (_, true) => ValueListenableBuilder(
          valueListenable: _locateHistoryBtn,
          builder: (_, display, __) {
            return AnimatedSwitcher(
              duration: _durationShort,
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: display
                  ? FloatingActionButton(
                      key: const Key('locate-history-btn'),
                      onPressed: () => _gotoHistory(_curChatId),
                      mini: true,
                      child: const Icon(Icons.gps_fixed, size: 17),
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
        onPressed: () async {
          final addBtn = TextButton(
            onPressed: () {
              context.pop();
              SettingsPage.route.go(
                context,
                const SettingsPageArgs(tabIndex: SettingsTab.profile),
              );
            },
            child: Text(libL10n.add),
          );
          final profiles = Stores.config.fetchAll().values.toList();
          final select = await context.showPickSingleDialog(
            title: l10n.profile,
            items: profiles,
            display: (p0) => p0.name.isEmpty ? l10n.defaulT : p0.name,
            initial: OpenAICfg.current,
            actions: [addBtn],
          );
          if (select == null) return;
          OpenAICfg.setTo(select);
        },
        icon: const Icon(Icons.switch_account),
        tooltip: l10n.profile,
      ),
      IconButton(
        onPressed: () => showSearch(
          context: context,
          delegate: _ChatSearchDelegate(),
        ),
        icon: const Icon(Icons.search),
      )
    ];

    /// Put it here, or it's l10n string won't rebuild every time
    for (final item in [
      _MoreAction(
        title: l10n.share,
        icon: Icons.share,
        onTap: () => _onShareChat(context),
        onHomePage: [HomePageEnum.chat],
      ),
    ]) {
      if (!_isWide.value && !item.onHomePage.contains(this)) {
        continue;
      }
      items.insert(
          0,
          IconButton(
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

final class _MoreAction {
  final String title;
  final IconData icon;
  final void Function() onTap;
  final List<HomePageEnum> onHomePage;

  _MoreAction({
    required this.title,
    required this.icon,
    required this.onTap,
    this.onHomePage = const [],
  });
}
