part of 'home.dart';

void _switchChat([String? id]) {
  id ??= _allHistories.keys.firstOrNull ?? _newChat().id;
  _curChatId = id;
  _chatItemRNMap.clear();
  _chatRN.build();
  _sendBtnRN.build();
  _appbarTitleRN.build();
  Future.delayed(_durationMedium, () {
    // Different chats have different height
    _chatFabRN.build();
  });
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
  _historyRN.build();
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
  _historyRNMap[chatId]?.build();
  _storeChat(chatId, context);
  _appbarTitleRN.build();
}

void _onStopStreamSub(String chatId) {
  _chatStreamSubs.remove(chatId)?.cancel();
  _sendBtnRN.build();
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
  final val = _filePicked.value;
  if (val != null) {
    final delete = await context.showRoundDialog(
      title: l10n.file,
      child: Image.memory(
        await val.readAsBytes(),
        fit: BoxFit.cover,
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(
            l10n.clear,
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
  final result = await picker.pickImage(
    source: ImageSource.gallery,
    requestFullMetadata: false,
  );
  if (result == null) return;
  final len = await result.length();
  if (len > 1024 * 1024 * 10) {
    context.showSnackBar(l10n.fileTooLarge(len.bytes2Str));
    return;
  }
  _filePicked.value = result;
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
      _historyRN.build();
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
      durationMills: 10,
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
        _chatRN.build();
        context.pop();
      },
    ),
  );
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

void _switchPage(HomePageEnum page) {
  _pageCtrl.animateToPage(
    page.index,
    duration: _durationMedium,
    curve: Curves.fastEaseInToSlowEaseOut,
  );
}
