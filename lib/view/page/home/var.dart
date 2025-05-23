part of 'home.dart';

final _inputCtrl = TextEditingController();
final _chatScrollCtrl = ScrollController()
  ..addListener(() {
    Fns.throttle(_chatFabRN.notify, id: 'chat_fab_rn', duration: 30);
  });
final _historyScrollCtrl = ScrollController()
  ..addListener(_locateHistoryListener);
final _pageCtrl = PageController(initialPage: _curPage.value.index);
final _screenshotCtrl = ScreenshotController();

final _timeRN = RNode();

/// Map for [ChatHistoryItem]'s [RNode]
final _chatItemRNMap = <String, RNode>{};

/// Audio / Image / File path
final _filesPicked = <String>[].vn;

/// Body chat view
final _chatRN = RNode();
final _historyRN = RNode();
final _appbarTitleVN = nvn<String>();
final _locateHistoryBtn = false.vn;
final _chatFabRN = RNode();
final _homeBottomRN = RNode();

var _allHistories = <String, ChatHistory>{};
ChatHistory? _curChat;
final _curChatId = 'fake-non-exist-id'.vn..addListener(_onCurChatIdChanged);
void _onCurChatIdChanged() {
  _curChat = _allHistories[_curChatId.value];
  _chatRN.notify();
  _appbarTitleVN.value = _curChat?.name;
}

/// [ChatHistory.id] or [ChatHistoryItem.id]
final _loadingChatIds = <String>{}.vn;
final _chatStreamSubs = <String, StreamSubscription>{};

final _curPage = HomePageEnum.chat.vn;

final _imeFocus = FocusNode();

final _isDesktop = false.vn..addListener(_onIsWideChanged);
void _onIsWideChanged() {
  _curPage.value = HomePageEnum.chat;
}

/// Mobile has higher density.
final _historyItemHeight = isDesktop ? 73.0 : 79.0;

/// The pixel tollerance
final _historyLocateTollerance = _historyItemHeight / 3;

const _durationShort = Durations.short4;
const _durationMedium = Durations.medium1;

// ignore: unused_element
KeyboardCtrlListener? _keyboardSendListener;

/// If current `ts > this + duration`, then no delete confirmation required.
var _noChatDeleteConfirmTS = 0;

final _autoHideCtrl = AutoHideController();

var _userStoppedScroll = false;
