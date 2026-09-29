// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get attention => 'Attention';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Vérifier automatiquement les mises à jour';

  @override
  String get autoScrollBottom => 'Défilement automatique vers le bas';

  @override
  String get backupTip =>
      'Assurez-vous que votre fichier de sauvegarde est privé et sécurisé !';

  @override
  String get calcTokenLen => 'Calculer la longueur des tokens';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Cliquer pour vérifier';

  @override
  String get codeBlock => 'Bloc de code';

  @override
  String get copied => 'Copié';

  @override
  String get current => 'Actuel';

  @override
  String delFmt(Object id, Object type) {
    return 'Supprimer $type ($id) ?';
  }

  @override
  String get deleteConfirm => 'Confirmer avant de supprimer';

  @override
  String emptyFields(Object fields) {
    return '$fields sont vides';
  }

  @override
  String get emptyTrash => 'Vider la corbeille';

  @override
  String get emptyTrashTip =>
      '==0, supprimer au prochain démarrage. <0 ne pas supprimer automatiquement.';

  @override
  String get fontSize => 'Taille de police';

  @override
  String get fontSizeSettingTip => 'S\'applique uniquement aux blocs de code';

  @override
  String get genChatTitle => 'Générer un titre de chat';

  @override
  String get history => 'Historique';

  @override
  String historyToolHelp(Object keywords) {
    return 'Charger les chats contenant les mots-clés $keywords comme contexte ?';
  }

  @override
  String get historyToolTip => 'Charger les chats historiques comme contexte';

  @override
  String get httpToolTip =>
      'Effectuer une requête HTTP, par exemple : rechercher du contenu';

  @override
  String get image => 'Image';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Lien inconnu : $uri';
  }

  @override
  String get joinBeta => 'Rejoindre le test bêta';

  @override
  String get languageName => 'Français';

  @override
  String get license => 'Licence';

  @override
  String get licenseMenuItem => 'Licences open source';

  @override
  String get list => 'Liste';

  @override
  String get manual => 'Manuel';

  @override
  String get memory => 'Mémoire';

  @override
  String memoryAdded(Object str) {
    return 'Mémoire ajoutée : $str';
  }

  @override
  String memoryTip(Object txt) {
    return 'Se souvenir de [$txt] ?';
  }

  @override
  String get message => 'Message';

  @override
  String get model => 'Modèle';

  @override
  String get more => 'Plus';

  @override
  String get myOtherApps => 'Mes autres applications';

  @override
  String get newChat => 'Nouveau chat';

  @override
  String get onMsgCome => 'Lorsqu\'il y a de nouveaux messages';

  @override
  String get onSwitchChat => 'Lors du changement de conversation';

  @override
  String get passwd => 'Mot de passe';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacyTip => 'Cette application ne collecte aucune information.';

  @override
  String get rename => 'Renommer';

  @override
  String get replay => 'Rejouer';

  @override
  String get share => 'Partager';

  @override
  String get shareFrom => 'Partagé depuis';

  @override
  String get softWrap => 'Retour à la ligne automatique';

  @override
  String sureRestoreFmt(Object time) {
    return 'Êtes-vous sûr de vouloir restaurer la sauvegarde ($time) ?';
  }

  @override
  String get switcher => 'Commutateur';

  @override
  String syncConflict(Object a, Object b) {
    return 'Conflit : impossible d\'activer $a et $b en même temps';
  }

  @override
  String get text => 'Texte';

  @override
  String get themeColorSeed => 'Graine de couleur du thème';

  @override
  String get themeMode => 'Mode de thème';

  @override
  String get tool => 'Outil';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Acceptez-vous d\'utiliser l\'outil $tool ?';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'Des données seront obtenues du réseau, cette fois en contactant $host';
  }

  @override
  String get toolHttpReqName => 'Requête HTTP';

  @override
  String get untitled => 'Sans titre';

  @override
  String get usage => 'Utilisation';

  @override
  String get user => 'Utilisateur';

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
