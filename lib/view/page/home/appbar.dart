part of 'home.dart';

final class _CustomAppBar extends CustomAppBar {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    final title = _appbarTitleVN.listenVal(
      (val) {
        return AnimatedSwitcher(
          duration: _durationMedium,
          switchInCurve: Easing.standardDecelerate,
          switchOutCurve: Easing.standardDecelerate,
          transitionBuilder: (child, animation) => SlideTransitionX(
            position: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          // Use a SizedBox to avoid the title jumping when switching chats.
          child: SizedBox(
            width: context.windowSize.width * 0.5,
            child: Text(
              val ?? l10n.untitled,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: UIs.text15,
            ),
          ),
        );
      },
    );

    final subtitle = Cfg.vn.listen(() {
      return Cfg.chatType.listenVal((typ) {
        final model = typ.model ?? '';
        return Text(
          model.isEmpty ? libL10n.empty : model,
          key: ValueKey(model),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: UIs.text12Grey,
        );
      });
    });

    return CustomAppBar(
      centerTitle: false,
      leading: Btn.icon(
        icon: const Icon(Icons.settings),
        onTap: () => _onTapSettings(context),
      ),
      title: GestureDetector(
        onLongPress: () => DebugPage.route.go(context),
        onTap: () => _onSwitchModel(context, notifyKey: true),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(
              width: context.windowSize.width * 0.5,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  subtitle,
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: _curPage,
          builder: (_, page, _) => page.buildAppbarActions(context),
        )
      ],
    );
  }
}
