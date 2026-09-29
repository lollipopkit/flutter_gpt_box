// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get attention => 'Attention';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Auto check for updates';

  @override
  String get autoScrollBottom => 'Auto scroll to bottom';

  @override
  String get backupTip => 'Please keep backup files private and safe!';

  @override
  String get calcTokenLen => 'Calculate tokens length';

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
  String get deleteConfirm => 'Confirmation berfore delete';

  @override
  String emptyFields(Object fields) {
    return '$fields is empty';
  }

  @override
  String get emptyTrash => 'Empty recycle bin';

  @override
  String get emptyTrashTip =>
      '==0, delete on next startup. <0 do not delete automatically.';

  @override
  String get fontSize => 'Font size';

  @override
  String get fontSizeSettingTip => 'Applies only to code blocks';

  @override
  String get genChatTitle => 'Chat title generator';

  @override
  String get history => 'History';

  @override
  String historyToolHelp(Object keywords) {
    return 'Load chats containing keywords $keywords as context?';
  }

  @override
  String get historyToolTip => 'Load history chats as context';

  @override
  String get httpToolTip => 'Send Http request, eg. search web content';

  @override
  String get image => 'Image';

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
  String get model => 'Model';

  @override
  String get more => 'More';

  @override
  String get myOtherApps => 'My other apps';

  @override
  String get newChat => 'New chat';

  @override
  String get onMsgCome => 'When there are new messages';

  @override
  String get onSwitchChat => 'When switching conversations';

  @override
  String get passwd => 'Password';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyTip => 'This app does not collect any data.';

  @override
  String get rename => 'Rename';

  @override
  String get replay => 'Replay';

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
  String get switcher => 'Switch';

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
  String toolConfirmFmt(Object tool) {
    return 'Is it permitted to use the tool $tool ?';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'It will fetch data from network. In this time, it will communicate with $host.';
  }

  @override
  String get toolHttpReqName => 'Http Request';

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
