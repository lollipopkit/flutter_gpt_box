/// OpenAI chat request related funcs
part of 'home.dart';

bool _validChatCfg(BuildContext context) {
  final config = OpenAICfg.current;
  final urlEmpty = config.url == 'https://api.openai.com' || config.url.isEmpty;
  if (urlEmpty && config.key.isEmpty) {
    final msg = l10n.emptyFields('${l10n.secretKey} | Api Url');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return false;
  }
  return true;
}

/// Auto select model and send the request
void _onCreateRequest(BuildContext context, String chatId) async {
  if (!_validChatCfg(context)) return;

  // Issues #18.
  // Prohibit users from starting chatting in the initial chat
  if (_curChat?.isInitHelp ?? false) {
    final newId = _newChat().id;
    _switchChat(newId);
    chatId = newId;
  }

  final chatType = _chatType.value;
  final notSupport = switch (chatType) {
    // Dart package `openai` uses [io.File], which is not supported on web
    ChatType.img || ChatType.audio => isWeb,
    _ => false,
  };
  if (notSupport) {
    final msg = l10n.notSupported('Web ${chatType.name}');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final func = switch ((chatType, _filePicked.value)) {
    (ChatType.text, _) => _onCreateText,
    (ChatType.img, null) => _onCreateImg,
    (ChatType.img, _) => _onCreateImgEdit,
    (ChatType.audio, null) => _onCreateTTS,
    (ChatType.audio, _) => _onCreateSTT,
  };
  return await func(context, chatId);
}

Future<void> _onCreateText(BuildContext context, String chatId) async {
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
  final (imgUrl, imgPath) = switch (_filePicked.value) {
    null => (null, null),
    final imgPath when imgPath.startsWith('http') => (imgPath, imgPath),
    final p when p.startsWith('/') => (await File(p).base64, p),
    _ => (null, null),
  };
  final historyCarried = workingChat.items.reversed
      .take(config.historyLen)
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
    model: config.model,
    messages: [...historyCarried.reversed, questionForApi.toOpenAI],
  );
  final assistReply = ChatHistoryItem.single(role: ChatRole.assist);
  workingChat.items.add(assistReply);
  _chatRN.build();
  _filePicked.value = null;

  try {
    _chatFabAutoHideKey.currentState?.autoHideEnabled = false;
    final sub = chatStream.listen(
      (eve) {
        final delta = eve.choices.firstOrNull?.delta.content?.firstOrNull?.text;
        if (delta == null) return;
        assistReply.content.first.raw += delta;
        _chatItemRNMap[assistReply.id]?.build();

        _autoScroll(chatId);
      },
      onError: (e, s) {
        _onErr(e, s, chatId, 'Listen text stream');
        _chatFabAutoHideKey.currentState?.autoHideEnabled = true;
      },
      onDone: () async {
        _onStopStreamSub(chatId);
        _storeChat(
          chatId,
          type: ChatType.text,
          model: config.model,
          profileId: config.id,
        );
        _sendBtnRN.build();
        // Wait for db to store the chat
        await Future.delayed(const Duration(milliseconds: 300));
        SyncService.sync();
      },
    );
    _chatStreamSubs[chatId] = sub;
    _sendBtnRN.build();
  } catch (e, s) {
    _onErr(e, s, chatId, 'Listen text stream');
  } finally {
    _chatFabAutoHideKey.currentState?.autoHideEnabled = true;
  }
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
  final replyContent = assistReply.content.first;
  AudioCard.loadingMap[replyContent.id] = completer;
  _chatRN.build();

  try {
    final file = await OpenAI.instance.audio.createSpeech(
      model: config.speechModel,
      input: questionContent,
      voice: 'nova',
      outputDirectory: Directory(Paths.audio),
      outputFileName: replyContent.id,
      responseFormat: OpenAIAudioSpeechResponseFormat.aac,
    );
    replyContent.raw = file.path;
    completer.complete();
    _chatItemRNMap[assistReply.id]?.build();
    _storeChat(
      chatId,
      type: ChatType.audio,
      model: config.speechModel,
      profileId: config.id,
    );
  } catch (e, s) {
    _onErr(e, s, chatId, 'Audio create speech');
  }
}

