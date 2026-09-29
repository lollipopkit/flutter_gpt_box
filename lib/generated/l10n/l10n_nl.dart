// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get attention => 'Opgelet';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Automatisch controleren op updates';

  @override
  String get backupTip =>
      'Zorg ervoor dat uw back-upbestand privé en veilig is!';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Klik om te controleren';

  @override
  String get codeBlock => 'Codeblok';

  @override
  String get copied => 'Gekopieerd';

  @override
  String get current => 'Huidig';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) verwijderen?';
  }

  @override
  String get deleteConfirm => 'Bevestigen voor verwijderen';

  @override
  String emptyFields(Object fields) {
    return '$fields zijn leeg';
  }

  @override
  String get emptyTrashTip =>
      '==0, bij de volgende start verwijderen. <0 niet automatisch verwijderen.';

  @override
  String get genChatTitle => 'Chattitel genereren';

  @override
  String get history => 'Geschiedenis';

  @override
  String get historyToolTip =>
      'Je andere chats doorzoeken en lezen, zonder te vragen';

  @override
  String get httpToolTip => 'Webpagina\'s en API\'s ophalen';

  @override
  String get image => 'Afbeelding';

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
  String get manual => 'Handmatig';

  @override
  String get memory => 'Geheugen';

  @override
  String get message => 'Bericht';

  @override
  String get model => 'Model';

  @override
  String get more => 'Meer';

  @override
  String get myOtherApps => 'Mijn andere apps';

  @override
  String get newChat => 'Nieuwe chat';

  @override
  String get passwd => 'Wachtwoord';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyTip => 'Deze app verzamelt geen informatie.';

  @override
  String get rename => 'Hernoemen';

  @override
  String get share => 'Delen';

  @override
  String get shareFrom => 'Gedeeld van';

  @override
  String get softWrap => 'Zachte terugloop';

  @override
  String sureRestoreFmt(Object time) {
    return 'Weet u zeker dat u de back-up ($time) wilt herstellen?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Conflict: kan $a en $b niet tegelijkertijd activeren';
  }

  @override
  String get text => 'Tekst';

  @override
  String get themeColorSeed => 'Themakleurzaad';

  @override
  String get themeMode => 'Thema-modus';

  @override
  String get tool => 'Tool';

  @override
  String get toolHttpReqName => 'HTTP-verzoek';

  @override
  String get untitled => 'Naamloos';

  @override
  String get usage => 'Gebruik';

  @override
  String get user => 'Gebruiker';

  @override
  String get deny => 'Weigeren';

  @override
  String get allow => 'Toestaan';

  @override
  String get allowAlways => 'Altijd toestaan';

  @override
  String get trash => 'Prullenbak';

  @override
  String get startChatTip => 'Kies hieronder een model en zeg iets.';

  @override
  String get camera => 'Camera';

  @override
  String get send => 'Verzenden';

  @override
  String get noProviderKey =>
      'Nog geen enkele provider heeft een sleutel. Voeg er een toe om te chatten.';

  @override
  String get providers => 'Providers';

  @override
  String get regenerate => 'Opnieuw genereren';

  @override
  String get compacted => 'Eerdere berichten zijn samengevat';

  @override
  String get favorite => 'Favorieten';

  @override
  String get defaultModel => 'Standaardmodel';

  @override
  String get titleModel => 'Model voor titels';

  @override
  String get systemPrompt => 'Systeemprompt';

  @override
  String get compaction => 'Lange chats comprimeren';

  @override
  String get compactionTip =>
      'Past een chat niet meer in de context van het model, dan worden eerdere berichten voor het model samengevat. Jij ziet ze nog allemaal.';

  @override
  String get customProvider => 'Aangepaste provider';

  @override
  String get refreshModels => 'Modellen vernieuwen';

  @override
  String get modelsListedTip =>
      'Optioneel: de /models-lijst van het endpoint wordt opgehaald. Voeg id’s toe die er niet in staan.';

  @override
  String get modelsRequired =>
      'Deze API kan zijn modellen niet opsommen: vul minstens één model-id in.';

  @override
  String modelsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n modellen',
      one: '1 model',
    );
    return '$_temp0';
  }

  @override
  String get sameAsChat => 'Zelfde als de chat';

  @override
  String get keyInKeychain =>
      'Opgeslagen in de sleutelhanger van het systeem, nooit in back-ups.';

  @override
  String get extraVars => 'Extra variabelen';

  @override
  String get extraVarsTip =>
      'Eén KEY=VALUE per regel, voor providers die meer dan een sleutel nodig hebben (Azure-resource, Cloudflare-account).';

  @override
  String providersCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n providers',
      one: '1 provider',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Vandaag';

  @override
  String get earlier => 'Eerder';

  @override
  String get now => 'nu';

  @override
  String minutesFmt(int n) {
    return '$n min';
  }

  @override
  String hoursFmt(int n) {
    return '$n u';
  }

  @override
  String messagesCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n berichten',
      one: '1 bericht',
    );
    return '$_temp0';
  }

  @override
  String get thought => 'Nagedacht';

  @override
  String tokensFmt(String n) {
    return '$n tokens';
  }

  @override
  String allowToolFmt(String tool) {
    return '$tool toestaan?';
  }

  @override
  String get replyWaits => 'Het antwoord wacht op je beslissing.';

  @override
  String usableModelsFmt(int n, int m) {
    return '$n bruikbaar · $m providers';
  }

  @override
  String get searchModels => 'Modellen zoeken';

  @override
  String get version => 'Versie';

  @override
  String get endpoint => 'Endpoint';

  @override
  String get key => 'Sleutel';

  @override
  String get toolsAndMcp => 'Tools & MCP';

  @override
  String get useTools => 'Tools gebruiken';

  @override
  String get useToolsTip =>
      'Elke aanroep vraagt eerst, tenzij hieronder toegestaan';

  @override
  String get builtIn => 'Ingebouwd';

  @override
  String get allowedWithoutAsking => 'Toegestaan zonder te vragen';

  @override
  String get mcpServers => 'MCP-servers';

  @override
  String get addServer => 'Server toevoegen';

  @override
  String connectedFmt(int n) {
    return 'Verbonden · $n tools';
  }

  @override
  String get disconnected => 'Niet verbonden';

  @override
  String get deleteKey => 'Sleutel verwijderen';

  @override
  String moreFmt(int n) {
    return '$n meer';
  }

  @override
  String get back => 'Terug';

  @override
  String get allProviders => 'Alle providers';

  @override
  String get searchProviders => 'Providers zoeken';

  @override
  String get backToChats => 'Terug naar chats';

  @override
  String get genChatTitleTip =>
      'Geeft een chat een naam na het eerste antwoord';

  @override
  String get scrollOnNewMsg => 'Naar beneden scrollen bij nieuw bericht';

  @override
  String get scrollAfterSwitch => 'Naar beneden scrollen na wisselen van chat';

  @override
  String chatsCountFmt(int n) {
    return '$n chats';
  }

  @override
  String get emptyTrashAfter => 'Prullenbak legen na';

  @override
  String get trashTip => 'Verwijderde chats wachten eerst hier';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dagen',
      one: '1 dag',
    );
    return '$_temp0';
  }

  @override
  String thoughtForFmt(String time) {
    return '$time nagedacht';
  }

  @override
  String secondsFmt(String n) {
    return '$n s';
  }

  @override
  String minutesSecondsFmt(int m, int s) {
    return '$m min $s s';
  }

  @override
  String get attachment => 'Bijlage';

  @override
  String get sync => 'Synchronisatie';

  @override
  String get syncNow => 'Nu synchroniseren';

  @override
  String get syncing => 'Synchroniseren…';

  @override
  String get neverSynced => 'Nog niet gesynchroniseerd';

  @override
  String lastSyncFmt(String time) {
    return 'Laatst gesynchroniseerd: $time';
  }

  @override
  String get syncOffTip =>
      'Zet hieronder iCloud of WebDAV aan om automatisch te synchroniseren.';

  @override
  String get backupPassword => 'Back-upwachtwoord';

  @override
  String get backupEncrypted => 'Back-ups worden hiermee versleuteld';

  @override
  String get backupNotEncrypted =>
      'Niet ingesteld: bestandsback-ups zijn onversleuteld en synchronisatie vereist er een';

  @override
  String get backupEncryptedTip => 'Deze back-up is versleuteld';

  @override
  String get backupPasswordRequired =>
      'Stel eerst een back-upwachtwoord in: gesynchroniseerde back-ups zijn altijd versleuteld';

  @override
  String get passwordWrong => 'Verkeerd wachtwoord of beschadigde back-up';

  @override
  String get backupTooNew =>
      'Deze back-up komt uit een nieuwere versie van de app. Werk bij om hem te herstellen.';

  @override
  String get syncAppSettings => 'App-instellingen synchroniseren';

  @override
  String get syncAppSettingsTip =>
      'Venstergrootte en titelbalk blijven per apparaat';

  @override
  String get webdavManualTip =>
      'Een gedateerde kopie naast de gesynchroniseerde';

  @override
  String get exportFile => 'Naar een bestand exporteren';

  @override
  String get importFile => 'Herstellen uit een bestand';

  @override
  String get copyBackup => 'Naar klembord kopiëren';

  @override
  String get pasteBackup => 'Herstellen vanaf klembord';

  @override
  String get memoryView => 'Geheugen lezen';

  @override
  String get memorySearch => 'Geheugen doorzoeken';

  @override
  String get memoryWrite => 'Geheugen opslaan';

  @override
  String get memoryEdit => 'Geheugen bewerken';

  @override
  String get memoryDelete => 'Geheugen verwijderen';

  @override
  String get memoryMove => 'Geheugen verplaatsen';

  @override
  String get memoryToolTip =>
      'Bestanden die het model tussen chats bewaart; het leest en schrijft ze zonder te vragen';

  @override
  String charsFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tekens',
      one: '1 teken',
    );
    return '$_temp0';
  }

  @override
  String alreadyExists(String path) {
    return '$path bestaat al';
  }

  @override
  String get unsavedChanges => 'Wijzigingen opslaan voor het verlaten?';

  @override
  String get discard => 'Verwerpen';

  @override
  String get chatSearch => 'Chats doorzoeken';

  @override
  String get chatRead => 'Chat lezen';
}
