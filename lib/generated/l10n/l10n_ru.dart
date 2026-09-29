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
  String get backupTip =>
      'Пожалуйста, убедитесь, что ваш файл резервной копии является приватным и безопасным!';

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
  String get emptyTrashTip =>
      '==0, удалить при следующем запуске. <0 не удалять автоматически.';

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
  String get passwd => 'Пароль';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacyTip => 'Это приложение не собирает никакой информации.';

  @override
  String get rename => 'Переименовать';

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
  String get deny => 'Запретить';

  @override
  String get allow => 'Разрешить';

  @override
  String get allowAlways => 'Всегда разрешать';

  @override
  String get trash => 'Корзина';

  @override
  String get startChatTip => 'Выберите модель ниже и напишите что-нибудь.';

  @override
  String get camera => 'Камера';

  @override
  String get send => 'Отправить';

  @override
  String get noProviderKey =>
      'Ни у одного провайдера пока нет ключа. Добавьте ключ, чтобы начать чат.';

  @override
  String get providers => 'Провайдеры';

  @override
  String get regenerate => 'Сгенерировать заново';

  @override
  String get compacted => 'Ранние сообщения были сжаты в резюме';

  @override
  String get favorite => 'Избранное';

  @override
  String get defaultModel => 'Модель по умолчанию';

  @override
  String get titleModel => 'Модель для заголовков';

  @override
  String get systemPrompt => 'Системный промпт';

  @override
  String get compaction => 'Сжимать длинные чаты';

  @override
  String get compactionTip =>
      'Когда чат перестаёт помещаться в контекст модели, ранние сообщения пересказываются для модели. Вы по-прежнему видите их все.';

  @override
  String get customProvider => 'Свой провайдер';

  @override
  String get refreshModels => 'Обновить модели';

  @override
  String get modelsListedTip =>
      'Необязательно: список /models эндпоинта загружается автоматически. Добавьте ID, которых в нём нет.';

  @override
  String get modelsRequired =>
      'Этот API не умеет перечислять модели: укажите хотя бы один ID модели.';

  @override
  String modelsCountFmt(int n) {
    return 'Моделей: $n';
  }

  @override
  String get sameAsChat => 'Как в чате';

  @override
  String get keyInKeychain =>
      'Хранится в системной связке ключей, никогда не попадает в резервные копии.';

  @override
  String get extraVars => 'Дополнительные переменные';

  @override
  String get extraVarsTip =>
      'По одной KEY=VALUE в строке — для провайдеров, которым нужно больше, чем ключ (ресурс Azure, аккаунт Cloudflare).';

  @override
  String providersCountFmt(int n) {
    return 'Провайдеров: $n';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get earlier => 'Ранее';

  @override
  String get now => 'сейчас';

  @override
  String minutesFmt(int n) {
    return '$n мин';
  }

  @override
  String hoursFmt(int n) {
    return '$n ч';
  }

  @override
  String messagesCountFmt(int n) {
    return 'Сообщений: $n';
  }

  @override
  String get thought => 'Размышления';

  @override
  String tokensFmt(String n) {
    return 'Токенов: $n';
  }

  @override
  String allowToolFmt(String tool) {
    return 'Разрешить $tool?';
  }

  @override
  String get replyWaits => 'Ответ ждёт вашего решения.';

  @override
  String usableModelsFmt(int n, int m) {
    return 'Доступно: $n · провайдеров: $m';
  }

  @override
  String get searchModels => 'Поиск моделей';

  @override
  String get version => 'Версия';

  @override
  String get endpoint => 'Эндпоинт';

  @override
  String get key => 'Ключ';

  @override
  String get toolsAndMcp => 'Инструменты и MCP';

  @override
  String get useTools => 'Использовать инструменты';

  @override
  String get useToolsTip =>
      'Каждый вызов сначала спрашивает, если он не разрешён ниже';

  @override
  String get builtIn => 'Встроенные';

  @override
  String get memories => 'Воспоминания';

  @override
  String entriesFmt(int n) {
    return 'Записей: $n';
  }

  @override
  String get allowedWithoutAsking => 'Разрешены без запроса';

  @override
  String get mcpServers => 'Серверы MCP';

  @override
  String get addServer => 'Добавить сервер';

  @override
  String connectedFmt(int n) {
    return 'Подключён · инструментов: $n';
  }

  @override
  String get disconnected => 'Отключён';

  @override
  String get deleteKey => 'Удалить ключ';

  @override
  String moreFmt(int n) {
    return 'Ещё $n';
  }

  @override
  String get back => 'Назад';

  @override
  String get allProviders => 'Все провайдеры';

  @override
  String get searchProviders => 'Поиск провайдеров';

  @override
  String get backToChats => 'Назад к чатам';

  @override
  String get genChatTitleTip => 'Называет чат после первого ответа';

  @override
  String get scrollOnNewMsg => 'Прокручивать вниз при новом сообщении';

  @override
  String get scrollAfterSwitch => 'Прокручивать вниз после смены чата';

  @override
  String chatsCountFmt(int n) {
    return 'Чатов: $n';
  }

  @override
  String get emptyTrashAfter => 'Очищать корзину через';

  @override
  String get trashTip => 'Удалённые чаты сначала попадают сюда';

  @override
  String daysFmt(int n) {
    return 'Дней: $n';
  }

  @override
  String thoughtForFmt(String time) {
    return 'Размышлял $time';
  }

  @override
  String secondsFmt(String n) {
    return '$n с';
  }

  @override
  String minutesSecondsFmt(int m, int s) {
    return '$m мин $s с';
  }

  @override
  String get attachment => 'Вложение';

  @override
  String get sync => 'Синхронизация';

  @override
  String get syncNow => 'Синхронизировать сейчас';

  @override
  String get syncing => 'Синхронизация…';

  @override
  String get neverSynced => 'Ещё не синхронизировано';

  @override
  String lastSyncFmt(String time) {
    return 'Последняя синхронизация: $time';
  }

  @override
  String get syncOffTip =>
      'Включите iCloud или WebDAV ниже для автоматической синхронизации.';

  @override
  String get backupPassword => 'Пароль резервной копии';

  @override
  String get backupEncrypted => 'Резервные копии шифруются им';

  @override
  String get backupNotEncrypted =>
      'Не задан: резервные копии в файл не шифруются, а для синхронизации он нужен';

  @override
  String get backupEncryptedTip => 'Эта резервная копия зашифрована';

  @override
  String get backupPasswordRequired =>
      'Сначала задайте пароль: синхронизируемые копии всегда шифруются';

  @override
  String get passwordWrong => 'Неверный пароль или копия повреждена';

  @override
  String get backupTooNew =>
      'Эта копия из более новой версии приложения. Обновите приложение, чтобы восстановить её.';

  @override
  String get syncAppSettings => 'Синхронизировать настройки';

  @override
  String get syncAppSettingsTip =>
      'Размер окна и заголовок остаются свои на каждом устройстве';

  @override
  String get webdavManualTip => 'Датированная копия рядом с синхронизируемой';

  @override
  String get exportFile => 'Экспорт в файл';

  @override
  String get importFile => 'Восстановить из файла';

  @override
  String get copyBackup => 'Скопировать в буфер обмена';

  @override
  String get pasteBackup => 'Восстановить из буфера обмена';
}
