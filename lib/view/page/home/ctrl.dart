part of 'home.dart';

void _switchChat([String? id]) {
  id ??= _allHistories.keys.firstOrNull ?? _newChat().id;
  _curChatId = id;
  _applyChatConfig(_getChatConfig(_curChatId));
  _mdRNMap.clear();
  _chatRN.rebuild();
  _sendBtnRN.rebuild();
  _appbarTitleRN.rebuild();
}

void _storeChat(String chatId, BuildContext context) {
  final chat = _allHistories[chatId];
  if (chat == null) {
    final msg = 'Store Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  Stores.history.put(chat);
}

Future<void> _onSend(String chatId, BuildContext context) async {
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
  _genChatTitle(chatId, context);
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
        _storeChat(chatId, context);
        _sendBtnRN.rebuild();
      },
      onDone: () {
        _onStopStreamSub(chatId);
        _storeChat(chatId, context);
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

ChatHistory _newChat() {
  late final ChatHistory newHistory;
  if (_allHistories.isEmpty && !Stores.setting.initHelpShown.fetch()) {
    newHistory = ChatHistory.example;
  } else {
    newHistory = ChatHistory.empty;
  }
  _allHistories[newHistory.id] = newHistory;
  _allChatIds.add(newHistory.id);
  Stores.history.put(newHistory);
  return newHistory;
}

void _applyChatConfig(ChatConfig config) {
  OpenAICfg.key = config.key;
  OpenAICfg.url = config.url;
}

ChatConfig _getChatConfig(String chatId) {
  return _allHistories[chatId]?.config ?? ChatConfig.fromStore();
}

void _onTapSetting(BuildContext context) async {
  final config = _getChatConfig(_curChatId);
  final result = await context.showRoundDialog<ChatConfig>(
    title: '${l10n.settings}(${l10n.current})',
    child: _CurrentChatSettings(config: config),
  );
  if (result == null) return;
  _allHistories[_curChatId]?.config = result;
  _storeChat(_curChatId, context);
  _applyChatConfig(config);
}

void _onTapDeleteChat(String chatId, BuildContext context) {
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
  if (BuildMode.isDebug) {
    _onDeleteChat(chatId);
    return;
  }
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
  _allChatIds.remove(chatId);
  if (_curChatId == chatId) {
    _switchChat();
  }
  _historyRN.rebuild();
}

void _onTapRenameChat(String chatId, BuildContext context) async {
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
  _storeChat(chatId, context);
  _appbarTitleRN.rebuild();
}

void _onStopStreamSub(String chatId) {
  _chatStreamSubs.remove(chatId)?.cancel();
}

void _genChatTitle(String chatId, BuildContext context) async {
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

void _onShareChat(BuildContext context) async {
  final result = _curChat?.gen4Share(_isDark);
  if (result == null) {
    final msg = 'Share Chat($_curChatId): null';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final pic = await _screenshotCtrl.captureFromLongWidget(
    result,
    context: context,
    constraints: const BoxConstraints(maxWidth: 577),
    pixelRatio: _media?.devicePixelRatio ?? 1,
  );
  final title = _curChat?.name ?? l10n.untitled;
  Share.shareXFiles(
    [XFile.fromData(pic, name: '$title.png', mimeType: 'image/png')],
    subject: '$title - GPT Box',
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

void loadFromStore() {
  _allHistories = Stores.history.fetchAll();
  _allChatIds = _allHistories.keys.toList();
  _historyRN.rebuild();
  _switchChat();
}

void _removeDuplicateHistory(BuildContext context) async {
  final existTitles = <String>{};
  final rmIds = <String>[];
  for (final item in _allHistories.values) {
    if (rmIds.contains(item.id)) continue;
    final name = item.name;
    if (name == null || name.isEmpty) continue;
    if (existTitles.contains(item.name)) {
      rmIds.add(item.id);
    } else {
      existTitles.add(name);
    }
  }

  if (rmIds.isEmpty) {
    return;
  }

  final rmCount = rmIds.length;
  final result = await context.showRoundDialog<bool>(
    title: l10n.attention,
    child: Text(l10n.rmDuplicationFmt(rmCount)),
    actions: [
      TextButton(
        onPressed: () => context.pop(true),
        child: Text(l10n.ok),
      ),
    ],
  );

  if (result != true) return;

  for (final id in rmIds) {
    Stores.history.delete(id);
    _allHistories.remove(id);
  }
  _historyRN.rebuild();
  if (!_allHistories.keys.contains(_curChatId)) {
    _switchChat();
  }
}
