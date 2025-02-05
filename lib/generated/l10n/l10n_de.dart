import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get apiUrlV1Tip => 'Ähnlich wie https://api.openai.com/v1 (mit dem abschließenden /v1). Soll diese URL weiterhin verwendet werden?';

  @override
  String get assistant => 'Assistent';

  @override
  String get attention => 'Achtung';

  @override
  String get audio => 'Audio';

  @override
  String get auto => 'Automatisch';

  @override
  String get autoCheckUpdate => 'Automatisch nach Updates suchen';

  @override
  String get autoRmDupChat => 'Doppelte Chats automatisch entfernen';

  @override
  String get autoScrollBottom => 'Automatisch nach unten scrollen';

  @override
  String get backupTip => 'Bitte stellen Sie sicher, dass Ihre Sicherungsdatei privat und sicher ist!';

  @override
  String get balance => 'Guthaben';

  @override
  String get calcTokenLen => 'Token-Länge berechnen';

  @override
  String get changeModelTip => 'Verschiedene Schlüssel können möglicherweise auf unterschiedliche Modelllisten zugreifen. Wenn Sie den Mechanismus nicht verstehen und Fehler auftreten, empfiehlt es sich, das Modell neu einzustellen.';

  @override
  String get chat => 'Chat';

  @override
  String get chatHistoryLength => 'Länge des Chat-Verlaufs';

  @override
  String get chatHistoryTip => 'Wird als Chat-Kontext verwendet';

  @override
  String get clickSwitch => 'Zum Umschalten klicken';

  @override
  String get clickToCheck => 'Zum Überprüfen klicken';

  @override
  String get clipboard => 'Zwischenablage';

  @override
  String get codeBlock => 'Codeblock';

  @override
  String get colorSeedTip => 'Dies ist ein Farbsamen, keine Farbe';

  @override
  String get compress => 'Komprimieren';

  @override
  String get compressImgTip => 'Für Chat und Teilen';

  @override
  String get contributor => 'Mitwirkender';

  @override
  String get copied => 'Kopiert';

  @override
  String get current => 'Aktuell';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get day => 'Tag';

  @override
  String get defaulT => 'Standard';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) löschen?';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get deleteConfirm => 'Vor dem Löschen bestätigen';

  @override
  String get editor => 'Editor';

  @override
  String emptyFields(Object fields) {
    return '$fields sind leer';
  }

  @override
  String get emptyTrash => 'Papierkorb leeren';

  @override
  String fileNotFound(Object file) {
    return 'Datei ($file) nicht gefunden';
  }

  @override
  String fileTooLarge(Object size) {
    return 'Datei zu groß: $size';
  }

  @override
  String get followChatModel => 'Chat-Modell folgen';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get fontSizeSettingTip => 'Gilt nur für Codeblöcke';

  @override
  String get freeCopy => 'Freies Kopieren';

  @override
  String get genChatTitle => 'Chat-Titel generieren';

  @override
  String get genTitle => 'Titel generieren';

  @override
  String get headTailMode => 'Kopf-Schwanz-Modus';

  @override
  String get headTailModeTip => 'Sendet nur `Prompt + erste Benutzernachricht + aktuelle Eingabe` als Kontext.\n\nDies ist besonders nützlich für die Übersetzung von Gesprächen (spart Tokens).';

  @override
  String get help => 'Hilfe';

  @override
  String get history => 'Verlauf';

  @override
  String historyToolHelp(Object keywords) {
    return 'Chats mit den Schlüsselwörtern $keywords als Kontext laden?';
  }

  @override
  String get historyToolTip => 'Lade historische Chats als Kontext';

  @override
  String get hour => 'Stunde';

  @override
  String get httpToolTip => 'HTTP-Anfrage senden, z.B.: Inhalte suchen';

  @override
  String get ignoreContextConstraint => 'Kontextbeschränkung ignorieren';

  @override
  String get ignoreTip => 'Hinweis ignorieren';

  @override
  String get image => 'Bild';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Tipps\n- Übermäßiges Scrollen (Overscroll) im Chat-Bildschirm ermöglicht schnelles Wechseln zwischen Chat-Verläufen\n- Langes Drücken auf Chat-Text ermöglicht freies Auswählen und Kopieren der Markdown-Quelle\n- Die Verwendung des URL-Schemas finden Sie [hier]($unilink)\n\n### 🔍 Hilfe\n- Wenn GPT Box Bugs hat, verwenden Sie bitte [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

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
  String get migrationV1UrlTip => 'Soll \"/v1\" automatisch am Ende der Konfiguration hinzugefügt werden?';

  @override
  String get minute => 'Minute';

  @override
  String get model => 'Modell';

  @override
  String get modelRegExpTip => 'Wenn der Modellname übereinstimmt, werden Tools verwendet';

  @override
  String get more => 'Mehr';

  @override
  String get multiModel => 'Multimodal';

  @override
  String get myOtherApps => 'Meine anderen Apps';

  @override
  String get needOpenAIKey => 'Bitte geben Sie zuerst den OpenAI-Schlüssel ein';

  @override
  String get needRestart => 'Neustart erforderlich, um Änderungen anzuwenden';

  @override
  String get newChat => 'Neuer Chat';

  @override
  String get noDuplication => 'Keine Duplikate';

  @override
  String notSupported(Object val) {
    return '$val wird nicht unterstützt';
  }

  @override
  String get onMsgCome => 'Wenn neue Nachrichten vorhanden sind';

  @override
  String get onSwitchChat => 'Beim Wechseln der Konversation';

  @override
  String get onlyRestoreHistory => 'Nur Chat-Verlauf wiederherstellen (API-URL und geheimer Schlüssel werden nicht wiederhergestellt)';

  @override
  String get onlySyncOnLaunch => 'Nur beim Start synchronisieren';

  @override
  String get other => 'Andere';

  @override
  String get participant => 'Teilnehmer';

  @override
  String get passwd => 'Passwort';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacyTip => 'Diese App sammelt keine Informationen.';

  @override
  String get profile => 'Profil';

  @override
  String get promptsSettingsItem => 'Prompts';

  @override
  String get quickShareTip => 'Öffnen Sie diesen Link auf einem anderen Gerät, um die aktuelle Konfiguration schnell zu importieren.';

  @override
  String get raw => 'Roh';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get regExp => 'Regulärer Ausdruck';

  @override
  String get remember30s => '30 Sekunden merken';

  @override
  String get rename => 'Umbenennen';

  @override
  String get replay => 'Wiederholen';

  @override
  String get replayTip => 'Die wiederholten Nachrichten und alle folgenden Nachrichten werden gelöscht.';

  @override
  String get res => 'Ressource';

  @override
  String restoreOpenaiTip(Object url) {
    return 'Die Dokumentation finden Sie [hier]($url)';
  }

  @override
  String get rmDuplication => 'Duplikate entfernen';

  @override
  String rmDuplicationFmt(Object count) {
    return 'Sind Sie sicher, dass Sie [$count] doppelte Elemente löschen möchten?';
  }

  @override
  String get route => 'Route';

  @override
  String get save => 'Speichern';

  @override
  String get saveErrChat => 'Fehlerhaften Chat speichern';

  @override
  String get saveErrChatTip => 'Speichern Sie nach dem Empfangen/Senden jeder Nachricht, auch wenn Fehler auftreten';

  @override
  String get scrollSwitchChat => 'Scrollen zum Wechseln des Chats';

  @override
  String get search => 'Suche';

  @override
  String get secretKey => 'Geheimer Schlüssel';

  @override
  String get share => 'Teilen';

  @override
  String get shareFrom => 'Geteilt von';

  @override
  String get skipSameTitle => 'Chats mit demselben Titel wie lokale Chats überspringen';

  @override
  String get softWrap => 'Zeilenumbruch';

  @override
  String get stt => 'Sprache zu Text';

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
  String get system => 'System';

  @override
  String get text => 'Text';

  @override
  String get themeColorSeed => 'Farbsamen für das Theme';

  @override
  String get themeMode => 'Theme-Modus';

  @override
  String get thirdParty => 'Drittanbieter';

  @override
  String get tool => 'Werkzeug';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Stimmen Sie der Verwendung des Werkzeugs $tool zu?';
  }

  @override
  String get toolFinishTip => 'Werkzeugaufruf abgeschlossen';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Es werden Daten aus dem Netzwerk abgerufen, diesmal wird $host kontaktiert';
  }

  @override
  String get toolHttpReqName => 'HTTP-Anfrage';

  @override
  String get tts => 'Text zu Sprache';

  @override
  String get unsupported => 'Nicht unterstützt';

  @override
  String get untitled => 'Unbenannt';

  @override
  String get update => 'Aktualisieren';

  @override
  String get usage => 'Verwendung';

  @override
  String get user => 'Benutzer';

  @override
  String weeksAgo(Object weeks) {
    return 'Vor $weeks Wochen';
  }

  @override
  String get wrap => 'Umbruch';
}
