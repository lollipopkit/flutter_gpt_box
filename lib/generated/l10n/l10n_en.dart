// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Auto check for updates';

  @override
  String get backupTip => 'Please keep backup files private and safe!';

  @override
  String get chat => 'Chat';

  @override
  String get clickToCheck => 'Click to check';

  @override
  String get codeBlock => 'Code block';

  @override
  String get copied => 'Copied';

  @override
  String get current => 'Current';

  @override
  String delFmt(Object id, Object type) {
    return 'Delete $type($id)?';
  }

  @override
  String get deleteConfirm => 'Confirm before deleting';

  @override
  String emptyFields(Object fields) {
    return '$fields is empty';
  }

  @override
  String get emptyTrashTip =>
      '==0, delete on next startup. <0 do not delete automatically.';

  @override
  String get genChatTitle => 'Chat title generator';

  @override
  String get history => 'History';

  @override
  String get historyToolTip =>
      'Search and read your other chats, without asking';

  @override
  String get httpToolTip => 'Fetch web pages and APIs';

  @override
  String get image => 'Image';

  @override
  String invalidLinkFmt(Object uri) {
    return 'Invalid link: $uri';
  }

  @override
  String get languageName => 'English';

  @override
  String get license => 'License';

  @override
  String get licenseMenuItem => 'Open-source licenses';

  @override
  String get manual => 'Manual';

  @override
  String get memory => 'Memory';

  @override
  String get message => 'Message';

  @override
  String get model => 'Model';

  @override
  String get more => 'More';

  @override
  String get myOtherApps => 'My other apps';

  @override
  String get newChat => 'New chat';

  @override
  String get passwd => 'Password';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyTip => 'This app does not collect any data.';

  @override
  String get rename => 'Rename';

  @override
  String get share => 'Share';

  @override
  String get shareFrom => 'Share from';

  @override
  String get softWrap => 'Soft wrap';

  @override
  String sureRestoreFmt(Object time) {
    return 'Are you sure to restore Backup($time)?';
  }

  @override
  String syncConflict(Object a, Object b) {
    return 'Sync conflict: can\'t turn on $a and $b at the same time.';
  }

  @override
  String get text => 'Text';

  @override
  String get themeColorSeed => 'Theme color seed';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get tool => 'Tool';

  @override
  String get toolHttpReqName => 'HTTP request';

  @override
  String get untitled => 'Untitled';

  @override
  String get usage => 'Usage';

  @override
  String get user => 'User';

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
  String get modelsListedTip =>
      'Optional: the endpoint\'s /models list is fetched. Add ids it does not list.';

  @override
  String get modelsRequired =>
      'This API cannot list its models: enter at least one model id.';

  @override
  String modelsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n models',
      one: '1 model',
    );
    return '$_temp0';
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
  String get today => 'Today';

  @override
  String get earlier => 'Earlier';

  @override
  String get now => 'now';

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
  String get thought => 'Thought';

  @override
  String tokensFmt(String n) {
    return '$n tokens';
  }

  @override
  String allowToolFmt(String tool) {
    return 'Allow $tool?';
  }

  @override
  String get replyWaits => 'The reply waits for your answer.';

  @override
  String usableModelsFmt(int n, int m) {
    String _temp0 = intl.Intl.pluralLogic(
      m,
      locale: localeName,
      other: '$m providers',
      one: '1 provider',
    );
    return '$n usable · $_temp0';
  }

  @override
  String get searchModels => 'Search models';

  @override
  String get version => 'Version';

  @override
  String get endpoint => 'Endpoint';

  @override
  String get key => 'Key';

  @override
  String get toolsAndMcp => 'Tools & MCP';

  @override
  String get useTools => 'Use tools';

  @override
  String get useToolsTip => 'Each call asks first unless it is allowed below';

  @override
  String get builtIn => 'Built-in';

  @override
  String get allowedWithoutAsking => 'Allowed without asking';

  @override
  String get mcpServers => 'MCP servers';

  @override
  String get addServer => 'Add server';

  @override
  String connectedFmt(int n) {
    return 'Connected · $n tools';
  }

  @override
  String get disconnected => 'Disconnected';

  @override
  String get deleteKey => 'Delete key';

  @override
  String moreFmt(int n) {
    return '$n more';
  }

  @override
  String get back => 'Back';

  @override
  String get allProviders => 'All providers';

  @override
  String get searchProviders => 'Search providers';

  @override
  String get backToChats => 'Back to chats';

  @override
  String get genChatTitleTip => 'Names a chat after its first reply';

  @override
  String get scrollOnNewMsg => 'Scroll to bottom on new message';

  @override
  String get scrollAfterSwitch => 'Scroll to bottom after switching chat';

  @override
  String chatsCountFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n chats',
      one: '1 chat',
    );
    return '$_temp0';
  }

  @override
  String get emptyTrashAfter => 'Empty trash after';

  @override
  String get trashTip => 'Deleted chats wait here first';

  @override
  String daysFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String thoughtForFmt(String time) {
    return 'Thought for $time';
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
  String get attachment => 'Attachment';

  @override
  String get sync => 'Sync';

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncing => 'Syncing…';

  @override
  String get neverSynced => 'Not synced yet';

  @override
  String lastSyncFmt(String time) {
    return 'Last synced $time';
  }

  @override
  String get syncOffTip =>
      'Turn on iCloud or WebDAV below to sync automatically.';

  @override
  String get backupPassword => 'Backup password';

  @override
  String get backupEncrypted => 'Backups are encrypted with it';

  @override
  String get backupNotEncrypted =>
      'Not set: file backups are plain text, and sync needs one';

  @override
  String get backupEncryptedTip => 'This backup is encrypted';

  @override
  String get backupPasswordRequired =>
      'Set a backup password first: synced backups are always encrypted';

  @override
  String get passwordWrong => 'Wrong password, or the backup is damaged';

  @override
  String get backupTooNew =>
      'This backup is from a newer version of the app. Update to restore it.';

  @override
  String get syncAppSettings => 'Sync app settings';

  @override
  String get syncAppSettingsTip => 'Window size and title bar stay per device';

  @override
  String get webdavManualTip => 'A dated copy beside the synced one';

  @override
  String get exportFile => 'Export to a file';

  @override
  String get importFile => 'Restore from a file';

  @override
  String get copyBackup => 'Copy to clipboard';

  @override
  String get pasteBackup => 'Restore from clipboard';

  @override
  String get memoryView => 'Read memory';

  @override
  String get memorySearch => 'Search memory';

  @override
  String get memoryWrite => 'Save memory';

  @override
  String get memoryEdit => 'Edit memory';

  @override
  String get memoryDelete => 'Delete memory';

  @override
  String get memoryMove => 'Move memory';

  @override
  String get memoryToolTip =>
      'Files the model keeps across chats, read and written without asking';

  @override
  String charsFmt(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n characters',
      one: '1 character',
    );
    return '$_temp0';
  }

  @override
  String alreadyExists(String path) {
    return '$path already exists';
  }

  @override
  String get unsavedChanges => 'Save your changes before leaving?';

  @override
  String get discard => 'Discard';

  @override
  String get chatSearch => 'Search chats';

  @override
  String get chatRead => 'Read chat';

  @override
  String attachUnsupported(String name) {
    return 'Cannot attach $name: only images and text files up to 512 KB';
  }

  @override
  String get replyInterrupted => 'The reply was interrupted';

  @override
  String get resumeReply => 'Continue';
}
