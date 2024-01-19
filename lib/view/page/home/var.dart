part of 'home.dart';

final _inputCtrl = TextEditingController();
final _scrollCtrl = ScrollController();
final _pageCtrl = PageController(initialPage: _curPageIdx);
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
final _pageIndicatorRN = RebuildNode();

late final Map<String, ChatHistory> _allHistories;

/// Keep this for sort
late final List<String> _allChatIds;
String _curChatId = 'fake-non-exist-id';
ChatHistory? get _curChat => _allHistories[_curChatId];
final _chatStreamSubs = <String, StreamSubscription>{};
int _curPageIdx = 1;

final _focusNode = FocusNode();

MediaQueryData? _media;
bool _isDark = false;

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
