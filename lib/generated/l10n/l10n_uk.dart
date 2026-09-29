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
  String get deny => 'Заборонити';

  @override
  String get allow => 'Дозволити';

  @override
  String get allowAlways => 'Завжди дозволяти';

  @override
  String get trash => 'Кошик';

  @override
  String get startChatTip => 'Виберіть модель нижче й напишіть щось.';

  @override
  String get camera => 'Камера';

  @override
  String get send => 'Надіслати';

  @override
  String get noProviderKey =>
      'Жоден провайдер ще не має ключа. Додайте ключ, щоб почати чат.';

  @override
  String get providers => 'Провайдери';

  @override
  String get regenerate => 'Згенерувати знову';

  @override
  String get compacted => 'Ранні повідомлення стиснуто в підсумок';

  @override
  String get favorite => 'Обране';

  @override
  String get defaultModel => 'Модель за замовчуванням';

  @override
  String get titleModel => 'Модель для заголовків';

  @override
  String get systemPrompt => 'Системний промпт';

  @override
  String get compaction => 'Стискати довгі чати';

  @override
  String get compactionTip =>
      'Коли чат більше не вміщається в контекст моделі, ранні повідомлення підсумовуються для моделі. Ви й далі бачите їх усі.';

  @override
  String get customProvider => 'Власний провайдер';

  @override
  String get refreshModels => 'Оновити моделі';

  @override
  String get modelsListedTip =>
      'Необовʼязково: список /models ендпоінта завантажується автоматично. Додайте ID, яких у ньому немає.';

  @override
  String get modelsRequired =>
      'Цей API не вміє перелічувати моделі: вкажіть щонайменше один ID моделі.';

  @override
  String modelsCountFmt(int n) {
    return 'Моделей: $n';
  }

  @override
  String get sameAsChat => 'Як у чаті';

  @override
  String get keyInKeychain =>
      'Зберігається в системній вʼязці ключів, ніколи не потрапляє в резервні копії.';

  @override
  String get extraVars => 'Додаткові змінні';

  @override
  String get extraVarsTip =>
      'Одна KEY=VALUE на рядок — для провайдерів, яким потрібно більше, ніж ключ (ресурс Azure, акаунт Cloudflare).';
}
