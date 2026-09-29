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
  String get autoScrollBottom => '自动滚动到底部';

  @override
  String get backupTip => '请保证备份文件私密且安全！';

  @override
  String get calcTokenLen => '计算 Tokens 长度';

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
  String get emptyTrash => '清理回收站';

  @override
  String get emptyTrashTip => '==0，下次启动时删除。<0 不自动删除。';

  @override
  String get fontSize => '字体大小';

  @override
  String get fontSizeSettingTip => '仅对代码块生效';

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
  String get model => '模型';

  @override
  String get more => '更多';

  @override
  String get myOtherApps => '我的其它 App';

  @override
  String get newChat => '新建聊天';

  @override
  String get onMsgCome => '当有新消息';

  @override
  String get onSwitchChat => '当切换对话';

  @override
  String get passwd => '密码';

  @override
  String get privacy => '隐私';

  @override
  String get privacyTip => '此 app 不搜集任何信息。';

  @override
  String get rename => '重命名';

  @override
  String get replay => '重放';

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
  String get switcher => '开关';

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
  String toolConfirmFmt(Object tool) {
    return '是否同意使用工具 $tool ？';
  }

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
  String get autoScrollBottom => '自動捲動到底部';

  @override
  String get backupTip => '請確保備份檔案私密且安全！';

  @override
  String get calcTokenLen => '計算 Tokens 長度';

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
  String get emptyTrash => '清理回收站';

  @override
  String get emptyTrashTip => '==0，下次啟動時刪除。<0 不自動刪除。';

  @override
  String get fontSize => '字型大小';

  @override
  String get fontSizeSettingTip => '僅對程式碼區塊生效';

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
  String get model => '模型';

  @override
  String get more => '更多';

  @override
  String get myOtherApps => '我的其它 App';

  @override
  String get newChat => '新建聊天';

  @override
  String get onMsgCome => '當有新訊息';

  @override
  String get onSwitchChat => '當切換對話時';

  @override
  String get passwd => '密碼';

  @override
  String get privacy => '隱私';

  @override
  String get privacyTip => '此 app 不蒐集任何資訊。';

  @override
  String get rename => '重新命名';

  @override
  String get replay => '重播';

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
  String get switcher => '開關';

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
  String toolConfirmFmt(Object tool) {
    return '是否同意使用工具 $tool ？';
  }

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
}
