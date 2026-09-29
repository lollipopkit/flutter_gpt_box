// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get attention => '注意';

  @override
  String get auto => '自動';

  @override
  String get autoCheckUpdate => '自動更新チェック';

  @override
  String get autoScrollBottom => '自動で下にスクロール';

  @override
  String get backupTip => 'バックアップファイルのプライバシーと安全性を確保してください！';

  @override
  String get calcTokenLen => 'トークン長を計算';

  @override
  String get chat => 'チャット';

  @override
  String get clickToCheck => 'クリックでチェック';

  @override
  String get codeBlock => 'コードブロック';

  @override
  String get copied => 'コピーしました';

  @override
  String get current => '現在';

  @override
  String delFmt(Object id, Object type) {
    return '$type（$id）を削除しますか？';
  }

  @override
  String get deleteConfirm => '削除前に確認';

  @override
  String emptyFields(Object fields) {
    return '$fieldsが空です';
  }

  @override
  String get emptyTrash => 'ゴミ箱を空にする';

  @override
  String get emptyTrashTip => '==0、次回起動時に削除。<0 自動削除しない。';

  @override
  String get fontSize => 'フォントサイズ';

  @override
  String get fontSizeSettingTip => 'コードブロックにのみ適用されます';

  @override
  String get genChatTitle => 'チャットタイトルを生成';

  @override
  String get history => '履歴';

  @override
  String historyToolHelp(Object keywords) {
    return 'キーワード$keywordsを含むチャットをコンテキストとして読み込みますか？';
  }

  @override
  String get historyToolTip => '履歴チャットをコンテキストとして読み込む';

  @override
  String get httpToolTip => 'HTTP要求を送信、例：コンテンツを検索';

  @override
  String get image => '画像';

  @override
  String invalidLinkFmt(Object uri) {
    return '不明なリンク：$uri';
  }

  @override
  String get joinBeta => 'ベータテストに参加';

  @override
  String get languageName => '日本語';

  @override
  String get license => 'ライセンス';

  @override
  String get licenseMenuItem => 'オープンソースライセンス';

  @override
  String get list => 'リスト';

  @override
  String get manual => '手動';

  @override
  String get memory => 'メモリ';

  @override
  String memoryAdded(Object str) {
    return 'メモリに追加しました：$str';
  }

  @override
  String memoryTip(Object txt) {
    return '[$txt]を記憶しますか？';
  }

  @override
  String get message => 'メッセージ';

  @override
  String get model => 'モデル';

  @override
  String get more => 'もっと';

  @override
  String get myOtherApps => '他のアプリ';

  @override
  String get newChat => '新しいチャット';

  @override
  String get onMsgCome => '新しいメッセージがある時';

  @override
  String get onSwitchChat => '会話を切り替える時';

  @override
  String get passwd => 'パスワード';

  @override
  String get privacy => 'プライバシー';

  @override
  String get privacyTip => 'このアプリは情報を収集しません。';

  @override
  String get rename => '名前変更';

  @override
  String get replay => 'リプレイ';

  @override
  String get share => '共有';

  @override
  String get shareFrom => '共有元';

  @override
  String get softWrap => 'ソフトラップ';

  @override
  String sureRestoreFmt(Object time) {
    return 'バックアップ（$time）を復元してもよろしいですか？';
  }

  @override
  String get switcher => 'スイッチャー';

  @override
  String syncConflict(Object a, Object b) {
    return '競合：$aと$bを同時に有効にすることはできません';
  }

  @override
  String get text => 'テキスト';

  @override
  String get themeColorSeed => 'テーマカラーシード';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get tool => 'ツール';

  @override
  String toolConfirmFmt(Object tool) {
    return 'ツール$toolの使用に同意しますか？';
  }

  @override
  String toolHttpReqHelp(Object host) {
    return 'ネットワークからデータを取得します。今回は$hostに接続します';
  }

  @override
  String get toolHttpReqName => 'HTTP要求';

  @override
  String get untitled => '無題';

  @override
  String get usage => '使用法';

  @override
  String get user => 'ユーザー';

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
