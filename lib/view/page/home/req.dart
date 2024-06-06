/// OpenAI chat request related funcs
part of 'home.dart';

bool _checkSettingsValid(BuildContext context) {
  final config = OpenAICfg.current;
  final urlEmpty = config.url == 'https://api.openai.com' ||
      config.url == 'https://api.chatgpt.com' ||
      config.url.isEmpty;
  if (urlEmpty && config.key.isEmpty) {
    final msg = l10n.emptyFields('Api${l10n.secretKey}');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return false;
  }
  return true;
}

/// Auto select model and send the request
void _onCreateRequest(BuildContext context, String chatId) async {
  if (!_checkSettingsValid(context)) return;

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
  final (imgUrl, imgPath) = await () async {
    final value = _filePicked.value;
    if (value == null) return (null, null);
    final imgPath = Paths.img.joinPath(shortid.generate());
    await value.saveTo(imgPath);
    // Convert to base64 url
    return (await value.base64, imgPath);
  }();
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
    final sub = chatStream.listen(
      (eve) {
        final delta = eve.choices.firstOrNull?.delta.content?.firstOrNull?.text;
        if (delta == null) return;
        assistReply.content.first.raw += delta;
        _chatItemRNMap[assistReply.id]?.build();

        _autoScroll(chatId);
      },
      onError: (e, s) => _onErr(e, s, chatId, 'Listen text stream'),
      onDone: () async {
        _onStopStreamSub(chatId);
        _storeChat(chatId, type: ChatType.text, model: config.model);
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
    _storeChat(chatId, type: ChatType.audio, model: config.speechModel);
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

  final userQuestion = ChatHistoryItem.single(
    role: ChatRole.user,
    raw: prompt,
  );
  workingChat.items.add(userQuestion);
  _chatRN.build();

  final model = OpenAICfg.current.imgModel;
  try {
    final resp = await OpenAI.instance.image.create(
      model: model,
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
    _storeChat(chatId, type: ChatType.img, model: model);
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
    content: [
      ChatContent.text(prompt),
      ChatContent.image(val.path),
    ],
  );
  workingChat.items.add(chatItem);
  _chatRN.build();
  _filePicked.value = null;

  final model = OpenAICfg.current.imgModel;
  try {
    final resp = await OpenAI.instance.image.edit(
      model: model,
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
      throw 'Edit image: empty resp';
    }

    workingChat.items.add(ChatHistoryItem.gen(
      role: ChatRole.assist,
      content: imgs.map((e) => ChatContent.image(e)).toList(),
    ));
    _storeChat(chatId, type: ChatType.img, model: model);
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
    raw: val.path,
    role: ChatRole.user,
  );
  workingChat.items.add(chatItem);
  _chatRN.build();
  _storeChat(chatId);
  _filePicked.value = null;

  final model = OpenAICfg.current.speechModel;
  try {
    final resp = await OpenAI.instance.audio.createTranscription(
      model: model,
      file: File(val.path),
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
    _storeChat(chatId, type: ChatType.audio, model: model);
    _chatRN.build();
  } catch (e, s) {
    _onErr(e, s, chatId, 'Audio to Text');
  }
}

final _punctionsRm = RegExp('[。"\'“”]');

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

  final stream = OpenAI.instance.chat.createStream(
    model: cfg.model,
    messages: [
      ChatHistoryItem.single(
        raw: '''
Create a simple and clear title based on user content.
If the language is Chinese, Japanese or Korean, the title should be within 10 characters; 
if it is English, French, German, Latin and other Western languages, the number of title characters should not exceed 23. 
The title should be the same as the language entered by the user (except the code block) as below:''',
        role: ChatRole.system,
      ).toOpenAI,
      ChatHistoryItem.single(
        role: ChatRole.user,
        raw: entity.items.first.content
                .firstWhereOrNull((p0) => p0.type == ChatContentType.text)
                ?.raw ??
            '',
      ).toOpenAI,
    ],
  );

  void onErr(Object e, StackTrace s) {
    Loggers.app.warning('Gen title: $e');
    _historyRNMap[chatId]?.build();
    if (chatId == _curChatId) _appbarTitleRN.build();
  }

  try {
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
        // Prettiy the title
        entity.name = (entity.name ?? '').replaceAll(_punctionsRm, '');
        if (entity.name!.length > 23) {
          entity.name = entity.name!.substring(0, 23);
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
  if (!_checkSettingsValid(context)) return;

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
  _chatRN.build();
  try {
    final sub = chatStream.listen(
      (event) {
        final delta = event.choices.first.delta.content?.first?.text;
        if (delta == null) return;
        assistReply.content.first.raw += delta;
        _chatItemRNMap[assistReply.id]?.build();

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
        _chatRN.build();
        _storeChat(chatId);
        _sendBtnRN.build();
      },
      onDone: () {
        _onStopStreamSub(chatId);
        _storeChat(chatId);
        _sendBtnRN.build();
        _appbarTitleRN.build();
        SyncService.sync();
      },
    );
    _chatStreamSubs[chatId] = sub;
    _sendBtnRN.build();
  } catch (e) {
    _onStopStreamSub(chatId);
    final msg = 'Chat stream: $e';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    assistReply.content.first.raw += '\n$msg';
    _sendBtnRN.build();
  }
}

void _onErr(Object e, StackTrace s, String chatId, String action) {
  Loggers.app.warning('$action: $e');
  _onStopStreamSub(chatId);

  final msg = 'Error: $e\nTrace:\n$s';
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
  // Do not store if error
  // _storeChat(chatId, context);
  _sendBtnRN.build();
}
