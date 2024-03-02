part of 'home.dart';

void _switchChat([String? id]) {
  id ??= _allHistories.keys.firstOrNull ?? _newChat().id;
  _curChatId = id;
  _chatItemRNMap.clear();
  _chatRN.rebuild();
  _sendBtnRN.rebuild();
  _appbarTitleRN.rebuild();
}

void _switchPreviousChat() {
  final idx = _allHistories.keys.toList().indexOf(_curChatId);
  if (idx < 0 || idx >= _allHistories.length - 1) return;
  _switchChat(_allHistories.keys.elementAt(idx + 1));
}

void _switchNextChat() {
  final idx = _allHistories.keys.toList().indexOf(_curChatId);
  if (idx <= 0) return;
  _switchChat(_allHistories.keys.elementAt(idx - 1));
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

Future<void> _onCreateChat(String chatId, BuildContext context) async {
  if (_inputCtrl.text.isEmpty) return;
  _imeFocus.unfocus();
  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final config = OpenAICfg.current;
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
  final (imgUrl, imgPath) = await () async {
    final value = _filePicked.value;
    if (value == null) return (null, null);
    final imgPath = FileUtil.joinPath(await Paths.image, uuid.v4());
    await value.saveTo(imgPath);
    // Convert to base64 url
    return (await value.base64, imgPath);
  }();
  final historyLen = config.historyLen > workingChat.items.length
      ? workingChat.items.length
      : config.historyLen;
  final historyCarried = workingChat.items.reversed
      .take(historyLen)
      .map((e) => e.toOpenAI)
      .toList();
  final question = ChatHistoryItem.gen(
    content: [
      ChatContent.text(questionContent),
      if (imgPath != null) ChatContent.image(imgPath),
    ],
    role: ChatRole.user,
  );
  workingChat.items.add(question);
  final questionForApi = ChatHistoryItem.gen(
    role: ChatRole.user,
    content: [
      ChatContent.text(questionContent),
      if (imgUrl != null) ChatContent.image(imgUrl),
    ],
  );
  _genChatTitle(context, chatId, config);
  _inputCtrl.clear();
  final chatStream = OpenAI.instance.chat.createStream(
    model: imgUrl == null ? config.model : config.imgModel,
    messages: [...historyCarried.reversed, questionForApi.toOpenAI],
  );
  final assistReply = ChatHistoryItem.single(role: ChatRole.assist);
  workingChat.items.add(assistReply);
  _chatRN.rebuild();
  _filePicked.value = null;
  try {
    final sub = chatStream.listen(
      (event) {
        final delta = event.choices.first.delta.content?.first.text ?? '';
        assistReply.content.first.raw += delta;
        _chatItemRNMap[assistReply.id]?.rebuild();

        _autoScroll(chatId);
      },
      onError: (e, trace) {
        Loggers.app.warning('Listen chat stream: $e');
        _onStopStreamSub(chatId);

        final msg = 'Error: $e\nTrace:\n$trace';
        workingChat.items.add(ChatHistoryItem.single(
          type: ChatContentType.text,
          raw: msg,
          role: ChatRole.system,
        ));
        _chatRN.rebuild();
        _storeChat(chatId, context);
        _sendBtnRN.rebuild();
      },
      onDone: () async {
        _onStopStreamSub(chatId);
        _storeChat(chatId, context);
        _sendBtnRN.rebuild();
        // Wait for db to store the chat
        await Future.delayed(const Duration(milliseconds: 300));
        SyncService.sync();
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

  /// Put newHistory to the first place, the default implementation of Dart's
  /// Map will put the new item to the last place.
  _allHistories = {newHistory.id: newHistory, ..._allHistories};
  Stores.history.put(newHistory);
  return newHistory;
}

void _onTapDeleteChat(String chatId, BuildContext context) {
  final entity = _allHistories[chatId];
  if (entity == null) {
    final msg = 'Delete Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  /// If items is empty, delete it directly
  if (entity.items.isEmpty) {
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
    actions: Btns.oks(
      onTap: () {
        _onDeleteChat(chatId);
        context.pop();
      },
      red: true,
    ),
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
      autoFocus: true,
      onSubmitted: (p0) => context.pop(p0),
    ),
    actions: Btns.oks(onTap: () => context.pop(ctrl.text)),
  );
  if (title == null || title.isEmpty) return;
  entity.name = title;
  _historyRNMap[chatId]?.rebuild();
  _storeChat(chatId, context);
  _appbarTitleRN.rebuild();
}

void _onStopStreamSub(String chatId) {
  _chatStreamSubs.remove(chatId)?.cancel();
  _sendBtnRN.rebuild();
}

Future<void> _genChatTitle(
  BuildContext context,
  String chatId,
  ChatConfig cfg,
) async {
  if (!Stores.setting.genTitle.fetch()) return;

  final entity = _allHistories[chatId];
  if (entity == null) {
    final msg = 'Gen Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  if (entity.items.length != 1) return;

  final resp = await OpenAI.instance.chat.create(
    model: cfg.model,
    messages: [
      ChatHistoryItem.single(
        raw: '''
Create a simple and clear title based on user content.
If the language is Chinese, Japanese or Korean, the title should be within 10 characters; 
if it is English, French, German, Latin and other Western languages, the number of title characters should not exceed 23. 
The title should be the same as the language entered by the user.''',
        role: ChatRole.system,
      ).toOpenAI,
      entity.items.first.toOpenAI,
    ],
  );
  final title = resp.choices.firstOrNull?.message.content?.firstOrNull?.text;
  if (title == null) {
    final msg = 'Gen Chat($chatId) title: null resp';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  /// These punctions which not affect the meaning of the title will be removed
  const punctions2Rm = ['。', '"', "'", "“", '”'];
  entity.name = title.replaceAll(RegExp('[${punctions2Rm.join()}]'), '');
  _historyRNMap[chatId]?.rebuild();
  if (chatId == _curChatId) _appbarTitleRN.rebuild();
}

void _onShareChat(BuildContext context) async {
  final result = _curChat?.gen4Share(context);
  if (result == null) {
    final msg = 'Share Chat($_curChatId): null';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final pic = await context.showLoadingDialog(fn: () {
    return _screenshotCtrl.captureFromLongWidget(
      result,
      context: context,
      constraints: const BoxConstraints(maxWidth: 577),
      pixelRatio: _media?.devicePixelRatio ?? 1,
      delay: const Duration(milliseconds: 500),
    );
  });
  final title = _curChat?.name ?? l10n.untitled;
  final shareResult = await Share.shareXFiles(
    [XFile.fromData(pic, name: '$title.png', mimeType: 'image/png')],
    subject: '$title - GPT Box',
  );
  if (shareResult.status == ShareResultStatus.success) {
    context.showSnackBar(l10n.success);
  }
}

Future<void> _onTapImgPick(BuildContext context) async {
  if (_filePicked.value != null) {
    final delete = await context.showRoundDialog(
      title: l10n.file,
      child: Image.memory(
        await _filePicked.value!.readAsBytes(),
        fit: BoxFit.cover,
        cacheHeight: 100,
        cacheWidth: 100,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(
            l10n.delete,
            style: UIs.textRed,
          ),
        ),
      ],
    );
    if (delete == true) {
      _filePicked.value = null;
    }
    return;
  }
  final picker = ImagePicker();
  final result = await picker.pickImage(source: ImageSource.gallery);
  if (result == null) return;
  final len = await result.length();
  if (len > 1024 * 1024 * 10) {
    context.showSnackBar(l10n.fileTooLarge(len.bytes2Str));
    return;
  }
  _filePicked.value = result;
}

void loadFromStore() {
  _allHistories = Stores.history.fetchAll();
  _historyRN.rebuild();
  _switchChat();
}

void _removeDuplicateHistory(BuildContext context) async {
  final existTitles = <String, String>{}; // {ID: Title}
  final rmIds = <String>[];
  for (final item in _allHistories.values) {
    if (rmIds.contains(item.id)) continue;
    final name = item.name;
    if (name == null || name.isEmpty) continue;
    // For performance, only check the title at first
    final titleIncluded = existTitles.values.contains(item.name);
    if (titleIncluded) {
      // Secondly, check the length of the history
      final sameLen = _allHistories[item.id]?.items.length == item.items.length;
      if (sameLen) {
        // Thirdly, check the content of the history
        final sameContent = _allHistories[item.id]
                ?.items
                .map((e) => e.content.first.raw)
                .join() ==
            item.items.map((e) => e.content.first.raw).join();
        if (sameContent) {
          rmIds.add(item.id);
        }
      }
    } else {
      existTitles[item.id] = name;
    }
  }

  if (rmIds.isEmpty) {
    return;
  }

  final rmCount = rmIds.length;
  context.showSnackBarWithAction(
    content: l10n.rmDuplicationFmt(rmCount),
    action: l10n.delete,
    onTap: () {
      for (final id in rmIds) {
        Stores.history.delete(id);
        _allHistories.remove(id);
      }
      _historyRN.rebuild();
      if (!_allHistories.keys.contains(_curChatId)) {
        _switchChat();
      }
    },
  );
}

void _locateHistoryListener() => Funcs.throttle(
      () {
        // Calculate _curChatId is visible or not
        final idx = _allHistories.keys.toList().indexOf(_curChatId);
        final offset = _historyScrollCtrl.offset;
        final height = _historyScrollCtrl.position.viewportDimension;
        final visible =
            offset - _historyLocateTollerance <= idx * _historyItemHeight &&
                offset + height + _historyLocateTollerance >=
                    (idx + 1) * _historyItemHeight;
        _locateHistoryBtn.value = !visible;
      },
      id: 'calcChatLocateBtn',
      duration: 10,
    );

void _gotoHistory(String chatId) {
  final idx = _allHistories.keys.toList().indexOf(chatId);
  if (idx == -1) return;
  _historyScrollCtrl.animateTo(
    idx * _historyItemHeight,
    duration: Durations.long1,
    curve: Curves.easeInOut,
  );
}

void _onTapReplay(
    BuildContext context, String chatId, ChatHistoryItem item) async {
  if (item.role != ChatRole.user) return;
  final sure = await context.showRoundDialog<bool>(
    title: l10n.attention,
    child: Text('${l10n.replay} ?'),
    actions: Btns.oks(onTap: () => context.pop(true), red: true),
  );
  if (sure != true) return;
  _onReplay(context: context, chatId: chatId, item: item);
}

/// Remove the [ChatHistoryItem] behind this [item], and resend the [item] like
/// [_onCreateChat], but append the result after this [item] instead of at the end.
void _onReplay({
  required BuildContext context,
  required String chatId,
  required ChatHistoryItem item,
}) async {
  // If is receiving the reply, ignore this action
  if (_chatStreamSubs.containsKey(chatId)) {
    final msg = 'Replay Chat($chatId) is receiving reply';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final chatHistory = _allHistories[chatId];
  if (chatHistory == null) {
    final msg = 'Replay Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final itemIdx = chatHistory.items.indexOf(item);
  if (itemIdx == -1) {
    final msg = 'Replay Chat($chatId) item($item) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  // remove exist reply
  if (itemIdx + 1 < chatHistory.items.length &&
      chatHistory.items[itemIdx + 1].role == ChatRole.assist) {
    chatHistory.items.removeAt(itemIdx + 1);
  }

  final config = OpenAICfg.current;
  final questionContent = switch ((
    config.prompt,
    config.historyLen,
    chatHistory.items.length,
  )) {
    ('', _, _) => item.toMarkdown,

    /// If prompt is not empty and historyCount == null || 0,
    /// append it to the input
    (final prompt, 0, _) => '$prompt\n${item.toMarkdown}',

    /// If this the first msg, append it to the input
    (final prompt, _, 1) => '$prompt\n${item.toMarkdown}',
    _ => item.content.first.raw,
  };
  final question = ChatHistoryItem.single(
    raw: questionContent,
    role: ChatRole.user,
  );

  final historyCarried = chatHistory.items.reversed
      .take(config.historyLen)
      .map(
        (e) => e.toOpenAI,
      )
      .toList();

  final chatStream = OpenAI.instance.chat.createStream(
    model: config.model,
    messages: [...historyCarried.reversed, question.toOpenAI],
  );
  final assistReply = ChatHistoryItem.single(role: ChatRole.assist);
  chatHistory.items.insert(itemIdx + 1, assistReply);
  _chatRN.rebuild();
  try {
    final sub = chatStream.listen(
      (event) {
        final delta = event.choices.first.delta.content?.first.text ?? '';
        assistReply.content.first.raw += delta;
        _chatItemRNMap[assistReply.id]?.rebuild();

        _autoScroll(chatId);
      },
      onError: (e, trace) {
        Loggers.app.warning('Listen chat stream: $e');
        _onStopStreamSub(chatId);

        final msg = 'Error: $e\nTrace:\n$trace';
        chatHistory.items.add(ChatHistoryItem.single(
          raw: msg,
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
        _appbarTitleRN.rebuild();
        SyncService.sync();
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

void _onTapEditMsg(BuildContext context, ChatHistoryItem chatItem) async {
  final ctrl = TextEditingController(text: chatItem.toMarkdown);
  await context.showRoundDialog(
    title: l10n.edit,
    child: Input(
      controller: ctrl,
      maxLines: 7,
      minLines: 1,
      autoCorrect: true,
      autoFocus: true,
      suggestion: true,
      action: TextInputAction.send,
      onSubmitted: (p0) {
        chatItem.content.clear();
        chatItem.content.add(ChatContent.text(p0));
        _storeChat(_curChatId, context);
        _chatRN.rebuild();
        context.pop();
      },
    ),
  );
}

Future<void> _onCreateTTS(BuildContext context, String chatId) async {
  if (isWeb) {
    final msg = l10n.notSupported('TTS Web');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  if (_inputCtrl.text.isEmpty) return;
  _imeFocus.unfocus();
  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final config = OpenAICfg.current;
  final questionContent = _inputCtrl.text;
  final question = ChatHistoryItem.single(
    type: ChatContentType.text,
    raw: questionContent,
    role: ChatRole.user,
  );
  workingChat.items.add(question);
  _inputCtrl.clear();
  final assistReply = ChatHistoryItem.single(
    role: ChatRole.assist,
    type: ChatContentType.audio,
  );
  workingChat.items.add(assistReply);
  final completer = Completer();
  _audioLoadingMap[assistReply.id] = completer;
  _chatRN.rebuild();
  _storeChat(chatId, context);

  try {
    await OpenAI.instance.audio.createSpeech(
      model: config.model,
      input: questionContent,
      voice: 'nova',
      outputDirectory: Directory(await Paths.audio),
      outputFileName: assistReply.id,
      responseFormat: OpenAIAudioSpeechResponseFormat.mp3,
    );
    assistReply.content.first.raw = assistReply.id;
    completer.complete();
    _audioLoadingMap.remove(assistReply.id);
    _storeChat(chatId, context);
  } catch (e) {
    _onStopStreamSub(chatId);
    final msg = 'Audio create speech: $e';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    assistReply.content.first.raw += '\n$msg';
    _sendBtnRN.rebuild();
  }
}

Future<void> _onCreateImg(BuildContext context) async {
  final prompt = _inputCtrl.text;
  if (prompt.isEmpty) return;
  _imeFocus.unfocus();
  _inputCtrl.clear();

  final workingChat = _allHistories[_curChatId];
  if (workingChat == null) {
    final msg = 'Chat($_curChatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final resp = await OpenAI.instance.image.create(
    model: OpenAICfg.current.imgModel,
    prompt: prompt,
  );
  final imgs = <String>[];
  for (final item in resp.data) {
    final url = item.url;
    if (url != null) {
      imgs.add(url);
    }
  }
  if (imgs.isEmpty) {
    const msg = 'Create image: empty resp';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  workingChat.items.add(ChatHistoryItem.gen(
    role: ChatRole.assist,
    content: imgs.map((e) => ChatContent.image(e)).toList(),
  ));
  _chatRN.rebuild();
  _storeChat(_curChatId, context);
}

Future<void> _onEditImage(BuildContext context) async {
  final prompt = _inputCtrl.text;
  if (prompt.isEmpty) return;
  _imeFocus.unfocus();
  _inputCtrl.clear();

  final val = _filePicked.value;
  if (val == null) return;
  final workingChat = _allHistories[_curChatId];
  if (workingChat == null) return;
  final chatItem = ChatHistoryItem.single(
    type: ChatContentType.image,
    raw: val.path,
    role: ChatRole.user,
  );
  workingChat.items.add(chatItem);
  _chatRN.rebuild();
  _storeChat(_curChatId, context);
  _filePicked.value = null;

  final resp = await OpenAI.instance.image.edit(
    model: OpenAICfg.current.imgModel,
    image: File(val.path),
    prompt: prompt,
  );

  final imgs = <String>[];
  for (final item in resp.data) {
    final url = item.url;
    if (url != null) {
      imgs.add(url);
    }
  }

  if (imgs.isEmpty) {
    const msg = 'Edit image: empty resp';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  workingChat.items.add(ChatHistoryItem.gen(
    role: ChatRole.assist,
    content: imgs.map((e) => ChatContent.image(e)).toList(),
  ));
  _chatRN.rebuild();
  _storeChat(_curChatId, context);
}

Future<void> _onCreateAudioToText(BuildContext context) async {
  if (isWeb) {
    final msg = l10n.notSupported('Audio to Text Web');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final val = _filePicked.value;
  if (val == null) return;
  final workingChat = _allHistories[_curChatId];
  if (workingChat == null) return;
  final chatItem = ChatHistoryItem.single(
    type: ChatContentType.audio,
    raw: val.path,
    role: ChatRole.user,
  );
  workingChat.items.add(chatItem);
  _chatRN.rebuild();
  _storeChat(_curChatId, context);
  _filePicked.value = null;

  final resp = await OpenAI.instance.audio.createTranscription(
    model: OpenAICfg.current.speechModel,
    file: File(val.path),
    prompt: '',
  );
  final text = resp.text;
  if (text.isEmpty) {
    const msg = 'Audio to Text: empty resp';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  workingChat.items.add(ChatHistoryItem.single(
    role: ChatRole.assist,
    type: ChatContentType.text,
    raw: text,
  ));
  _chatRN.rebuild();
  _storeChat(_curChatId, context);
}

/// Auto select model and send the request
void _onCreateRequest(BuildContext context, String chatId) async {
  final chatType = _chatType.value;
  final notSupport = switch (chatType) {
    /// Dart package `openai` uses [io.File], which is not supported on web
    ChatType.img || ChatType.audio => isWeb,
    _ => false,
  };
  if (notSupport) {
    final msg = l10n.notSupported('Web ${chatType.name}');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  return await switch ((chatType, _filePicked.value)) {
    (ChatType.text, _) => _onCreateChat(chatId, context),
    (ChatType.img, null) => _onCreateImg(context),
    (ChatType.img, _) => _onEditImage(context),
    (ChatType.audio, null) => _onCreateTTS(context, chatId),
    (ChatType.audio, _) => _onCreateAudioToText(context),
  };
}

void _onTapAudioCtrl(
  AudioPlayStatus val,
  ChatHistoryItem chatItem,
  ValueNotifier<AudioPlayStatus> listenable,
) async {
  if (val.playing) {
    _audioPlayer.pause();
    _nowPlayingId = null;
    listenable.value = val.copyWith(playing: false);
  } else {
    if (_nowPlayingId == chatItem.id) {
      _audioPlayer.resume();
      _nowPlayingId = chatItem.id;
      listenable.value = val.copyWith(playing: true);
      return;
    } else {
      if (_nowPlayingId != null) {
        final last = _audioPlayerMap[_nowPlayingId];
        if (last != null) {
          _audioPlayer.pause();
          _nowPlayingId = null;
          last.value = last.value.copyWith(playing: false);
        }
      }
    }
    _nowPlayingId = chatItem.id;
    listenable.value = val.copyWith(playing: true);
    _audioPlayer.play(DeviceFileSource(
      '${await Paths.audio}/${chatItem.id}.mp3',
    ));
  }
}

void _autoScroll(String chatId) {
  if (Stores.setting.scrollBottom.fetch()) {
    // Only scroll to bottom when current chat is the working chat
    final isWorking = chatId == _curChatId;
    final isSubscribed = _chatStreamSubs.containsKey(chatId);
    final isDisplaying = _chatScrollCtrl.hasClients;
    if (isWorking && isSubscribed && isDisplaying) {
      _chatScrollCtrl.jumpTo(_chatScrollCtrl.position.maxScrollExtent);
    }
  }
}

// /// The chat type is determined by the following order:
// /// Programmatically -> AI -> Text
// Future<ChatType> _getChatType() async {
//   return _getChatTypeByProg() ?? await _getChatTypeByAI() ?? ChatType.text;
// }

// /// Recognize the chat type by the question content programmatically.
// ChatType? _getChatTypeByProg() {
//   if (isWeb) return ChatType.text;

//   final file = _filePicked.value;
//   if (file != null) {
//     final mime = file.mimeType;
//     if (mime != null) {
//       // If file is image
//       if (mime.startsWith('image/')) {
//         // explainImage / editImage
//         if (_inputCtrl.text.isNotEmpty) {
//           return null;
//         }
//         return ChatType.varifyImage;
//       }
//       // If file is audio
//       if (mime.startsWith('audio/')) {
//         return ChatType.audioToText;
//       }
//     }
//   }

//   return null;
// }

// /// Send [_inputCtrl.text] to OpenAI and get the chat type by the AI response.
// Future<ChatType?> _getChatTypeByAI() async {
//   if (_inputCtrl.text.isEmpty) return null;

//   final config = OpenAICfg.current;
//   final result = await OpenAI.instance.chat.create(
//     model: config.model,
//     messages: [
//       ChatHistoryItem.single(
//         role: ChatRole.system,
//         raw: '''
// There are some types of chat:
// ${ChatType.values.map((e) => e.name).join('/')}
// Which is most proper type for this chat? (Only response the `code` of type, eg: `text`)
// ''',
//       ).toOpenAI,
//       ChatHistoryItem.single(
//         raw: _inputCtrl.text,
//         role: ChatRole.user,
//       ).toOpenAI,
//     ],
//   );
//   final type =
//       result.choices.firstOrNull?.message.content?.firstOrNull?.text?.trim();
//   if (type == null) return null;
//   return ChatType.fromString(type);
// }

Future<void> _onLongTapSetting(BuildContext context) async {
  // final map = Stores.setting.box.toJson(includeInternal: false);
  // final keys = map.keys;

  // /// Encode [map] to String with indent `\t`
  // final text = const JsonEncoder.withIndent('  ').convert(map);
  // final result = await Routes.editor.go(context, args: (
  //   text: text,
  //   langCode: 'json',
  //   title: l10n.settings,
  // ));
  // if (result == null) {
  //   return;
  // }
  // try {
  //   final newSettings = json.decode(result) as Map<String, dynamic>;
  //   Stores.setting.box.putAll(newSettings);
  //   final newKeys = newSettings.keys;
  //   final removedKeys = keys.where((e) => !newKeys.contains(e));
  //   for (final key in removedKeys) {
  //     Stores.setting.box.delete(key);
  //   }
  //   RebuildNode.app.rebuild();
  // } catch (e, trace) {
  //   context.showRoundDialog(
  //     title: l10n.error,
  //     child: Text('$e'),
  //   );
  //   Loggers.app.warning('Update json settings failed', e, trace);
  // }
}
