part of 'home.dart';

final class _CustomAppBar extends CustomAppBar {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    final title = ListenBuilder(
      listenable: _appbarTitleRN,
      builder: () {
        final entity = _curChat;
        if (entity == null) return Text(libL10n.empty);
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
            key: Key(entity.id),
            width: (_size?.width ?? 300) * 0.5,
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

    final subtitle = Cfg.vn.listenVal((val) {
      return Text(
        val.model.isEmpty ? libL10n.empty : val.model,
        key: ValueKey(val),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: UIs.text12Grey,
      );
      // return ValBuilder(
      //   listenable: _chatType,
      //   builder: (type) {
      //     return AnimatedSwitcher(
      //       duration: _durationMedium,
      //       switchInCurve: Easing.standardDecelerate,
      //       switchOutCurve: Easing.standardDecelerate,
      //       transitionBuilder: (child, animation) => SlideTransitionX(
      //         position: animation,
      //         child: FadeTransition(
      //           opacity: animation,
      //           child: child,
      //         ),
      //       ),
      //       // Use a SizedBox to avoid the title jumping when switching chats.
      //       child: Text(
      //         switch (type) {
      //           ChatType.text => val.model,
      //           ChatType.img => val.imgModel,
      //           //ChatType.audio => val.speechModel,
      //         },
      //         key: ValueKey(val),
      //         maxLines: 1,
      //         overflow: TextOverflow.ellipsis,
      //         textAlign: TextAlign.left,
      //         style: UIs.text12Grey,
      //       ),
      //     );
      //   },
      // );
    });

    return CustomAppBar(
      centerTitle: false,
      leading: Btn.icon(
        icon: const Icon(Icons.settings),
        onTap: () async {
          final ret = await SettingsPage.route.go(context);
          if (ret?.restored == true) {
            HomePage.afterRestore();
          }
        },
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
              width: (_size?.width ?? 300) * 0.5,
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

// Future<void> _onLongTapSetting(
//   BuildContext context,
//   HiveStore store,
// ) async {
//   final map = store.box.toJson(includeInternal: false);
//   final keys = map.keys;

//   /// Encode [map] to String with indent `\t`
//   final text = const JsonEncoder.withIndent('  ').convert(map);
//   final result = await PlainEditPage.route.go(
//     context,
//     args: PlainEditPageArgs(
//       initialText: text,
//       title: store.box.name,
//     ),
//   );
//   if (result == null) return;

//   try {
//     final newSettings = json.decode(result) as Map<String, dynamic>;
//     store.box.putAll(newSettings);
//     final newKeys = newSettings.keys;
//     final removedKeys = keys.where((e) => !newKeys.contains(e));
//     for (final key in removedKeys) {
//       Stores.setting.box.delete(key);
//     }
//   } catch (e, s) {
//     context.showErrDialog(e, s);
//   }
// }
