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
