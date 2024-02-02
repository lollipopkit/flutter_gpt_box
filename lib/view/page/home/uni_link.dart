part of 'home.dart';

abstract final class AppLink {
  static const scheme = 'lk-gptbox';

  static final List<AppLinkHost> hosts = <AppLinkHost>[
    AppLinkHostChat._(),
    AppLinkHostConfig._(),
  ];

  /// example: lk-gptbox://chat/ACTION?PARAM=PARAM_VALUE
  static bool? handle(BuildContext context, Uri uri) {
    if (uri.scheme != scheme) {
      return false;
    }
    final handlers = hosts.where((e) => e.host == uri.host);
    if (handlers.isEmpty) {
      return null;
    }
    for (final handler in handlers) {
      if (handler.handler(context, uri.path, uri.queryParameters)) {
        return true;
      }
    }
    return false;
  }
}

abstract final class AppLinkHost {
  String get host => throw UnimplementedError();

  /// Return [true] to block other handlers, [false] to fallback to next handler
  bool handler(BuildContext context, String path, Map<String, String> params) {
    return false;
  }
}

final class AppLinkHostChat extends AppLinkHost {
  AppLinkHostChat._();

  @override
  String get host => 'chat';

  @override
  bool handler(BuildContext context, String path, Map<String, String> params) {
    switch (path) {
      case '/new':
        final msg = params['msg'];
        final chat = _newChat();
        _switchChat(chat.id);
        if (msg != null) {
          _inputCtrl.text = msg;
          _onSend(chat.id, context);
        }
        return true;
      case '/open':
        final chatId = params['chatId'];
        if (chatId != null) {
          _switchChat(chatId);
          return true;
        }
        final msg = l10n.invalidLinkFmt('${l10n.empty} chatId');
        context.showSnackBar(msg);
        Loggers.app.warning(msg);
        return true;
      case '/search':
        final query = params['keyword'];
        showSearch(
            context: context, delegate: ChatSearchDelegate(initKeyword: query));
        return true;
      case '/share':
        final chatId = params['chatId'];
        if (chatId != null) {
          final chat = _allHistories[chatId];
          if (chat != null) {
            _switchChat(chat.id);
            _onShareChat(context);
            return true;
          }
        }
        final msg = l10n.invalidLinkFmt('${l10n.empty} chatId');
        context.showSnackBar(msg);
        Loggers.app.warning(msg);
        return true;
      default:
        final msg = l10n.invalidLinkFmt(path);
        context.showSnackBar(msg);
        Loggers.app.warning(msg);
        return false;
    }
  }
}

final class AppLinkHostConfig extends AppLinkHost {
  AppLinkHostConfig._();

  @override
  String get host => 'config';

  @override
  bool handler(BuildContext context, String path, Map<String, String> params) {
    switch (path) {
      case '/open':
        Routes.setting.go(context);
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
        final chatId = params['chatId'];
        if (chatId != null) {
          final chat = _allHistories[chatId];
          if (chat == null) {
            final msg = l10n.invalidLinkFmt('no chatId($chatId)');
            context.showSnackBar(msg);
            Loggers.app.warning(msg);
            return true;
          }
          var cfg = chat.config;
          if (cfg != null) {
            if (openAiKey != null) {
              cfg = cfg.copyWith(key: openAiKey);
            }
            if (openAiUrl != null) {
              cfg = cfg.copyWith(url: openAiUrl);
            }
            if (openAiModel != null) {
              cfg = cfg.copyWith(model: openAiModel);
            }
            chat.config = cfg;
            _storeChat(chatId, context);
          }
        } else {
          if (openAiKey != null) {
            Stores.setting.openaiApiKey.put(openAiKey);
            OpenAICfg.key = openAiKey;
          }
          if (openAiUrl != null) {
            Stores.setting.openaiApiUrl.put(openAiUrl);
            OpenAICfg.url = openAiUrl;
          }
          if (openAiModel != null) {
            Stores.setting.openaiModel.put(openAiModel);
          }
        }
        return true;
      default:
        final msg = l10n.invalidLinkFmt(path);
        context.showSnackBar(msg);
        Loggers.app.warning(msg);
        return false;
    }
  }
}
