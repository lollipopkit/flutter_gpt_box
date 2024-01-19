import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/datetime.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
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
import 'package:flutter_chatgpt/view/widget/fade.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'setting.dart';
part 'chat.dart';
part 'history.dart';
part 'var.dart';
part 'ctrl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin<HomePage> {
  Timer? _refreshTimeTimer;

  @override
  void initState() {
    super.initState();
    _allHistories = Stores.history.fetchAll();
    _allChatIds = _allHistories.keys.toList();
    _refreshTimeTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _timeRN.rebuild(),
    );
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _refreshTimeTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _media = MediaQuery.of(context);
    _isDark = context.isDark;
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
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: ListenableBuilder(
        listenable: _appbarTitleRN,
        builder: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
      actions: [
        IconButton(
          onPressed: () => Routes.debug.go(context),
          icon: const Icon(Icons.developer_board),
          tooltip: 'Debug',
        ),
        _buildMoreActions(),
      ],
    );
  }

  Widget _buildBody() {
    return PageView(
      controller: _pageCtrl,
      children: const [
        _HistoryPage(),
        _ChatPage(),
      ],
      onPageChanged: (value) {
        _curPageIdx = value;
        _pageIndicatorRN.rebuild();
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
                _buildSwitchChatBtn(),
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
              type: TextInputType.text,
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
    return ListenableBuilder(
      listenable: _pageIndicatorRN,
      builder: (_, __) {
        if (_curPageIdx == 0) {
          return IconButton(
            onPressed: () => _pageCtrl.animateToPage(
              1,
              duration: Durations.medium1,
              curve: Curves.fastEaseInToSlowEaseOut,
            ),
            icon: const Icon(Icons.chat, size: 19),
          );
        }
        return IconButton(
          onPressed: () => _pageCtrl.animateToPage(
            0,
            duration: Durations.medium1,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
          icon: const Icon(Icons.history, size: 19),
        );
      },
    );
  }

  Widget _buildSwitchChatBtn() {
    return ListenableBuilder(
      listenable: _pageIndicatorRN,
      builder: (_, __) {
        if (_curPageIdx == 0) return UIs.placeholder;
        return ListenableBuilder(
          listenable: _chatRN,
          builder: (_, __) {
            final curIdx = _allChatIds.indexOf(_curChatId);
            final isLast = curIdx == _allChatIds.length - 1;
            final isFirst = curIdx == 0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLast)
                  IconButton(
                    onPressed: () => _switchChat(_allChatIds[curIdx + 1]),
                    icon: const Icon(Icons.keyboard_arrow_up, size: 19),
                  ),
                if (!isFirst)
                  IconButton(
                    onPressed: () => _switchChat(_allChatIds[curIdx - 1]),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 19),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMoreActions() {
    return PopupMenuButton<_MoreAction>(
      icon: const Icon(Icons.more_vert),
      tooltip: l10n.more,
      onSelected: (value) => value.onTap(),
      itemBuilder: (context) {
        /// Put it here, or it's l10n string won't rebuild every time
        final moreActions = [
          _MoreAction(
            title: l10n.rmDuplication,
            icon: Icons.delete,
            onTap: () => _onRmDup(context),
            onPageIdxs: [0],
          ),
          _MoreAction(
            title: l10n.share,
            icon: Icons.share,
            onTap: () => _onShareChat(context),
            onPageIdxs: [1],
          ),
        ];

        final items = <PopupMenuEntry<_MoreAction>>[];
        for (final item in moreActions) {
          if (!item.onPageIdxs.contains(_curPageIdx)) continue;
          items.add(
            PopupMenuItem(
              value: item,
              child: Row(
                children: [
                  Icon(item.icon),
                  UIs.width13,
                  Text(item.title),
                ],
              ),
            ),
          );
        }
        return items;
      },
    );
  }

  Widget _buildDrawer() {
    return Container(
      width: (_media?.size.width ?? 300) * 0.7,
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
    _switchChat();
  }
}
