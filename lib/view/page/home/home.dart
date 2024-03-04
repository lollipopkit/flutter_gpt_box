import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/core/build_mode.dart';
import 'package:flutter_chatgpt/core/ext/chat_history.dart';
import 'package:flutter_chatgpt/core/ext/color.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/datetime.dart';
import 'package:flutter_chatgpt/core/ext/list.dart';
import 'package:flutter_chatgpt/core/ext/media_query.dart';
import 'package:flutter_chatgpt/core/ext/num.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/core/ext/xfile.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/core/update.dart';
import 'package:flutter_chatgpt/core/util/func.dart';
import 'package:flutter_chatgpt/core/util/markdown.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/core/util/platform/file.dart';
import 'package:flutter_chatgpt/core/util/sync/base.dart';
import 'package:flutter_chatgpt/core/util/ui.dart';
import 'package:flutter_chatgpt/core/util/url.dart';
import 'package:flutter_chatgpt/data/model/app/audio_play.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/model/chat/type.dart';
import 'package:flutter_chatgpt/data/res/build.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/openai.dart';
import 'package:flutter_chatgpt/data/res/path.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/res/uuid.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/code.dart';
import 'package:flutter_chatgpt/view/widget/future.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';
import 'package:flutter_chatgpt/view/widget/popup_menu.dart';
import 'package:flutter_chatgpt/view/widget/slide_trans.dart';
import 'package:flutter_chatgpt/view/widget/switch_page_indicator.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uni_links/uni_links.dart';

part 'chat.dart';
part 'history.dart';
part 'var.dart';
part 'ctrl.dart';
part 'enum.dart';
part 'search.dart';
part 'appbar.dart';
part 'bottom.dart';
part 'uni_link.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static void afterRestore() {
    _allHistories = Stores.history.fetchAll();
    _historyRN.build();
    _chatRN.build();
    _appbarTitleRN.build();
    _switchChat();
  }
}

class _HomePageState extends State<HomePage>
    with AfterLayoutMixin<HomePage>, TickerProviderStateMixin {
  Timer? _refreshTimeTimer;

  @override
  void initState() {
    super.initState();
    _allHistories = Stores.history.fetchAll();
    _refreshTimeTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        if (mounted) _timeRN.build();
      },
    );
    _historyScrollCtrl.addListener(_locateHistoryListener);
    _initUniLinks();
    _listenAudioPlayer();
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _refreshTimeTimer?.cancel();
    _chatScrollCtrl.dispose();
    _historyScrollCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _media = MediaQuery.of(context);
    RNode.dark.value = context.isDark;
    _isWide.value = _media.isWide;
    super.didChangeDependencies();
    _homeBottomRN.build();

    /// Must call here, or the colorSeed is not applied
    UIs.primaryColor = Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _isWide,
        builder: (_, isWide, __) {
          if (isWide) return UIs.placeholder;
          return const _HomeBottom();
        },
      ),
    );
  }

  Widget _buildBody() {
    const history = _HistoryPage();
    const chat = _ChatPage();
    if (_isWide.value) {
      return const Row(
        children: [
          SizedBox(width: 300, child: history),
          Expanded(child: chat),
        ],
      );
    }
    return PageView(
      controller: _pageCtrl,
      children: const [history, chat],
      onPageChanged: (value) {
        _curPage.value = HomePageEnum.fromIdx(value);
      },
    );
  }

  Widget _buildDrawer() {
    return Container(
      width: _isWide.value ? 270 : (_media?.size.width ?? 300) * 0.7,
      color: UIs.bgColor.fromBool(RNode.dark.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UIs.height13,
            SizedBox(
              height: 47,
              width: 47,
              child: UIs.appIcon,
            ),
            UIs.height13,
            const Text(
              'GPT Box\nv1.0.${Build.build}',
              textAlign: TextAlign.center,
            ),
            UIs.height77,
            ListTile(
              onTap: () => Routes.setting.go(context),
              onLongPress: () => _onLongTapSetting(context),
              leading: const Icon(Icons.settings),
              title: Text(l10n.settings),
            ).card,
            ListTile(
              onTap: () async {
                final ret = await Routes.backup.go(context);
                Scaffold.maybeOf(context)?.closeDrawer();

                if (ret?.isRestoreSuc == true) {
                  HomePage.afterRestore();
                }
              },
              leading: const Icon(Icons.backup),
              title: Text(l10n.backup),
            ).card,
            ListTile(
              onTap: () => Routes.about.go(context),
              leading: const Icon(Icons.info),
              title: Text(l10n.about),
            ).card,
            SizedBox(height: (_media?.padding.bottom ?? 0) + 13),
          ],
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    /// Keep this here.
    /// - If there is not chat history, [_switchChat] will create one
    /// - If the init help haven't shown, [_switchChat] will show it
    /// - Init help uses [l10n] to gen msg, so [l10n] must be ready
    /// - [l10n] is ready after first layout
    _switchChat();
    _historyRN.build();
    _removeDuplicateHistory(context);

    if (Stores.setting.autoCheckUpdate.fetch()) {
      AppUpdateIface.doUpdate(context);
    }
  }

  Future<void> _initUniLinks() async {
    if (isWeb) {
      final uri = await getInitialUri();
      if (uri == null) return;
      AppLink.handle(context, uri);
    } else {
      uriLinkStream.listen((Uri? uri) {
        if (uri == null) return;
        if (!mounted) return;
        AppLink.handle(context, uri);
      }, onError: (err) {
        final msg = l10n.invalidLinkFmt(err);
        Loggers.app.warning(msg);
        context.showRoundDialog(title: l10n.attention, child: Text(msg));
      });
    }
  }

  void _listenAudioPlayer() {
    _audioPlayer.onPositionChanged.listen((position) {
      final status = _audioPlayerMap[_nowPlayingId];
      if (status == null) return;
      status.value = status.value.copyWith(played: position.inMilliseconds);
    });
    _audioPlayer.onPlayerComplete.listen((_) {
      final status = _audioPlayerMap[_nowPlayingId];
      if (status == null) return;
      status.value = status.value.copyWith(playing: false, played: 0);
    });
  }

  // void _checkInvalidModels() {
  //   final validModels =
  // }
}