Future<void> _onCreateImg(BuildContext context, String chatId) async {
  final prompt = _inputCtrl.text;
  if (prompt.isEmpty) return;
  _imeFocus.unfocus();
  _inputCtrl.clear();

  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final userQuestion = ChatHistoryItem.single(role: ChatRole.user, raw: prompt);
  workingChat.items.add(userQuestion);
  _chatRN.build();

  final cfg = OpenAICfg.current;
  try {
    final resp = await OpenAI.instance.image.create(
      model: cfg.model,
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
    _storeChat(
      chatId,
      type: ChatType.img,
      model: cfg.model,
      profileId: cfg.id,
    );
    _chatRN.build();
  } catch (e, s) {
    _onErr(e, s, chatId, 'Create image');
  }
}

Future<void> _onCreateImgEdit(BuildContext context, String chatId) async {
  final prompt = _inputCtrl.text;
  if (prompt.isEmpty) return;
  _imeFocus.unfocus();
  _inputCtrl.clear();

  final val = _filePicked.value;
  if (val == null) return;
  final workingChat = _allHistories[chatId];
  if (workingChat == null) return;
  final chatItem = ChatHistoryItem.gen(
    role: ChatRole.user,
    content: [ChatContent.text(prompt), ChatContent.image(val)],
  );
  workingChat.items.add(chatItem);
  _chatRN.build();
  _filePicked.value = null;

  final cfg = OpenAICfg.current;
  try {
    final resp = await OpenAI.instance.image.edit(
      model: cfg.imgModel,
      image: File(val),
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
      throw 'Edit image: empty resp';
    }

    workingChat.items.add(ChatHistoryItem.gen(
      role: ChatRole.assist,
      content: imgs.map((e) => ChatContent.image(e)).toList(),
    ));
    _storeChat(
      chatId,
      type: ChatType.img,
      model: cfg.imgModel,
      profileId: cfg.id,
    );
    _chatRN.build();
  } catch (e, s) {
    _onErr(e, s, chatId, 'Edit image');
  }
}

Future<void> _onCreateSTT(BuildContext context, String chatId) async {
  if (isWeb) {
    final msg = l10n.notSupported('Audio to Text Web');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final val = _filePicked.value;
  if (val == null) return;
  final workingChat = _allHistories[chatId];
  if (workingChat == null) return;
  final chatItem = ChatHistoryItem.single(
    type: ChatContentType.audio,
    raw: val,
    role: ChatRole.user,
  );
  workingChat.items.add(chatItem);
  _chatRN.build();
  _storeChat(chatId);
  _filePicked.value = null;

  final cfg = OpenAICfg.current;
  try {
    final resp = await OpenAI.instance.audio.createTranscription(
      model: cfg.speechModel,
      file: File(val),
      //prompt: '',
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
    _storeChat(
      chatId,
      type: ChatType.audio,
      model: cfg.speechModel,
      profileId: cfg.id,
    );
    _chatRN.build();
  } catch (e, s) {
    _onErr(e, s, chatId, 'Audio to Text');
  }
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

  void onErr(Object e, StackTrace s) {
    Loggers.app.warning('Gen title: $e');
    _historyRNMap[chatId]?.build();
    if (chatId == _curChatId) _appbarTitleRN.build();
  }

  try {
    final stream = OpenAI.instance.chat.createStream(
      model: cfg.model,
      messages: [
        ChatHistoryItem.single(
          raw: ChatTitleUtil.titlePrompt,
          role: ChatRole.system,
        ).toOpenAI,
        ChatHistoryItem.single(
          role: ChatRole.user,
          raw: entity.items.first.content
              .firstWhere((p0) => p0.type == ChatContentType.text)
              .raw,
        ).toOpenAI,
      ],
    );

    stream.listen(
      (eve) {
        final title = eve.choices.firstOrNull?.delta.content?.firstOrNull?.text;
        if (title == null) return;

        /// These punctions which not affect the meaning of the title will be removed
        entity.name = (entity.name ?? '') + title;
        _historyRNMap[chatId]?.build();
        if (chatId == _curChatId) _appbarTitleRN.build();
      },
      onError: (e, s) => onErr(e, s),
      onDone: () {
        var title = entity.name;
        if (title == null) return;

        title = ChatTitleUtil.prettify(title);

        if (title.isNotEmpty) {
          entity.name = title;
        }

        _historyRNMap[chatId]?.build();
        if (chatId == _curChatId) _appbarTitleRN.build();
        _storeChat(chatId);
      },
    );
  } catch (e, s) {
    onErr(e, s);
  }
}

/// Remove the [ChatHistoryItem] behind this [item], and resend the [item] like
/// [_onCreateText], but append the result after this [item] instead of at the end.
void _onReplay({
  required BuildContext context,
  required String chatId,
  required ChatHistoryItem item,
}) async {
  if (!_validChatCfg(context)) return;

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

  chatHistory.items.removeAt(itemIdx);

  final text =
      item.content.firstWhereOrNull((e) => e.type == ChatContentType.text)?.raw;
  if (text != null) _inputCtrl.text = text;
  final img = item.content
      .firstWhereOrNull((e) => e.type == ChatContentType.image)
      ?.raw;
  if (img != null) _filePicked.value = img;

  _onCreateRequest(context, chatId);
}

void _onErr(Object e, StackTrace s, String chatId, String action) {
  Loggers.app.warning('$action: $e');
  _onStopStreamSub(chatId);

  final msg = 'Error: $e\n\nTrace:\n$s';
  final workingChat = _allHistories[chatId];
  if (workingChat == null) return;

  // If previous msg is assistant reply and it's empty, remove it
  if (workingChat.items.isNotEmpty) {
    final last = workingChat.items.last;
    if (last.role == ChatRole.assist &&
        last.content.every((e) => e.raw.isEmpty)) {
      workingChat.items.removeLast();
    }
  }

  // Add error msg to the chat
  workingChat.items.add(ChatHistoryItem.single(
    type: ChatContentType.text,
    raw: msg,
    role: ChatRole.system,
  ));

  _chatRN.build();

  if (Stores.setting.saveErrChat.fetch()) _storeChat(chatId);
  _sendBtnRN.build();
}
