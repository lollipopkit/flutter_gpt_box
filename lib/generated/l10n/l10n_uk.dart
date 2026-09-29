// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get attention => 'Увага';

  @override
  String get auto => 'Авто';

  @override
  String get autoCheckUpdate => 'Автоматично перевіряти оновлення';

  @override
  String get autoScrollBottom => 'Автоматично прокручувати до низу';

  @override
  String get backupTip =>
      'Будь ласка, зберігайте резервну копію файлу в безпеці та приватності!';

  @override
  String get calcTokenLen => 'Обчислити довжину токенів';

  @override
  String get chat => 'Чат';

  @override
  String get clickToCheck => 'Натисніть для перевірки';

  @override
  String get codeBlock => 'Блок коду';

  @override
  String get copied => 'Скопійовано';

  @override
  String get current => 'Поточний';

  @override
  String delFmt(Object id, Object type) {
    return 'Видалити $type ($id)?';
  }

  @override
  String get deleteConfirm => 'Підтвердити перед видаленням';

  @override
  String emptyFields(Object fields) {
    return '$fields порожні';
  }

  @override
  String get emptyTrash => 'Очистити кошик';

  @override
  String get emptyTrashTip =>
      '==0, видалити під час наступного запуску. <0 не видаляти автоматично.';

  @override
  String get fontSize => 'Розмір шрифту';

  @override
  String get fontSizeSettingTip => 'Діє лише для блоків коду';

  @override
  String get genChatTitle => 'Генерувати заголовок чату';

  @override
  String get history => 'Історія';

  @override
  String historyToolHelp(Object keywords) {
    return 'Завантажити чат, що містить ключові слова $keywords, як контекст?';
  }

  @override
  String get historyToolTip => 'Завантажити історію чату як контекст';

  @override
  String get httpToolTip => 'Зробити HTTP-запит, наприклад: пошук вмісту';

  @override
  String get image => 'Зображення';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Невідоме посилання: $uri';
  }

  @override
  String get joinBeta => 'Приєднатися до бета-тестування';

  @override
  String get languageName => 'Українська';

  @override
  String get license => 'Ліцензія';

  @override
  String get licenseMenuItem => 'Ліцензії відкритого коду';

  @override
  String get list => 'Список';

  @override
  String get manual => 'Вручну';

  @override
  String get memory => 'Пам\'ять';

  @override
  String memoryAdded(Object str) {
    return 'Пам\'ять додано: $str';
  }

  @override
  String memoryTip(Object txt) {
    return 'Запам\'ятати [$txt]?';
  }

  @override
  String get message => 'Повідомлення';

  @override
  String get model => 'Модель';

  @override
  String get more => 'Більше';

  @override
  String get myOtherApps => 'Мої інші додатки';

  @override
  String get newChat => 'Новий чат';

  @override
  String get onMsgCome => 'Коли приходить нове повідомлення';

  @override
  String get onSwitchChat => 'При перемиканні чату';

  @override
  String get passwd => 'Пароль';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get privacyTip => 'Цей додаток не збирає жодної інформації.';

  @override
  String get rename => 'Перейменувати';

  @override
  String get replay => 'Повторити';

  @override
  String get share => 'Поділитися';

  @override
  String get shareFrom => 'Поділитися з';

  @override
  String get softWrap => 'М\'який перенос';

  @override
  String sureRestoreFmt(Object time) {
    return 'Ви впевнені, що хочете відновити резервну копію ($time)?';
  }

  @override
  String get switcher => 'Перемикач';

  @override
  String syncConflict(Object a, Object b) {
    return 'Конфлікт: неможливо одночасно увімкнути $a та $b';
  }

  @override
  String get text => 'Текст';

  @override
  String get themeColorSeed => 'Насіння кольору теми';

  @override
  String get themeMode => 'Режим теми';

  @override
  String get tool => 'Інструмент';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Ви згодні використовувати інструмент $tool?';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'Буде отримано дані з мережі, цього разу буде зв\'язок з $host';
  }

  @override
  String get toolHttpReqName => 'HTTP-запит';

  @override
  String get untitled => 'Без назви';

  @override
  String get usage => 'Використання';

  @override
  String get user => 'Користувач';

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
