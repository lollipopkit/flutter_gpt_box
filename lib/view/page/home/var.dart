part of 'home.dart';

final _inputCtrl = TextEditingController();
final _chatScrollCtrl = ScrollController()
  ..addListener(() {
    Funcs.throttle(_chatFabRN.notify, id: 'chat_fab_rn', duration: 30);
  });
final _historyScrollCtrl = ScrollController()
  ..addListener(_locateHistoryListener);
final _pageCtrl = PageController(initialPage: _curPage.value.index);
final _screenshotCtrl = ScreenshotController();

final _timeRN = RNode();

/// Map for [ChatHistoryItem]'s [RNode]
final _chatItemRNMap = <String, RNode>{};
final _historyRNMap = <String, RNode>{};

/// Audio / Image / File path
final _filePicked = nvn<String>();

final _chatType = ChatType.text.vn;

// For page body chat view
final _chatRN = RNode();
final _historyRN = RNode();
final _appbarTitleRN = RNode();
final _sendBtnRN = RNode();
final _locateHistoryBtn = false.vn;
final _chatFabRN = RNode();
final _homeBottomRN = RNode();

var _allHistories = <String, ChatHistory>{};
String _curChatId = 'fake-non-exist-id';
ChatHistory? get _curChat => _allHistories[_curChatId];

/// [ChatHistory.id] or [ChatHistoryItem.id]
final _loadingChatIds = <String>{};
final _loadingChatIdRN = RNode();

final _curPage = HomePageEnum.chat.vn;

final _imeFocus = FocusNode();

MediaQueryData? _media;
final _isWide = false.vn
  ..addListener(() {
    _curPage.value = HomePageEnum.chat;
  });

const _boxShadow = [
  BoxShadow(
    color: Colors.black12,
    blurRadius: 3,
    offset: Offset(0, -0.5),
  ),
];

const _boxShadowDark = [
  BoxShadow(
    color: Colors.white12,
    blurRadius: 3,
    offset: Offset(0, -0.5),
  ),
];

/// Set it as final, so we can scroll to it.
/// Mobile has higher density.
final _historyItemHeight = isDesktop ? 73.0 : 79.0;
// The pixel tollerance
final _historyLocateTollerance = _historyItemHeight / 3;

const _durationShort = Durations.short4;
const _durationMedium = Durations.medium1;

final _chatFabAutoHideKey = GlobalKey<AutoHideState>();

KeyboardCtrlListener? _keyboardSendListener;
