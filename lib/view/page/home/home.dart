import 'dart:async';
import 'dart:collection';

import 'package:after_layout/after_layout.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/core/build_mode.dart';
import 'package:flutter_chatgpt/core/ext/chat_history.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/datetime.dart';
import 'package:flutter_chatgpt/core/ext/media_query.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/core/util/func.dart';
import 'package:flutter_chatgpt/core/util/markdown.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/res/build.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/openai.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/code.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';
import 'package:flutter_chatgpt/view/widget/slide_trans.dart';
import 'package:flutter_chatgpt/view/widget/switch_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'setting.dart';
part 'chat.dart';
part 'history.dart';
part 'var.dart';
part 'ctrl.dart';
part 'enum.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
      (_) => _timeRN.rebuild(),
    );
    _historyScrollCtrl.addListener(() {
    Funcs.throttle(
      () {
        // Calculate _curChatId is visible or not
        final idx = _allHistories.keys.toList().indexOf(_curChatId);
        final offset = _historyScrollCtrl.offset;
        final height = _historyScrollCtrl.position.viewportDimension;
        final visible = offset <= idx * _historyItemHeight &&
            offset + height >= idx * _historyItemHeight;
        _locateHistoryBtn.value = !visible;
      },
      id: 'calc-chat-locate-btn',
      duration: 30,
    );
  });
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
    _isDark = context.isDark;
    _isWide.value = _media.isWide;
    CodeElementBuilder.isDark = _isDark;
    l10n = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildInput(),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _curPage,
        builder: (_, page, __) => page.fab,
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: Align(
        alignment: Alignment.centerLeft,
        child: ListenableBuilder(
          listenable: _appbarTitleRN,
          builder: (_, __) => AnimatedSwitcher(
            duration: Durations.medium1,
            switchInCurve: Easing.standardDecelerate,
            switchOutCurve: Easing.standardDecelerate,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransitionX(
                position: animation,
                direction: AxisDirection.right,
                child: child,
              ),
            ),
            child: Column(
              key: Key(_curChatId),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  _curChat?.name ?? l10n.untitled,
                  style: UIs.text15,
                ),
                ListenableBuilder(
                  listenable: _timeRN,
                  builder: (_, __) {
                    final entity = _curChat;
                    if (entity == null) return Text(l10n.empty);
                    final len = '${entity.items.length} ${l10n.message}';
                    final time =
                        entity.items.lastOrNull?.createdAt.toAgo ?? l10n.empty;
                    return Text(
                      '$len · $time',
                      style: UIs.text11Grey,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: _curPage,
          builder: (_, page, __) => page.buildAppbarActions(context),
        )
      ],
    );
  }

  Widget _buildBody() {
    const history = _HistoryPage();
    const chat = _ChatPage();
    if (_isWide.value) {
      return const Row(
        children: [
          Expanded(
            flex: 1,
            child: history,
          ),
          VerticalDivider(width: 1, color: Colors.white10),
          Expanded(
            flex: 2,
            child: chat,
          ),
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

  Widget _buildInput() {
    return Container(
      padding: isDesktop
          ? const EdgeInsets.only(left: 11, right: 11, top: 7, bottom: 17)
          : const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
        color: UIs.bgColor.fromBool(_isDark),
        boxShadow: _isDark ? _boxShadowDark : _boxShadow,
      ),
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: _media?.viewInsets.bottom ?? 0),
        curve: Curves.fastEaseInToSlowEaseOut,
        duration: Durations.short1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // IconButton(
                //   onPressed: _onImgPick,
                //   icon: const Icon(Icons.photo, size: 19),
                // ),
                IconButton(
                  onPressed: () => _onTapSetting(context),
                  icon: const Icon(Icons.settings, size: 19),
                  tooltip: l10n.settings,
                ),
                IconButton(
                  onPressed: () {
                    _switchChat(_newChat().id);
                    _historyRN.rebuild();
                  },
                  icon: const Icon(Icons.add),
                  tooltip: l10n.newChat,
                ),
                IconButton(
                  onPressed: () => _onTapRenameChat(_curChatId, context),
                  icon: const Icon(Icons.abc, size: 19),
                  tooltip: l10n.rename,
                ),
                const Spacer(),
                _buildSwitchPageBtn(),
                if (isMobile)
                  IconButton(
                    onPressed: () => _focusNode.unfocus(),
                    icon: const Icon(Icons.keyboard_hide, size: 19),
                  ),
              ],
            ),
            Input(
              controller: _inputCtrl,
              label: l10n.message,
              node: _focusNode,
              type: TextInputType.multiline,
              // action: TextInputAction.send,
              maxLines: 5,
              minLines: 1,
              suffix: ListenableBuilder(
                listenable: _sendBtnRN,
                builder: (_, __) {
                  final isWorking = _chatStreamSubs.containsKey(_curChatId);
                  return isWorking
                      ? IconButton(
                          onPressed: () => _onStopStreamSub(_curChatId),
                          icon: const Icon(Icons.stop),
                        )
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () => _onSend(_curChatId, context),
                        );
                },
              ),
            ),
            SizedBox(height: _media?.padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchPageBtn() {
    return ValueListenableBuilder(
      valueListenable: _isWide,
      builder: (_, isWide, __) => isWide
          ? UIs.placeholder
          : ValueListenableBuilder(
              valueListenable: _curPage,
              builder: (_, page, __) => switch (page) {
                HomePageEnum.history => IconButton(
                    onPressed: () => _pageCtrl.animateToPage(
                      1,
                      duration: Durations.medium1,
                      curve: Curves.fastEaseInToSlowEaseOut,
                    ),
                    icon: const Icon(Icons.chat, size: 19),
                  ),
                HomePageEnum.chat => IconButton(
                    onPressed: () => _pageCtrl.animateToPage(
                      0,
                      duration: Durations.medium1,
                      curve: Curves.fastEaseInToSlowEaseOut,
                    ),
                    icon: const Icon(Icons.history, size: 19),
                  ),
              },
            ),
    );
  }

  Widget _buildDrawer() {
    return Container(
      width: _isWide.value ? 270 : (_media?.size.width ?? 300) * 0.7,
      color: UIs.bgColor.fromBool(_isDark),
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
              leading: const Icon(Icons.settings),
              title: Text(l10n.settings),
            ).card,
            ListTile(
              onTap: () => Routes.backup.go(context),
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
    // Keep this here.
    // - If there is not chat history, [_switchChat] will create one
    // - If the init help haven't shown, [_switchChat] will show it
    // - Init help uses [l10n] to gen msg, so [l10n] must be ready
    // - [l10n] is ready after first layout
    _switchChat();
    _removeDuplicateHistory(context);
  }
}
