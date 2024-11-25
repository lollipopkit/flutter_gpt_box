import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get apiUrlV1Tip => '类似 `https://api.openai.com/v1`（需要最后的 `/v1`）。继续使用该 URL 吗？';

  @override
  String get assistant => '助手';

  @override
  String get attention => '注意';

  @override
  String get audio => '音频';

  @override
  String get auto => '自动';

  @override
  String get autoCheckUpdate => '自动检查更新';

  @override
  String get autoRmDupChat => '自动删除重复聊天';

  @override
  String get autoScrollBottom => '自动滚动到底部';

  @override
  String get backupTip => '请保证备份文件私密且安全！';

  @override
  String get balance => '余额';

  @override
  String get calcTokenLen => '计算 Tokens 长度';

  @override
  String get changeModelTip => '不同密钥可能能访问的模型列表不同，如果不了解机制并且出现错误，建议重新设置模型。';

  @override
  String get chat => '聊天';

  @override
  String get chatHistoryLength => '聊天历史长度';

  @override
  String get chatHistoryTip => '用作聊天上下文';

  @override
  String get clickSwitch => '点击切换';

  @override
  String get clickToCheck => '点击检查';

  @override
  String get clipboard => '剪切板';

  @override
  String get codeBlock => '代码区块';

  @override
  String get colorSeedTip => '这是颜色种子，不是颜色';

  @override
  String get compress => '压缩';

  @override
  String get compressImgTip => '用于聊天和分享';

  @override
  String get contributor => '贡献者';

  @override
  String get copied => '已复制';

  @override
  String get current => '当前';

  @override
  String get custom => '自定义';

  @override
  String get day => '天';

  @override
  String get defaulT => '默认';

  @override
  String delFmt(Object id, Object type) {
    return '删除 $type（$id）？';
  }

  @override
  String get delete => '删除';

  @override
  String get deleteConfirm => '删除前确认';

  @override
  String get editor => '编辑器';

  @override
  String emptyFields(Object fields) {
    return '$fields 为空';
  }

  @override
  String fileNotFound(Object file) {
    return '文件（$file）未能找到';
  }

  @override
  String fileTooLarge(Object size) {
    return '文件过大：$size';
  }

  @override
  String get followChatModel => '跟随聊天模型';

  @override
  String get fontSize => '字体大小';

  @override
  String get fontSizeSettingTip => '仅对代码块生效';

  @override
  String get freeCopy => '自由复制';

  @override
  String get genChatTitle => '生成聊天标题';

  @override
  String get genTitle => '生成标题';

  @override
  String get headTailMode => '头尾模式';

  @override
  String get headTailModeTip => '仅发送 `提示词+第一条用户信息+当前输入` 作为上下文。\n\n这在用于翻译对话时特别有用（可以节省 tokens）。';

  @override
  String get help => '帮助';

  @override
  String get history => '历史';

  @override
  String historyToolHelp(Object keywords) {
    return '加载包含关键字 $keywords 的聊天作为上下文？';
  }

  @override
  String get historyToolTip => '加载历史聊天作为上下文';

  @override
  String get hour => '小时';

  @override
  String get httpToolTip => '发起 Http 请求，例如：搜索内容';

  @override
  String get ignoreContextConstraint => '忽略上下文限制';

  @override
  String get ignoreTip => '忽略提示';

  @override
  String get image => '图片';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 提示\n- 在聊天界面过度滑动（overscroll）可以快捷切换聊天历史记录\n- 长按聊天文字自由选中复制Markdown源\n- URL Scheme 用法可以在 [这里]($unilink)\n\n### 🔍 帮助\n- 如果 GPT Box 有 bug，请使用 [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

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
  String get list => '列表';

  @override
  String get manual => '手动';

  @override
  String get memory => '记忆';

  @override
  String memoryAdded(Object str) {
    return '记忆已添加: $str';
  }

  @override
  String memoryTip(Object txt) {
    return '记住 [$txt]?';
  }

  @override
  String get message => '消息';

  @override
  String get migrationV1UrlTip => '是否自动在配置的末尾添加\"/v1\"？';

  @override
  String get minute => '分钟';

  @override
  String get model => '模型';

  @override
  String get modelRegExpTip => '如果模型名匹配，则使用 Tools';

  @override
  String get more => '更多';

  @override
  String get multiModel => '多模态';

  @override
  String get myOtherApps => '我的其它 App';

  @override
  String get needOpenAIKey => '请先输入 OpenAI 密钥';

  @override
  String get needRestart => '需要重启来应用';

  @override
  String get newChat => '新建聊天';

  @override
  String get noDuplication => '没有重复项目';

  @override
  String notSupported(Object val) {
    return '$val 不支持';
  }

  @override
  String get onMsgCome => '当有新消息';

  @override
  String get onSwitchChat => '当切换对话';

  @override
  String get onlyRestoreHistory => '仅恢复历史聊天（不恢复 API Url 和 Secret Key）';

  @override
  String get onlySyncOnLaunch => '仅在启动时同步';

  @override
  String get other => '其他';

  @override
  String get participant => '参与者';

  @override
  String get passwd => '密码';

  @override
  String get privacy => '隐私';

  @override
  String get privacyTip => '此 app 不搜集任何信息。';

  @override
  String get profile => '配置';

  @override
  String get promptsSettingsItem => '提示词';

  @override
  String get raw => '原始';

  @override
  String get refresh => '刷新';

  @override
  String get regExp => '正则表达式';

  @override
  String get remember30s => '记住 30 秒';

  @override
  String get rename => '重命名';

  @override
  String get replay => '重放';

  @override
  String get replayTip => '会清空被重放的消息、后面所有消息';

  @override
  String get res => '资源';

  @override
  String restoreOpenaiTip(Object url) {
    return '文档可以在 [这里]($url) 找到';
  }

  @override
  String get rmDuplication => '删除重复';

  @override
  String rmDuplicationFmt(Object count) {
    return '确定要删除 [$count]个重复项目吗？';
  }

  @override
  String get route => '路由';

  @override
  String get save => '保存';

  @override
  String get saveErrChat => '保存聊天错误';

  @override
  String get saveErrChatTip => '在接收/发送每条消息后保存，即使有报错';

  @override
  String get scrollSwitchChat => '上下滑动切换聊天';

  @override
  String get search => '搜索';

  @override
  String get secretKey => '密钥';

  @override
  String get share => '分享';

  @override
  String get shareFrom => '分享自';

  @override
  String get skipSameTitle => '跳过有与本地聊天相同标题的聊天';

  @override
  String get softWrap => '自动换行';

  @override
  String get stt => '语音转文字';

  @override
  String sureRestoreFmt(Object time) {
    return '确定恢复备份（$time）？';
  }

  @override
  String get switcher => '开关';

  @override
  String syncConflict(Object a, Object b) {
    return '冲突：不能同时开启 $a 和 $b';
  }

  @override
  String get system => '系统';

  @override
  String get text => '文字';

  @override
  String get themeColorSeed => '主题颜色种子';

  @override
  String get themeMode => '主题模式';

  @override
  String get thirdParty => '第三方';

  @override
  String get tool => '工具';

  @override
  String toolConfirmFmt(Object tool) {
    return '是否同意使用工具 $tool ？';
  }

  @override
  String get toolFinishTip => '工具调用完成';

  @override
  String toolHttpReqHelp(Object host) {
    return '将会与从网络获取数据，本次将会联系 $host';
  }

  @override
  String get toolHttpReqName => 'Http 请求';

  @override
  String get tts => '文字转语音';

  @override
  String get unsupported => '不支持';

  @override
  String get untitled => '未命名';

  @override
  String get update => '更新';

  @override
  String get usage => '用法';

  @override
  String get user => '用户';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks 周前';
  }

  @override
  String get wrap => '换行';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get apiUrlV1Tip => '類似 https://api.openai.com/v1（需要最後的 /v1）。繼續使用該 URL 嗎？';

  @override
  String get assistant => '助手';

  @override
  String get attention => '注意';

  @override
  String get audio => '音訊';

  @override
  String get auto => '自動';

  @override
  String get autoCheckUpdate => '自動檢查更新';

  @override
  String get autoRmDupChat => '自動刪除重複聊天';

  @override
  String get autoScrollBottom => '自動捲動到底部';

  @override
  String get backupTip => '請確保備份檔案私密且安全！';

  @override
  String get balance => '餘額';

  @override
  String get calcTokenLen => '計算 Tokens 長度';

  @override
  String get changeModelTip => '不同密鑰可能能存取的模型列表不同，如果不了解機制並且出現錯誤，建議重新設置模型。';

  @override
  String get chat => '聊天';

  @override
  String get chatHistoryLength => '聊天歷史長度';

  @override
  String get chatHistoryTip => '用作聊天上下文';

  @override
  String get clickSwitch => '點擊切換';

  @override
  String get clickToCheck => '點擊檢查';

  @override
  String get clipboard => '剪貼簿';

  @override
  String get codeBlock => '程式碼區塊';

  @override
  String get colorSeedTip => '這是顏色種子，不是顏色';

  @override
  String get compress => '壓縮';

  @override
  String get compressImgTip => '用於聊天和分享';

  @override
  String get contributor => '貢獻者';

  @override
  String get copied => '已複製';

  @override
  String get current => '當前';

  @override
  String get custom => '自定義';

  @override
  String get day => '天';

  @override
  String get defaulT => '預設';

  @override
  String delFmt(Object id, Object type) {
    return '刪除 $type（$id）？';
  }

  @override
  String get delete => '刪除';

  @override
  String get deleteConfirm => '刪除前確認';

  @override
  String get editor => '編輯器';

  @override
  String emptyFields(Object fields) {
    return '$fields 為空';
  }

  @override
  String fileNotFound(Object file) {
    return '檔案（$file）未能找到';
  }

  @override
  String fileTooLarge(Object size) {
    return '檔案過大：$size';
  }

  @override
  String get followChatModel => '跟隨聊天模型';

  @override
  String get fontSize => '字型大小';

  @override
  String get fontSizeSettingTip => '僅對程式碼區塊生效';

  @override
  String get freeCopy => '自由複製';

  @override
  String get genChatTitle => '生成聊天標題';

  @override
  String get genTitle => '生成標題';

  @override
  String get headTailMode => '頭尾模式';

  @override
  String get headTailModeTip => '僅發送 `提示詞+第一條用戶訊息+當前輸入` 作為上下文。\n\n這在用於翻譯對話時特別有用（可以節省 tokens）。';

  @override
  String get help => '幫助';

  @override
  String get history => '歷史';

  @override
  String historyToolHelp(Object keywords) {
    return '載入包含關鍵字 $keywords 的聊天作為上下文？';
  }

  @override
  String get historyToolTip => '載入歷史聊天作為上下文';

  @override
  String get hour => '小時';

  @override
  String get httpToolTip => '發起 Http 請求，例如：搜索內容';

  @override
  String get ignoreContextConstraint => '忽略上下文限制';

  @override
  String get ignoreTip => '忽略提示';

  @override
  String get image => '圖片';

  @override
  String initChatHelp(Object issue, Object unilink) {
    return '### 📖 提示\n- 在聊天介面過度滑動（overscroll）可以快捷切換聊天歷史記錄\n- 長按聊天文字自由選中複製Markdown源\n- URL Scheme 用法可以在 [這裡]($unilink)\n\n### 🔍 幫助\n- 如果 GPT Box 有 bug，請使用 [Github Issue]($issue)\n- Telegram `@lpktg`';
  }

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
  String get list => '列表';

  @override
  String get manual => '手動';

  @override
  String get memory => '記憶';

  @override
  String memoryAdded(Object str) {
    return '記憶已添加: $str';
  }

  @override
  String memoryTip(Object txt) {
    return '記住 [$txt]?';
  }

  @override
  String get message => '訊息';

  @override
  String get migrationV1UrlTip => '是否自動在配置的末尾添加\"/v1\"？';

  @override
  String get minute => '分鐘';

  @override
  String get model => '模型';

  @override
  String get modelRegExpTip => '如果模型名稱匹配，則使用 Tools';

  @override
  String get more => '更多';

  @override
  String get multiModel => '多模態';

  @override
  String get myOtherApps => '我的其它 App';

  @override
  String get needOpenAIKey => '請先輸入 OpenAI 密鑰';

  @override
  String get needRestart => '需要重新啟動來應用';

  @override
  String get newChat => '新建聊天';

  @override
  String get noDuplication => '沒有重複項目';

  @override
  String notSupported(Object val) {
    return '$val 不支援';
  }

  @override
  String get onMsgCome => '當有新訊息';

  @override
  String get onSwitchChat => '當切換對話時';

  @override
  String get onlyRestoreHistory => '僅恢復歷史聊天（不恢復 API Url 和 Secret Key）';

  @override
  String get onlySyncOnLaunch => '僅在啟動時同步';

  @override
  String get other => '其他';

  @override
  String get participant => '參與者';

  @override
  String get passwd => '密碼';

  @override
  String get privacy => '隱私';

  @override
  String get privacyTip => '此 app 不蒐集任何資訊。';

  @override
  String get profile => '設定';

  @override
  String get promptsSettingsItem => '提示詞';

  @override
  String get raw => '原始';

  @override
  String get refresh => '重新整理';

  @override
  String get regExp => '正則表達式';

  @override
  String get remember30s => '記住 30 秒';

  @override
  String get rename => '重新命名';

  @override
  String get replay => '重播';

  @override
  String get replayTip => '重播的訊息和所有後續訊息將被清除';

  @override
  String get res => '資源';

  @override
  String restoreOpenaiTip(Object url) {
    return '文件可以在 [這裡]($url) 找到';
  }

  @override
  String get rmDuplication => '刪除重複';

  @override
  String rmDuplicationFmt(Object count) {
    return '確定要刪除 [$count]個重複項目嗎？';
  }

  @override
  String get route => '路由';

  @override
  String get save => '儲存';

  @override
  String get saveErrChat => '儲存聊天錯誤';

  @override
  String get saveErrChatTip => '在接收/發送每條訊息後儲存，即使有報錯';

  @override
  String get scrollSwitchChat => '上下滑動切換聊天';

  @override
  String get search => '搜尋';

  @override
  String get secretKey => '密鑰';

  @override
  String get share => '分享';

  @override
  String get shareFrom => '分享自';

  @override
  String get skipSameTitle => '跳過有與本地聊天相同標題的聊天';

  @override
  String get softWrap => '自動換行';

  @override
  String get stt => '語音轉文字';

  @override
  String sureRestoreFmt(Object time) {
    return '確定恢復備份（$time）？';
  }

  @override
  String get switcher => '開關';

  @override
  String syncConflict(Object a, Object b) {
    return '衝突：不能同時開啟 $a 和 $b';
  }

  @override
  String get system => '系統';

  @override
  String get text => '文字';

  @override
  String get themeColorSeed => '主題顏色種子';

  @override
  String get themeMode => '主題模式';

  @override
  String get thirdParty => '第三方';

  @override
  String get tool => '工具';

  @override
  String toolConfirmFmt(Object tool) {
    return '是否同意使用工具 $tool ？';
  }

  @override
  String get toolFinishTip => '工具調用完成';

  @override
  String toolHttpReqHelp(Object host) {
    return '將會與從網路獲取數據，本次將會聯絡 $host';
  }

  @override
  String get toolHttpReqName => 'Http 請求';

  @override
  String get tts => '文字轉語音';

  @override
  String get unsupported => '不支援';

  @override
  String get untitled => '未命名';

  @override
  String get update => '更新';

  @override
  String get usage => '用法';

  @override
  String get user => '使用者';

  @override
  String weeksAgo(Object weeks) {
    return '$weeks 週前';
  }

  @override
  String get wrap => '換行';
}
