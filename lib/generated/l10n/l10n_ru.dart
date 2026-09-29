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
}
