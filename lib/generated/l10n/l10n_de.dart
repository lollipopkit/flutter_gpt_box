// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get attention => 'Achtung';

  @override
  String get auto => 'Automatisch';

  @override
  String get autoCheckUpdate => 'Automatisch nach Updates suchen';

  @override
  String get backupTip =>
      'Bitte stellen Sie sicher, dass Ihre Sicherungsdatei privat und sicher ist!';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Zum Überprüfen klicken';

  @override
  String get codeBlock => 'Codeblock';

  @override
  String get copied => 'Kopiert';

  @override
  String get current => 'Aktuell';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) löschen?';
  }

  @override
  String get deleteConfirm => 'Vor dem Löschen bestätigen';

  @override
  String emptyFields(Object fields) {
    return '$fields sind leer';
  }

  @override
  String get emptyTrashTip =>
      '==0, beim nächsten Start löschen. <0 nicht automatisch löschen.';

  @override
  String get genChatTitle => 'Chat-Titel generieren';

  @override
  String get history => 'Verlauf';

  @override
  String historyToolHelp(Object keywords) {
    return 'Chats mit den Schlüsselwörtern $keywords als Kontext laden?';
  }

  @override
  String get historyToolTip => 'Lade historische Chats als Kontext';

  @override
  String get httpToolTip => 'HTTP-Anfrage senden, z.B.: Inhalte suchen';

  @override
  String get image => 'Bild';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Unbekannter Link: $uri';
  }

  @override
  String get joinBeta => 'An Beta-Tests teilnehmen';

  @override
  String get languageName => 'Deutsch';

  @override
  String get license => 'Lizenz';

  @override
  String get licenseMenuItem => 'Open-Source-Lizenzen';

  @override
  String get manual => 'Manuell';

  @override
  String get memory => 'Gedächtnis';

  @override
  String memoryAdded(Object str) {
    return 'Gedächtnis hinzugefügt: $str';
  }

  @override
  String memoryTip(Object txt) {
    return '[$txt] merken?';
  }

  @override
  String get message => 'Nachricht';

  @override
  String get model => 'Modell';

  @override
  String get more => 'Mehr';

  @override
  String get myOtherApps => 'Meine anderen Apps';

  @override
  String get newChat => 'Neuer Chat';

  @override
  String get passwd => 'Passwort';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacyTip => 'Diese App sammelt keine Informationen.';

  @override
  String get rename => 'Umbenennen';

  @override
  String get share => 'Teilen';

  @override
  String get shareFrom => 'Geteilt von';

  @override
  String get softWrap => 'Zeilenumbruch';

  @override
  String sureRestoreFmt(Object time) {
    return 'Sind Sie sicher, dass Sie die Sicherung ($time) wiederherstellen möchten?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Konflikt: $a und $b können nicht gleichzeitig aktiviert werden';
  }

  @override
  String get text => 'Text';

  @override
  String get themeColorSeed => 'Farbsamen für das Theme';

  @override
  String get themeMode => 'Theme-Modus';

  @override
  String get tool => 'Werkzeug';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Es werden Daten aus dem Netzwerk abgerufen, diesmal wird $host kontaktiert';
  }

  @override
  String get toolHttpReqName => 'HTTP-Anfrage';

  @override
  String get untitled => 'Unbenannt';

  @override
  String get usage => 'Verwendung';

  @override
  String get user => 'Benutzer';

  @override
  String get deny => 'Ablehnen';

  @override
  String get allow => 'Erlauben';

  @override
  String get allowAlways => 'Immer erlauben';

  @override
  String get trash => 'Papierkorb';

  @override
  String get startChatTip => 'Wähle unten ein Modell und schreib etwas.';

  @override
  String get camera => 'Kamera';

  @override
  String get send => 'Senden';

  @override
  String get noProviderKey =>
      'Noch kein Anbieter hat einen Schlüssel. Füge einen hinzu, um zu chatten.';

  @override
  String get providers => 'Anbieter';

  @override
  String get regenerate => 'Neu generieren';

  @override
  String get compacted => 'Frühere Nachrichten wurden zusammengefasst';

  @override
  String get favorite => 'Favoriten';

  @override
  String get defaultModel => 'Standardmodell';

  @override
  String get titleModel => 'Modell für Titel';

  @override
  String get systemPrompt => 'Systemprompt';

  @override
  String get compaction => 'Lange Chats komprimieren';

  @override
  String get compactionTip =>
      'Passt ein Chat nicht mehr in den Kontext des Modells, werden frühere Nachrichten für das Modell zusammengefasst. Du siehst weiterhin alle.';

  @override
  String get customProvider => 'Eigener Anbieter';

  @override
  String get refreshModels => 'Modelle aktualisieren';

  @override
  String get modelsListedTip =>
      'Optional: Die /models-Liste des Endpunkts wird abgerufen. Ergänze IDs, die dort fehlen.';

  @override
  String get modelsRequired =>
      'Diese API kann ihre Modelle nicht auflisten: Gib mindestens eine Modell-ID ein.';

  @override
  String modelsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Modelle',
      one: '1 Modell',
    );
    return '$_temp0';
  }

  @override
  String get sameAsChat => 'Wie im Chat';

  @override
  String get keyInKeychain =>
      'Im Schlüsselbund des Systems gespeichert, nie in Backups.';

  @override
  String get extraVars => 'Zusätzliche Variablen';

  @override
  String get extraVarsTip =>
      'Eine KEY=VALUE pro Zeile, für Anbieter, die mehr als einen Schlüssel brauchen (Azure-Ressource, Cloudflare-Konto).';

  @override
  String providersCountFmt(int n) {
    return '$n Anbieter';
  }

  @override
  String get today => 'Heute';

  @override
  String get earlier => 'Früher';

  @override
  String get now => 'jetzt';

  @override
  String minutesFmt(int n) {
    return '$n Min.';
  }

  @override
  String hoursFmt(int n) {
    return '$n Std.';
  }

  @override
  String messagesCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Nachrichten',
      one: '1 Nachricht',
    );
    return '$_temp0';
  }

  @override
  String get thought => 'Nachgedacht';

  @override
  String tokensFmt(String n) {
    return '$n Tokens';
  }

  @override
  String allowToolFmt(String tool) {
    return '$tool erlauben?';
  }

  @override
  String get replyWaits => 'Die Antwort wartet auf deine Entscheidung.';

  @override
  String usableModelsFmt(int n, int m) {
    return '$n nutzbar · $m Anbieter';
  }

  @override
  String get searchModels => 'Modelle suchen';

  @override
  String get version => 'Version';

  @override
  String get endpoint => 'Endpunkt';

  @override
  String get key => 'Schlüssel';

  @override
  String get toolsAndMcp => 'Werkzeuge & MCP';

  @override
  String get useTools => 'Werkzeuge verwenden';

  @override
  String get useToolsTip =>
      'Jeder Aufruf fragt zuerst, außer er ist unten erlaubt';

  @override
  String get builtIn => 'Integriert';

  @override
  String get memories => 'Erinnerungen';

  @override
  String entriesFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get allowedWithoutAsking => 'Ohne Nachfrage erlaubt';

  @override
  String get mcpServers => 'MCP-Server';

  @override
  String get addServer => 'Server hinzufügen';

  @override
  String connectedFmt(int n) {
    return 'Verbunden · $n Werkzeuge';
  }

  @override
  String get disconnected => 'Getrennt';

  @override
  String get deleteKey => 'Schlüssel löschen';

  @override
  String moreFmt(int n) {
    return '$n weitere';
  }

  @override
  String get back => 'Zurück';

  @override
  String get allProviders => 'Alle Anbieter';

  @override
  String get searchProviders => 'Anbieter suchen';

  @override
  String get backToChats => 'Zurück zu den Chats';

  @override
  String get genChatTitleTip => 'Benennt einen Chat nach der ersten Antwort';

  @override
  String get scrollOnNewMsg => 'Bei neuer Nachricht nach unten scrollen';

  @override
  String get scrollAfterSwitch => 'Nach Chatwechsel nach unten scrollen';

  @override
  String chatsCountFmt(int n) {
    return '$n Chats';
  }

  @override
  String get emptyTrashAfter => 'Papierkorb leeren nach';

  @override
  String get trashTip => 'Gelöschte Chats landen zuerst hier';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String thoughtForFmt(String time) {
    return '$time nachgedacht';
  }

  @override
  String secondsFmt(String n) {
    return '$n s';
  }

  @override
  String minutesSecondsFmt(int m, int s) {
    return '$m Min. $s s';
  }

  @override
  String get attachment => 'Anhang';

  @override
  String get sync => 'Synchronisierung';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get syncing => 'Wird synchronisiert…';

  @override
  String get neverSynced => 'Noch nicht synchronisiert';

  @override
  String lastSyncFmt(String time) {
    return 'Zuletzt synchronisiert: $time';
  }

  @override
  String get syncOffTip =>
      'Schalte unten iCloud oder WebDAV ein, um automatisch zu synchronisieren.';

  @override
  String get backupPassword => 'Backup-Passwort';

  @override
  String get backupEncrypted => 'Backups werden damit verschlüsselt';

  @override
  String get backupNotEncrypted =>
      'Nicht gesetzt: Datei-Backups sind unverschlüsselt, und die Synchronisierung braucht eines';

  @override
  String get backupEncryptedTip => 'Dieses Backup ist verschlüsselt';

  @override
  String get backupPasswordRequired =>
      'Lege zuerst ein Backup-Passwort fest: synchronisierte Backups sind immer verschlüsselt';

  @override
  String get passwordWrong => 'Falsches Passwort oder beschädigtes Backup';

  @override
  String get backupTooNew =>
      'Dieses Backup stammt aus einer neueren App-Version. Aktualisiere, um es wiederherzustellen.';

  @override
  String get syncAppSettings => 'App-Einstellungen synchronisieren';

  @override
  String get syncAppSettingsTip =>
      'Fenstergröße und Titelleiste bleiben pro Gerät';

  @override
  String get webdavManualTip =>
      'Eine datierte Kopie neben der synchronisierten';

  @override
  String get exportFile => 'In eine Datei exportieren';

  @override
  String get importFile => 'Aus einer Datei wiederherstellen';

  @override
  String get copyBackup => 'In die Zwischenablage kopieren';

  @override
  String get pasteBackup => 'Aus der Zwischenablage wiederherstellen';
}
