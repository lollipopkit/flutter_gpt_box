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
  String get autoScrollBottom => 'Automatisch nach unten scrollen';

  @override
  String get backupTip =>
      'Bitte stellen Sie sicher, dass Ihre Sicherungsdatei privat und sicher ist!';

  @override
  String get calcTokenLen => 'Token-Länge berechnen';

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
  String get emptyTrash => 'Papierkorb leeren';

  @override
  String get emptyTrashTip =>
      '==0, beim nächsten Start löschen. <0 nicht automatisch löschen.';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get fontSizeSettingTip => 'Gilt nur für Codeblöcke';

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
  String get list => 'Liste';

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
  String get onMsgCome => 'Wenn neue Nachrichten vorhanden sind';

  @override
  String get onSwitchChat => 'Beim Wechseln der Konversation';

  @override
  String get passwd => 'Passwort';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacyTip => 'Diese App sammelt keine Informationen.';

  @override
  String get rename => 'Umbenennen';

  @override
  String get replay => 'Wiederholen';

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
  String get switcher => 'Schalter';

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
  String toolConfirmFmt(Object tool) {
    return 'Stimmen Sie der Verwendung des Werkzeugs $tool zu?';
  }

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
    return '$n Modelle';
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
}
