import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get apiUrlV1Tip => 'Vergelijkbaar met https://api.openai.com/v1 (met de laatste /v1 vereist). Doorgaan met het gebruik van deze URL?';

  @override
  String get assistant => 'Assistent';

  @override
  String get attention => 'Opgelet';

  @override
  String get audio => 'Audio';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Automatisch controleren op updates';

  @override
  String get autoRmDupChat => 'Automatisch dubbele chats verwijderen';

  @override
  String get autoScrollBottom => 'Automatisch naar beneden scrollen';

  @override
  String get backupTip => 'Zorg ervoor dat uw back-upbestand privé en veilig is!';

  @override
  String get balance => 'Saldo';

  @override
  String get calcTokenLen => 'Tokenlengte berekenen';

  @override
  String get changeModelTip => 'Verschillende sleutels kunnen toegang hebben tot verschillende modellijsten. Als u het mechanisme niet begrijpt en er fouten optreden, is het raadzaam om het model opnieuw in te stellen.';

  @override
  String get chat => 'Chat';

  @override
  String get chatHistoryLength => 'Lengte chatgeschiedenis';

  @override
  String get chatHistoryTip => 'Gebruikt als chatcontext';

  @override
  String get clickSwitch => 'Klik om te schakelen';

  @override
  String get clickToCheck => 'Klik om te controleren';

  @override
  String get clipboard => 'Klembord';

  @override
  String get codeBlock => 'Codeblok';

  @override
  String get colorSeedTip => 'Dit is een kleurzaad, geen kleur';

  @override
  String get compress => 'Comprimeren';

  @override
  String get compressImgTip => 'Voor chatten en delen';

  @override
  String get contributor => 'Bijdrager';

  @override
  String get copied => 'Gekopieerd';

  @override
  String get current => 'Huidig';

  @override
  String get custom => 'Aangepast';

  @override
  String get day => 'dag';

  @override
  String get defaulT => 'Standaard';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) verwijderen?';
  }

  @override
  String get delete => 'Verwijderen';

  @override
  String get deleteConfirm => 'Bevestigen voor verwijderen';

  @override
  String get editor => 'Editor';

  @override
  String emptyFields(Object fields) {
    return '$fields zijn leeg';
  }

  @override
  String fileNotFound(Object file) {
    return 'Bestand ($file) niet gevonden';
  }

  @override
  String fileTooLarge(Object size) {
    return 'Bestand te groot: $size';
  }

  @override
  String get followChatModel => 'Chatmodel volgen';

  @override
  String get fontSize => 'Lettergrootte';

  @override
  String get fontSizeSettingTip => 'Alleen van toepassing op codeblokken';

  @override
  String get freeCopy => 'Vrij kopiëren';

  @override
  String get genChatTitle => 'Chattitel genereren';

  @override
  String get genTitle => 'Titel genereren';

  @override
  String get headTailMode => 'Kop-staart modus';

  @override
  String get headTailModeTip => 'Stuurt alleen `prompt + eerste gebruikersbericht + huidige invoer` als context.\n\nDit is vooral handig voor het vertalen van gesprekken (bespaart tokens).';

  @override
  String get help => 'Help';

  @override
  String get history => 'Geschiedenis';

  @override
  String historyToolHelp(Object keywords) {
    return 'Chats laden met trefwoorden $keywords als context?';
  }

  @override
  String get historyToolTip => 'Historische chats laden als context';

  @override
  String get hour => 'uur';

  @override
  String get httpToolTip => 'HTTP-verzoek uitvoeren, bijvoorbeeld: inhoud zoeken';

  @override
  String get ignoreContextConstraint => 'Contextbeperking negeren';

  @override
  String get ignoreTip => 'Tip negeren';

  @override
  String get image => 'Afbeelding';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Tips\n- Overmatig scrollen (overscroll) in het chatscherm laat je snel schakelen tussen chatgeschiedenissen\n- Lang drukken op chattekst laat je vrij Markdown-bron selecteren en kopiëren\n- URL-schema gebruik kan [hier]($unilink) worden gevonden\n\n### 🔍 Help\n- Als GPT Box bugs heeft, gebruik [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

  @override
  String invalidLinkFmt(Object uri) {
    return 'Onbekende link: $uri';
  }

  @override
  String get joinBeta => 'Deelnemen aan bètatest';

  @override
  String get languageName => 'Nederlands';

  @override
  String get license => 'Licentie';

  @override
  String get licenseMenuItem => 'Open-source licenties';

  @override
  String get list => 'Lijst';

  @override
  String get manual => 'Handmatig';

  @override
  String get memory => 'Geheugen';

  @override
  String memoryAdded(Object str) {
    return 'Geheugen toegevoegd: $str';
  }

  @override
  String memoryTip(Object txt) {
    return 'Onthouden [$txt]?';
  }

  @override
  String get message => 'Bericht';

  @override
  String get migrationV1UrlTip => 'Moet \"/v1\" automatisch worden toegevoegd aan het einde van de configuratie?';

  @override
  String get minute => 'minuut';

  @override
  String get model => 'Model';

  @override
  String get modelRegExpTip => 'Als de modelnaam overeenkomt, worden tools gebruikt';

  @override
  String get more => 'Meer';

  @override
  String get multiModel => 'Multimodaal';

  @override
  String get myOtherApps => 'Mijn andere apps';

  @override
  String get needOpenAIKey => 'Voer eerst de OpenAI-sleutel in';

  @override
  String get needRestart => 'Herstart nodig om toe te passen';

  @override
  String get newChat => 'Nieuwe chat';

  @override
  String get noDuplication => 'Geen duplicaten';

  @override
  String notSupported(Object val) {
    return '$val wordt niet ondersteund';
  }

  @override
  String get onMsgCome => 'Wanneer er nieuwe berichten zijn';

  @override
  String get onSwitchChat => 'Bij het wisselen van gesprekken';

  @override
  String get onlyRestoreHistory => 'Alleen chatgeschiedenis herstellen (API-URL en geheime sleutel niet herstellen)';

  @override
  String get onlySyncOnLaunch => 'Alleen synchroniseren bij opstarten';

  @override
  String get other => 'Overig';

  @override
  String get participant => 'Deelnemer';

  @override
  String get passwd => 'Wachtwoord';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyTip => 'Deze app verzamelt geen informatie.';

  @override
  String get profile => 'Profiel';

  @override
  String get promptsSettingsItem => 'Prompts';

  @override
  String get quickShareTip => 'Open deze link op een ander apparaat om de huidige configuratie snel te importeren.';

  @override
  String get raw => 'Onbewerkt';

  @override
  String get refresh => 'Vernieuwen';

  @override
  String get regExp => 'Reguliere expressie';

  @override
  String get remember30s => '30 seconden onthouden';

  @override
  String get rename => 'Hernoemen';

  @override
  String get replay => 'Herhalen';

  @override
  String get replayTip => 'De herhaalde berichten en alle volgende berichten worden gewist.';

  @override
  String get res => 'Bron';

  @override
  String restoreOpenaiTip(Object url) {
    return 'Documentatie kan [hier]($url) worden gevonden';
  }

  @override
  String get rmDuplication => 'Duplicaten verwijderen';

  @override
  String rmDuplicationFmt(Object count) {
    return 'Weet u zeker dat u [$count] dubbele items wilt verwijderen?';
  }

  @override
  String get route => 'Route';

  @override
  String get save => 'Opslaan';

  @override
  String get saveErrChat => 'Foutieve chat opslaan';

  @override
  String get saveErrChatTip => 'Opslaan na ontvangen/verzenden van elk bericht, zelfs als er fouten zijn';

  @override
  String get scrollSwitchChat => 'Scrollen om van chat te wisselen';

  @override
  String get search => 'Zoeken';

  @override
  String get secretKey => 'Geheime sleutel';

  @override
  String get share => 'Delen';

  @override
  String get shareFrom => 'Gedeeld van';

  @override
  String get skipSameTitle => 'Chats met dezelfde titel als lokale chats overslaan';

  @override
  String get softWrap => 'Zachte terugloop';

  @override
  String get stt => 'Spraak naar tekst';

  @override
  String sureRestoreFmt(Object time) {
    return 'Weet u zeker dat u de back-up ($time) wilt herstellen?';
  }

  @override
  String get switcher => 'Schakelaar';

  @override
  String syncConflict(Object a, Object b) {
    return 'Conflict: kan $a en $b niet tegelijkertijd activeren';
  }

  @override
  String get system => 'Systeem';

  @override
  String get text => 'Tekst';

  @override
  String get themeColorSeed => 'Themakleurzaad';

  @override
  String get themeMode => 'Thema-modus';

  @override
  String get thirdParty => 'Derde partij';

  @override
  String get tool => 'Tool';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Gaat u akkoord met het gebruik van tool $tool?';
  }

  @override
  String get toolFinishTip => 'Toolaanroep voltooid';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Er zullen gegevens van het netwerk worden opgehaald, deze keer zal er contact worden opgenomen met $host';
  }

  @override
  String get toolHttpReqName => 'HTTP-verzoek';

  @override
  String get tts => 'Tekst naar spraak';

  @override
  String get unsupported => 'Niet ondersteund';

  @override
  String get untitled => 'Naamloos';

  @override
  String get update => 'Bijwerken';

  @override
  String get usage => 'Gebruik';

  @override
  String get user => 'Gebruiker';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks weken geleden';
  }

  @override
  String get wrap => 'Omslaan';
}
