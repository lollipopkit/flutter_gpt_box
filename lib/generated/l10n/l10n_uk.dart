import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get apiUrlV1Tip => 'Схоже на https://api.openai.com/v1 (потрібен кінцевий /v1). Продовжити використання цього URL?';

  @override
  String get assistant => 'Асистент';

  @override
  String get attention => 'Увага';

  @override
  String get audio => 'Аудіо';

  @override
  String get auto => 'Авто';

  @override
  String get autoCheckUpdate => 'Автоматично перевіряти оновлення';

  @override
  String get autoRmDupChat => 'Автоматично видаляти дублікати чатів';

  @override
  String get autoScrollBottom => 'Автоматично прокручувати до низу';

  @override
  String get backupTip => 'Будь ласка, зберігайте резервну копію файлу в безпеці та приватності!';

  @override
  String get balance => 'Баланс';

  @override
  String get calcTokenLen => 'Обчислити довжину токенів';

  @override
  String get changeModelTip => 'Різні ключі можуть мати доступ до різних списків моделей. Якщо ви не розумієте механізму і виникають помилки, рекомендується переналаштувати модель.';

  @override
  String get chat => 'Чат';

  @override
  String get chatHistoryLength => 'Довжина історії чату';

  @override
  String get chatHistoryTip => 'Використовується як контекст чату';

  @override
  String get clickSwitch => 'Натисніть для перемикання';

  @override
  String get clickToCheck => 'Натисніть для перевірки';

  @override
  String get clipboard => 'Буфер обміну';

  @override
  String get codeBlock => 'Блок коду';

  @override
  String get colorSeedTip => 'Це насіння кольору, а не сам колір';

  @override
  String get compress => 'Стиснути';

  @override
  String get compressImgTip => 'Для чату та поширення';

  @override
  String get contributor => 'Учасник';

  @override
  String get copied => 'Скопійовано';

  @override
  String get current => 'Поточний';

  @override
  String get custom => 'Користувацький';

  @override
  String get day => 'День';

  @override
  String get defaulT => 'За замовчуванням';

  @override
  String delFmt(Object id, Object type) {
    return 'Видалити $type ($id)?';
  }

  @override
  String get delete => 'Видалити';

  @override
  String get deleteConfirm => 'Підтвердити перед видаленням';

  @override
  String get editor => 'Редактор';

  @override
  String emptyFields(Object fields) {
    return '$fields порожні';
  }

  @override
  String fileNotFound(Object file) {
    return 'Файл ($file) не знайдено';
  }

  @override
  String fileTooLarge(Object size) {
    return 'Файл занадто великий: $size';
  }

  @override
  String get followChatModel => 'Слідувати моделі чату';

  @override
  String get fontSize => 'Розмір шрифту';

  @override
  String get fontSizeSettingTip => 'Діє лише для блоків коду';

  @override
  String get freeCopy => 'Вільне копіювання';

  @override
  String get genChatTitle => 'Генерувати заголовок чату';

  @override
  String get genTitle => 'Генерувати заголовок';

  @override
  String get headTailMode => 'Режим голова-хвіст';

  @override
  String get headTailModeTip => 'Надсилає лише підказку + перше повідомлення користувача + поточне введення як контекст.\n\nЦе особливо корисно при перекладі діалогів (може заощадити токени).';

  @override
  String get help => 'Допомога';

  @override
  String get history => 'Історія';

  @override
  String historyToolHelp(Object keywords) {
    return 'Завантажити чат, що містить ключові слова $keywords, як контекст?';
  }

  @override
  String get historyToolTip => 'Завантажити історію чату як контекст';

  @override
  String get hour => 'Година';

  @override
  String get httpToolTip => 'Зробити HTTP-запит, наприклад: пошук вмісту';

  @override
  String get ignoreContextConstraint => 'Ігнорувати обмеження контексту';

  @override
  String get ignoreTip => 'Ігнорувати підказку';

  @override
  String get image => 'Зображення';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Підказка\n- Надмірне прокручування (overscroll) в інтерфейсі чату дозволяє швидко перемикатися між історіями чатів\n- Довге натискання на текст чату дозволяє вільно вибирати та копіювати вихідний Markdown\n- Використання URL Scheme можна знайти тут\n\n### 🔍 Допомога\n- Якщо у GPT Box є помилки, будь ласка, використовуйте Github Issue\n- Telegram @lpktg';
  }

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
  String get migrationV1UrlTip => 'Автоматично додати \"/v1\" у кінці конфігурації?';

  @override
  String get minute => 'Хвилина';

  @override
  String get model => 'Модель';

  @override
  String get modelRegExpTip => 'Якщо назва моделі відповідає, використовувати інструменти';

  @override
  String get more => 'Більше';

  @override
  String get multiModel => 'Мультимодальний';

  @override
  String get myOtherApps => 'Мої інші додатки';

  @override
  String get needOpenAIKey => 'Будь ласка, спочатку введіть ключ OpenAI';

  @override
  String get needRestart => 'Потрібен перезапуск для застосування';

  @override
  String get newChat => 'Новий чат';

  @override
  String get noDuplication => 'Немає дублікатів';

  @override
  String notSupported(Object val) {
    return '$val не підтримується';
  }

  @override
  String get onMsgCome => 'Коли приходить нове повідомлення';

  @override
  String get onSwitchChat => 'При перемиканні чату';

  @override
  String get onlyRestoreHistory => 'Відновити лише історію чатів (без відновлення API Url та Secret Key)';

  @override
  String get onlySyncOnLaunch => 'Синхронізувати лише при запуску';

  @override
  String get other => 'Інше';

  @override
  String get participant => 'Учасник';

  @override
  String get passwd => 'Пароль';

  @override
  String get privacy => 'Конфіденційність';

  @override
  String get privacyTip => 'Цей додаток не збирає жодної інформації.';

  @override
  String get profile => 'Профіль';

  @override
  String get promptsSettingsItem => 'Підказки';

  @override
  String get raw => 'Сирий';

  @override
  String get refresh => 'Оновити';

  @override
  String get regExp => 'Регулярний вираз';

  @override
  String get remember30s => 'Запам\'ятати на 30 секунд';

  @override
  String get rename => 'Перейменувати';

  @override
  String get replay => 'Повторити';

  @override
  String get replayTip => 'Очистить повторені повідомлення та всі наступні';

  @override
  String get res => 'Ресурси';

  @override
  String restoreOpenaiTip(Object url) {
    return 'Документацію можна знайти тут';
  }

  @override
  String get rmDuplication => 'Видалити дублікати';

  @override
  String rmDuplicationFmt(Object count) {
    return 'Ви впевнені, що хочете видалити [$count] дублікатів?';
  }

  @override
  String get route => 'Маршрут';

  @override
  String get save => 'Зберегти';

  @override
  String get saveErrChat => 'Зберегти помилку чату';

  @override
  String get saveErrChatTip => 'Зберігати після отримання/відправлення кожного повідомлення, навіть якщо є помилки';

  @override
  String get scrollSwitchChat => 'Прокручування вгору-вниз для перемикання чатів';

  @override
  String get search => 'Пошук';

  @override
  String get secretKey => 'Секретний ключ';

  @override
  String get share => 'Поділитися';

  @override
  String get shareFrom => 'Поділитися з';

  @override
  String get skipSameTitle => 'Пропустити чати з такими ж заголовками, як у локальних';

  @override
  String get softWrap => 'М\'який перенос';

  @override
  String get stt => 'Мовлення в текст';

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
  String get system => 'Система';

  @override
  String get text => 'Текст';

  @override
  String get themeColorSeed => 'Насіння кольору теми';

  @override
  String get themeMode => 'Режим теми';

  @override
  String get thirdParty => 'Сторонній';

  @override
  String get tool => 'Інструмент';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Ви згодні використовувати інструмент $tool?';
  }

  @override
  String get toolFinishTip => 'Виклик інструменту завершено';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Буде отримано дані з мережі, цього разу буде зв\'язок з $host';
  }

  @override
  String get toolHttpReqName => 'HTTP-запит';

  @override
  String get tts => 'Текст у мовлення';

  @override
  String get unsupported => 'Не підтримується';

  @override
  String get untitled => 'Без назви';

  @override
  String get update => 'Оновити';

  @override
  String get usage => 'Використання';

  @override
  String get user => 'Користувач';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks тижнів тому';
  }

  @override
  String get wrap => 'Перенос';
}
