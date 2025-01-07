import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get apiUrlV1Tip => 'https://api.openai.com/v1に似ています（最後の /v1 が必要）。このURLを引き続き使用しますか？';

  @override
  String get assistant => 'アシスタント';

  @override
  String get attention => '注意';

  @override
  String get audio => 'オーディオ';

  @override
  String get auto => '自動';

  @override
  String get autoCheckUpdate => '自動更新チェック';

  @override
  String get autoRmDupChat => '重複チャットを自動削除';

  @override
  String get autoScrollBottom => '自動で下にスクロール';

  @override
  String get backupTip => 'バックアップファイルのプライバシーと安全性を確保してください！';

  @override
  String get balance => '残高';

  @override
  String get calcTokenLen => 'トークン長を計算';

  @override
  String get changeModelTip => '異なるキーで利用可能なモデルリストが異なる場合があります。メカニズムがわからない場合やエラーが発生する場合は、モデルを再設定することをお勧めします。';

  @override
  String get chat => 'チャット';

  @override
  String get chatHistoryLength => 'チャット履歴の長さ';

  @override
  String get chatHistoryTip => 'チャットのコンテキストとして使用';

  @override
  String get clickSwitch => 'クリックで切り替え';

  @override
  String get clickToCheck => 'クリックでチェック';

  @override
  String get clipboard => 'クリップボード';

  @override
  String get codeBlock => 'コードブロック';

  @override
  String get colorSeedTip => 'これは色のシードであり、色そのものではありません';

  @override
  String get compress => '圧縮';

  @override
  String get compressImgTip => 'チャットと共有用';

  @override
  String get contributor => '貢献者';

  @override
  String get copied => 'コピーしました';

  @override
  String get current => '現在';

  @override
  String get custom => 'カスタム';

  @override
  String get day => '日';

  @override
  String get defaulT => 'デフォルト';

  @override
  String delFmt(Object id, Object type) {
    return '$type（$id）を削除しますか？';
  }

  @override
  String get delete => '削除';

  @override
  String get deleteConfirm => '削除前に確認';

  @override
  String get editor => 'エディタ';

  @override
  String emptyFields(Object fields) {
    return '$fieldsが空です';
  }

  @override
  String fileNotFound(Object file) {
    return 'ファイル（$file）が見つかりません';
  }

  @override
  String fileTooLarge(Object size) {
    return 'ファイルが大きすぎます：$size';
  }

  @override
  String get followChatModel => 'チャットモデルに従う';

  @override
  String get fontSize => 'フォントサイズ';

  @override
  String get fontSizeSettingTip => 'コードブロックにのみ適用されます';

  @override
  String get freeCopy => '自由にコピー';

  @override
  String get genChatTitle => 'チャットタイトルを生成';

  @override
  String get genTitle => 'タイトル生成';

  @override
  String get headTailMode => 'ヘッドテールモード';

  @override
  String get headTailModeTip => '`プロンプト+最初のユーザーメッセージ+現在の入力`のみをコンテキストとして送信します。\n\nこれは会話の翻訳に特に有用です（トークンを節約できます）。';

  @override
  String get help => 'ヘルプ';

  @override
  String get history => '履歴';

  @override
  String historyToolHelp(Object keywords) {
    return 'キーワード$keywordsを含むチャットをコンテキストとして読み込みますか？';
  }

  @override
  String get historyToolTip => '履歴チャットをコンテキストとして読み込む';

  @override
  String get hour => '時間';

  @override
  String get httpToolTip => 'HTTP要求を送信、例：コンテンツを検索';

  @override
  String get ignoreContextConstraint => 'コンテキスト制約を無視';

  @override
  String get ignoreTip => 'ヒントを無視';

  @override
  String get image => '画像';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 ヒント\n- チャット画面でオーバースクロールすると、チャット履歴を素早く切り替えられます\n- チャットテキストを長押しすると、Markdownソースを自由に選択してコピーできます\n- URL Schemeの使用方法は[こちら]($unilink)で確認できます\n\n### 🔍 ヘルプ\n- GPT Boxにバグがある場合は、[Github Issue]($issue)を使用してください\n- Telegram `@lpktg`';
  }

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
  String get migrationV1UrlTip => '設定の末尾に自動的に\"/v1\"を追加すべきですか？';

  @override
  String get minute => '分';

  @override
  String get model => 'モデル';

  @override
  String get modelRegExpTip => 'モデル名が一致する場合、ツールを使用します';

  @override
  String get more => 'もっと';

  @override
  String get multiModel => 'マルチモーダル';

  @override
  String get myOtherApps => '他のアプリ';

  @override
  String get needOpenAIKey => 'OpenAIキーを先に入力してください';

  @override
  String get needRestart => '適用には再起動が必要です';

  @override
  String get newChat => '新しいチャット';

  @override
  String get noDuplication => '重複はありません';

  @override
  String notSupported(Object val) {
    return '$valはサポートされていません';
  }

  @override
  String get onMsgCome => '新しいメッセージがある時';

  @override
  String get onSwitchChat => '会話を切り替える時';

  @override
  String get onlyRestoreHistory => 'チャット履歴のみを復元（API URLと秘密キーは復元しない）';

  @override
  String get onlySyncOnLaunch => '起動時のみ同期';

  @override
  String get other => 'その他';

  @override
  String get participant => '参加者';

  @override
  String get passwd => 'パスワード';

  @override
  String get privacy => 'プライバシー';

  @override
  String get privacyTip => 'このアプリは情報を収集しません。';

  @override
  String get profile => 'プロフィール';

  @override
  String get promptsSettingsItem => 'プロンプト';

  @override
  String get raw => '生データ';

  @override
  String get refresh => '更新';

  @override
  String get regExp => '正規表現';

  @override
  String get remember30s => '30秒間記憶';

  @override
  String get rename => '名前変更';

  @override
  String get replay => 'リプレイ';

  @override
  String get replayTip => '再生されたメッセージとそれ以降のすべてのメッセージがクリアされます';

  @override
  String get res => 'リソース';

  @override
  String restoreOpenaiTip(Object url) {
    return 'ドキュメントは[こちら]($url)で見つけられます';
  }

  @override
  String get rmDuplication => '重複を削除';

  @override
  String rmDuplicationFmt(Object count) {
    return '[$count]個の重複項目を削除してもよろしいですか？';
  }

  @override
  String get route => 'ルート';

  @override
  String get save => '保存';

  @override
  String get saveErrChat => 'エラーチャットを保存';

  @override
  String get saveErrChatTip => 'エラーがあっても、各メッセージの受信/送信後に保存します';

  @override
  String get scrollSwitchChat => 'スクロールでチャットを切り替え';

  @override
  String get search => '検索';

  @override
  String get secretKey => 'シークレットキー';

  @override
  String get share => '共有';

  @override
  String get shareFrom => '共有元';

  @override
  String get skipSameTitle => 'ローカルチャットと同じタイトルのチャットをスキップ';

  @override
  String get softWrap => 'ソフトラップ';

  @override
  String get stt => '音声からテキスト';

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
  String get system => 'システム';

  @override
  String get text => 'テキスト';

  @override
  String get themeColorSeed => 'テーマカラーシード';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get thirdParty => 'サードパーティ';

  @override
  String get tool => 'ツール';

  @override
  String toolConfirmFmt(Object tool) {
    return 'ツール$toolの使用に同意しますか？';
  }

  @override
  String get toolFinishTip => 'ツール呼び出しが完了しました';

  @override
  String toolHttpReqHelp(Object host) {
    return 'ネットワークからデータを取得します。今回は$hostに接続します';
  }

  @override
  String get toolHttpReqName => 'HTTP要求';

  @override
  String get tts => 'テキストから音声';

  @override
  String get unsupported => 'サポートされていません';

  @override
  String get untitled => '無題';

  @override
  String get update => '更新';

  @override
  String get usage => '使用法';

  @override
  String get user => 'ユーザー';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks週間前';
  }

  @override
  String get wrap => 'ラップ';
}
