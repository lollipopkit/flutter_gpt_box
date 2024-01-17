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
import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/res/build.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/code.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

part 'misc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  late final _pageCtrl = PageController(initialPage: _curPageIdx);

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
  String _curChatId = 'fake-non-exist-id';
  ChatHistory? get _curChat => _allHistories[_curChatId];
  final _chatStreamSubs = <String, StreamSubscription>{};
  int _curPageIdx = 1;

  MediaQueryData? _media;
  Timer? _refreshTimeTimer;

  bool _isDark = false;
  Color _bg = UIs.bgColor.light;

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _allHistories = Stores.history.fetchAll();
    _switchChat();
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
      bottomNavigationBar: _buildInput(),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: ListenableBuilder(
        listenable: _appbarTitleRN,
        builder: (_, __) => Text(
          _curChat?.name ?? l10n.untitled,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Routes.debug.go(context),
          icon: const Icon(Icons.developer_board),
          tooltip: 'Debug',
        )
      ],
    );
  }

  Widget _buildBody() {
    return PageView(
      controller: _pageCtrl,
      children: [
        _buildChatHistoryPage(),
        ListenableBuilder(
          listenable: _chatRN,
          builder: (_, __) => _buildChatPage(),
        ),
      ],
      onPageChanged: (value) {
        _curPageIdx = value;
        _pageIndicatorRN.rebuild();
      },
    );
  }

  Widget _buildChatHistoryPage() {
    return ListenableBuilder(
      listenable: _historyRN,
      builder: (_, __) {
        final keys = _allHistories.keys.toList();
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 11),
          reverse: true,
          itemCount: keys.length,
          itemBuilder: (_, index) {
            final chatId = keys.elementAt(index);
            return _buildHistoryListItem(chatId).card;
          },
        );
      },
    );
  }

  Widget _buildChatPage() {
    final item = _curChat?.items;
    if (item == null) return UIs.placeholder;
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.only(
        left: 7,
        right: 7,
      ),
      itemCount: item.length,
      itemBuilder: (_, index) {
        return _buildChatItem(item, index);
      },
    );
  }

  Widget _buildHistoryListItem(String chatId) {
    final entity = _allHistories[chatId];
    if (entity == null) return UIs.placeholder;
    final node = _chatRNMap.putIfAbsent(chatId, () => RebuildNode());
    return ListTile(
      leading: Text('#${entity.items.length}', style: UIs.textGrey),
      title: ListenableBuilder(
        listenable: node,
        builder: (_, __) => Text(entity.name ?? l10n.untitled),
      ),
      subtitle: ListenableBuilder(
        listenable: _timeRN,
        builder: (_, __) => Text(
          entity.items.lastOrNull?.createdAt.toAgo ?? l10n.empty,
          style: UIs.textGrey,
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 17, right: 11),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _onTapRenameChat(chatId),
            icon: const Icon(Icons.abc, size: 19),
            tooltip: l10n.rename,
          ),
          IconButton(
            onPressed: () => _onTapDeleteChat(chatId),
            icon: const Icon(Icons.delete, size: 19),
          ),
        ],
      ),
      onTap: () {
        _switchChat(chatId);
        if (_pageCtrl.page == 0) {
          _pageCtrl.animateToPage(
            1,
            duration: Durations.medium3,
            curve: Curves.fastEaseInToSlowEaseOut,
          );
        }
      },
    );
  }

  Widget _buildChatItemBtn(
    List<ChatHistoryItem> chatItems,
    ChatHistoryItem chatItem,
  ) {
    return Row(
      children: [
        Text(chatItem.role.name, style: UIs.text13Grey),
        const Spacer(),
        IconButton(
          onPressed: () async {
            final result = await context.showRoundDialog<bool>(
              title: l10n.attention,
              child: Text(l10n.delFmt(chatItem.toMarkdown, chatItem.id)),
              actions: [
                TextButton(
                  onPressed: () => context.pop(true),
                  child: Text(l10n.ok),
                ),
              ],
            );
            if (result != true) return;
            chatItems.remove(chatItem);
            _storeChat(_curChatId);
            _chatRN.rebuild();
          },
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.delete,
            size: 17,
          ),
        ),
        IconButton(
          onPressed: () => _onCopy(chatItem.toMarkdown),
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.copy,
            size: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildChatItem(List<ChatHistoryItem> chatItems, int idx) {
    final chatItem = chatItems[idx];
    final node = _mdRNMap.putIfAbsent(chatItem.id, () => RebuildNode());
    final md = ListenableBuilder(
      listenable: node,
      builder: (_, __) {
        return MarkdownBody(
          data: chatItem.toMarkdown,
          builders: {
            'code': CodeElementBuilder(onCopy: _onCopy),
          },
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChatItemBtn(chatItems, chatItem),
          Stores.setting.softWrap.fetch()
              ? md
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: md,
                ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: isDesktop
          ? const EdgeInsets.only(left: 11, right: 11, top: 7, bottom: 17)
          : const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
        color: _bg,
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
                  onPressed: _onTapSetting,
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
                  onPressed: () => _onTapRenameChat(_curChatId),
                  icon: const Icon(Icons.abc, size: 19),
                  tooltip: l10n.rename,
                ),
                IconButton(
                  onPressed: () => _onTapDeleteChat(_curChatId),
                  icon: const Icon(Icons.delete, size: 19),
                  tooltip: l10n.delete,
                ),
                const Spacer(),
                ListenableBuilder(
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
                ),
                if (isMobile)
                  IconButton(
                    onPressed: () {
                      _focusNode.unfocus();
                    },
                    icon: const Icon(Icons.keyboard_hide, size: 19),
                  ),
              ],
            ),
            Input(
              controller: _inputCtrl,
              label: l10n.message,
              node: _focusNode,
              type: TextInputType.multiline,
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
                          onPressed: () => _onSend(_curChatId),
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

  Future<void> _onSend(String chatId) async {
    if (_inputCtrl.text.isEmpty) return;
    _focusNode.unfocus();
    final workingChat = _allHistories[chatId];
    if (workingChat == null) {
      final msg = 'Chat($chatId) not found';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }
    final config = _getChatConfig(chatId);
    final questionContent = switch ((
      config.prompt,
      config.historyLen,
      workingChat.items.length,
    )) {
      ('', _, _) => _inputCtrl.text,

      /// If prompt is not empty and historyCount == null || 0,
      /// append it to the input
      (final prompt, 0, _) => '$prompt\n${_inputCtrl.text}',

      /// If this the first msg, append it to the input
      (final prompt, _, 2) => '$prompt\n${_inputCtrl.text}',
      _ => _inputCtrl.text,
    };
    final question = ChatHistoryItem.noid(
      content: [
        ChatContent(type: ChatContentType.text, raw: questionContent),
      ],
      role: ChatRole.user,
    );
    workingChat.items.add(question);
    _genChatTitle(chatId);
    final historyCarried = workingChat.items.reversed
        .take(config.historyLen)
        .map(
          (e) => e.toOpenAI,
        )
        .toList();
    _inputCtrl.clear();
    final chatStream = OpenAI.instance.chat.createStream(
      model: config.model,
      messages: [...historyCarried.reversed, question.toOpenAI],
      temperature: config.temperature,
      seed: config.seed,
    );
    final assistReply = ChatHistoryItem.emptyAssist;
    workingChat.items.add(assistReply);
    _chatRN.rebuild();
    try {
      final sub = chatStream.listen(
        (event) {
          final delta = event.choices.first.delta.content?.first.text ?? '';
          assistReply.content.first.raw += delta;
          _mdRNMap[assistReply.id]?.rebuild();

          if (Stores.setting.scrollBottom.fetch()) {
            // Only scroll to bottom when current chat is the working chat
            final isWorking = chatId == _curChatId;
            final isSubscribed = _chatStreamSubs.containsKey(chatId);
            if (isWorking && isSubscribed) {
              _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
            }
          }
        },
        onError: (e, trace) {
          Loggers.app.warning('Listen chat stream: $e');
          _onStopStreamSub(chatId);

          final msg = 'Error: $e\nTrace:\n$trace';
          workingChat.items.add(ChatHistoryItem.noid(
            content: [ChatContent(type: ChatContentType.text, raw: msg)],
            role: ChatRole.system,
          ));
          _chatRN.rebuild();
          _storeChat(chatId);
          _sendBtnRN.rebuild();
        },
        onDone: () {
          _onStopStreamSub(chatId);
          _storeChat(chatId);
          _sendBtnRN.rebuild();
        },
      );
      _chatStreamSubs[chatId] = sub;
      _sendBtnRN.rebuild();
    } catch (e) {
      _onStopStreamSub(chatId);
      final msg = 'Chat stream: $e';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      assistReply.content.first.raw += '\n$msg';
      _sendBtnRN.rebuild();
    }
  }

  void _switchChat([String? id]) {
    id ??= _allHistories.keys.firstOrNull ?? _newChat().id;
    _curChatId = id;
    _applyChatConfig(_getChatConfig(_curChatId));
    _mdRNMap.clear();
    _chatRN.rebuild();
    _sendBtnRN.rebuild();
    _appbarTitleRN.rebuild();
  }

  ChatHistory _newChat() {
    final newHistory = ChatHistory.empty;
    _allHistories[newHistory.id] = ChatHistory.empty;
    Stores.history.put(newHistory);
    return newHistory;
  }

  void _storeChat(String chatId) {
    final chat = _allHistories[chatId];
    if (chat == null) {
      final msg = 'Store Chat($chatId) not found';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }
    Stores.history.put(chat);
  }

  void _applyChatConfig(ChatConfig config) {
    OpenAI.apiKey = config.key;
    if (config.url.isNotEmpty) OpenAI.baseUrl = config.url;
  }

  ChatConfig _getChatConfig(String chatId) {
    return _allHistories[chatId]?.config ?? ChatConfig.fromStore();
  }

  void _onTapSetting() async {
    final config = _getChatConfig(_curChatId);
    final result = await context.showRoundDialog<ChatConfig>(
      title: '${l10n.settings}(${l10n.current})',
      child: _CurrentChatSettings(config: config),
    );
    if (result == null) return;
    _allHistories[_curChatId]?.config = result;
    _storeChat(_curChatId);
    _applyChatConfig(config);
  }

  void _onTapDeleteChat(String chatId) {
    final entity = _allHistories[chatId];
    if (entity == null) {
      final msg = 'Delete Chat($chatId) not found';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }

    /// If config is null and items is empty, delete it directly
    if (entity.config == null && entity.items.isEmpty) {
      _onDeleteChat(chatId);
      return;
    }

    final name = entity.name ?? 'Untitled';
    context.showRoundDialog(
      title: l10n.attention,
      child: Text(l10n.delFmt(name, l10n.chat)),
      actions: [
        TextButton(
          onPressed: () {
            _onDeleteChat(chatId);
            context.pop();
          },
          child: Text(l10n.ok),
        ),
      ],
    );
  }

  void _onDeleteChat(String chatId) {
    Stores.history.delete(chatId);
    _allHistories.remove(chatId);
    if (_curChatId == chatId) {
      _switchChat();
    }
    _historyRN.rebuild();
  }

  void _onTapRenameChat(String chatId) async {
    final entity = _allHistories[chatId];
    if (entity == null) {
      final msg = 'Rename Chat($chatId) not found';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }
    final ctrl = TextEditingController(text: entity.name);
    final title = await context.showRoundDialog<String>(
      title: l10n.rename,
      child: Input(
        controller: ctrl,
        onSubmitted: (p0) => context.pop(p0),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(ctrl.text),
          child: Text(l10n.ok),
        ),
      ],
    );
    if (title == null || title.isEmpty) return;
    entity.name = title;
    _chatRNMap[chatId]?.rebuild();
    _storeChat(chatId);
    _appbarTitleRN.rebuild();
  }

  void _onStopStreamSub(String chatId) {
    _chatStreamSubs.remove(chatId)?.cancel();
  }

  void _genChatTitle(String chatId) async {
    if (!Stores.setting.autoGenTitle.fetch()) return;
    final entity = _allHistories[chatId];
    if (entity?.items.length != 1) return;
    if (entity == null) {
      final msg = 'Gen Chat($chatId) not found';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }

    final question = entity.items.first.content.first.raw;
    final resp = await OpenAI.instance.chat.create(
      model: 'gpt-3.5-turbo',
      messages: [
        entity.items.first.copyWith(
          content: [
            ChatContent(
              type: ChatContentType.text,
              raw: l10n.genTitlePrompt + question,
            ),
          ],
        ).toOpenAI,
      ],
    );
    final title = resp.choices.firstOrNull?.message.content?.firstOrNull?.text;
    if (title == null) {
      final msg = 'Gen Chat($chatId) title: null resp';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }
    entity.name = title;
    _chatRNMap[chatId]?.rebuild();
    _appbarTitleRN.rebuild();
  }

  void _onCopy(String content) {
    Clipboard.setData(ClipboardData(text: content));
    context.showSnackBar(l10n.copied);
  }
}
