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
Future<Iterable<ChatCompletionMessage>> _historyCarried(
  ChatHistory workingChat,
) async {
  final config = OpenAICfg.current;

  // #106
  final ignoreCtxCons = workingChat.settings?.ignoreContextConstraint == true;
  if (ignoreCtxCons) {
    return Future.wait(workingChat.items.map((e) async => await e.toApi()));
  }

  final promptStr = config.prompt + Stores.tool.memories.fetch().join('\n');
  final prompt = promptStr.isNotEmpty
      ? ChatHistoryItem.single(
          role: ChatRole.system,
          raw: promptStr,
        ).toOpenAI()
      : null;

  // #101
  if (workingChat.settings?.headTailMode == true) {
    final first = await workingChat.items.firstOrNull?.toApi();
    return [
      if (prompt != null) prompt,
      if (first != null) first,
    ];
  }

  var count = 0;
  final msgs = <ChatCompletionMessage>[];
  for (final item in workingChat.items.reversed) {
    if (count > config.historyLen) break;
    if (item.role.isSystem) continue;
    final msg = await item.toApi();
    msgs.add(msg);
    count++;
  }
  if (prompt != null) msgs.add(prompt);
  return msgs.reversed;
}

/// Auto select model and send the request
void _onCreateRequest(BuildContext context, String chatId) async {
  if (!_validChatCfg(context)) return;

  // #18
  // Prohibit users from starting chat in the initial chat
  if (_curChat?.isInitHelp ?? false) {
    final newId = _newChat().id;
    _switchChat(newId);
    chatId = newId;
  }

  // final chatType = _chatType.value;
  // final notSupport = switch (chatType) {
  //   // Dart package `openai` uses [io.File], which is not supported on web
  //   ChatType.img || ChatType.audio => isWeb,
  //   _ => false,
  // };
  // if (notSupport) {
  //   final msg = l10n.notSupported('Web ${chatType.name}');
  //   Loggers.app.warning(msg);
  //   context.showSnackBar(msg);
  //   return;
  // }
  // final func = switch ((chatType, _filePicked.value)) {
  //   (ChatType.text, _) => _onCreateText,
  //   (ChatType.img, null) => _onCreateImg,
  //   (ChatType.img, _) => _onCreateImgEdit,
  //   (ChatType.audio, null) => _onCreateTTS,
  //   (ChatType.audio, _) => _onCreateSTT,
  // };

  if (_inputCtrl.text.isEmpty) return;
  _imeFocus.unfocus();
  final input = _inputCtrl.text;
  return await _onCreateText(context, chatId, input, _filePicked.value?.url);
}

Future<void> _onCreateText(
  BuildContext context,
  String chatId,
  String input,
  String? fileUrl,
) async {
  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final config = OpenAICfg.current;

  final hasImg = fileUrl != null;
  final question = ChatHistoryItem.gen(
    content: [
      ChatContent.text(input),
      if (hasImg) ChatContent.image(fileUrl),
    ],
    role: ChatRole.user,
  );
  final questionForApi = ChatHistoryItem.gen(
    role: ChatRole.user,
    content: [
      ChatContent.text(input),
      if (hasImg) await ChatContent.image(fileUrl).toApi,
    ],
  );
  final msgs = (await _historyCarried(workingChat)).toList();
  msgs.add(questionForApi.toOpenAI());

  workingChat.items.add(question);
  _genChatTitle(context, chatId, config);
  _inputCtrl.clear();
  _chatRN.notify();
  _loadingChatIds.add(chatId);
  _autoScroll(chatId);

  final toolCompatible = OpenAICfg.isToolCompatible();

  // #104
  final chatScopeUseTools = workingChat.settings?.useTools != false;

  // #111
  final availableTools = OpenAIFuncCalls.tools;
  final isToolsEmpty = availableTools.isEmpty;

  if (toolCompatible && chatScopeUseTools && !isToolsEmpty) {
    // Used for logging tool call resp
    final toolReply = ChatHistoryItem.single(role: ChatRole.tool, raw: '');
    workingChat.items.add(toolReply);
    _loadingChatIds.add(toolReply.id);
    _loadingChatIdRN.notify();
    _chatRN.notify();
    _autoScroll(chatId);

    CreateChatCompletionResponse? resp;
    try {
      resp = await OpenAICfg.client!.createChatCompletion(
        request: CreateChatCompletionRequest(
          messages: msgs,
          model: ChatCompletionModel.modelId(config.model),
          tools: availableTools,
        ),
      );
    } catch (e, s) {
      _onErr(e, s, chatId, 'Tool');
    }

    final firstToolReply = resp?.choices.firstOrNull;
    final toolCalls = firstToolReply?.message.toolCalls;
    if (toolCalls != null && toolCalls.isNotEmpty) {
      final assistReply = ChatHistoryItem.gen(
        role: ChatRole.assist,
        content: [],
        toolCalls: toolCalls,
      );
      workingChat.items.add(assistReply);
      msgs.add(assistReply.toOpenAI());
      void onToolLog(String log) {
        toolReply.content.first.raw = log;
        _chatItemRNMap[toolReply.id]?.notify();
      }

      for (final toolCall in toolCalls) {
        final contents = <ChatContent>[];
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
        if (contents.isNotEmpty && contents.every((e) => e.raw.isNotEmpty)) {
          final historyItem = ChatHistoryItem.gen(
            role: ChatRole.tool,
            content: contents,
            toolCallId: toolCall.id,
          );
          workingChat.items.add(historyItem);
          msgs.add(historyItem.toOpenAI());
        }
      }
    }

    _chatItemRNMap[toolReply.id]?.notify();
    workingChat.items.remove(toolReply);
    _chatRN.notify();
    _chatItemRNMap.remove(toolReply.id)?.dispose();
    _loadingChatIds.remove(toolReply.id);
    _loadingChatIdRN.notify();
  }

  final chatStream = OpenAICfg.client!.createChatCompletionStream(
    request: CreateChatCompletionRequest(
      messages: msgs,
      model: ChatCompletionModel.modelId(config.model),
    ),
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
        final delta = first?.delta.content;
        if (delta == null) return;
        assistReply.content.first.raw += delta;
        _chatItemRNMap[assistReply.id]?.notify();

        _autoScroll(chatId);
      },
    );
  } catch (e, s) {
    _onErr(e, s, chatId, 'Listen text stream');
    _loadingChatIds.remove(chatId);
  } finally {
    _onStopStreamSub(chatId);
    _loadingChatIds.remove(chatId);
    _loadingChatIds.remove(assistReply.id);
    _loadingChatIdRN.notify();
    _chatFabAutoHideKey.currentState?.autoHideEnabled = true;

    _storeChat(chatId);
    // Wait for db to store the chat
    await Future.delayed(const Duration(milliseconds: 300));
    sync.sync();
  }
}

