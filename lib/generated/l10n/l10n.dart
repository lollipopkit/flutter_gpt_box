import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_de.dart';
import 'l10n_en.dart';
import 'l10n_es.dart';
import 'l10n_fr.dart';
import 'l10n_id.dart';
import 'l10n_ja.dart';
import 'l10n_nl.dart';
import 'l10n_pt.dart';
import 'l10n_ru.dart';
import 'l10n_tr.dart';
import 'l10n_uk.dart';
import 'l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('ja'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @apiUrlV1Tip.
  ///
  /// In en, this message translates to:
  /// **'Similar to https://api.openai.com/v1 (requiring the final /v1). Continue using this URL?'**
  String get apiUrlV1Tip;

  /// No description provided for @assistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistant;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @autoCheckUpdate.
  ///
  /// In en, this message translates to:
  /// **'Auto check for updates'**
  String get autoCheckUpdate;

  /// No description provided for @autoRmDupChat.
  ///
  /// In en, this message translates to:
  /// **'Auto remove duplicate chats'**
  String get autoRmDupChat;

  /// No description provided for @autoScrollBottom.
  ///
  /// In en, this message translates to:
  /// **'Auto scroll to bottom'**
  String get autoScrollBottom;

  /// No description provided for @backupTip.
  ///
  /// In en, this message translates to:
  /// **'Please keep backup files private and safe!'**
  String get backupTip;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @calcTokenLen.
  ///
  /// In en, this message translates to:
  /// **'Calculate tokens length'**
  String get calcTokenLen;

  /// No description provided for @changeModelTip.
  ///
  /// In en, this message translates to:
  /// **'Different keys may be able to access different lists of models, so if you don\'t understand the mechanism and get an error, it is recommended to reset the model.'**
  String get changeModelTip;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chatHistoryLength.
  ///
  /// In en, this message translates to:
  /// **'Chat history length'**
  String get chatHistoryLength;

  /// No description provided for @chatHistoryTip.
  ///
  /// In en, this message translates to:
  /// **'Use as chat context'**
  String get chatHistoryTip;

  /// No description provided for @clickSwitch.
  ///
  /// In en, this message translates to:
  /// **'Click to switch'**
  String get clickSwitch;

  /// No description provided for @clickToCheck.
  ///
  /// In en, this message translates to:
  /// **'Click to check'**
  String get clickToCheck;

  /// No description provided for @clipboard.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get clipboard;

  /// No description provided for @codeBlock.
  ///
  /// In en, this message translates to:
  /// **'Code block'**
  String get codeBlock;

  /// No description provided for @colorSeedTip.
  ///
  /// In en, this message translates to:
  /// **'It\'s color seed, not color'**
  String get colorSeedTip;

  /// No description provided for @compress.
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get compress;

  /// No description provided for @compressImgTip.
  ///
  /// In en, this message translates to:
  /// **'For chat and share'**
  String get compressImgTip;

  /// No description provided for @contributor.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributor;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @defaulT.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaulT;

  /// No description provided for @delFmt.
  ///
  /// In en, this message translates to:
  /// **'Delete {type}({id})?'**
  String delFmt(Object id, Object type);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirmation berfore delete'**
  String get deleteConfirm;

  /// No description provided for @editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get editor;

  /// No description provided for @emptyFields.
  ///
  /// In en, this message translates to:
  /// **'{fields} is empty'**
  String emptyFields(Object fields);

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File({file}) not found'**
  String fileNotFound(Object file);

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'File too large: {size}'**
  String fileTooLarge(Object size);

  /// No description provided for @followChatModel.
  ///
  /// In en, this message translates to:
  /// **'Follow chat model'**
  String get followChatModel;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @fontSizeSettingTip.
  ///
  /// In en, this message translates to:
  /// **'Applies only to code blocks'**
  String get fontSizeSettingTip;

  /// No description provided for @freeCopy.
  ///
  /// In en, this message translates to:
  /// **'Free copy'**
  String get freeCopy;

  /// No description provided for @genChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat title generator'**
  String get genChatTitle;

  /// No description provided for @genTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate title'**
  String get genTitle;

  /// No description provided for @headTailMode.
  ///
  /// In en, this message translates to:
  /// **'Head-Tail'**
  String get headTailMode;

  /// No description provided for @headTailModeTip.
  ///
  /// In en, this message translates to:
  /// **'Only send `prompt + first user message + current input` as the context. \n\nThis is useful for translating as it saves tokens.'**
  String get headTailModeTip;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyToolHelp.
  ///
  /// In en, this message translates to:
  /// **'Load chats containing keywords {keywords} as context?'**
  String historyToolHelp(Object keywords);

  /// No description provided for @historyToolTip.
  ///
  /// In en, this message translates to:
  /// **'Load history chats as context'**
  String get historyToolTip;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @httpToolTip.
  ///
  /// In en, this message translates to:
  /// **'Send Http request, eg. search web content'**
  String get httpToolTip;

  /// No description provided for @ignoreContextConstraint.
  ///
  /// In en, this message translates to:
  /// **'Ignore context constraint'**
  String get ignoreContextConstraint;

  /// No description provided for @ignoreTip.
  ///
  /// In en, this message translates to:
  /// **'Ignore tips'**
  String get ignoreTip;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @initChatHelp.
  ///
  /// In en, this message translates to:
  /// **'### 📖 Tip\n- Overscroll on the chat page to switch chat history.\n- Long press chat to free copy raw markdown data / delete / etc.\n- URL Scheme usage can be found [here]({unilink})\n\n### 🔍 Help\n- If you have found a bug, please use [Github Issue]({issue})'**
  String initChatHelp(Object issue, Object unilink);

  /// No description provided for @invalidLinkFmt.
  ///
  /// In en, this message translates to:
  /// **'Invalid link: {uri}'**
  String invalidLinkFmt(Object uri);

  /// No description provided for @joinBeta.
  ///
  /// In en, this message translates to:
  /// **'Join Beta Program'**
  String get joinBeta;

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @licenseMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get licenseMenuItem;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @memory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// No description provided for @memoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Memory added: {str}'**
  String memoryAdded(Object str);

  /// No description provided for @memoryTip.
  ///
  /// In en, this message translates to:
  /// **'Memorise [{txt}]?'**
  String memoryTip(Object txt);

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @migrationV1UrlTip.
  ///
  /// In en, this message translates to:
  /// **'Should \"/v1\" be automatically added to the end of the configuration?'**
  String get migrationV1UrlTip;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minute;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @modelRegExpTip.
  ///
  /// In en, this message translates to:
  /// **'If the model name matches, use tools.'**
  String get modelRegExpTip;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @multiModel.
  ///
  /// In en, this message translates to:
  /// **'Multimodel'**
  String get multiModel;

  /// No description provided for @myOtherApps.
  ///
  /// In en, this message translates to:
  /// **'My other apps'**
  String get myOtherApps;

  /// No description provided for @needOpenAIKey.
  ///
  /// In en, this message translates to:
  /// **'Please input OpenAI Key first.'**
  String get needOpenAIKey;

  /// No description provided for @needRestart.
  ///
  /// In en, this message translates to:
  /// **'Need restart to take effect'**
  String get needRestart;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get newChat;

  /// No description provided for @noDuplication.
  ///
  /// In en, this message translates to:
  /// **'No duplication'**
  String get noDuplication;

  /// No description provided for @notSupported.
  ///
  /// In en, this message translates to:
  /// **'{val} is not supported'**
  String notSupported(Object val);

  /// No description provided for @onMsgCome.
  ///
  /// In en, this message translates to:
  /// **'When there are new messages'**
  String get onMsgCome;

  /// No description provided for @onSwitchChat.
  ///
  /// In en, this message translates to:
  /// **'When switching conversations'**
  String get onSwitchChat;

  /// No description provided for @onlyRestoreHistory.
  ///
  /// In en, this message translates to:
  /// **'Only restore histories (exclude api url / secret key)'**
  String get onlyRestoreHistory;

  /// No description provided for @onlySyncOnLaunch.
  ///
  /// In en, this message translates to:
  /// **'Only sync on launch'**
  String get onlySyncOnLaunch;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @participant.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get participant;

  /// No description provided for @passwd.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwd;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyTip.
  ///
  /// In en, this message translates to:
  /// **'This app does not collect any data.'**
  String get privacyTip;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @promptsSettingsItem.
  ///
  /// In en, this message translates to:
  /// **'Prompts'**
  String get promptsSettingsItem;

  /// No description provided for @quickShareTip.
  ///
  /// In en, this message translates to:
  /// **'Open this link on another device to quickly import the current configuration.'**
  String get quickShareTip;

  /// No description provided for @raw.
  ///
  /// In en, this message translates to:
  /// **'Raw'**
  String get raw;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @regExp.
  ///
  /// In en, this message translates to:
  /// **'Reg Exp'**
  String get regExp;

  /// No description provided for @remember30s.
  ///
  /// In en, this message translates to:
  /// **'Remember 30s'**
  String get remember30s;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @replayTip.
  ///
  /// In en, this message translates to:
  /// **'The replayed messages and all subsequent messages will be cleared.'**
  String get replayTip;

  /// No description provided for @res.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get res;

  /// No description provided for @restoreOpenaiTip.
  ///
  /// In en, this message translates to:
  /// **'Document can be found [here]({url})'**
  String restoreOpenaiTip(Object url);

  /// No description provided for @rmDuplication.
  ///
  /// In en, this message translates to:
  /// **'Remove duplication'**
  String get rmDuplication;

  /// No description provided for @rmDuplicationFmt.
  ///
  /// In en, this message translates to:
  /// **'Sure to delete [{count}] items?'**
  String rmDuplicationFmt(Object count);

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveErrChat.
  ///
  /// In en, this message translates to:
  /// **'Save chat with errors'**
  String get saveErrChat;

  /// No description provided for @saveErrChatTip.
  ///
  /// In en, this message translates to:
  /// **'Save the chat after each message sent or received even if it has error.'**
  String get saveErrChatTip;

  /// No description provided for @scrollSwitchChat.
  ///
  /// In en, this message translates to:
  /// **'Scroll to switch chat'**
  String get scrollSwitchChat;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @secretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret key'**
  String get secretKey;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareFrom.
  ///
  /// In en, this message translates to:
  /// **'Share from'**
  String get shareFrom;

  /// No description provided for @skipSameTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip chats with titles that are the same as local chats.'**
  String get skipSameTitle;

  /// No description provided for @softWrap.
  ///
  /// In en, this message translates to:
  /// **'Soft wrap'**
  String get softWrap;

  /// No description provided for @stt.
  ///
  /// In en, this message translates to:
  /// **'stt'**
  String get stt;

  /// No description provided for @sureRestoreFmt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to restore Backup({time})?'**
  String sureRestoreFmt(Object time);

  /// No description provided for @switcher.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switcher;

  /// No description provided for @syncConflict.
  ///
  /// In en, this message translates to:
  /// **'Sync conflict: can\'t turn on {a} and {b} at the same time.'**
  String syncConflict(Object a, Object b);

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @themeColorSeed.
  ///
  /// In en, this message translates to:
  /// **'Theme color seed'**
  String get themeColorSeed;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @thirdParty.
  ///
  /// In en, this message translates to:
  /// **'Third Party'**
  String get thirdParty;

  /// No description provided for @tool.
  ///
  /// In en, this message translates to:
  /// **'Tool'**
  String get tool;

  /// No description provided for @toolConfirmFmt.
  ///
  /// In en, this message translates to:
  /// **'Is it permitted to use the tool {tool} ?'**
  String toolConfirmFmt(Object tool);

  /// No description provided for @toolFinishTip.
  ///
  /// In en, this message translates to:
  /// **'Tools invocation completed'**
  String get toolFinishTip;

  /// No description provided for @toolHttpReqHelp.
  ///
  /// In en, this message translates to:
  /// **'It will fetch data from network. In this time, it will communicate with {host}.'**
  String toolHttpReqHelp(Object host);

  /// No description provided for @toolHttpReqName.
  ///
  /// In en, this message translates to:
  /// **'Http Request'**
  String get toolHttpReqName;

  /// No description provided for @tts.
  ///
  /// In en, this message translates to:
  /// **'TTS'**
  String get tts;

  /// No description provided for @unsupported.
  ///
  /// In en, this message translates to:
  /// **'Unsupported'**
  String get unsupported;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{weeks} weeks ago'**
  String weeksAgo(Object weeks);

  /// No description provided for @wrap.
  ///
  /// In en, this message translates to:
  /// **'Wrap'**
  String get wrap;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'id', 'ja', 'nl', 'pt', 'ru', 'tr', 'uk', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'id': return AppLocalizationsId();
    case 'ja': return AppLocalizationsJa();
    case 'nl': return AppLocalizationsNl();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'tr': return AppLocalizationsTr();
    case 'uk': return AppLocalizationsUk();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
