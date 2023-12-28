import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/datetime.dart';
import 'package:flutter_chatgpt/core/ext/string.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/data/model/chat/config.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
import 'package:flutter_chatgpt/data/res/build_data.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/data/store/all.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/input.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'misc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _kPanelMinHeight = 167.0;

  final _inputCtrl = TextEditingController();

  final _timeRN = RebuildNode();
  // Map for markdown rebuild nodes
  final _mdRNMap = <String, RebuildNode>{};
  // RebuildNodes for chat history panel list items
  final _chatRNMap = <String, RebuildNode>{};
  // For page body chat view
  final _bodyRN = RebuildNode();
  final _panelRN = RebuildNode();

  late final Map<String, ChatHistory> _allHistories;
  String _curChatId = 'fake-non-exist-id';
  List<ChatHistoryItem>? get _curHistories => _allHistories[_curChatId]?.items;

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
    _isDark = context.isDark;
    _bg = UIs.bgColor.fromBool(_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: CustomAppBar(
        title: const Text('GPT'),
        actions: [
          IconButton(
            onPressed: () => Routes.debug.go(context),
            icon: const Icon(Icons.developer_board),
          )
        ],
      ),
      body: SlidingUpPanel(
        body: ListenableBuilder(
          listenable: _bodyRN,
          builder: (_, __) => _buildBody(),
        ),
        panelBuilder: _buildBottomPanel,
        maxHeight: (_media?.size.height ?? 500) * 0.7,
        minHeight: _kPanelMinHeight,
        backdropEnabled: true,
        color: _bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
        boxShadow: _isDark ? _boxShadowDark : _boxShadow,
      ),
    );
  }

  Widget _buildBody() {
    final item = _curHistories;
    return ListView.builder(
      padding: EdgeInsets.only(
        left: 7,
        right: 7,
        bottom: _kPanelMinHeight + 100 + (_media?.padding.bottom ?? 0),
      ),
      itemCount: item?.length ?? 0,
      itemBuilder: (_, index) {
        return _buildChatItem(item!, index);
      },
    );
  }

  Widget _buildBottomPanel(ScrollController sc) {
    return ListenableBuilder(
      listenable: _panelRN,
      builder: (_, __) {
        final keys = _allHistories.keys.toList();
        return ListView.builder(
          controller: sc,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          itemCount: keys.length + 3,
          itemBuilder: (_, index) {
            return switch (index) {
              0 => _buildDragHandle(),
              1 => _buildInput(),
              2 => _buildAddChat(),
              final val => _buildHistoryListItem(keys[val - 3]),
            };
          },
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return UnconstrainedBox(
      child: Container(
        width: 37,
        height: 3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isDark ? Colors.white10 : Colors.black12,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    ).padding(const EdgeInsets.only(top: 7, bottom: 3));
  }

  Widget _buildHistoryListItem(String chatId) {
    final entity = _allHistories[chatId];
    if (entity == null) return UIs.placeholder;
    final node = _chatRNMap.putIfAbsent(chatId, () => RebuildNode());
    return ListTile(
      leading: Text('#${entity.items.length}', style: UIs.textGrey),
      title: ListenableBuilder(
        listenable: node,
        builder: (_, __) => Text(
          entity.name.isEmpty ? 'Untitled' : entity.name,
        ),
      ),
      subtitle: ListenableBuilder(
        listenable: _timeRN,
        builder: (_, __) => Text(
          (entity.items.lastOrNull?.createdAt ?? DateTime.now()).toAgo,
          style: UIs.textGrey,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _onTapRenameChat(chatId, entity, node),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _onTapDeleteChat(chatId),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      onTap: () {
        _switchChat(chatId);
      },
    ).card;
  }

  Widget _buildAddChat() {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text('New'),
      onTap: () async {
        _switchChat(_newChat().id);
        _panelRN.rebuild();
      },
    ).card.padding(EdgeInsets.only(top: 20 + (_media?.padding.bottom ?? 0)));
  }

  Widget _buildChatItemBtn(
    List<ChatHistoryItem> chatItems,
    ChatHistoryItem chatItem,
  ) {
    return Row(
      children: [
        Text(chatItem.role.name.upperFirst, style: UIs.text13Grey),
        const Spacer(),
        IconButton(
          onPressed: () {
            chatItems.remove(chatItem);
            _storeChat(_curChatId);
            _bodyRN.rebuild();
          },
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.delete,
            size: 17,
          ),
        ),
        IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: chatItem.toMarkdown));
            context.showSnackBar('Copied');
          },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChatItemBtn(chatItems, chatItem),
        ListenableBuilder(
          listenable: node,
          builder: (_, __) {
            return MarkdownBody(data: chatItem.toMarkdown, selectable: true);
          },
        ),
      ],
    ).padding(const EdgeInsets.all(7));
  }

  Widget _buildInput() {
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: _media?.viewInsets.bottom ?? 0),
      curve: Curves.fastEaseInToSlowEaseOut,
      duration: Durations.short1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _onImgPick,
                icon: const Icon(Icons.photo, size: 19),
              ),
              IconButton(
                onPressed: _onTapSetting,
                icon: const Icon(Icons.settings, size: 19),
              ),
              const Spacer(),
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
            label: 'Message',
            node: _focusNode,
            type: TextInputType.multiline,
            maxLines: 2,
            minLines: 2,
            suffix: IconButton(
              icon: const Icon(Icons.send),
              // Capture here
              onPressed: () => _onSend(_curChatId),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      width: (_media?.size.width ?? 300) * 0.7,
      color: _bg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FlutterLogo(size: 57),
          UIs.height13,
          const Text(
            'GPT Box\nv1.0.${BuildData.build}',
            textAlign: TextAlign.center,
          ),
          UIs.height77,
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Routes.setting.go(context);
            },
          ).card,
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup'),
            onTap: () {
              Routes.backup.go(context);
            },
          ).card,
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Routes.about.go(context);
            },
          ).card,
        ],
      ).padding(const EdgeInsets.symmetric(horizontal: 13)),
    );
  }

  Future<void> _onImgPick() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    final path = result?.files.single.path;
    if (path == null) return;
    final b64 = base64Encode(await File(path).readAsBytes());
    _curHistories?.add(ChatHistoryItem.noid(
      content: [
        ChatContent(
          type: ChatContentType.image,
          raw: 'base64://$b64',
        ),
      ],
      role: ChatRole.user,
    ));
  }

  Future<void> _onSend(String chatId) async {
    if (_inputCtrl.text.isEmpty) return;
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
    _bodyRN.rebuild();
    try {
      chatStream.listen(
        (event) {
          final delta = event.choices.first.delta.content?.first.text ?? '';
          assistReply.content.first.raw += delta;
          _mdRNMap[assistReply.id]?.rebuild();
        },
        onError: (e) {
          Loggers.app.warning('Listen chat stream: $e');
          // workingChat.items.add(ChatHistoryItem.noid(
          //   content: [
          //     ChatContent(type: ChatContentType.text, raw: 'Error: $e'),
          //   ],
          //   role: ChatRole.system,
          //   createdAt: DateTime.now(),
          // ));
          // _rebuildMap[assistReply.id]?.rebuild();
          // _generatingMap.remove(chatId);
          // _storeHistory(chatId);
        },
        onDone: () {
          _mdRNMap[assistReply.id]?.rebuild();
          _storeChat(chatId);
        },
      );
    } catch (e) {
      final msg = 'Chat stream: $e';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      assistReply.content.first.raw += '\n$msg';
    }
  }

  void _switchChat([String? id]) {
    id ??= _allHistories.keys.firstOrNull ?? _newChat().id;
    _curChatId = id;
    _applyChatConfig(_getChatConfig(_curChatId));
    _mdRNMap.clear();
    _bodyRN.rebuild();
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
    OpenAI.baseUrl = config.url;
  }

  ChatConfig _getChatConfig(String chatId) {
    return _allHistories[chatId]?.config ?? ChatConfig.fromStore();
  }

  void _onTapSetting() async {
    final config = _getChatConfig(_curChatId);
    final result = await context.showRoundDialog<ChatConfig>(
      title: 'Current chat',
      child: _ConversationSetting(config: config),
    );
    if (result == null) return;
    Loggers.app.info('Chat config: $result');
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
    final name = entity.name.isEmpty ? 'Untitled' : entity.name;
    context.showRoundDialog(
      title: 'Attention',
      child: Text('Delete chat [$name]?'),
      actions: [
        TextButton(
          onPressed: () {
            Stores.history.delete(chatId);
            _allHistories.remove(chatId);
            if (_curChatId == chatId) {
              _switchChat();
            }
            _panelRN.rebuild();
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }

  void _onTapRenameChat(
    String chatId,
    ChatHistory entity,
    RebuildNode node,
  ) async {
    final ctrl = TextEditingController(text: entity.name);
    final title = await context.showRoundDialog<String>(
      title: 'Rename',
      child: Input(
        controller: ctrl,
        onSubmitted: (p0) => context.pop(p0),
      ),
    );
    if (title == null || title.isEmpty) return;
    entity.name = title;
    node.rebuild();
    _storeChat(chatId);
  }
}
