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

/// Assumption that context len = 3:
/// - History len = 0 => [prompt]
/// - History len = 1 => [prompt, idx0]
/// - 2 => [prompt, idx0, idx1]
/// - n >= 3 => [prompt, idxn-2, idxn-1]
Iterable<OpenAIChatCompletionChoiceMessageModel> _historyCarried(
  ChatHistory workingChat,
) {
  final config = OpenAICfg.current;

  // #106
  final ignoreCtxCons = workingChat.settings?.ignoreContextConstraint == true;
  if (ignoreCtxCons) return workingChat.items.map((e) => e.toOpenAI);

  final prompt = config.prompt.isNotEmpty
      ? ChatHistoryItem.single(
          role: ChatRole.system,
          raw: config.prompt,
        ).toOpenAI
      : null;

  // #101
  if (workingChat.settings?.headTailMode == true) {
    final first = workingChat.items.firstOrNull?.toOpenAI;
    return [
      if (prompt != null) prompt,
      if (first != null) first,
    ];
  }

  var count = 0;
  final msgs = workingChat.items.reversed
      .takeWhile((e) {
        // HISTORY_LEN = LEN - 1 (1: user's question)
        if (config.historyLen > count) return false;
        if (!e.role.isSystem) return false;
        count++;
        return true;
      })
      .map((e) => e.toOpenAI)
      .toList();
  if (prompt != null) msgs.add(prompt);
  return msgs.reversed;
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

Future<void> _onCreateText(
  BuildContext context,
  String chatId,
) async {
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

  final (imgUrl, imgPath) = await ImageUtil.normalizeUrl(_filePicked.value);
  final hasImg = imgPath != null || imgUrl != null;
  final question = ChatHistoryItem.gen(
    content: [
      ChatContent.text(questionContent),
      if (imgPath != null) ChatContent.image(imgPath),
    ],
    role: ChatRole.user,
  );
  final questionForApi = ChatHistoryItem.gen(
    role: ChatRole.user,
    content: [
      ChatContent.text(questionContent),
      if (imgUrl != null) ChatContent.image(imgUrl),
    ],
  );
  final msgs = _historyCarried(workingChat).toList();
  msgs.add(questionForApi.toOpenAI);

  workingChat.items.add(question);
  _genChatTitle(context, chatId, config);
  _inputCtrl.clear();
  _chatRN.notify();
  _loadingChatIds.add(chatId);
  _autoScroll(chatId);

  final useTools = OpenAICfg.canUseToolNow;

  // #104
  final singleChatScopeUseTools = workingChat.settings?.useTools != false;

  /// TODO: after switching to http img url, remove this condition.
  /// To save tokens, we don't use tools for image prompt
  if (useTools && !hasImg && singleChatScopeUseTools) {
    final toolReply = ChatHistoryItem.single(role: ChatRole.tool, raw: '');
    workingChat.items.add(toolReply);
    _loadingChatIds.add(toolReply.id);
    _loadingChatIdRN.notify();
    _chatRN.notify();
    _autoScroll(chatId);

    OpenAIChatCompletionModel? resp;
    try {
      resp = await OpenAI.instance.chat.create(
        model: config.model,
        messages: [
          ChatHistoryItem.single(
            role: ChatRole.system,
            raw: ChatTitleUtil.toolPrompt,
          ).toOpenAI,
          ...msgs,
        ],
        tools: OpenAIFuncCalls.tools,
      );
    } catch (e, s) {
      _onErr(e, s, chatId, 'Tool');
    }

    final toolCalls = resp?.choices.firstOrNull?.message.toolCalls;
    if (toolCalls != null && toolCalls.isNotEmpty) {
      void onToolLog(String log) {
        toolReply.content.first.raw = log;
        _chatItemRNMap[toolReply.id]?.notify();
      }

      final contents = <ChatContent>[];
      for (final toolCall in toolCalls) {
        try {
          final msg = await OpenAIFuncCalls.handle(
            toolCall,
            (e, s) => _askToolConfirm(context, e, s),
            onToolLog,
          );
          if (msg != null) contents.addAll(msg);
        } catch (e, s) {
          _onErr(e, s, chatId, 'Tool call');
        }
      }
      toolReply.content.clear();
      if (contents.isNotEmpty) {
        toolReply.content.addAll(contents);
        _chatItemRNMap[toolReply.id]?.notify();
        msgs.add(toolReply.toOpenAI);
      }
    } else {
      workingChat.items.remove(toolReply);
      _chatItemRNMap[toolReply.id]?.notify();
      _chatRN.notify();
    }

    _loadingChatIds.remove(toolReply.id);
    _loadingChatIdRN.notify();
  }

  final chatStream = OpenAI.instance.chat.createStream(
    model: config.model,
    messages: msgs,
  );
  final assistReply = ChatHistoryItem.single(role: ChatRole.assist);
  workingChat.items.add(assistReply);
  _chatRN.notify();
  _loadingChatIds.add(assistReply.id);
  _loadingChatIdRN.notify();
  _filePicked.value = null;
  _sendBtnRN.notify();

  _chatFabAutoHideKey.currentState?.autoHideEnabled = false;
  try {
    chatStream.listen(
      (eve) async {
        final first = eve.choices.firstOrNull;
        final delta = first?.delta.content?.firstOrNull?.text;
        if (delta == null) return;
        assistReply.content.first.raw += delta;
        _chatItemRNMap[assistReply.id]?.notify();

        _autoScroll(chatId);
      },
      onError: (e, s) {
        _onStopStreamSub(chatId);
        _loadingChatIds.remove(assistReply.id);
        _loadingChatIdRN.notify();
        _onErr(e, s, chatId, 'Listen text stream');
      },
      onDone: () async {
        _storeChat(chatId);
        _onStopStreamSub(chatId);
        _loadingChatIds.remove(chatId);
        _loadingChatIds.remove(assistReply.id);
        _loadingChatIdRN.notify();
        // Wait for db to store the chat
        await Future.delayed(const Duration(milliseconds: 300));
        SyncService.sync();
      },
    );
  } catch (e, s) {
    _onErr(e, s, chatId, 'Listen text stream');
    _loadingChatIds.remove(chatId);
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
  _chatRN.notify();

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
    _chatItemRNMap[assistReply.id]?.notify();
    _storeChat(chatId);
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
  _chatRN.notify();

  final cfg = OpenAICfg.current;
  try {
    final resp = await OpenAI.instance.image.create(
      model: cfg.imgModel,
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
    _storeChat(chatId);
    _chatRN.notify();
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
  _chatRN.notify();
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
    _storeChat(chatId);
    _chatRN.notify();
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
  _chatRN.notify();
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
    _storeChat(chatId);
    _chatRN.notify();
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
    _historyRNMap[chatId]?.notify();
    if (chatId == _curChatId) _appbarTitleRN.notify();
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

    String title = '';
    stream.listen(
      (eve) {
        final t = eve.choices.firstOrNull?.delta.content?.firstOrNull?.text;
        if (t == null) return;

        /// These punctions which not affect the meaning of the title will be removed
        title += t;
        _historyRNMap[chatId]?.notify();
        if (chatId == _curChatId) _appbarTitleRN.notify();
      },
      onError: (e, s) => onErr(e, s),
      onDone: () {
        title = ChatTitleUtil.prettify(title);

        if (title.isNotEmpty) {
          final ne = entity.copyWith(name: title)..save();
          _allHistories[chatId] = ne;
          _historyRNMap[chatId]?.notify();
          if (chatId == _curChatId) _appbarTitleRN.notify();
        }
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
  if (_loadingChatIds.contains(chatId)) {
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

  // tool
  if (itemIdx + 1 < chatHistory.items.length) {
    final item = chatHistory.items.elementAt(itemIdx + 1);
    if (item.role.isAssist || item.role.isTool) {
      chatHistory.items.removeAt(itemIdx + 1);
    }
  }
  // assist
  if (itemIdx + 1 < chatHistory.items.length) {
    final item = chatHistory.items.elementAt(itemIdx + 1);
    if (item.role.isAssist || item.role.isTool) {
      chatHistory.items.removeAt(itemIdx + 1);
    }
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

  final msg = '$e\n\n```$s```';
  final workingChat = _allHistories[chatId];
  if (workingChat == null) return;

  // If previous msg is assistant reply and it's empty, remove it
  if (workingChat.items.isNotEmpty) {
    final last = workingChat.items.last;
    if (last.role.isAssist && last.content.every((e) => e.raw.isEmpty)) {
      workingChat.items.removeLast();
    }
  }

  // Add error msg to the chat
  workingChat.items.add(ChatHistoryItem.single(
    type: ChatContentType.text,
    raw: msg,
    role: ChatRole.system,
  ));

  _chatRN.notify();

  if (Stores.setting.saveErrChat.fetch()) _storeChat(chatId);
  _sendBtnRN.notify();
}
