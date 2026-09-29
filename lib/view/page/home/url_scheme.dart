part of 'home.dart';

/// Handles `lollipopkit.com://gptbox/...`. See [AppLink] for the paths.
extension on _HomePageState {
  void _handleLink(Uri uri, [BuildContext? context]) {
    if (uri.host != AppLink.host) return;
    final p = uri.queryParameters;
    switch (uri.path) {
      case AppLink.newChatPath:
        Chats.current.value = null;
        final msg = p['msg'];
        if (msg == null) return;
        if (p['send'] == 'true') {
          final id = Chats.create();
          Chats.current.value = id;
          unawaited(Chats.send(id, msg));
        } else {
          Composer.draft.value = msg;
        }
      case AppLink.openChatPath:
        final id = p['chatId'] ?? _byTitle(p['title'])?.id;
        if (id != null && Stores.chat.fetch(id) != null) Chats.current.value = id;
      case AppLink.searchPath:
        _search();
      case AppLink.shareChatPath:
        final id = p['chatId'] ?? Chats.current.value;
        if (id != null && context != null) unawaited(shareChat(context, id));
      case AppLink.goPath:
        if (context == null) return;
        switch (p['page']) {
          case 'providers':
            ProvidersPage.route.go(context);
          case 'settings' || 'tools' || 'backup' || 'about':
            SettingsPage.route.go(context);
          default:
            Toast.show(l10n.invalidLinkFmt(p['page'] ?? ''));
        }
      case AppLink.providerPath:
        if (context == null) return;
        unawaited(ProvidersPage.addFromLink(context, p));
      default:
        Loggers.app.warning(l10n.invalidLinkFmt(uri.toString()));
    }
  }

  ChatMeta? _byTitle(String? title) {
    if (title == null) return null;
    return Stores.chat.all().firstWhereOrNull((m) => m.title?.contains(title) ?? false);
  }
}