// Future<void> _onCreateTTS(BuildContext context, String chatId) async {
//   if (isWeb) {
//     final msg = l10n.notSupported('TTS Web');
//     Loggers.app.warning(msg);
//     context.showSnackBar(msg);
//     return;
//   }
//   if (_inputCtrl.text.isEmpty) return;
//   _imeFocus.unfocus();
//   final workingChat = _allHistories[chatId];
//   if (workingChat == null) {
//     final msg = 'Chat($chatId) not found';
//     Loggers.app.warning(msg);
//     context.showSnackBar(msg);
//     return;
//   }
//   final config = OpenAICfg.current;
//   final questionContent = _inputCtrl.text;
//   final question = ChatHistoryItem.single(
//     type: ChatContentType.text,
//     raw: questionContent,
//     role: ChatRole.user,
//   );
//   workingChat.items.add(question);
//   _inputCtrl.clear();
//   final assistReply = ChatHistoryItem.single(
//     role: ChatRole.assist,
//     type: ChatContentType.audio,
//   );
//   workingChat.items.add(assistReply);
//   final completer = Completer();
//   final replyContent = assistReply.content.first;
//   AudioCard.loadingMap[replyContent.id] = completer;
//   _chatRN.notify();

//   try {
//     final file = await OpenAICfg.client!.(
//       model: config.speechModel,
//       input: questionContent,
//       voice: 'nova',
//       outputDirectory: Directory(Paths.audio),
//       outputFileName: replyContent.id,
//       responseFormat: OpenAIAudioSpeechResponseFormat.aac,
//     );
//     replyContent.raw = file.path;
//     completer.complete();
//     _chatItemRNMap[assistReply.id]?.notify();
//     _storeChat(chatId);
//   } catch (e, s) {
//     _onErr(e, s, chatId, 'Audio create speech');
//   }
// }

// Future<void> _onCreateImg(BuildContext context, String chatId) async {
//   final prompt = _inputCtrl.text;
//   if (prompt.isEmpty) return;
//   _imeFocus.unfocus();
//   _inputCtrl.clear();

//   final workingChat = _allHistories[chatId];
//   if (workingChat == null) {
//     final msg = 'Chat($chatId) not found';
//     Loggers.app.warning(msg);
//     context.showSnackBar(msg);
//     return;
//   }

//   final userQuestion = ChatHistoryItem.single(role: ChatRole.user, raw: prompt);
//   workingChat.items.add(userQuestion);
//   _chatRN.notify();

//   final cfg = OpenAICfg.current;
//   try {
//     final resp = await OpenAI.instance.image.create(
//       model: cfg.imgModel,
//       prompt: prompt,
//     );
//     final imgs = <String>[];
//     for (final item in resp.data) {
//       final url = item.url;
//       if (url != null) {
//         imgs.add(url);
//       }
//     }
//     if (imgs.isEmpty) {
//       const msg = 'Create image: empty resp';
//       Loggers.app.warning(msg);
//       context.showSnackBar(msg);
//       return;
//     }
//     workingChat.items.add(ChatHistoryItem.gen(
//       role: ChatRole.assist,
//       content: imgs.map((e) => ChatContent.image(e)).toList(),
//     ));
//     _storeChat(chatId);
//     _chatRN.notify();
//   } catch (e, s) {
//     _onErr(e, s, chatId, 'Create image');
//   }
// }

