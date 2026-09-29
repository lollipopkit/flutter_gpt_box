// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get attention => '注意';

  @override
  String get auto => '自动';

  @override
  String get autoCheckUpdate => '自动检查更新';

  @override
  String get backupTip => '请保证备份文件私密且安全！';

  @override
  String get chat => '聊天';

  @override
  String get clickToCheck => '点击检查';

  @override
  String get codeBlock => '代码区块';

  @override
  String get copied => '已复制';

  @override
  String get current => '当前';

  @override
  String delFmt(Object id, Object type) {
    return '删除 $type（$id）？';
  }

  @override
  String get deleteConfirm => '删除前确认';

  @override
  String emptyFields(Object fields) {
    return '$fields 为空';
  }

  @override
  String get emptyTrashTip => '==0，下次启动时删除。<0 不自动删除。';

  @override
  String get genChatTitle => '生成聊天标题';

  @override
  String get history => '历史';

  @override
  String historyToolHelp(Object keywords) {
    return '加载包含关键字 $keywords 的聊天作为上下文？';
  }

  @override
  String get historyToolTip => '加载历史聊天作为上下文';

  @override
  String get httpToolTip => '发起 Http 请求，例如：搜索内容';

  @override
  String get image => '图片';

  @override
  String invalidLinkFmt(Object uri) {
    return '未知链接：$uri';
  }

  @override
  String get joinBeta => '参与Beta版测试';

  @override
  String get languageName => '简体中文';

  @override
  String get license => '许可证';

  @override
  String get licenseMenuItem => '开放源代码许可';

  @override
  String get manual => '手动';

  @override
  String get memory => '记忆';

  @override
  String get message => '消息';

  @override
  String get model => '模型';

  @override
  String get more => '更多';

  @override
  String get myOtherApps => '我的其它 App';

  @override
  String get newChat => '新建聊天';

  @override
  String get passwd => '密码';

  @override
  String get privacy => '隐私';

  @override
  String get privacyTip => '此 app 不搜集任何信息。';

  @override
  String get rename => '重命名';

  @override
  String get share => '分享';

  @override
  String get shareFrom => '分享自';

  @override
  String get softWrap => '自动换行';

  @override
  String sureRestoreFmt(Object time) {
    return '确定恢复备份（$time）？';
  }

  @override
  String syncConflict(Object a, Object b) {
    return '冲突：不能同时开启 $a 和 $b';
  }

  @override
  String get text => '文字';

  @override
  String get themeColorSeed => '主题颜色种子';

  @override
  String get themeMode => '主题模式';

  @override
  String get tool => '工具';

  @override
  String toolHttpReqHelp(Object host) {
    return '将会与从网络获取数据，本次将会联系 $host';
  }

  @override
  String get toolHttpReqName => 'Http 请求';

  @override
  String get untitled => '未命名';

  @override
  String get usage => '用法';

  @override
  String get user => '用户';

  @override
  String get deny => '拒绝';

  @override
  String get allow => '允许';

  @override
  String get allowAlways => '始终允许';

  @override
  String get trash => '回收站';

  @override
  String get startChatTip => '在下方选择模型，然后开始对话。';

  @override
  String get camera => '相机';

  @override
  String get send => '发送';

  @override
  String get noProviderKey => '还没有任何服务商配置了 key，添加一个即可开始对话。';

  @override
  String get providers => '服务商';

  @override
  String get regenerate => '重新生成';

  @override
  String get compacted => '较早的消息已被总结';

  @override
  String get favorite => '收藏';

  @override
  String get defaultModel => '默认模型';

  @override
  String get titleModel => '生成标题的模型';

  @override
  String get systemPrompt => '系统提示词';

  @override
  String get compaction => '压缩长对话';

  @override
  String get compactionTip => '对话超出模型上下文时，较早的消息会被总结后发给模型；你仍然能看到全部消息。';

  @override
  String get customProvider => '自定义服务商';

  @override
  String get refreshModels => '刷新模型';

  @override
  String get modelsListedTip => '可选：会自动获取端点 /models 的模型列表，此处补充其中没有的 ID。';

  @override
  String get modelsRequired => '该 API 无法获取模型列表，请至少填写一个模型 ID。';

  @override
  String modelsCountFmt(int n) {
    return '$n 个模型';
  }

  @override
  String get sameAsChat => '与对话相同';

  @override
  String get keyInKeychain => '保存在系统钥匙串中，不会进入备份。';

  @override
  String get extraVars => '额外变量';

  @override
  String get extraVarsTip =>
      '每行一个 KEY=VALUE，用于需要不止一个 key 的服务商（如 Azure 资源、Cloudflare 账号）。';

  @override
  String providersCountFmt(int n) {
    return '$n 个服务商';
  }

  @override
  String get today => '今天';

  @override
  String get earlier => '更早';

  @override
  String get now => '刚刚';

  @override
  String minutesFmt(int n) {
    return '$n 分钟';
  }

  @override
  String hoursFmt(int n) {
    return '$n 小时';
  }

  @override
  String messagesCountFmt(int n) {
    return '$n 条消息';
  }

  @override
  String get thought => '已思考';

  @override
  String tokensFmt(String n) {
    return '$n tokens';
  }

  @override
  String allowToolFmt(String tool) {
    return '允许$tool？';
  }

  @override
  String get replyWaits => '回复会等待你的决定。';

  @override
  String usableModelsFmt(int n, int m) {
    return '$n 个可用 · $m 个服务商';
  }

  @override
  String get searchModels => '搜索模型';

  @override
  String get version => '版本';

  @override
  String get endpoint => '端点';

  @override
  String get key => '密钥';

  @override
  String get toolsAndMcp => '工具与 MCP';

  @override
  String get useTools => '使用工具';

  @override
  String get useToolsTip => '每次调用都会先询问，除非已在下方允许';

  @override
  String get builtIn => '内置';

  @override
  String get allowedWithoutAsking => '无需询问即可使用';

  @override
  String get mcpServers => 'MCP 服务器';

  @override
  String get addServer => '添加服务器';

  @override
  String connectedFmt(int n) {
    return '已连接 · $n 个工具';
  }

  @override
  String get disconnected => '未连接';

  @override
  String get deleteKey => '删除密钥';

  @override
  String moreFmt(int n) {
    return '还有 $n 个';
  }

  @override
  String get back => '返回';

  @override
  String get allProviders => '全部服务商';

  @override
  String get searchProviders => '搜索服务商';

  @override
  String get backToChats => '返回对话';

  @override
  String get genChatTitleTip => '在首次回复后为对话命名';

  @override
  String get scrollOnNewMsg => '新消息时滚动到底部';

  @override
  String get scrollAfterSwitch => '切换对话后滚动到底部';

  @override
  String chatsCountFmt(int n) {
    return '$n 个对话';
  }

  @override
  String get emptyTrashAfter => '清空回收站间隔';

  @override
  String get trashTip => '删除的对话会先放在这里';

  @override
  String daysFmt(int n) {
    return '$n 天';
  }

  @override
  String thoughtForFmt(String time) {
    return '思考了 $time';
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
  String get attachment => '附件';

  @override
  String get sync => '同步';

  @override
  String get syncNow => '立即同步';

  @override
  String get syncing => '同步中…';

  @override
  String get neverSynced => '尚未同步';

  @override
  String lastSyncFmt(String time) {
    return '上次同步：$time';
  }

  @override
  String get syncOffTip => '在下方开启 iCloud 或 WebDAV 以自动同步。';

  @override
  String get backupPassword => '备份密码';

  @override
  String get backupEncrypted => '备份将用它加密';

  @override
  String get backupNotEncrypted => '未设置：文件备份为明文，且同步需要密码';

  @override
  String get backupEncryptedTip => '此备份已加密';

  @override
  String get backupPasswordRequired => '请先设置备份密码：同步的备份始终加密';

  @override
  String get passwordWrong => '密码错误，或备份已损坏';

  @override
  String get backupTooNew => '此备份来自更新版本的应用，请更新后再恢复。';

  @override
  String get syncAppSettings => '同步应用设置';

  @override
  String get syncAppSettingsTip => '窗口大小和标题栏始终按设备保存';

  @override
  String get webdavManualTip => '在同步文件旁保存带日期的副本';

  @override
  String get exportFile => '导出到文件';

  @override
  String get importFile => '从文件恢复';

  @override
  String get copyBackup => '复制到剪贴板';

  @override
  String get pasteBackup => '从剪贴板恢复';

  @override
  String get memoryView => '读取记忆';

  @override
  String get memorySearch => '搜索记忆';

  @override
  String get memoryWrite => '保存记忆';

  @override
  String get memoryEdit => '编辑记忆';

  @override
  String get memoryDelete => '删除记忆';

  @override
  String get memoryMove => '移动记忆';

  @override
  String get memoryToolTip => '模型跨对话保存的文件,读写无需确认';

  @override
  String charsFmt(int n) {
    return '$n 字符';
  }

  @override
  String alreadyExists(String path) {
    return '$path 已存在';
  }

  @override
  String get unsavedChanges => '离开前保存更改?';

  @override
  String get discard => '放弃';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get attention => '注意';

  @override
  String get auto => '自動';

  @override
  String get autoCheckUpdate => '自動檢查更新';

  @override
  String get backupTip => '請確保備份檔案私密且安全！';

  @override
  String get chat => '聊天';

  @override
  String get clickToCheck => '點擊檢查';

  @override
  String get codeBlock => '程式碼區塊';

  @override
  String get copied => '已複製';

  @override
  String get current => '當前';

  @override
  String delFmt(Object id, Object type) {
    return '刪除 $type（$id）？';
  }

  @override
  String get deleteConfirm => '刪除前確認';

  @override
  String emptyFields(Object fields) {
    return '$fields 為空';
  }

  @override
  String get emptyTrashTip => '==0，下次啟動時刪除。<0 不自動刪除。';

  @override
  String get genChatTitle => '生成聊天標題';

  @override
  String get history => '歷史';

  @override
  String historyToolHelp(Object keywords) {
    return '載入包含關鍵字 $keywords 的聊天作為上下文？';
  }

  @override
  String get historyToolTip => '載入歷史聊天作為上下文';

  @override
  String get httpToolTip => '發起 Http 請求，例如：搜索內容';

  @override
  String get image => '圖片';

  @override
  String invalidLinkFmt(Object uri) {
    return '未知連結：$uri';
  }

  @override
  String get joinBeta => '參與Beta版測試';

  @override
  String get languageName => '繁體中文';

  @override
  String get license => '許可證';

  @override
  String get licenseMenuItem => '開放源碼許可';

  @override
  String get manual => '手動';

  @override
  String get memory => '記憶';

  @override
  String get message => '訊息';

  @override
  String get model => '模型';

  @override
  String get more => '更多';

  @override
  String get myOtherApps => '我的其它 App';

  @override
  String get newChat => '新建聊天';

  @override
  String get passwd => '密碼';

  @override
  String get privacy => '隱私';

  @override
  String get privacyTip => '此 app 不蒐集任何資訊。';

  @override
  String get rename => '重新命名';

  @override
  String get share => '分享';

  @override
  String get shareFrom => '分享自';

  @override
  String get softWrap => '自動換行';

  @override
  String sureRestoreFmt(Object time) {
    return '確定恢復備份（$time）？';
  }

  @override
  String syncConflict(Object a, Object b) {
    return '衝突：不能同時開啟 $a 和 $b';
  }

  @override
  String get text => '文字';

  @override
  String get themeColorSeed => '主題顏色種子';

  @override
  String get themeMode => '主題模式';

  @override
  String get tool => '工具';

  @override
  String toolHttpReqHelp(Object host) {
    return '將會與從網路獲取數據，本次將會聯絡 $host';
  }

  @override
  String get toolHttpReqName => 'Http 請求';

  @override
  String get untitled => '未命名';

  @override
  String get usage => '用法';

  @override
  String get user => '使用者';

  @override
  String get deny => '拒絕';

  @override
  String get allow => '允許';

  @override
  String get allowAlways => '一律允許';

  @override
  String get trash => '垃圾桶';

  @override
  String get startChatTip => '在下方選擇模型，然後開始對話。';

  @override
  String get camera => '相機';

  @override
  String get send => '傳送';

  @override
  String get noProviderKey => '還沒有服務商設定了金鑰。新增一個即可開始聊天。';

  @override
  String get providers => '服務商';

  @override
  String get regenerate => '重新生成';

  @override
  String get compacted => '較早的訊息已被摘要';

  @override
  String get favorite => '收藏';

  @override
  String get defaultModel => '預設模型';

  @override
  String get titleModel => '標題模型';

  @override
  String get systemPrompt => '系統提示詞';

  @override
  String get compaction => '壓縮長對話';

  @override
  String get compactionTip => '當對話超出模型的上下文時，較早的訊息會為模型摘要。你仍可看到全部訊息。';

  @override
  String get customProvider => '自訂服務商';

  @override
  String get refreshModels => '重新整理模型';

  @override
  String get modelsListedTip => '可選：會自動取得端點 /models 的模型清單，此處補充其中沒有的 ID。';

  @override
  String get modelsRequired => '此 API 無法取得模型清單，請至少填寫一個模型 ID。';

  @override
  String modelsCountFmt(int n) {
    return '$n 個模型';
  }

  @override
  String get sameAsChat => '與對話相同';

  @override
  String get keyInKeychain => '儲存在系統鑰匙圈中，不會進入備份。';

  @override
  String get extraVars => '額外變數';

  @override
  String get extraVarsTip =>
      '每行一個 KEY=VALUE，用於除金鑰外還需要其他設定的服務商（Azure 資源、Cloudflare 帳號）。';

  @override
  String providersCountFmt(int n) {
    return '$n 個服務商';
  }

  @override
  String get today => '今天';

  @override
  String get earlier => '更早';

  @override
  String get now => '剛剛';

  @override
  String minutesFmt(int n) {
    return '$n 分鐘';
  }

  @override
  String hoursFmt(int n) {
    return '$n 小時';
  }

  @override
  String messagesCountFmt(int n) {
    return '$n 則訊息';
  }

  @override
  String get thought => '已思考';

  @override
  String tokensFmt(String n) {
    return '$n tokens';
  }

  @override
  String allowToolFmt(String tool) {
    return '允許$tool？';
  }

  @override
  String get replyWaits => '回覆會等待你的決定。';

  @override
  String usableModelsFmt(int n, int m) {
    return '$n 個可用 · $m 個服務商';
  }

  @override
  String get searchModels => '搜尋模型';

  @override
  String get version => '版本';

  @override
  String get endpoint => '端點';

  @override
  String get key => '金鑰';

  @override
  String get toolsAndMcp => '工具與 MCP';

  @override
  String get useTools => '使用工具';

  @override
  String get useToolsTip => '每次呼叫都會先詢問，除非已在下方允許';

  @override
  String get builtIn => '內建';

  @override
  String get allowedWithoutAsking => '無需詢問即可使用';

  @override
  String get mcpServers => 'MCP 伺服器';

  @override
  String get addServer => '新增伺服器';

  @override
  String connectedFmt(int n) {
    return '已連線 · $n 個工具';
  }

  @override
  String get disconnected => '未連線';

  @override
  String get deleteKey => '刪除金鑰';

  @override
  String moreFmt(int n) {
    return '還有 $n 個';
  }

  @override
  String get back => '返回';

  @override
  String get allProviders => '全部服務商';

  @override
  String get searchProviders => '搜尋服務商';

  @override
  String get backToChats => '返回對話';

  @override
  String get genChatTitleTip => '在首次回覆後為對話命名';

  @override
  String get scrollOnNewMsg => '新訊息時捲動到底部';

  @override
  String get scrollAfterSwitch => '切換對話後捲動到底部';

  @override
  String chatsCountFmt(int n) {
    return '$n 個對話';
  }

  @override
  String get emptyTrashAfter => '清空垃圾桶間隔';

  @override
  String get trashTip => '刪除的對話會先放在這裡';

  @override
  String daysFmt(int n) {
    return '$n 天';
  }

  @override
  String thoughtForFmt(String time) {
    return '思考了 $time';
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
  String get attachment => '附件';

  @override
  String get sync => '同步';

  @override
  String get syncNow => '立即同步';

  @override
  String get syncing => '同步中…';

  @override
  String get neverSynced => '尚未同步';

  @override
  String lastSyncFmt(String time) {
    return '上次同步：$time';
  }

  @override
  String get syncOffTip => '在下方開啟 iCloud 或 WebDAV 以自動同步。';

  @override
  String get backupPassword => '備份密碼';

  @override
  String get backupEncrypted => '備份將用它加密';

  @override
  String get backupNotEncrypted => '未設定：檔案備份為明文，且同步需要密碼';

  @override
  String get backupEncryptedTip => '此備份已加密';

  @override
  String get backupPasswordRequired => '請先設定備份密碼：同步的備份一律加密';

  @override
  String get passwordWrong => '密碼錯誤，或備份已損壞';

  @override
  String get backupTooNew => '此備份來自較新版本的應用程式，請更新後再還原。';

  @override
  String get syncAppSettings => '同步應用程式設定';

  @override
  String get syncAppSettingsTip => '視窗大小和標題列始終依裝置保存';

  @override
  String get webdavManualTip => '在同步檔案旁保存帶日期的副本';

  @override
  String get exportFile => '匯出到檔案';

  @override
  String get importFile => '從檔案還原';

  @override
  String get copyBackup => '複製到剪貼簿';

  @override
  String get pasteBackup => '從剪貼簿還原';

  @override
  String get memoryView => '讀取記憶';

  @override
  String get memorySearch => '搜尋記憶';

  @override
  String get memoryWrite => '儲存記憶';

  @override
  String get memoryEdit => '編輯記憶';

  @override
  String get memoryDelete => '刪除記憶';

  @override
  String get memoryMove => '移動記憶';

  @override
  String get memoryToolTip => '模型跨對話保存的檔案,讀寫無需確認';

  @override
  String charsFmt(int n) {
    return '$n 字元';
  }

  @override
  String alreadyExists(String path) {
    return '$path 已存在';
  }

  @override
  String get unsavedChanges => '離開前儲存變更?';

  @override
  String get discard => '捨棄';
}
