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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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
    Locale('zh', 'TW'),
  ];

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

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

  /// No description provided for @calcTokenLen.
  ///
  /// In en, this message translates to:
  /// **'Calculate tokens length'**
  String get calcTokenLen;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @clickToCheck.
  ///
  /// In en, this message translates to:
  /// **'Click to check'**
  String get clickToCheck;

  /// No description provided for @codeBlock.
  ///
  /// In en, this message translates to:
  /// **'Code block'**
  String get codeBlock;

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

  /// No description provided for @delFmt.
  ///
  /// In en, this message translates to:
  /// **'Delete {type}({id})?'**
  String delFmt(Object id, Object type);

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirmation berfore delete'**
  String get deleteConfirm;

  /// No description provided for @emptyFields.
  ///
  /// In en, this message translates to:
  /// **'{fields} is empty'**
  String emptyFields(Object fields);

  /// No description provided for @emptyTrash.
  ///
  /// In en, this message translates to:
  /// **'Empty recycle bin'**
  String get emptyTrash;

  /// No description provided for @emptyTrashTip.
  ///
  /// In en, this message translates to:
  /// **'==0, delete on next startup. <0 do not delete automatically.'**
  String get emptyTrashTip;

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

  /// No description provided for @genChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat title generator'**
  String get genChatTitle;

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

  /// No description provided for @httpToolTip.
  ///
  /// In en, this message translates to:
  /// **'Send Http request, eg. search web content'**
  String get httpToolTip;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

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

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @myOtherApps.
  ///
  /// In en, this message translates to:
  /// **'My other apps'**
  String get myOtherApps;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get newChat;

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

  /// No description provided for @softWrap.
  ///
  /// In en, this message translates to:
  /// **'Soft wrap'**
  String get softWrap;

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

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

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

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @allowAlways.
  ///
  /// In en, this message translates to:
  /// **'Always allow'**
  String get allowAlways;

  /// No description provided for @trash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// No description provided for @startChatTip.
  ///
  /// In en, this message translates to:
  /// **'Pick a model below and say something.'**
  String get startChatTip;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @noProviderKey.
  ///
  /// In en, this message translates to:
  /// **'No provider has a key yet. Add one to start chatting.'**
  String get noProviderKey;

  /// No description provided for @providers.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providers;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// No description provided for @compacted.
  ///
  /// In en, this message translates to:
  /// **'Earlier messages were summarised'**
  String get compacted;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorite;

  /// No description provided for @defaultModel.
  ///
  /// In en, this message translates to:
  /// **'Default model'**
  String get defaultModel;

  /// No description provided for @titleModel.
  ///
  /// In en, this message translates to:
  /// **'Model for titles'**
  String get titleModel;

  /// No description provided for @systemPrompt.
  ///
  /// In en, this message translates to:
  /// **'System prompt'**
  String get systemPrompt;

  /// No description provided for @compaction.
  ///
  /// In en, this message translates to:
  /// **'Compact long chats'**
  String get compaction;

  /// No description provided for @compactionTip.
  ///
  /// In en, this message translates to:
  /// **'When a chat no longer fits the model\'s context, earlier messages are summarised for the model. You still see all of them.'**
  String get compactionTip;

  /// No description provided for @customProvider.
  ///
  /// In en, this message translates to:
  /// **'Custom provider'**
  String get customProvider;

  /// No description provided for @refreshModels.
  ///
  /// In en, this message translates to:
  /// **'Refresh models'**
  String get refreshModels;

  /// No description provided for @modelsListedTip.
  ///
  /// In en, this message translates to:
  /// **'Optional: the endpoint\'s /models list is fetched. Add ids it does not list.'**
  String get modelsListedTip;

  /// No description provided for @modelsRequired.
  ///
  /// In en, this message translates to:
  /// **'This API cannot list its models: enter at least one model id.'**
  String get modelsRequired;

  /// No description provided for @modelsCountFmt.
  ///
  /// In en, this message translates to:
  /// **'{n} models'**
  String modelsCountFmt(int n);

  /// No description provided for @sameAsChat.
  ///
  /// In en, this message translates to:
  /// **'Same as the chat'**
  String get sameAsChat;

  /// No description provided for @keyInKeychain.
  ///
  /// In en, this message translates to:
  /// **'Stored in the system keychain, never in backups.'**
  String get keyInKeychain;

  /// No description provided for @extraVars.
  ///
  /// In en, this message translates to:
  /// **'Extra variables'**
  String get extraVars;

  /// No description provided for @extraVarsTip.
  ///
  /// In en, this message translates to:
  /// **'KEY=VALUE per line, for providers that need more than a key (Azure resource, Cloudflare account).'**
  String get extraVarsTip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'id',
    'ja',
    'nl',
    'pt',
    'ru',
    'tr',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'nl':
      return AppLocalizationsNl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
