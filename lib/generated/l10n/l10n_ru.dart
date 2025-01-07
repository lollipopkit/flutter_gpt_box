import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get apiUrlV1Tip => 'Похоже на https://api.openai.com/v1 (требуется конечный /v1). Продолжить использование этого URL?';

  @override
  String get assistant => 'Ассистент';

  @override
  String get attention => 'Внимание';

  @override
  String get audio => 'Аудио';

  @override
  String get auto => 'Авто';

  @override
  String get autoCheckUpdate => 'Автоматически проверять обновления';

  @override
  String get autoRmDupChat => 'Автоматически удалять дублирующиеся чаты';

  @override
  String get autoScrollBottom => 'Автоматическая прокрутка вниз';

  @override
  String get backupTip => 'Пожалуйста, убедитесь, что ваш файл резервной копии является приватным и безопасным!';

  @override
  String get balance => 'Баланс';

  @override
  String get calcTokenLen => 'Рассчитать длину токенов';

  @override
  String get changeModelTip => 'Разные ключи могут иметь доступ к разным спискам моделей. Если вы не понимаете механизм и возникают ошибки, рекомендуется переустановить модель.';

  @override
  String get chat => 'Чат';

  @override
  String get chatHistoryLength => 'Длина истории чата';

  @override
  String get chatHistoryTip => 'Используется как контекст чата';

  @override
  String get clickSwitch => 'Нажмите для переключения';

  @override
  String get clickToCheck => 'Нажмите для проверки';

  @override
  String get clipboard => 'Буфер обмена';

  @override
  String get codeBlock => 'Блок кода';

  @override
  String get colorSeedTip => 'Это семя цвета, а не цвет';

  @override
  String get compress => 'Сжать';

  @override
  String get compressImgTip => 'Для чата и обмена';

  @override
  String get contributor => 'Участник';

  @override
  String get copied => 'Скопировано';

  @override
  String get current => 'Текущий';

  @override
  String get custom => 'Пользовательский';

  @override
  String get day => 'день';

  @override
  String get defaulT => 'По умолчанию';

  @override
  String delFmt(Object id, Object type) {
    return 'Удалить $type ($id)?';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get deleteConfirm => 'Подтвердить перед удалением';

  @override
  String get editor => 'Редактор';

  @override
  String emptyFields(Object fields) {
    return '$fields пусты';
  }

  @override
  String fileNotFound(Object file) {
    return 'Файл ($file) не найден';
  }

  @override
  String fileTooLarge(Object size) {
    return 'Файл слишком большой: $size';
  }

  @override
  String get followChatModel => 'Следовать модели чата';

  @override
  String get fontSize => 'Размер шрифта';

  @override
  String get fontSizeSettingTip => 'Применяется только к блокам кода';

  @override
  String get freeCopy => 'Свободное копирование';

  @override
  String get genChatTitle => 'Сгенерировать заголовок чата';

  @override
  String get genTitle => 'Сгенерировать заголовок';

  @override
  String get headTailMode => 'Режим начало-конец';

  @override
  String get headTailModeTip => 'Отправляет только `подсказку + первое сообщение пользователя + текущий ввод` в качестве контекста.\n\nЭто особенно полезно для перевода разговоров (экономит токены).';

  @override
  String get help => 'Помощь';

  @override
  String get history => 'История';

  @override
  String historyToolHelp(Object keywords) {
    return 'Загрузить чаты, содержащие ключевые слова $keywords, как контекст?';
  }

  @override
  String get historyToolTip => 'Загрузить исторические чаты как контекст';

  @override
  String get hour => 'час';

  @override
  String get httpToolTip => 'Выполнить HTTP-запрос, например: поиск контента';

  @override
  String get ignoreContextConstraint => 'Игнорировать ограничение контекста';

  @override
  String get ignoreTip => 'Игнорировать подсказку';

  @override
  String get image => 'Изображение';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Советы\n- Чрезмерная прокрутка (overscroll) в интерфейсе чата позволяет быстро переключаться между историями чатов\n- Долгое нажатие на текст чата позволяет свободно выбирать и копировать исходный Markdown\n- Использование схемы URL можно найти [здесь]($unilink)\n\n### 🔍 Помощь\n- Если в GPT Box есть ошибки, используйте [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

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
  String get migrationV1UrlTip => 'Следует ли автоматически добавлять \"/v1\" в конец конфигурации?';

  @override
  String get minute => 'минута';

  @override
  String get model => 'Модель';

  @override
  String get modelRegExpTip => 'Если имя модели совпадает, будут использованы инструменты';

  @override
  String get more => 'Больше';

  @override
  String get multiModel => 'Мультимодальный';

  @override
  String get myOtherApps => 'Мои другие приложения';

  @override
  String get needOpenAIKey => 'Пожалуйста, сначала введите ключ OpenAI';

  @override
  String get needRestart => 'Требуется перезапуск для применения';

  @override
  String get newChat => 'Новый чат';

  @override
  String get noDuplication => 'Нет дубликатов';

  @override
  String notSupported(Object val) {
    return '$val не поддерживается';
  }

  @override
  String get onMsgCome => 'Когда есть новые сообщения';

  @override
  String get onSwitchChat => 'При переключении разговора';

  @override
  String get onlyRestoreHistory => 'Восстановить только историю чатов (не восстанавливать URL API и секретный ключ)';

  @override
  String get onlySyncOnLaunch => 'Синхронизировать только при запуске';

  @override
  String get other => 'Другое';

  @override
  String get participant => 'Участник';

  @override
  String get passwd => 'Пароль';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacyTip => 'Это приложение не собирает никакой информации.';

  @override
  String get profile => 'Профиль';

  @override
  String get promptsSettingsItem => 'Подсказки';

  @override
  String get raw => 'Необработанный';

  @override
  String get refresh => 'Обновить';

  @override
  String get regExp => 'Регулярное выражение';

  @override
  String get remember30s => 'Запомнить на 30 секунд';

  @override
  String get rename => 'Переименовать';

  @override
  String get replay => 'Повтор';

  @override
  String get replayTip => 'Воспроизведенные сообщения и все последующие сообщения будут удалены.';

  @override
  String get res => 'Ресурс';

  @override
  String restoreOpenaiTip(Object url) {
    return 'Документацию можно найти [здесь]($url)';
  }

  @override
  String get rmDuplication => 'Удалить дубликаты';

  @override
  String rmDuplicationFmt(Object count) {
    return 'Вы уверены, что хотите удалить [$count] дублирующихся элементов?';
  }

  @override
  String get route => 'Маршрут';

  @override
  String get save => 'Сохранить';

  @override
  String get saveErrChat => 'Сохранить чат с ошибкой';

  @override
  String get saveErrChatTip => 'Сохранять после получения/отправки каждого сообщения, даже если есть ошибки';

  @override
  String get scrollSwitchChat => 'Прокрутка для переключения чата';

  @override
  String get search => 'Поиск';

  @override
  String get secretKey => 'Секретный ключ';

  @override
  String get share => 'Поделиться';

  @override
  String get shareFrom => 'Поделился';

  @override
  String get skipSameTitle => 'Пропустить чаты с тем же заголовком, что и у локальных чатов';

  @override
  String get softWrap => 'Мягкий перенос';

  @override
  String get stt => 'Речь в текст';

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
  String get system => 'Система';

  @override
  String get text => 'Текст';

  @override
  String get themeColorSeed => 'Семя цвета темы';

  @override
  String get themeMode => 'Режим темы';

  @override
  String get thirdParty => 'Третья сторона';

  @override
  String get tool => 'Инструмент';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Вы согласны использовать инструмент $tool?';
  }

  @override
  String get toolFinishTip => 'Вызов инструмента завершен';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Будут получены данные из сети, на этот раз будет установлен контакт с $host';
  }

  @override
  String get toolHttpReqName => 'HTTP-запрос';

  @override
  String get tts => 'Текст в речь';

  @override
  String get unsupported => 'Не поддерживается';

  @override
  String get untitled => 'Без названия';

  @override
  String get update => 'Обновить';

  @override
  String get usage => 'Использование';

  @override
  String get user => 'Пользователь';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks недель назад';
  }

  @override
  String get wrap => 'Перенос';
}
