part of 'home.dart';

final _inputCtrl = TextEditingController();
final _chatScrollCtrl = ScrollController()..addListener(_onChatScroll);
final _historyScrollCtrl = ScrollController()
  ..addListener(_locateHistoryListener);
final _pageCtrl = PageController(initialPage: _curPage.value.index);
final _screenshotCtrl = ScreenshotController();

final _timeRN = RNode();

/// Map for [ChatHistoryItem]'s [RNode]
final _chatItemRNMap = <String, RNode>{};
final _historyRNMap = <String, RNode>{};

/// Audio / Image / File path
final _filePicked = nvn<_FilePicked>();

final _chatType = ChatType.text.vn;

// For page body chat view
final _chatRN = RNode();
final _historyRN = RNode();
final _appbarTitleRN = RNode();
final _locateHistoryBtn = false.vn;
final _chatFabRN = RNode();
final _homeBottomRN = RNode();

var _allHistories = <String, ChatHistory>{};
ChatHistory? _curChat;
final _curChatId = 'fake-non-exist-id'.vn..addListener(_onCurChatIdChanged);
void _onCurChatIdChanged() {
  _curChat = _allHistories[_curChatId.value];
  _chatRN.notify();
}

/// [ChatHistory.id] or [ChatHistoryItem.id]
final _loadingChatIds = <String>{}.vn;
final _chatStreamSubs = <String, StreamSubscription>{};

final _curPage = HomePageEnum.chat.vn;

final _imeFocus = FocusNode();

Size? _size;
final _isWide = false.vn..addListener(_onIsWideChanged);

/// Set it as final, so we can scroll to it.
/// Mobile has higher density.
final _historyItemHeight = isDesktop ? 73.0 : 79.0;
// The pixel tollerance
final _historyLocateTollerance = _historyItemHeight / 3;

const _durationShort = Durations.short4;
const _durationMedium = Durations.medium1;

final _chatFabAutoHideKey = GlobalKey<AutoHideState>();

// ignore: unused_element
KeyboardCtrlListener? _keyboardSendListener;

/// If current `ts > this + duration`, then no delete confirmation required.
var _noChatDeleteConfirmTS = 0;
