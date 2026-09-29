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
  String get backupTip =>
      'Assurez-vous que votre fichier de sauvegarde est privé et sécurisé !';

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
  String get emptyTrashTip =>
      '==0, supprimer au prochain démarrage. <0 ne pas supprimer automatiquement.';

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
  String get manual => 'Manuel';

  @override
  String get memory => 'Mémoire';

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
  String get passwd => 'Mot de passe';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacyTip => 'Cette application ne collecte aucune information.';

  @override
  String get rename => 'Renommer';

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
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n modèles',
      one: '1 modèle',
    );
    return '$_temp0';
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

  @override
  String providersCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fournisseurs',
      one: '1 fournisseur',
    );
    return '$_temp0';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get earlier => 'Plus tôt';

  @override
  String get now => 'maintenant';

  @override
  String minutesFmt(int n) {
    return '$n min';
  }

  @override
  String hoursFmt(int n) {
    return '$n h';
  }

  @override
  String messagesCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n messages',
      one: '1 message',
    );
    return '$_temp0';
  }

  @override
  String get thought => 'Réflexion';

  @override
  String tokensFmt(String n) {
    return '$n jetons';
  }

  @override
  String allowToolFmt(String tool) {
    return 'Autoriser $tool ?';
  }

  @override
  String get replyWaits => 'La réponse attend votre décision.';

  @override
  String usableModelsFmt(int n, int m) {
    return '$n utilisables · $m fournisseurs';
  }

  @override
  String get searchModels => 'Rechercher des modèles';

  @override
  String get version => 'Version';

  @override
  String get endpoint => 'Point d\'accès';

  @override
  String get key => 'Clé';

  @override
  String get toolsAndMcp => 'Outils et MCP';

  @override
  String get useTools => 'Utiliser les outils';

  @override
  String get useToolsTip =>
      'Chaque appel demande d\'abord, sauf s\'il est autorisé ci-dessous';

  @override
  String get builtIn => 'Intégrés';

  @override
  String get allowedWithoutAsking => 'Autorisés sans demander';

  @override
  String get mcpServers => 'Serveurs MCP';

  @override
  String get addServer => 'Ajouter un serveur';

  @override
  String connectedFmt(int n) {
    return 'Connecté · $n outils';
  }

  @override
  String get disconnected => 'Déconnecté';

  @override
  String get deleteKey => 'Supprimer la clé';

  @override
  String moreFmt(int n) {
    return '$n de plus';
  }

  @override
  String get back => 'Retour';

  @override
  String get allProviders => 'Tous les fournisseurs';

  @override
  String get searchProviders => 'Rechercher des fournisseurs';

  @override
  String get backToChats => 'Retour aux discussions';

  @override
  String get genChatTitleTip => 'Nomme la discussion après la première réponse';

  @override
  String get scrollOnNewMsg => 'Défiler en bas à chaque nouveau message';

  @override
  String get scrollAfterSwitch =>
      'Défiler en bas après un changement de discussion';

  @override
  String chatsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n discussions',
      one: '1 discussion',
    );
    return '$_temp0';
  }

  @override
  String get emptyTrashAfter => 'Vider la corbeille après';

  @override
  String get trashTip => 'Les discussions supprimées attendent d\'abord ici';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String thoughtForFmt(String time) {
    return 'Réflexion : $time';
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
  String get attachment => 'Pièce jointe';

  @override
  String get sync => 'Synchronisation';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get syncing => 'Synchronisation…';

  @override
  String get neverSynced => 'Pas encore synchronisé';

  @override
  String lastSyncFmt(String time) {
    return 'Dernière synchronisation : $time';
  }

  @override
  String get syncOffTip =>
      'Activez iCloud ou WebDAV ci-dessous pour synchroniser automatiquement.';

  @override
  String get backupPassword => 'Mot de passe de sauvegarde';

  @override
  String get backupEncrypted => 'Les sauvegardes sont chiffrées avec';

  @override
  String get backupNotEncrypted =>
      'Non défini : les sauvegardes en fichier sont en clair, et la synchronisation en exige un';

  @override
  String get backupEncryptedTip => 'Cette sauvegarde est chiffrée';

  @override
  String get backupPasswordRequired =>
      'Définissez d\'abord un mot de passe : les sauvegardes synchronisées sont toujours chiffrées';

  @override
  String get passwordWrong => 'Mot de passe incorrect ou sauvegarde endommagée';

  @override
  String get backupTooNew =>
      'Cette sauvegarde vient d\'une version plus récente de l\'app. Mettez à jour pour la restaurer.';

  @override
  String get syncAppSettings => 'Synchroniser les réglages de l\'app';

  @override
  String get syncAppSettingsTip =>
      'La taille de fenêtre et la barre de titre restent propres à l\'appareil';

  @override
  String get webdavManualTip => 'Une copie datée à côté de celle synchronisée';

  @override
  String get exportFile => 'Exporter dans un fichier';

  @override
  String get importFile => 'Restaurer depuis un fichier';

  @override
  String get copyBackup => 'Copier dans le presse-papiers';

  @override
  String get pasteBackup => 'Restaurer depuis le presse-papiers';

  @override
  String get memoryView => 'Lire la mémoire';

  @override
  String get memorySearch => 'Rechercher dans la mémoire';

  @override
  String get memoryWrite => 'Enregistrer en mémoire';

  @override
  String get memoryEdit => 'Modifier la mémoire';

  @override
  String get memoryDelete => 'Supprimer de la mémoire';

  @override
  String get memoryMove => 'Déplacer en mémoire';

  @override
  String get memoryToolTip =>
      'Fichiers que le modèle conserve d\'un chat à l\'autre ; il les lit et les écrit sans demander';

  @override
  String charsFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n caractères',
      one: '1 caractère',
    );
    return '$_temp0';
  }

  @override
  String alreadyExists(String path) {
    return '$path existe déjà';
  }

  @override
  String get unsavedChanges =>
      'Enregistrer les modifications avant de quitter ?';

  @override
  String get discard => 'Abandonner';
}
