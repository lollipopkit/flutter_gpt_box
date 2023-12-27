import 'dart:async';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/ext/datetime.dart';
import 'package:flutter_chatgpt/core/ext/string.dart';
import 'package:flutter_chatgpt/core/ext/widget.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/rebuild.dart';
import 'package:flutter_chatgpt/core/route/page.dart';
import 'package:flutter_chatgpt/data/model/chat/history.dart';
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

  final _timeRebuild = RebuildNode();
  final _rebuildMap = <String, RebuildNode>{};
  // Whether chatId is generating reply
  final _generatingMap = <String, bool>{};

  final _allHistories = <String, ChatHistory>{};
  String _curChatId = 'fake-non-exist-id';
  List<ChatHistoryItem>? get _curHistories => _allHistories[_curChatId]?.items;

  MediaQueryData? _media;
  Timer? _refreshTimeTimer;

  bool _isDark = false;
  Color _bg = UIs.bgColor.light;

  @override
  void initState() {
    super.initState();
    final allHistories = Stores.history.fetchAll();
    _allHistories.addAll(
      Map.fromIterables(allHistories.map((e) => e.id), allHistories),
    );
    _loadHistory();
    _refreshTimeTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _timeRebuild.rebuild(),
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
        body: _buildBody(),
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
        return _buildBodyItem(item!, index);
      },
    );
  }

  Widget _buildBottomPanel(ScrollController sc) {
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

  Widget _buildHistoryListItem(String historyKey) {
    final entry = _allHistories[historyKey]!;
    final shareBtn = IconButton(
      onPressed: () {},
      icon: const Icon(Icons.share),
    );
    final actions = [
      shareBtn,
      IconButton(
        onPressed: () {
          context.showSnackBarWithAction(
            content: 'Delete anyway?',
            action: 'Yes',
            onTap: () {
              Stores.history.delete(historyKey);
              _allHistories.remove(historyKey);
              if (_curChatId == historyKey) {
                _loadHistory();
              }
              setState(() {});
            },
          );
        },
        icon: const Icon(Icons.delete),
      ),
    ];
    return ListTile(
      leading: Text('#${entry.items.length}', style: UIs.textGrey),
      title: Text(entry.name),
      subtitle: ListenableBuilder(
        listenable: _timeRebuild,
        builder: (_, __) => Text(
          (entry.items.lastOrNull?.createdAt ?? DateTime.now()).toHuman,
          style: UIs.textGrey,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
      onTap: () {
        _loadHistory(historyKey);
      },
    ).card;
  }

  Widget _buildAddChat() {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text('New'),
      onTap: () async {
        _loadHistory(_newHistory().id);
        setState(() {});
      },
    ).card.padding(EdgeInsets.only(top: 20 + (_media?.padding.bottom ?? 0)));
  }

  Widget _buildBodyItem(List<ChatHistoryItem> chats, int idx) {
    final chat = chats[idx];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(chat.role.name.upperFirst, style: UIs.text13Grey),
            const Spacer(),
            IconButton(
                onPressed: () {
                  chats.remove(chat);
                  _storeHistory(chat.id);
                  setState(() {});
                },
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.delete,
                  size: 17,
                )),
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: chat.toMarkdown));
                  context.showSnackBar('Copied');
                },
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.copy,
                  size: 15,
                )),
          ],
        ),
        _buildMd(chat),
      ],
    ).padding(const EdgeInsets.all(7));
  }

  Widget _buildMd(ChatHistoryItem chat) {
    final node = _rebuildMap.putIfAbsent(chat.id, () => RebuildNode());
    return ListenableBuilder(
      listenable: node,
      builder: (_, __) {
        return MarkdownBody(data: chat.toMarkdown, selectable: true);
      },
    );
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
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  final path = result?.files.single.path;
                  if (path == null) return;
                  // upload to openai
                  final resp = await OpenAI.instance.file.upload(
                    file: File(path),
                    purpose: 'image',
                  );
                  _curHistories?.add(ChatHistoryItem.noid(
                    content: [
                      ChatContent(
                        type: ChatContentType.image,
                        raw: path,
                      ),
                    ],
                    role: ChatRole.user,
                    createdAt: DateTime.now(),
                  ));
                },
                icon: const Icon(Icons.photo, size: 19),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          Input(
            controller: _inputCtrl,
            label: 'Message',
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

  Future<void> _onSend(String chatId) async {
    if (_inputCtrl.text.isEmpty) return;
    final workingChat = _allHistories[chatId];
    if (workingChat == null) {
      final msg = 'Chat($chatId) not found';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }
    workingChat.items.add(ChatHistoryItem.noid(
      content: [
        ChatContent(type: ChatContentType.text, raw: _inputCtrl.text),
      ],
      role: ChatRole.user,
      createdAt: DateTime.now(),
    ));
    _inputCtrl.clear();
    final chatStream = OpenAI.instance.chat.createStream(
      model: Stores.setting.openaiModel.fetch(),
      messages: [
        workingChat.items.last.toOpenAI,
      ],
    );
    final assistReply = ChatHistoryItem.emptyAssist;
    workingChat.items.add(assistReply);
    _generatingMap.putIfAbsent(chatId, () => true);
    setState(() {});
    chatStream.listen(
      (event) {
        workingChat.items.last.content.first.raw +=
            event.choices.first.delta.content?.first.text ?? '';
        _rebuildMap[chatId]?.rebuild();
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
        _rebuildMap[assistReply.id]?.rebuild();
        _generatingMap.remove(chatId);
        _storeHistory(chatId);
      },
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
          Text('GPT', style: UIs.text17),
          UIs.height77,
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Routes.setting.go(context);
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

  void _loadHistory([String? id]) {
    id ??= _allHistories.keys.firstOrNull ?? _newHistory().id;
    _curChatId = id;
    _rebuildMap.clear();
    setState(() {});
  }

  ChatHistory _newHistory() {
    final newHistory = ChatHistory.empty;
    _allHistories[newHistory.id] = ChatHistory.empty;
    Stores.history.put(newHistory);
    return newHistory;
  }

  void _storeHistory(String chatId) {
    final chat = _allHistories[chatId];
    if (chat == null) {
      final msg = 'Store Chat($chatId) not found';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }
    Stores.history.put(chat);
  }
}
