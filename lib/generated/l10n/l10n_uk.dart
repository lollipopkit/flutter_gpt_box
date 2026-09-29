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
  String get backupTip =>
      'Будь ласка, зберігайте резервну копію файлу в безпеці та приватності!';

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
  String get emptyTrashTip =>
      '==0, видалити під час наступного запуску. <0 не видаляти автоматично.';

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
  String get manual => 'Вручну';

  @override
  String get memory => 'Пам\'ять';

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
  String get passwd => 'Пароль';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get privacyTip => 'Цей додаток не збирає жодної інформації.';

  @override
  String get rename => 'Перейменувати';

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

  @override
  String providersCountFmt(int n) {
    return 'Провайдерів: $n';
  }

  @override
  String get today => 'Сьогодні';

  @override
  String get earlier => 'Раніше';

  @override
  String get now => 'щойно';

  @override
  String minutesFmt(int n) {
    return '$n хв';
  }

  @override
  String hoursFmt(int n) {
    return '$n год';
  }

  @override
  String messagesCountFmt(int n) {
    return 'Повідомлень: $n';
  }

  @override
  String get thought => 'Роздуми';

  @override
  String tokensFmt(String n) {
    return 'Токенів: $n';
  }

  @override
  String allowToolFmt(String tool) {
    return 'Дозволити $tool?';
  }

  @override
  String get replyWaits => 'Відповідь чекає на ваше рішення.';

  @override
  String usableModelsFmt(int n, int m) {
    return 'Доступно: $n · провайдерів: $m';
  }

  @override
  String get searchModels => 'Пошук моделей';

  @override
  String get version => 'Версія';

  @override
  String get endpoint => 'Ендпоінт';

  @override
  String get key => 'Ключ';

  @override
  String get toolsAndMcp => 'Інструменти та MCP';

  @override
  String get useTools => 'Використовувати інструменти';

  @override
  String get useToolsTip =>
      'Кожен виклик спершу питає, якщо його не дозволено нижче';

  @override
  String get builtIn => 'Вбудовані';

  @override
  String get allowedWithoutAsking => 'Дозволені без запиту';

  @override
  String get mcpServers => 'Сервери MCP';

  @override
  String get addServer => 'Додати сервер';

  @override
  String connectedFmt(int n) {
    return 'Підключено · інструментів: $n';
  }

  @override
  String get disconnected => 'Відключено';

  @override
  String get deleteKey => 'Видалити ключ';

  @override
  String moreFmt(int n) {
    return 'Ще $n';
  }

  @override
  String get back => 'Назад';

  @override
  String get allProviders => 'Усі провайдери';

  @override
  String get searchProviders => 'Пошук провайдерів';

  @override
  String get backToChats => 'Назад до чатів';

  @override
  String get genChatTitleTip => 'Називає чат після першої відповіді';

  @override
  String get scrollOnNewMsg => 'Прокручувати вниз при новому повідомленні';

  @override
  String get scrollAfterSwitch => 'Прокручувати вниз після зміни чату';

  @override
  String chatsCountFmt(int n) {
    return 'Чатів: $n';
  }

  @override
  String get emptyTrashAfter => 'Очищати кошик через';

  @override
  String get trashTip => 'Видалені чати спершу потрапляють сюди';

  @override
  String daysFmt(int n) {
    return 'Днів: $n';
  }

  @override
  String thoughtForFmt(String time) {
    return 'Розмірковував $time';
  }

  @override
  String secondsFmt(String n) {
    return '$n с';
  }

  @override
  String minutesSecondsFmt(int m, int s) {
    return '$m хв $s с';
  }

  @override
  String get attachment => 'Вкладення';

  @override
  String get sync => 'Синхронізація';

  @override
  String get syncNow => 'Синхронізувати зараз';

  @override
  String get syncing => 'Синхронізація…';

  @override
  String get neverSynced => 'Ще не синхронізовано';

  @override
  String lastSyncFmt(String time) {
    return 'Остання синхронізація: $time';
  }

  @override
  String get syncOffTip =>
      'Увімкніть iCloud або WebDAV нижче для автоматичної синхронізації.';

  @override
  String get backupPassword => 'Пароль резервної копії';

  @override
  String get backupEncrypted => 'Резервні копії шифруються ним';

  @override
  String get backupNotEncrypted =>
      'Не задано: резервні копії у файл не шифруються, а для синхронізації він потрібен';

  @override
  String get backupEncryptedTip => 'Ця резервна копія зашифрована';

  @override
  String get backupPasswordRequired =>
      'Спершу задайте пароль: синхронізовані копії завжди шифруються';

  @override
  String get passwordWrong => 'Неправильний пароль або копія пошкоджена';

  @override
  String get backupTooNew =>
      'Ця копія з новішої версії застосунку. Оновіть застосунок, щоб відновити її.';

  @override
  String get syncAppSettings => 'Синхронізувати налаштування';

  @override
  String get syncAppSettingsTip =>
      'Розмір вікна й заголовок лишаються окремими для кожного пристрою';

  @override
  String get webdavManualTip => 'Датована копія поруч із синхронізованою';

  @override
  String get exportFile => 'Експорт у файл';

  @override
  String get importFile => 'Відновити з файлу';

  @override
  String get copyBackup => 'Скопіювати в буфер обміну';

  @override
  String get pasteBackup => 'Відновити з буфера обміну';

  @override
  String get memoryView => 'Прочитати пам\'ять';

  @override
  String get memorySearch => 'Пошук у пам\'яті';

  @override
  String get memoryWrite => 'Зберегти в пам\'ять';

  @override
  String get memoryEdit => 'Змінити пам\'ять';

  @override
  String get memoryDelete => 'Видалити з пам\'яті';

  @override
  String get memoryMove => 'Перемістити в пам\'яті';

  @override
  String get memoryToolTip =>
      'Файли, які модель зберігає між чатами; читає й пише їх без запиту';

  @override
  String charsFmt(int n) {
    return 'Символів: $n';
  }

  @override
  String alreadyExists(String path) {
    return '$path вже існує';
  }

  @override
  String get unsavedChanges => 'Зберегти зміни перед виходом?';

  @override
  String get discard => 'Скасувати зміни';
}
