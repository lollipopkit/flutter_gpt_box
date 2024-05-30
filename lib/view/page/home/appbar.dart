part of 'home.dart';

CustomAppBar _buildAppBar(BuildContext context) {
  final title = ListenableBuilder(
    listenable: _appbarTitleRN,
    builder: (_, __) {
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
          key: ValueKey(val),
          val.model,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: UIs.text12Grey,
        ),
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
      onTap: () => _onSwitchModel(context),
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

void _onSwitchModel(BuildContext context) async {
  final cfg = OpenAICfg.current;
  if (cfg.key.isEmpty) {
    context.showRoundDialog(
      title: l10n.attention,
      child: Text(l10n.needOpenAIKey),
      actions: Btns.oks(onTap: context.pop),
    );
    return;
  }
  final models = OpenAICfg.models.value;
  final modelStrs = List<String>.from(models);
  modelStrs.removeWhere((element) => !element.startsWith('gpt'));
  if (modelStrs.isEmpty) {
    modelStrs.addAll(models);
  }

  final model = await context.showPickSingleDialog(
    items: modelStrs,
    initial: cfg.model,
    title: l10n.model,
  );
  if (model == null) return;
  OpenAICfg.setTo(cfg.copyWith(model: model), context);
}
