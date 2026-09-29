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
  String get backupTip => 'バックアップファイルのプライバシーと安全性を確保してください！';

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
  String get emptyTrashTip => '==0、次回起動時に削除。<0 自動削除しない。';

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
  String get manual => '手動';

  @override
  String get memory => 'メモリ';

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
  String get passwd => 'パスワード';

  @override
  String get privacy => 'プライバシー';

  @override
  String get privacyTip => 'このアプリは情報を収集しません。';

  @override
  String get rename => '名前変更';

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
  String get deny => '拒否';

  @override
  String get allow => '許可';

  @override
  String get allowAlways => '常に許可';

  @override
  String get trash => 'ゴミ箱';

  @override
  String get startChatTip => '下でモデルを選んで話しかけてください。';

  @override
  String get camera => 'カメラ';

  @override
  String get send => '送信';

  @override
  String get noProviderKey => 'キーが設定されたプロバイダーがまだありません。追加するとチャットを始められます。';

  @override
  String get providers => 'プロバイダー';

  @override
  String get regenerate => '再生成';

  @override
  String get compacted => '以前のメッセージは要約されました';

  @override
  String get favorite => 'お気に入り';

  @override
  String get defaultModel => 'デフォルトモデル';

  @override
  String get titleModel => 'タイトル用モデル';

  @override
  String get systemPrompt => 'システムプロンプト';

  @override
  String get compaction => '長いチャットを圧縮';

  @override
  String get compactionTip =>
      'チャットがモデルのコンテキストに収まらなくなると、以前のメッセージがモデル向けに要約されます。表示上はすべて残ります。';

  @override
  String get customProvider => 'カスタムプロバイダー';

  @override
  String get refreshModels => 'モデルを更新';

  @override
  String get modelsListedTip =>
      '任意：エンドポイントの /models 一覧を取得します。一覧にない ID をここに追加してください。';

  @override
  String get modelsRequired => 'この API はモデル一覧を取得できません。モデル ID を 1 つ以上入力してください。';

  @override
  String modelsCountFmt(int n) {
    return '$n 個のモデル';
  }

  @override
  String get sameAsChat => 'チャットと同じ';

  @override
  String get keyInKeychain => 'システムのキーチェーンに保存され、バックアップには含まれません。';

  @override
  String get extraVars => '追加の変数';

  @override
  String get extraVarsTip =>
      '1 行に 1 つの KEY=VALUE。キー以外の設定が必要なプロバイダー向けです（Azure リソース、Cloudflare アカウント）。';

  @override
  String providersCountFmt(int n) {
    return '$n 個のプロバイダー';
  }

  @override
  String get today => '今日';

  @override
  String get earlier => 'それ以前';

  @override
  String get now => 'たった今';

  @override
  String minutesFmt(int n) {
    return '$n 分';
  }

  @override
  String hoursFmt(int n) {
    return '$n 時間';
  }

  @override
  String messagesCountFmt(int n) {
    return '$n 件のメッセージ';
  }

  @override
  String get thought => '思考';

  @override
  String tokensFmt(String n) {
    return '$n トークン';
  }

  @override
  String allowToolFmt(String tool) {
    return '$tool を許可しますか？';
  }

  @override
  String get replyWaits => '返信はあなたの回答を待っています。';

  @override
  String usableModelsFmt(int n, int m) {
    return '$n 個使用可能 · $m 個のプロバイダー';
  }

  @override
  String get searchModels => 'モデルを検索';

  @override
  String get version => 'バージョン';

  @override
  String get endpoint => 'エンドポイント';

  @override
  String get key => 'キー';

  @override
  String get toolsAndMcp => 'ツールと MCP';

  @override
  String get useTools => 'ツールを使う';

  @override
  String get useToolsTip => '下で許可したもの以外、呼び出しごとに確認します';

  @override
  String get builtIn => '組み込み';

  @override
  String get allowedWithoutAsking => '確認なしで許可';

  @override
  String get mcpServers => 'MCP サーバー';

  @override
  String get addServer => 'サーバーを追加';

  @override
  String connectedFmt(int n) {
    return '接続済み · $n 個のツール';
  }

  @override
  String get disconnected => '未接続';

  @override
  String get deleteKey => 'キーを削除';

  @override
  String moreFmt(int n) {
    return '他 $n 個';
  }

  @override
  String get back => '戻る';

  @override
  String get allProviders => 'すべてのプロバイダー';

  @override
  String get searchProviders => 'プロバイダーを検索';

  @override
  String get backToChats => 'チャットに戻る';

  @override
  String get genChatTitleTip => '最初の返信の後にチャットに名前を付けます';

  @override
  String get scrollOnNewMsg => '新しいメッセージで一番下へスクロール';

  @override
  String get scrollAfterSwitch => 'チャット切り替え後に一番下へスクロール';

  @override
  String chatsCountFmt(int n) {
    return '$n 件のチャット';
  }

  @override
  String get emptyTrashAfter => 'ゴミ箱を空にするまで';

  @override
  String get trashTip => '削除したチャットはまずここに入ります';

  @override
  String daysFmt(int n) {
    return '$n 日';
  }

  @override
  String thoughtForFmt(String time) {
    return '$time 思考';
  }

  @override
  String secondsFmt(String n) {
    return '$n 秒';
  }

  @override
  String minutesSecondsFmt(int m, int s) {
    return '$m 分 $s 秒';
  }

  @override
  String get attachment => '添付ファイル';

  @override
  String get sync => '同期';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get syncing => '同期中…';

  @override
  String get neverSynced => 'まだ同期していません';

  @override
  String lastSyncFmt(String time) {
    return '最終同期：$time';
  }

  @override
  String get syncOffTip => '下で iCloud または WebDAV をオンにすると自動で同期します。';

  @override
  String get backupPassword => 'バックアップのパスワード';

  @override
  String get backupEncrypted => 'バックアップはこれで暗号化されます';

  @override
  String get backupNotEncrypted => '未設定：ファイルのバックアップは平文になり、同期には必要です';

  @override
  String get backupEncryptedTip => 'このバックアップは暗号化されています';

  @override
  String get backupPasswordRequired =>
      '先にバックアップのパスワードを設定してください。同期するバックアップは常に暗号化されます';

  @override
  String get passwordWrong => 'パスワードが違うか、バックアップが壊れています';

  @override
  String get backupTooNew => 'このバックアップは新しいバージョンのアプリで作成されました。復元するには更新してください。';

  @override
  String get syncAppSettings => 'アプリの設定を同期';

  @override
  String get syncAppSettingsTip => 'ウィンドウサイズとタイトルバーは端末ごとに保持されます';

  @override
  String get webdavManualTip => '同期ファイルの横に日付付きのコピー';

  @override
  String get exportFile => 'ファイルに書き出す';

  @override
  String get importFile => 'ファイルから復元';

  @override
  String get copyBackup => 'クリップボードにコピー';

  @override
  String get pasteBackup => 'クリップボードから復元';

  @override
  String get memoryView => 'メモリを読む';

  @override
  String get memorySearch => 'メモリを検索';

  @override
  String get memoryWrite => 'メモリを保存';

  @override
  String get memoryEdit => 'メモリを編集';

  @override
  String get memoryDelete => 'メモリを削除';

  @override
  String get memoryMove => 'メモリを移動';

  @override
  String get memoryToolTip => 'モデルがチャットをまたいで保持するファイル。確認なしで読み書きします';

  @override
  String charsFmt(int n) {
    return '$n 文字';
  }

  @override
  String alreadyExists(String path) {
    return '$path は既に存在します';
  }

  @override
  String get unsavedChanges => '離れる前に変更を保存しますか?';

  @override
  String get discard => '破棄';
}
