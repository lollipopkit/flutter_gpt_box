part of 'home.dart';

abstract final class AppLink {
  static const scheme = 'lk-gptbox';

  /// example: lk-gptbox://HOST/ACTION?PARAM=PARAM_VALUE
  static bool? handle(BuildContext context, Uri uri) {
    if (uri.scheme != scheme && !isWeb) {
      return false;
    }

    final path = uri.path;
    final params = uri.queryParameters;

    switch (path) {
      case '/new':
        final msg = params['msg'];
        final send = params['send'];
        final chat = _newChat();
        _switchChat(chat.id);
        if (msg != null) {
          _inputCtrl.text = msg;
          if (send == 'true') _onCreateChat(chat.id, context);
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
            _onShareChat(context);
            return true;
          }
        }
        _onShareChat(context);
        return true;
      case '/go':
        final page = params['page'];
        if (page != null) {
          switch (page) {
            case 'setting':
              Routes.setting.go(context);
              return true;
            case 'backup':
              Routes.backup.go(context);
              return true;
            case 'about':
              Routes.about.go(context);
              return true;
            case 'res':
              Routes.res.go(context);
              return true;
            default:
              final msg = l10n.invalidLinkFmt(page);
              context.showSnackBar(msg);
              Loggers.app.warning(msg);
              return true;
          }
        }
        final msg = l10n.invalidLinkFmt('${l10n.empty} page');
        context.showSnackBar(msg);
        Loggers.app.warning(msg);
        return true;
      case '/set':
        final openAiUrl = params['openAiUrl'];
        final openAiKey = params['openAiKey'];
        final openAiModel = params['openAiModel'];
        if (openAiKey == null && openAiUrl == null && openAiModel == null) {
          final msg = l10n.invalidLinkFmt('${l10n.empty} config');
          context.showSnackBar(msg);
          Loggers.app.warning(msg);
          return true;
        }
        OpenAICfg.current = OpenAICfg.current.copyWith(
          url: openAiUrl,
          key: openAiKey,
          model: openAiModel,
        );
        return true;
      default:
        if (isWeb && path == '/') return true;
        final msg = l10n.invalidLinkFmt(path);
        context.showSnackBar(msg);
        Loggers.app.warning(msg);
        return false;
    }
  }
}
