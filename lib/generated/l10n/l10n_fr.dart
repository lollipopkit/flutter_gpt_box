// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get apiUrlV1Tip =>
      'Similaire à https://api.openai.com/v1 (nécessitant le /v1 final). Continuer à utiliser cette URL ?';

  @override
  String get assistant => 'Assistant';

  @override
  String get attention => 'Attention';

  @override
  String get audio => 'Audio';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Vérifier automatiquement les mises à jour';

  @override
  String get autoRmDupChat => 'Supprimer automatiquement les chats en double';

  @override
  String get autoScrollBottom => 'Défilement automatique vers le bas';

  @override
  String get backupTip =>
      'Assurez-vous que votre fichier de sauvegarde est privé et sécurisé !';

  @override
  String get balance => 'Solde';

  @override
  String get calcTokenLen => 'Calculer la longueur des tokens';

  @override
  String get changeModelTip =>
      'Différentes clés peuvent accéder à différentes listes de modèles. Si vous ne comprenez pas le mécanisme et que des erreurs surviennent, il est recommandé de reconfigurer le modèle.';

  @override
  String get chat => 'Chat';

  @override
  String get chatHistoryLength => 'Longueur de l\'historique du chat';

  @override
  String get chatHistoryTip => 'Utilisé comme contexte du chat';

  @override
  String get clickSwitch => 'Cliquer pour changer';

  @override
  String get clickToCheck => 'Cliquer pour vérifier';

  @override
  String get clipboard => 'Presse-papiers';

  @override
  String get codeBlock => 'Bloc de code';

  @override
  String get colorSeedTip => 'Ceci est une graine de couleur, pas une couleur';

  @override
  String get compress => 'Compresser';

  @override
  String get compressImgTip => 'Pour le chat et le partage';

  @override
  String get contributor => 'Contributeur';

  @override
  String get copied => 'Copié';

  @override
  String get current => 'Actuel';

  @override
  String get custom => 'Personnalisé';

  @override
  String get day => 'jour';

  @override
  String get defaulT => 'Par défaut';

  @override
  String delFmt(Object id, Object type) {
    return 'Supprimer $type ($id) ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteConfirm => 'Confirmer avant de supprimer';

  @override
  String get editor => 'Éditeur';

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
  String fileNotFound(Object file) {
    return 'Fichier ($file) non trouvé';
  }

  @override
  String fileTooLarge(Object size) {
    return 'Fichier trop volumineux : $size';
  }

  @override
  String get followChatModel => 'Suivre le modèle de chat';

  @override
  String get fontSize => 'Taille de police';

  @override
  String get fontSizeSettingTip => 'S\'applique uniquement aux blocs de code';

  @override
  String get freeCopy => 'Copie libre';

  @override
  String get genChatTitle => 'Générer un titre de chat';

  @override
  String get genTitle => 'Générer un titre';

  @override
  String get headTailMode => 'Mode tête-queue';

  @override
  String get headTailModeTip =>
      'Envoie seulement `prompt + premier message utilisateur + entrée actuelle` comme contexte.\n\nCeci est particulièrement utile pour traduire des conversations (économise des tokens).';

  @override
  String get help => 'Aide';

  @override
  String get history => 'Historique';

  @override
  String historyToolHelp(Object keywords) {
    return 'Charger les chats contenant les mots-clés $keywords comme contexte ?';
  }

  @override
  String get historyToolTip => 'Charger les chats historiques comme contexte';

  @override
  String get hour => 'heure';

  @override
  String get httpToolTip =>
      'Effectuer une requête HTTP, par exemple : rechercher du contenu';

  @override
  String get ignoreContextConstraint => 'Ignorer la contrainte de contexte';

  @override
  String get ignoreTip => 'Ignorer l\'astuce';

  @override
  String get image => 'Image';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Astuces\n- Le défilement excessif (overscroll) dans l\'interface de chat permet de basculer rapidement entre les historiques de chat\n- Appuyez longuement sur le texte du chat pour sélectionner et copier librement la source Markdown\n- L\'utilisation du schéma URL peut être trouvée [ici]($unilink)\n\n### 🔍 Aide\n- Si GPT Box a des bugs, utilisez [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

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
  String get migrationV1UrlTip =>
      'Faut-il ajouter automatiquement \"/v1\" à la fin de la configuration ?';

  @override
  String get minute => 'minute';

  @override
  String get model => 'Modèle';

  @override
  String get modelRegExpTip =>
      'Si le nom du modèle correspond, les outils seront utilisés';

  @override
  String get more => 'Plus';

  @override
  String get multiModel => 'Multimodal';

  @override
  String get myOtherApps => 'Mes autres applications';

  @override
  String get needOpenAIKey => 'Veuillez d\'abord saisir la clé OpenAI';

  @override
  String get needRestart => 'Redémarrage nécessaire pour appliquer';

  @override
  String get newChat => 'Nouveau chat';

  @override
  String get noDuplication => 'Pas de doublon';

  @override
  String notSupported(Object val) {
    return '$val n\'est pas pris en charge';
  }

  @override
  String get onMsgCome => 'Lorsqu\'il y a de nouveaux messages';

  @override
  String get onSwitchChat => 'Lors du changement de conversation';

  @override
  String get onlyRestoreHistory =>
      'Restaurer uniquement l\'historique des chats (ne pas restaurer l\'URL de l\'API et la clé secrète)';

  @override
  String get onlySyncOnLaunch => 'Synchroniser uniquement au lancement';

  @override
  String get other => 'Autre';

  @override
  String get participant => 'Participant';

  @override
  String get passwd => 'Mot de passe';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacyTip => 'Cette application ne collecte aucune information.';

  @override
  String get profile => 'Profil';

  @override
  String get promptsSettingsItem => 'Invites';

  @override
  String get quickShareTip =>
      'Ouvrez ce lien sur un autre appareil pour importer rapidement la configuration actuelle.';

  @override
  String get raw => 'Brut';

  @override
  String get refresh => 'Actualiser';

  @override
  String get regExp => 'Expression régulière';

  @override
  String get remember30s => 'Se souvenir pendant 30 secondes';

  @override
  String get rename => 'Renommer';

  @override
  String get replay => 'Rejouer';

  @override
  String get replayTip =>
      'Les messages rejoués et tous les messages suivants seront effacés.';

  @override
  String get res => 'Ressource';

  @override
  String restoreOpenaiTip(Object url) {
    return 'La documentation peut être trouvée [ici]($url)';
  }

  @override
  String get rmDuplication => 'Supprimer les doublons';

  @override
  String rmDuplicationFmt(Object count) {
    return 'Êtes-vous sûr de vouloir supprimer [$count] éléments en double ?';
  }

  @override
  String get route => 'Route';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveErrChat => 'Enregistrer le chat avec erreur';

  @override
  String get saveErrChatTip =>
      'Enregistrer après réception/envoi de chaque message, même s\'il y a des erreurs';

  @override
  String get scrollSwitchChat => 'Faire défiler pour changer de chat';

  @override
  String get search => 'Rechercher';

  @override
  String get secretKey => 'Clé secrète';

  @override
  String get share => 'Partager';

  @override
  String get shareFrom => 'Partagé depuis';

  @override
  String get skipSameTitle =>
      'Ignorer les chats avec le même titre que les chats locaux';

  @override
  String get softWrap => 'Retour à la ligne automatique';

  @override
  String get stt => 'Parole vers texte';

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
  String get system => 'Système';

  @override
  String get text => 'Texte';

  @override
  String get themeColorSeed => 'Graine de couleur du thème';

  @override
  String get themeMode => 'Mode de thème';

  @override
  String get thirdParty => 'Tiers';

  @override
  String get tool => 'Outil';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Acceptez-vous d\'utiliser l\'outil $tool ?';
  }

  @override
  String get toolFinishTip => 'Appel d\'outil terminé';

  @override
  String toolHttpReqHelp(Object host) {
    return 'Des données seront obtenues du réseau, cette fois en contactant $host';
  }

  @override
  String get toolHttpReqName => 'Requête HTTP';

  @override
  String get tts => 'Texte vers parole';

  @override
  String get unsupported => 'Non pris en charge';

  @override
  String get untitled => 'Sans titre';

  @override
  String get update => 'Mettre à jour';

  @override
  String get usage => 'Utilisation';

  @override
  String get user => 'Utilisateur';

  @override
  String weeksAgo(Object weeks) {
    return 'Il y a $weeks semaines';
  }

  @override
  String get wrap => 'Envelopper';
}
