import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:app_links/app_links.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_tiktoken/flutter_tiktoken.dart';
import 'package:gpt_box/core/ext/chat_history.dart';
import 'package:gpt_box/core/ext/file.dart';
import 'package:gpt_box/core/route/page.dart';
import 'package:gpt_box/core/util/chat_title.dart';
import 'package:gpt_box/core/util/tool.dart';
import 'package:gpt_box/core/util/image.dart';
import 'package:gpt_box/core/util/sync/base.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/model/chat/history.dart';
import 'package:gpt_box/data/model/chat/type.dart';
import 'package:gpt_box/data/provider/all.dart';
import 'package:gpt_box/data/res/build.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/openai.dart';
import 'package:gpt_box/data/res/rnode.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/widget/audio.dart';
import 'package:gpt_box/view/widget/code.dart';
import 'package:gpt_box/view/widget/image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shortid/shortid.dart';

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
  final _appLink = AppLinks();

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
    _initUrlScheme();
    AudioCard.listenAudioPlayer();
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
    RNodes.dark.value = context.isDark;
    _isWide.value = (_media?.size.width ?? 0) > 639;
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
      bottomNavigationBar: ValBuilder(
        listenable: _isWide,
        builder: (isWide) {
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
      return LayoutBuilder(
        builder: (context, cons) {
          final width = cons.maxWidth;
          final height = cons.maxHeight;
          final historyWidth = math.max(200.0, math.min(400.0, width * 0.3));
          return Row(
            children: [
              SizedBox(width: historyWidth, height: height, child: history),
              const Expanded(child: chat),
            ],
          );
        },
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
      color: UIs.bgColor.fromBool(RNodes.dark.value),
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
            ).cardx,
            ListTile(
              leading: const Icon(MingCute.tool_fill),
              title: Text(l10n.tool),
              onTap: () => Routes.tool.go(context),
            ).cardx,
            ListTile(
              onTap: () async {
                final ret = await Routes.backup.go(context);
                Scaffold.maybeOf(context)?.closeDrawer();

                if (ret?.isRestoreSuc == true) {
                  HomePage.afterRestore();
                }
              },
              leading: const Icon(Icons.backup),
              title: Text('${l10n.backup} & ${l10n.restore}'),
            ).cardx,
            ListTile(
              leading: const Icon(BoxIcons.bxs_videos),
              title: Text(l10n.res),
              onTap: () => Routes.res.go(context),
            ).cardx,
            ListTile(
              onTap: () => Routes.about.go(context),
              leading: const Icon(Icons.info),
              title: Text(l10n.about),
            ).cardx,
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
      AppUpdateIface.doUpdate(
        build: Build.build,
        url: Urls.appUpdateCfg,
        context: context,
      );
    }
  }

  Future<void> _initUrlScheme() async {
    if (isWeb) {
      final uri = await _appLink.getInitialLink();
      if (uri == null) return;
      AppLink.handle(context, uri);
    } else {
      _appLink.uriLinkStream.listen((Uri? uri) {
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

  // void _checkInvalidModels() {
  //   final validModels =
  // }
}
