part of 'home.dart';

final class _CustomAppBar extends CustomAppBar {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    final title = ListenBuilder(
      listenable: _appbarTitleRN,
      builder: () {
        final entity = _curChat;
        if (entity == null) return Text(l10n.empty);
        return AnimatedSwitcher(
          duration: _durationMedium,
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
            child: Text(
              _curChat?.name ?? l10n.untitled,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: UIs.text15,
            ),
          ),
        );
      },
    );

    final subtitle = ValBuilder(
      listenable: OpenAICfg.vn,
      builder: (val) {
        return ValBuilder(
          listenable: _chatType,
          builder: (type) {
            return AnimatedSwitcher(
              duration: _durationMedium,
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
              child: Text(
                switch (type) {
                  ChatType.text => val.model,
                  ChatType.img => val.imgModel,
                  ChatType.audio => val.speechModel,
                },
                key: ValueKey(val),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: UIs.text12Grey,
              ),
            );
          },
        );
      },
    );

    return CustomAppBar(
      centerTitle: false,
      title: GestureDetector(
        onLongPress: () => Routes.debug.go(
          context,
          args: DebugPageArgs(
            notifier: Pros.debug.widgets,
            onClear: Pros.debug.clear,
            title: 'Logs(${Build.build})',
          ),
        ),
        onTap: () => _onSwitchModel(context, notifyKey: true),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            SizedBox(
              width: (_media?.size.width ?? 300) * 0.5,
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
          builder: (_, page, __) => page.buildAppbarActions(context),
        )
      ],
    );
  }
}
