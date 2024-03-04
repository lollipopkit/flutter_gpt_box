part of 'home.dart';

final _inputCtrl = TextEditingController();
final _chatScrollCtrl = ScrollController()
  ..addListener(() {
    Funcs.throttle(_chatFabRN.build, id: 'chat_fab_rn', durationMills: 30);
  });
final _historyScrollCtrl = ScrollController()
  ..addListener(_locateHistoryListener);
final _pageCtrl = PageController(initialPage: _curPage.value.index);
final _screenshotCtrl = ScreenshotController();

final _timeRN = RNode();
// Map for markdown rebuild nodes
final _chatItemRNMap = <String, RNode>{};
// RebuildNodes for history list items
final _historyRNMap = <String, RNode>{};

final _audioPlayer = AudioPlayer();
// Map for audio player value notifiers which stores the current playing status
final _audioPlayerMap = <String, ValueNotifier<AudioPlayStatus>>{};
String? _nowPlayingId;
final _audioLoadingMap = <String, Completer>{};

/// Audio / Image / File
final _filePicked = ValueNotifier<XFile?>(null);

final _chatType = ValueNotifier(ChatType.text);

// For page body chat view
final _chatRN = RNode();
final _historyRN = RNode();
final _appbarTitleRN = RNode();
final _sendBtnRN = RNode();
// Default false: the history item is visible on app start, no need to locate
final _locateHistoryBtn = ValueNotifier(false);
final _chatFabRN = RNode();

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

const _durationShort = Durations.short4;
const _durationMedium = Durations.medium1;
