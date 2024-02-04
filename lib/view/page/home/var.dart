part of 'home.dart';

final _inputCtrl = TextEditingController();
final _chatScrollCtrl = ScrollController();
final _historyScrollCtrl = ScrollController();
final _pageCtrl = PageController(initialPage: _curPage.value.index);
final _screenshotCtrl = ScreenshotController();

final _timeRN = RebuildNode();
// Map for markdown rebuild nodes
final _chatItemRNMap = <String, RebuildNode>{};
// RebuildNodes for history list items
final _historyRNMap = <String, RebuildNode>{};

final _audioPlayer = AudioPlayer();
// Map for audio player value notifiers which stores the current playing status
final _audioPlayerMap = <String, ValueNotifier<AudioPlayStatus>>{};
String? _nowPlayingId;
final _audioLoadingMap = <String, Completer>{};

final _imagesMap = <String, XFile>{};

// For page body chat view
final _chatRN = RebuildNode();
final _historyRN = RebuildNode();
final _appbarTitleRN = RebuildNode();
final _sendBtnRN = RebuildNode();
// Default false: the history item is visible on app start, no need to locate
final _locateHistoryBtn = ValueNotifier(false);

var _allHistories = <String, ChatHistory>{};
String _curChatId = 'fake-non-exist-id';
ChatHistory? get _curChat => _allHistories[_curChatId];
final _chatStreamSubs = <String, StreamSubscription>{};
final _curPage = ValueNotifier(HomePageEnum.chat)
  ..addListener(() {
    _imeFocus.unfocus();
  });

final _imeFocus = FocusNode();

MediaQueryData? _media;
bool _isDark = false;
final _isWide = ValueNotifier(false)
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
