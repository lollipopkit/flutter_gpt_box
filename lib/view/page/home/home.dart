import 'dart:async';

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
part 'more_action.dart';
part 'input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _refreshTimeTimer;

  @override
  void initState() {
    super.initState();
    _allHistories = Stores.history.fetchAll();
    _allChatIds = _allHistories.keys.toList();
    _switchChat();
    _refreshTimeTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _timeRN.rebuild(),
    );
    _scrollCtrl.addListener(() {
      /// If scroll overflow > 10% / -10%, switch chat
      final max = _scrollCtrl.position.maxScrollExtent;
      final offset = _scrollCtrl.offset;
      final overflow = offset - max;
      final curIdx = _allChatIds.indexOf(_curChatId);
      if (curIdx == 0 || curIdx == _allChatIds.length - 1) return;
      if (overflow > 0 && overflow > max * 0.1) {
        _switchChat(_allChatIds[curIdx - 1]);
      } else if (overflow < 0 && overflow < max * -0.1) {
        _switchChat(_allChatIds[curIdx + 1]);
      }
    });
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _refreshTimeTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);

    l10n = AppLocalizations.of(context)!;
    _isDark = context.isDark;
    _bg = UIs.bgColor.fromBool(_isDark);
    CodeElementBuilder.isDark = _isDark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: const _Input(),
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
        const _MoreActionsBtn(),
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

  Widget _buildDrawer() {
    return Container(
      width: (_media?.size.width ?? 300) * 0.7,
      color: _bg,
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

  // Future<void> _onImgPick() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //   );
  //   final path = result?.files.single.path;
  //   if (path == null) return;
  //   final b64 = base64Encode(await File(path).readAsBytes());
  //   _curHistories?.add(ChatHistoryItem.noid(
  //     content: [
  //       ChatContent(
  //         type: ChatContentType.image,
  //         raw: 'base64://$b64',
  //       ),
  //     ],
  //     role: ChatRole.user,
  //   ));
  // }
}
