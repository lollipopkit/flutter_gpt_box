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
  String get autoScrollBottom => 'Automatisch naar beneden scrollen';

  @override
  String get backupTip =>
      'Zorg ervoor dat uw back-upbestand privé en veilig is!';

  @override
  String get calcTokenLen => 'Tokenlengte berekenen';

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
  String get emptyTrash => 'Prullenbak leegmaken';

  @override
  String get emptyTrashTip =>
      '==0, bij de volgende start verwijderen. <0 niet automatisch verwijderen.';

  @override
  String get fontSize => 'Lettergrootte';

  @override
  String get fontSizeSettingTip => 'Alleen van toepassing op codeblokken';

  @override
  String get genChatTitle => 'Chattitel genereren';

  @override
  String get history => 'Geschiedenis';

  @override
  String historyToolHelp(Object keywords) {
    return 'Chats laden met trefwoorden $keywords als context?';
  }

  @override
  String get historyToolTip => 'Historische chats laden als context';

  @override
  String get httpToolTip =>
      'HTTP-verzoek uitvoeren, bijvoorbeeld: inhoud zoeken';

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
  String get model => 'Model';

  @override
  String get more => 'Meer';

  @override
  String get myOtherApps => 'Mijn andere apps';

  @override
  String get newChat => 'Nieuwe chat';

  @override
  String get onMsgCome => 'Wanneer er nieuwe berichten zijn';

  @override
  String get onSwitchChat => 'Bij het wisselen van gesprekken';

  @override
  String get passwd => 'Wachtwoord';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyTip => 'Deze app verzamelt geen informatie.';

  @override
  String get rename => 'Hernoemen';

  @override
  String get replay => 'Herhalen';

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
  String get switcher => 'Schakelaar';

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
  String toolConfirmFmt(Object tool) {
    return 'Gaat u akkoord met het gebruik van tool $tool?';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'Er zullen gegevens van het netwerk worden opgehaald, deze keer zal er contact worden opgenomen met $host';
  }

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
    return '$n modellen';
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
}
