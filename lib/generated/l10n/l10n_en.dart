import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get apiUrlV1Tip => 'Similar to https://api.openai.com/v1 (requiring the final /v1). Continue using this URL?';

  @override
  String get assistant => 'Assistant';

  @override
  String get attention => 'Attention';

  @override
  String get audio => 'Audio';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Auto check for updates';

  @override
  String get autoRmDupChat => 'Auto remove duplicate chats';

  @override
  String get autoScrollBottom => 'Auto scroll to bottom';

  @override
  String get backupTip => 'Please keep backup files private and safe!';

  @override
  String get balance => 'Balance';

  @override
  String get calcTokenLen => 'Calculate tokens length';

  @override
  String get changeModelTip => 'Different keys may be able to access different lists of models, so if you don\'t understand the mechanism and get an error, it is recommended to reset the model.';

  @override
  String get chat => 'Chat';

  @override
  String get chatHistoryLength => 'Chat history length';

  @override
  String get chatHistoryTip => 'Use as chat context';

  @override
  String get clickSwitch => 'Click to switch';

  @override
  String get clickToCheck => 'Click to check';

  @override
  String get clipboard => 'Clipboard';

  @override
  String get codeBlock => 'Code block';

  @override
  String get colorSeedTip => 'It\'s color seed, not color';

  @override
  String get compress => 'Compress';

  @override
  String get compressImgTip => 'For chat and share';

  @override
  String get contributor => 'Contributors';

  @override
  String get copied => 'Copied';

  @override
  String get current => 'Current';

  @override
  String get custom => 'Custom';

  @override
  String get day => 'day';

  @override
  String get defaulT => 'Default';

  @override
  String delFmt(Object id, Object type) {
    return 'Delete $type($id)?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirm => 'Confirmation berfore delete';

  @override
  String get editor => 'Editor';

  @override
  String emptyFields(Object fields) {
    return '$fields is empty';
  }

  @override
  String fileNotFound(Object file) {
    return 'File($file) not found';
  }

  @override
  String fileTooLarge(Object size) {
    return 'File too large: $size';
  }

  @override
  String get followChatModel => 'Follow chat model';

  @override
  String get fontSize => 'Font size';

  @override
  String get fontSizeSettingTip => 'Applies only to code blocks';

  @override
  String get freeCopy => 'Free copy';

  @override
  String get genChatTitle => 'Chat title generator';

  @override
  String get genTitle => 'Generate title';

  @override
  String get headTailMode => 'Head-Tail';

  @override
  String get headTailModeTip => 'Only send `prompt + first user message + current input` as the context. \n\nThis is useful for translating as it saves tokens.';

  @override
  String get help => 'Help';

  @override
  String get history => 'History';

  @override
  String historyToolHelp(Object keywords) {
    return 'Load chats containing keywords $keywords as context?';
  }

  @override
  String get historyToolTip => 'Load history chats as context';

  @override
  String get hour => 'hour';

  @override
  String get httpToolTip => 'Send Http request, eg. search web content';

  @override
  String get ignoreContextConstraint => 'Ignore context constraint';

  @override
  String get ignoreTip => 'Ignore tips';

  @override
  String get image => 'Image';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 Tip\n- Overscroll on the chat page to switch chat history.\n- Long press chat to free copy raw markdown data / delete / etc.\n- URL Scheme usage can be found [here]($unilink)\n\n### 🔍 Help\n- If you have found a bug, please use [Github Issue]($issue)';
  }

  @override
  String invalidLinkFmt(Object uri) {
    return 'Invalid link: $uri';
  }

  @override
  String get joinBeta => 'Join Beta Program';

  @override
  String get languageName => 'English';

  @override
  String get license => 'License';

  @override
  String get licenseMenuItem => 'Open-source licenses';

  @override
  String get list => 'List';

  @override
  String get manual => 'Manual';

  @override
  String get memory => 'Memory';

  @override
  String memoryAdded(Object str) {
    return 'Memory added: $str';
  }

  @override
  String memoryTip(Object txt) {
    return 'Memorise [$txt]?';
  }

  @override
  String get message => 'Message';

  @override
  String get migrationV1UrlTip => 'Should \"/v1\" be automatically added to the end of the configuration?';

  @override
  String get minute => 'min';

  @override
  String get model => 'Model';

  @override
  String get modelRegExpTip => 'If the model name matches, use tools.';

  @override
  String get more => 'More';

  @override
  String get multiModel => 'Multimodel';

  @override
  String get myOtherApps => 'My other apps';

  @override
  String get needOpenAIKey => 'Please input OpenAI Key first.';

  @override
  String get needRestart => 'Need restart to take effect';

  @override
  String get newChat => 'New chat';

  @override
  String get noDuplication => 'No duplication';

  @override
  String notSupported(Object val) {
    return '$val is not supported';
  }

  @override
  String get onMsgCome => 'When there are new messages';

  @override
  String get onSwitchChat => 'When switching conversations';

  @override
  String get onlyRestoreHistory => 'Only restore histories (exclude api url / secret key)';

  @override
  String get onlySyncOnLaunch => 'Only sync on launch';

  @override
  String get other => 'Other';

  @override
  String get participant => 'Participant';

  @override
  String get passwd => 'Password';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyTip => 'This app does not collect any data.';

  @override
  String get profile => 'Profile';

  @override
  String get promptsSettingsItem => 'Prompts';

  @override
  String get quickShareTip => 'Open this link on another device to quickly import the current configuration.';

  @override
  String get raw => 'Raw';

  @override
  String get refresh => 'Refresh';

  @override
  String get regExp => 'Reg Exp';

  @override
  String get remember30s => 'Remember 30s';

  @override
  String get rename => 'Rename';

  @override
  String get replay => 'Replay';

  @override
  String get replayTip => 'The replayed messages and all subsequent messages will be cleared.';

  @override
  String get res => 'Resource';

  @override
  String restoreOpenaiTip(Object url) {
    return 'Document can be found [here]($url)';
  }

  @override
  String get rmDuplication => 'Remove duplication';

  @override
  String rmDuplicationFmt(Object count) {
    return 'Sure to delete [$count] items?';
  }

  @override
  String get route => 'Route';

  @override
  String get save => 'Save';

  @override
  String get saveErrChat => 'Save chat with errors';

  @override
  String get saveErrChatTip => 'Save the chat after each message sent or received even if it has error.';

  @override
  String get scrollSwitchChat => 'Scroll to switch chat';

  @override
  String get search => 'Search';

  @override
  String get secretKey => 'Secret key';

  @override
  String get share => 'Share';

  @override
  String get shareFrom => 'Share from';

  @override
  String get skipSameTitle => 'Skip chats with titles that are the same as local chats.';

  @override
  String get softWrap => 'Soft wrap';

  @override
  String get stt => 'stt';

  @override
  String sureRestoreFmt(Object time) {
    return 'Are you sure to restore Backup($time)?';
  }

  @override
  String get switcher => 'Switch';

  @override
  String syncConflict(Object a, Object b) {
    return 'Sync conflict: can\'t turn on $a and $b at the same time.';
  }

  @override
  String get system => 'System';

  @override
  String get text => 'Text';

  @override
  String get themeColorSeed => 'Theme color seed';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get thirdParty => 'Third Party';

  @override
  String get tool => 'Tool';

  @override
  String toolConfirmFmt(Object tool) {
    return 'Is it permitted to use the tool $tool ?';
  }

  @override
  String get toolFinishTip => 'Tools invocation completed';

  @override
  String toolHttpReqHelp(Object host) {
    return 'It will fetch data from network. In this time, it will communicate with $host.';
  }

  @override
  String get toolHttpReqName => 'Http Request';

  @override
  String get tts => 'TTS';

  @override
  String get unsupported => 'Unsupported';

  @override
  String get untitled => 'Untitled';

  @override
  String get update => 'Update';

  @override
  String get usage => 'Usage';

  @override
  String get user => 'User';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks weeks ago';
  }

  @override
  String get wrap => 'Wrap';
}
