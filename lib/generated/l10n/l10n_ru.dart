// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get attention => 'Внимание';

  @override
  String get auto => 'Авто';

  @override
  String get autoCheckUpdate => 'Автоматически проверять обновления';

  @override
  String get autoScrollBottom => 'Автоматическая прокрутка вниз';

  @override
  String get backupTip =>
      'Пожалуйста, убедитесь, что ваш файл резервной копии является приватным и безопасным!';

  @override
  String get calcTokenLen => 'Рассчитать длину токенов';

  @override
  String get chat => 'Чат';

  @override
  String get clickToCheck => 'Нажмите для проверки';

  @override
  String get codeBlock => 'Блок кода';

  @override
  String get copied => 'Скопировано';

  @override
  String get current => 'Текущий';

  @override
  String delFmt(Object id, Object type) {
    return 'Удалить $type ($id)?';
  }

  @override
  String get deleteConfirm => 'Подтвердить перед удалением';

  @override
  String emptyFields(Object fields) {
    return '$fields пусты';
  }

  @override
  String get emptyTrash => 'Очистить корзину';

  @override
  String get emptyTrashTip =>
      '==0, удалить при следующем запуске. <0 не удалять автоматически.';

  @override
  String get fontSize => 'Размер шрифта';

  @override
  String get fontSizeSettingTip => 'Применяется только к блокам кода';

  @override
  String get genChatTitle => 'Сгенерировать заголовок чата';

  @override
  String get history => 'История';

  @override
  String historyToolHelp(Object keywords) {
    return 'Загрузить чаты, содержащие ключевые слова $keywords, как контекст?';
  }

  @override
  String get historyToolTip => 'Загрузить исторические чаты как контекст';

  @override
  String get httpToolTip => 'Выполнить HTTP-запрос, например: поиск контента';

  @override
  String get image => 'Изображение';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Неизвестная ссылка: $uri';
  }

  @override
  String get joinBeta => 'Присоединиться к бета-тестированию';

  @override
  String get languageName => 'Русский';

  @override
  String get license => 'Лицензия';

  @override
  String get licenseMenuItem => 'Лицензии с открытым исходным кодом';

  @override
  String get list => 'Список';

  @override
  String get manual => 'Ручной';

  @override
  String get memory => 'Память';

  @override
  String memoryAdded(Object str) {
    return 'Память добавлена: $str';
  }

  @override
  String memoryTip(Object txt) {
    return 'Запомнить [$txt]?';
  }

  @override
  String get message => 'Сообщение';

  @override
  String get model => 'Модель';

  @override
  String get more => 'Больше';

  @override
  String get myOtherApps => 'Мои другие приложения';

  @override
  String get newChat => 'Новый чат';

  @override
  String get onMsgCome => 'Когда есть новые сообщения';

  @override
  String get onSwitchChat => 'При переключении разговора';

  @override
  String get passwd => 'Пароль';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacyTip => 'Это приложение не собирает никакой информации.';

  @override
  String get rename => 'Переименовать';

  @override
  String get replay => 'Повтор';

  @override
  String get share => 'Поделиться';

  @override
  String get shareFrom => 'Поделился';

  @override
  String get softWrap => 'Мягкий перенос';

  @override
  String sureRestoreFmt(Object time) {
    return 'Вы уверены, что хотите восстановить резервную копию ($time)?';
  }

  @override
  String get switcher => 'Переключатель';

  @override
  String syncConflict(Object a, Object b) {
    return 'Конфликт: невозможно активировать $a и $b одновременно';
  }

  @override
  String get text => 'Текст';

  @override
  String get themeColorSeed => 'Семя цвета темы';

  @override
  String get themeMode => 'Режим темы';

  @override
  String get tool => 'Инструмент';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Вы согласны использовать инструмент $tool?';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'Будут получены данные из сети, на этот раз будет установлен контакт с $host';
  }

  @override
  String get toolHttpReqName => 'HTTP-запрос';

  @override
  String get untitled => 'Без названия';

  @override
  String get usage => 'Использование';

  @override
  String get user => 'Пользователь';

  @override
  String get deny => 'Deny';

  @override
  String get allow => 'Allow';

  @override
  String get allowAlways => 'Always allow';

  @override
  String get trash => 'Trash';

  @override
  String get startChatTip => 'Pick a model below and say something.';

  @override
  String get camera => 'Camera';

  @override
  String get send => 'Send';

  @override
  String get noProviderKey =>
      'No provider has a key yet. Add one to start chatting.';

  @override
  String get providers => 'Providers';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get compacted => 'Earlier messages were summarised';

  @override
  String get favorite => 'Favorites';

  @override
  String get defaultModel => 'Default model';

  @override
  String get titleModel => 'Model for titles';

  @override
  String get systemPrompt => 'System prompt';

  @override
  String get compaction => 'Compact long chats';

  @override
  String get compactionTip =>
      'When a chat no longer fits the model\'s context, earlier messages are summarised for the model. You still see all of them.';

  @override
  String get customProvider => 'Custom provider';

  @override
  String get refreshModels => 'Refresh models';

  @override
  String providerLinkFmt(String name, String url) {
    return 'Add the provider \"$name\" at $url? Its key is not in the link; you enter it yourself.';
  }

  @override
  String get modelsListedTip =>
      'Optional: the endpoint\'s /models list is fetched. Add ids it does not list.';

  @override
  String get modelsRequired =>
      'This API cannot list its models: enter at least one model id.';

  @override
  String modelsCountFmt(int n) {
    return '$n models';
  }

  @override
  String get sameAsChat => 'Same as the chat';

  @override
  String get keyInKeychain =>
      'Stored in the system keychain, never in backups.';

  @override
  String get extraVars => 'Extra variables';

  @override
  String get extraVarsTip =>
      'KEY=VALUE per line, for providers that need more than a key (Azure resource, Cloudflare account).';
}
