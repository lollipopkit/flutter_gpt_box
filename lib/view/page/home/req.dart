/// OpenAI chat request related funcs
part of 'home.dart';

bool _validChatCfg(BuildContext context) {
  final config = Cfg.current;
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
  final config = Cfg.current;

  // #106
  final ignoreCtxCons = workingChat.settings?.ignoreContextConstraint == true;
  if (ignoreCtxCons) {
    return Future.wait(workingChat.items.map((e) => e.toOpenAI()));
  }

  final promptStr = config.prompt + Stores.tool.memories.get().join('\n');
  final prompt = promptStr.isNotEmpty
      ? await ChatHistoryItem.single(role: ChatRole.system, raw: promptStr)
          .toOpenAI()
      : null;

  // #101
  if (workingChat.settings?.headTailMode == true) {
    final first = await workingChat.items.firstOrNull?.toOpenAI();
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
    final msg = await item.toOpenAI();
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

  final chatType = Cfg.chatType.value;
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

  final input = _inputCtrl.text;
  if (input.isEmpty) return;
  _imeFocus.unfocus();

  _loadingChatIds.value.add(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = false;

  final func = switch ((chatType, _filesPicked.value)) {
    (ChatType.text, _) => _onCreateText,
    (ChatType.img, _) => _onCreateImg,
    // (ChatType.img, _) => _onCreateImgEdit,
    // (ChatType.audio, null) => _onCreateTTS,
    // (ChatType.audio, _) => _onCreateSTT,
  };

  return await func(context, chatId, input, _filesPicked.value);
}

Future<void> _onCreateText(
  BuildContext context,
  String chatId,
  String input,
  List<String> files,
) async {
  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final config = Cfg.current;

  final questionContents = <ChatContent>[ChatContent.text(input)];
  for (final file in files) {
    questionContents.add(ChatContent.file(file));
  }
  final question = ChatHistoryItem.gen(
    content: questionContents,
    role: ChatRole.user,
  );
  final msgs = (await _historyCarried(workingChat)).toList();
  msgs.add(await question.toOpenAI());

  workingChat.items.add(question);
  _inputCtrl.clear();
  _chatRN.notify();
  _autoScroll(chatId);
  final titleCompleter = await _genChatTitle(context, chatId, config);

  final toolCompatible = Cfg.isToolCompatible();

  // #104
  final chatScopeUseTools = workingChat.settings?.useTools != false;

  // #111
  final availableTools = OpenAIFuncCalls.tools;
  final isToolsEmpty = availableTools.isEmpty;

  if (toolCompatible && chatScopeUseTools && !isToolsEmpty) {
    // Used for logging tool call resp
    final toolReply = ChatHistoryItem.single(role: ChatRole.tool, raw: '');
    workingChat.items.add(toolReply);
    _chatRN.notify();
    _autoScroll(chatId);

    CreateChatCompletionResponse? resp;
    try {
      resp = await Cfg.client.createChatCompletion(
        request: CreateChatCompletionRequest(
          messages: msgs,
          model: ChatCompletionModel.modelId(config.model),
          tools: availableTools,
        ),
      );
    } catch (e, s) {
      _onErr(e, s, chatId, 'Tool');
      return;
    }

    final firstToolReply = resp.choices.firstOrNull;
    final toolCalls = firstToolReply?.message.toolCalls;
    if (toolCalls != null && toolCalls.isNotEmpty) {
      final assistReply = ChatHistoryItem.gen(
        role: ChatRole.assist,
        content: [],
        toolCalls: toolCalls,
      );
      workingChat.items.add(assistReply);
      msgs.add(await assistReply.toOpenAI());
      void onToolLog(String log) {
        final content = ChatContent.text(log);
        if (toolReply.content.isEmpty) {
          toolReply.content.add(content);
        } else {
          toolReply.content[0] = content;
        }
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
          msgs.add(await historyItem.toOpenAI());
        }
      }
    }

    _chatItemRNMap[toolReply.id]?.notify();
    workingChat.items.remove(toolReply);
    _chatRN.notify();
    _chatItemRNMap.remove(toolReply.id)?.dispose();
  }

  final chatStream = Cfg.client.createChatCompletionStream(
    request: CreateChatCompletionRequest(
      messages: msgs,
      model: ChatCompletionModel.modelId(config.model),
    ),
  );
  final assistReply = ChatHistoryItem.single(role: ChatRole.assist);
  workingChat.items.add(assistReply);
  _chatRN.notify();
  _filesPicked.value = [];

  try {
    final sub = chatStream.listen(
      (eve) async {
        final delta = eve.choices.firstOrNull?.delta;
        if (delta == null) return;

        final content = delta.content;
        if (content != null) {
          final newContent = ChatContent.text(assistReply.content.first.raw + content);
          if (assistReply.content.isEmpty) {
            assistReply.content.add(newContent);
          } else {
            assistReply.content[0] = newContent;
          }
          _chatItemRNMap[assistReply.id]?.notify();
        }

        final deltaResoningContent = delta.reasoningContent;
        if (deltaResoningContent != null) {
          final originReasoning = assistReply.reasoning ?? '';
          final newReasoning = '$originReasoning$deltaResoningContent';
          assistReply.reasoning = newReasoning;
          _chatItemRNMap[assistReply.id]?.notify();
        }

        _autoScroll(chatId);
      },
      onDone: () async {
        _onStopStreamSub(chatId);
        _loadingChatIds.value.remove(chatId);
        _loadingChatIds.notify();
        _autoHideCtrl.autoHideEnabled = true;

        _storeChat(chatId);

        // Wait for db to store the chat
        await titleCompleter?.future;
        await Future.delayed(const Duration(milliseconds: 300));
        BakSync.instance.sync();
      },
      onError: (e, s) {
        _onErr(e, s, chatId, 'Listen text stream');
      },
    );
    _chatStreamSubs[chatId] = sub;
  } catch (e, s) {
    _loadingChatIds.value.remove(chatId);
    _loadingChatIds.notify();
    _onErr(e, s, chatId, 'Catch text stream');
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

Future<void> _onCreateImg(
  BuildContext context,
  String chatId,
  String input,
  List<String> files,
) async {
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
  final assistReply = ChatHistoryItem.gen(
    role: ChatRole.assist,
    content: [],
  );
  workingChat.items.add(assistReply);
  _chatRN.notify();
  _autoScroll(chatId);

  final cfg = Cfg.current;
  final imgModel = cfg.imgModel;
  if (imgModel == null) {
    final msg = l10n.emptyFields('Image Model');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  _loadingChatIds.value.add(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = false;

  try {
    final resp = await Cfg.client.createImage(
      request: CreateImageRequest(
        prompt: prompt,
        model: CreateImageRequestModel.modelId(imgModel),
      ),
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

    final imgContents = imgs.map((e) => ChatContent.image(e)).toList();
    assistReply.content.addAll(imgContents);

    _storeChat(chatId);
    _chatRN.notify();
    _autoScroll(chatId);

    // Only sync if success
    BakSync.instance.sync();
  } catch (e, s) {
    // _onErr handles removing loading state and enabling auto-hide
    _onErr(e, s, chatId, 'Create image');
  } finally {
    _loadingChatIds.value.remove(chatId);
    _loadingChatIds.notify();
    _autoHideCtrl.autoHideEnabled = true;
  }
}

// Future<void> _onCreateImgEdit(
//   BuildContext context,
//   String chatId,
//   String input,
//   List<String> files,
// ) async {
//   final cfg = Cfg.current;
//   final imgModel = cfg.imgModel;
//   if (imgModel == null) {
//     final msg = l10n.emptyFields('Image Model');
//     Loggers.app.warning(msg);
//     context.showSnackBar(msg);
//     return;
//   }

//   final prompt = _inputCtrl.text;
//   if (prompt.isEmpty) return;
//   _imeFocus.unfocus();
//   _inputCtrl.clear();

//   // Use the first file if available, assuming image edit takes one image
//   final imagePath = files.firstOrNull;
//   if (imagePath == null) {
//     Loggers.app.warning('Image edit requires an image file.');
//     context.showSnackBar(l10n.needSelectAnImage);
//     return;
//   }
//   final workingChat = _allHistories[chatId];
//   if (workingChat == null) {
//     final msg = 'Chat($chatId) not found';
//     Loggers.app.warning(msg);
//     context.showSnackBar(msg);
//     return;
//   }

//   final chatItem = ChatHistoryItem.gen(
//     role: ChatRole.user,
//     content: [ChatContent.text(prompt), ChatContent.image(imagePath)],
//   );
//   workingChat.items.add(chatItem);
//   final assistReply = ChatHistoryItem.gen(
//     role: ChatRole.assist,
//     content: [],
//   );
//   workingChat.items.add(assistReply);
//   _chatRN.notify();
//   _autoScroll(chatId);
//   _filesPicked.value = []; // Clear picked files after adding to history

//   _loadingChatIds.value.add(chatId);
//   _loadingChatIds.notify();
//   _autoHideCtrl.autoHideEnabled = false;

//   try {
//     final resp = await Cfg.client.createImage(
//       request: CreateImageRequest(
//         prompt: prompt,
//         model: CreateImageRequestModel.modelId(imgModel),
//       ),
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

//     final imgContents = imgs.map((e) => ChatContent.image(e)).toList();
//     assistReply.content.addAll(imgContents);

//     _storeChat(chatId);
//     _chatRN.notify();
//     _autoScroll(chatId);

//     // Only sync if success
//     BakSync.instance.sync();
//   } catch (e, s) {
//     _onErr(e, s, chatId, 'Edit image');
//   } finally {
//     _loadingChatIds.value.remove(chatId);
//     _loadingChatIds.notify();
//     _autoHideCtrl.autoHideEnabled = true;
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

Future<Completer<void>?> _genChatTitle(
  BuildContext context,
  String chatId,
  ChatConfig cfg,
) async {
  if (!Stores.setting.genTitle.get()) return null;

  final entity = _allHistories[chatId];
  if (entity == null) {
    final msg = 'Gen Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return null;
  }
  if (entity.items.where((e) => e.role.isUser).length > 1) return null;

  final completer = Completer<void>();
  void onErr(Object e, StackTrace s) {
    Loggers.app.warning('Gen title: $e');
    _historyRN.notify();
    completer.complete();
  }

  try {
    final msgs = [
      await ChatHistoryItem.single(
        raw: Cfg.current.genTitlePrompt ?? ChatTitleUtil.titlePrompt,
        role: ChatRole.system,
      ).toOpenAI(),
      await ChatHistoryItem.single(
        role: ChatRole.user,
        raw: entity.items.first.content
            .firstWhere((p0) => p0.type == ChatContentType.text)
            .raw,
      ).toOpenAI(),
    ];
    final model = ChatTitleUtil.pickSuitableModel ?? cfg.model;
    final req = CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(model),
      messages: msgs,
    );
    Cfg.client.createChatCompletion(request: req).then(
      (resp) {
        var title = resp.choices.firstOrNull?.message.content;
        title = ChatTitleUtil.prettify(title ?? '');

        if (title.isNotEmpty) {
          final ne = entity.copyWith(name: title)..save();
          _allHistories[chatId] = ne;
          _historyRN.notify();
          if (chatId == _curChatId.value) {
            _appbarTitleVN.value = title;
          }
        }

        completer.complete();
      },
      onError: onErr,
    );

    return completer;
  } catch (e, s) {
    onErr(e, s);
    return null;
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
  if (_loadingChatIds.value.contains(chatId)) {
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

  // Each item has only one text content inputed by user
  final text = item.content.firstWhereOrNull((e) => e.type.isText)?.raw;
  if (text != null) {
    _inputCtrl.text = text;
  }

  final files =
      item.content.where((e) => !e.type.isText).map((e) => e.raw).toList();
  _filesPicked.value = files;

  _onCreateRequest(context, chatId);
}

void _onErr(Object e, StackTrace s, String chatId, String action) {
  Loggers.app.warning('$action: $e');
  _onStopStreamSub(chatId);
  // Ensure loading state is removed and auto-hide is enabled on error
  _loadingChatIds.value.remove(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = true;

  final msg = '$e\n\n```$s```';
  final workingChat = _allHistories[chatId];
  if (workingChat == null) return;

  // If previous msg is assistant reply and it's empty, remove it
  if (workingChat.items.isNotEmpty) {
    final last = workingChat.items.last;
    final role = last.role;
    if ((role.isAssist || role.isTool) &&
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

  _chatRN.notify();

  if (Stores.setting.saveErrChat.get()) _storeChat(chatId);
}
