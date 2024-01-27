part of 'home.dart';

CustomAppBar _buildAppBar(BuildContext context) {
  return CustomAppBar(
    centerTitle: false,
    title: ListenableBuilder(
      listenable: _appbarTitleRN,
      builder: (_, __) {
        final entity = _curChat;
        if (entity == null) return Text(l10n.empty);
        final len = '${entity.items.length} ${l10n.message}';
        final time = entity.items.lastOrNull?.createdAt.toAgo;
        return AnimatedSwitcher(
          duration: Durations.medium1,
          switchInCurve: Easing.standardDecelerate,
          switchOutCurve: Easing.standardDecelerate,
          transitionBuilder: (child, animation) => SlideTransitionX(
            position: animation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
          // Use a SizedBox to avoid the title jumping when switching chats.
          child: SizedBox(
            key: Key(entity.id),
            width: (_media?.size.width ?? 300) * 0.5,
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _curChat?.name ?? l10n.untitled,
                    style: UIs.text13.copyWith(
                        color: UIs.textColor.fromBool(context.isDark)),
                  ),
                  TextSpan(
                    text: '\n$len · ${time ?? l10n.empty}',
                    style: UIs.text11Grey,
                  ),
                ],
              ),
            ),
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