// Future<void> _onCreateImgEdit(BuildContext context, String chatId) async {
//   final prompt = _inputCtrl.text;
//   if (prompt.isEmpty) return;
//   _imeFocus.unfocus();
//   _inputCtrl.clear();

//   final val = _filePicked.value;
//   if (val == null) return;
//   final workingChat = _allHistories[chatId];
//   if (workingChat == null) return;
//   final chatItem = ChatHistoryItem.gen(
//     role: ChatRole.user,
//     content: [ChatContent.text(prompt), ChatContent.image(val.url)],
//   );
//   workingChat.items.add(chatItem);
//   _chatRN.notify();
//   _filePicked.value = null;

//   final cfg = OpenAICfg.current;
//   try {
//     final resp = await OpenAI.instance.image.edit(
//       model: cfg.imgModel,
//       image: val.file,
//       prompt: prompt,
//     );

//     final imgs = <String>[];
//     for (final item in resp.data) {
//       final url = item.url;
//       if (url != null) {
//         imgs.add(url);
//       }
//     }

//     if (imgs.isEmpty) {
//       throw 'Edit image: empty resp';
//     }

//     workingChat.items.add(ChatHistoryItem.gen(
//       role: ChatRole.assist,
//       content: imgs.map((e) => ChatContent.image(e)).toList(),
//     ));
//     _storeChat(chatId);
//     _chatRN.notify();
//   } catch (e, s) {
//     _onErr(e, s, chatId, 'Edit image');
//   }
// }

// Future<void> _onCreateSTT(BuildContext context, String chatId) async {
//   if (isWeb) {
//     final msg = l10n.notSupported('Audio to Text Web');
//     Loggers.app.warning(msg);
//     context.showSnackBar(msg);
//     return;
//   }
//   final val = _filePicked.value;
//   if (val == null) return;
//   final workingChat = _allHistories[chatId];
//   if (workingChat == null) return;
//   final chatItem = ChatHistoryItem.single(
//     type: ChatContentType.audio,
//     raw: val.url,
//     role: ChatRole.user,
//   );
//   workingChat.items.add(chatItem);
//   _chatRN.notify();
//   _storeChat(chatId);
//   _filePicked.value = null;

//   final cfg = OpenAICfg.current;
//   try {
//     final resp = await OpenAI.instance.audio.createTranscription(
//       model: cfg.speechModel,
//       file: val.file,
//       //prompt: '',
//     );
//     final text = resp.text;
//     if (text.isEmpty) {
//       const msg = 'Audio to Text: empty resp';
//       Loggers.app.warning(msg);
//       context.showSnackBar(msg);
//       return;
//     }
//     workingChat.items.add(ChatHistoryItem.single(
//       role: ChatRole.assist,
//       type: ChatContentType.text,
//       raw: text,
//     ));
//     _storeChat(chatId);
//     _chatRN.notify();
//   } catch (e, s) {
//     _onErr(e, s, chatId, 'Audio to Text');
//   }
// }

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
    final resp = await OpenAICfg.client!.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId(cfg.model),
        messages: [
          ChatHistoryItem.single(
            raw: OpenAICfg.current.genTitlePrompt ?? ChatTitleUtil.titlePrompt,
            role: ChatRole.system,
          ).toOpenAI(),
          ChatHistoryItem.single(
            role: ChatRole.user,
            raw: entity.items.first.content
                .firstWhere((p0) => p0.type == ChatContentType.text)
                .raw,
          ).toOpenAI(),
        ],
      ),
    );

    var title = resp.choices.firstOrNull?.message.content;
    title = ChatTitleUtil.prettify(title ?? '');

    if (title.isNotEmpty) {
      final ne = entity.copyWith(name: title)..save();
      _allHistories[chatId] = ne;
      _historyRNMap[chatId]?.notify();
      if (chatId == _curChatId) _appbarTitleRN.notify();
    }
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
    return;
  }

  final chatHistory = _allHistories[chatId];
  if (chatHistory == null) {
    final msg = 'Replay Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  // Find the item, then delete all items behind it and itself
  final replayMsgIdx = chatHistory.items.indexOf(item);
  if (replayMsgIdx == -1) {
    final msg = 'Replay Chat($chatId) item($item) not found';
    Loggers.app.warning(msg);
    context.showSnackBar('${libL10n.fail}: $msg');
    return;
  }
  chatHistory.items.removeRange(replayMsgIdx, chatHistory.items.length);

  final text =
      item.content.firstWhereOrNull((e) => e.type == ChatContentType.text)?.raw;
  final img = item.content
      .firstWhereOrNull((e) => e.type == ChatContentType.image)
      ?.raw;

  _onCreateText(context, chatId, text ?? '', img);
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
