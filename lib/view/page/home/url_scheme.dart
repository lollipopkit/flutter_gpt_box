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
        // Without a model it cannot be sent: it waits in the composer.
        if (p['send'] == 'true' && Llm.defaultModel != null) {
          final id = Chats.create();
          Chats.current.value = id;
          Chats.send(id, msg).catchError((Object e) {
            Loggers.app.warning('Send from a link', e);
            Toast.show('$e');
          });
        } else {
          if (p['send'] == 'true') Toast.show(l10n.noProviderKey);
          Composer.draft.value = msg;
        }
      case AppLink.openChatPath:
        final id = p['chatId'] ?? _byTitle(p['title'])?.id;
        if (id != null && LlmStores.chat.fetch(id) != null) Chats.current.value = id;
      case AppLink.searchPath:
        _search();
      case AppLink.shareChatPath:
        final id = p['chatId'] ?? Chats.current.value;
        if (id != null && context != null) unawaited(shareChat(context, id));
      case AppLink.goPath:
        if (context == null) return;
        final tab = switch (p['page']) {
          'settings' => SettingsTab.app,
          'providers' => SettingsTab.providers,
          'tools' => SettingsTab.tool,
          'backup' => SettingsTab.bak,
          'about' => SettingsTab.about,
          _ => null,
        };
        if (tab == null) {
          Toast.show(l10n.invalidLinkFmt(p['page'] ?? ''));
        } else {
          _openSettings(tab);
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
    return LlmStores.chat.all().firstWhereOrNull((m) => m.title?.contains(title) ?? false);
  }
}
