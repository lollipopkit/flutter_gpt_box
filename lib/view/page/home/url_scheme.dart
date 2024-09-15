part of 'home.dart';

abstract final class AppLink {
  static const host = 'gptbox';

  /// example: lpkt.cn://gptbox/PATH?KEY=VAL
  static bool? handle(Uri uri, [BuildContext? context]) {
    final path = uri.path;
    final params = uri.queryParameters;

    switch (path) {
      case '/new':
        final msg = params['msg'];
        final send = params['send'];
        final chat = _newChat();
        _switchChat(chat.id);
        if (msg != null) {
          //_inputCtrl.text = msg;
          if (send == 'true' && context != null) {
            _onCreateText(context, chat.id, msg, null);
          }
        }
        return true;
      case '/open':
        final chatId = params['chatId'];
        final title = params['title'];
        if (chatId != null) {
          _switchChat(chatId);
          return true;
        }
        if (title != null) {
          final chat = _allHistories.values.toList().firstWhereOrNull(
                (e) => e.name?.contains(title) == true,
              );
          if (chat != null) {
            _switchChat(chat.id);
            return true;
          }
        }
        if (_curPage.value != HomePageEnum.history) {
          _switchPage(HomePageEnum.history);
        }
        return true;
      case '/search':
        if (context == null) return false;
        final query = params['keyword'];
        showSearch(
          context: context,
          delegate: _ChatSearchDelegate(initKeyword: query),
        );
        return true;
      case '/share':
        final chatId = params['chatId'];
        final title = params['title'];
        if (chatId != null) {
          final chat = _allHistories[chatId];
          if (chat != null) {
            _switchChat(chat.id);
            if (context == null) return false;
            _onShareChat(context);
            return true;
          }
        }
        if (title != null) {
          final chat = _allHistories.values.toList().firstWhereOrNull(
                (e) => e.name?.contains(title) == true,
              );
          if (chat != null) {
            _switchChat(chat.id);
            if (context == null) return false;
            _onShareChat(context);
            return true;
          }
        }
        if (context == null) return false;
        _onShareChat(context);
        return true;
      case '/go':
        if (context == null) return false;
        final page = params['page'];
        if (page != null) {
          switch (page) {
            case 'setting':
            case 'res':
            case 'about':
            case 'backup':
              SettingsPage.route.go(context, const SettingsPageArgs());
              return true;
            default:
              final msg = l10n.invalidLinkFmt(page);
              context.showSnackBar(msg);
              Loggers.app.warning(msg);
              return true;
          }
        }
        final msg = l10n.invalidLinkFmt('${libL10n.empty} page');
        context.showSnackBar(msg);
        Loggers.app.warning(msg);
        return true;
      case '/set':
        final openAiUrl = params['openAiUrl'];
        final openAiKey = params['openAiKey'];
        final openAiModel = params['openAiModel'];
        if (openAiKey == null && openAiUrl == null && openAiModel == null) {
          final msg = l10n.invalidLinkFmt('${libL10n.empty} config');
          context?.showSnackBar(msg);
          Loggers.app.warning(msg);
          return true;
        }
        OpenAICfg.setTo(OpenAICfg.current.copyWith(
          url: openAiUrl,
          key: openAiKey,
          model: openAiModel,
        ));
        return true;
      default:
        if (isWeb && path == '/') return true;
        return false;
    }
  }
}
