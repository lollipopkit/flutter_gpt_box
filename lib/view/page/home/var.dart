part of 'home.dart';

final _inputCtrl = TextEditingController();
final _chatScrollCtrl = ScrollController();
final _historyScrollCtrl = ScrollController();
final _pageCtrl = PageController(initialPage: _curPage.value.index);
final _screenshotCtrl = ScreenshotController();

final _timeRN = RebuildNode();

/// Map for markdown rebuild nodes
final _mdRNMap = <String, RebuildNode>{};

/// RebuildNodes for chat history list items
final _chatRNMap = <String, RebuildNode>{};

/// For page body chat view
final _chatRN = RebuildNode();
final _historyRN = RebuildNode();
final _appbarTitleRN = RebuildNode();
final _sendBtnRN = RebuildNode();
// Default false: this item is visible, no need to locate
final _locateHistoryBtn = ValueNotifier(false);

var _allHistories = <String, ChatHistory>{};
String _curChatId = 'fake-non-exist-id';
ChatHistory? get _curChat => _allHistories[_curChatId];
final _chatStreamSubs = <String, StreamSubscription>{};
final _curPage = ValueNotifier(HomePageEnum.chat);

final _focusNode = FocusNode();

MediaQueryData? _media;
bool _isDark = false;
final _isWide = ValueNotifier(false);

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

/// Set it as a const, so we can scroll to it
const _historyItemHeight = 73.0;
