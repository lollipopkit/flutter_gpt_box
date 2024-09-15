import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:app_links/app_links.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_box/core/util/sync.dart';
//import 'package:flutter_tiktoken/flutter_tiktoken.dart';
import 'package:gpt_box/data/model/chat/history/share.dart';
import 'package:gpt_box/core/util/chat_title.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history/history.dart';
import 'package:gpt_box/data/model/chat/history/view.dart';
import 'package:gpt_box/data/model/chat/type.dart';
import 'package:gpt_box/data/res/build.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/openai.dart';
import 'package:gpt_box/data/res/rnode.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/settings/setting.dart';
import 'package:gpt_box/view/widget/audio.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:screenshot/screenshot.dart';

part 'chat.dart';
part 'history.dart';
part 'var.dart';
part 'ctrl.dart';
part 'enum.dart';
part 'search.dart';
part 'appbar.dart';
part 'bottom.dart';
part 'url_scheme.dart';
part 'req.dart';
part 'md_copy.dart';
part 'file_picked.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static void afterRestore() {
    _allHistories = Stores.history.fetchAll();
    _historyRN.notify();
    _chatRN.notify();
    _appbarTitleRN.notify();
    _switchChat();
    OpenAICfg.setToId();
  }
}

class _HomePageState extends State<HomePage>
    with AfterLayoutMixin<HomePage>, TickerProviderStateMixin {
  Timer? _refreshTimeTimer;
  final _appLink = AppLinks();

  @override
  void dispose() {
    // Do NOT dispose these, it's global and will be reused
    // _inputCtrl.dispose();
    // _chatScrollCtrl.dispose();
    // _historyScrollCtrl.dispose();
    // _keyboardSendListener?.dispose();

    _refreshTimeTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _media = MediaQuery.of(context);
    RNodes.dark.value = context.isDark;
    _isWide.value = (_media?.size.width ?? 0) > 639;
    super.didChangeDependencies();
    _homeBottomRN.notify();
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirm(
      onPop: (_) => ExitConfirm.exitApp(),
      child: const Scaffold(
        appBar: _CustomAppBar(),
        body: _Body(),
        bottomNavigationBar: _HomeBottom(isHome: true),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    _allHistories = Stores.history.fetchAll();
    _refreshTimeTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        if (mounted) _timeRN.notify();
      },
    );
    _initUrlScheme();
    AudioCard.listenAudioPlayer();

    /// Keep this here.
    /// - If there is not chat history, [_switchChat] will create one
    /// - If the init help haven't shown, [_switchChat] will show it
    /// - Init help uses [l10n] to gen msg, so [l10n] must be ready
    /// - [l10n] is ready after first layout
    _switchChat();
    _listenKeyboard();
    _historyRN.notify();
    //_removeDuplicateHistory(context);

    if (Stores.setting.autoCheckUpdate.fetch()) {
      AppUpdateIface.doUpdate(
        build: Build.build,
        url: Urls.appUpdateCfg,
        context: context,
      );
    }
  }

  void _listenKeyboard() {
    _keyboardSendListener = KeyboardCtrlListener(
      key: PhysicalKeyboardKey.enter,
      callback: () {
        // If the current page is not chat, do nothing
        if (context.stillOnPage != true) return false;

        if (_inputCtrl.text.isEmpty) return false;
        _onCreateRequest(context, _curChatId);
        return true;
      },
    );
  }

  Future<void> _initUrlScheme() async {
    DeepLinks.register(AppLink.handle);

    if (isWeb) {
      final uri = await _appLink.getInitialLink();
      if (uri == null) return;
      DeepLinks.process(uri, context);
    } else {
      _appLink.uriLinkStream.listen((uri) {
        final ctx = mounted ? context : null;
        DeepLinks.process(uri, ctx);
      }, onError: (err) {
        final msg = l10n.invalidLinkFmt(err);
        Loggers.app.warning(msg);
        context.showRoundDialog(title: l10n.attention, child: Text(msg));
      });
    }
  }
}

final class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    const history = _HistoryPage();
    const chat = _ChatPage();

    return _isWide.listenVal(
      (isWide) {
        if (isWide) {
          return LayoutBuilder(
            builder: (context, cons) {
              final w = math.max(200.0, math.min(400.0, cons.maxWidth * 0.3));
              return Row(
                children: [
                  SizedBox(width: w, height: cons.maxHeight, child: history),
                  const Expanded(child: chat),
                ],
              );
            },
          );
        }

        return PageView(
          controller: _pageCtrl,
          onPageChanged: (value) {
            _curPage.value = HomePageEnum.fromIdx(value);
          },
          children: const [history, chat],
        );
      },
    );
  }
}
