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
  String get deny => 'Refuser';

  @override
  String get allow => 'Autoriser';

  @override
  String get allowAlways => 'Toujours autoriser';

  @override
  String get trash => 'Corbeille';

  @override
  String get startChatTip =>
      'Choisissez un modèle ci-dessous et écrivez quelque chose.';

  @override
  String get camera => 'Appareil photo';

  @override
  String get send => 'Envoyer';

  @override
  String get noProviderKey =>
      'Aucun fournisseur n\'a encore de clé. Ajoutez-en une pour commencer à discuter.';

  @override
  String get providers => 'Fournisseurs';

  @override
  String get regenerate => 'Régénérer';

  @override
  String get compacted => 'Les messages précédents ont été résumés';

  @override
  String get favorite => 'Favoris';

  @override
  String get defaultModel => 'Modèle par défaut';

  @override
  String get titleModel => 'Modèle pour les titres';

  @override
  String get systemPrompt => 'Prompt système';

  @override
  String get compaction => 'Compacter les longues discussions';

  @override
  String get compactionTip =>
      'Quand une discussion ne tient plus dans le contexte du modèle, les messages précédents sont résumés pour le modèle. Vous les voyez toujours tous.';

  @override
  String get customProvider => 'Fournisseur personnalisé';

  @override
  String get refreshModels => 'Actualiser les modèles';

  @override
  String get modelsListedTip =>
      'Facultatif : la liste /models du point d\'accès est récupérée. Ajoutez les identifiants qu\'elle ne contient pas.';

  @override
  String get modelsRequired =>
      'Cette API ne peut pas lister ses modèles : saisissez au moins un identifiant de modèle.';

  @override
  String modelsCountFmt(int n) {
    return '$n modèles';
  }

  @override
  String get sameAsChat => 'Comme la discussion';

  @override
  String get keyInKeychain =>
      'Stockée dans le trousseau du système, jamais dans les sauvegardes.';

  @override
  String get extraVars => 'Variables supplémentaires';

  @override
  String get extraVarsTip =>
      'Une KEY=VALUE par ligne, pour les fournisseurs qui demandent plus qu\'une clé (ressource Azure, compte Cloudflare).';
}
