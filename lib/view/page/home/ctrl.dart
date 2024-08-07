part of 'home.dart';

void _switchChat([String? id]) {
  id ??= _allHistories.keys.firstOrNull ?? _newChat().id;
  _curChatId = id;
  _chatItemRNMap.clear();
  _chatRN.notify();
  _sendBtnRN.notify();
  _appbarTitleRN.notify();
  Future.delayed(_durationMedium, () {
    // Different chats have different height
    _chatFabRN.notify();
  });

  final chat = _allHistories[id];
  if (chat == null) {
    final msg = 'Switch Chat($id) not found';
    Loggers.app.warning(msg);
    return;
  }
}

void _switchPreviousChat() {
  final iter = _allHistories.keys.iterator;
  bool next = false;
  while (iter.moveNext()) {
    if (next) {
      _switchChat(iter.current);
      return;
    }
    if (iter.current == _curChatId) next = true;
  }
}

void _switchNextChat() {
  final iter = _allHistories.keys.iterator;
  String? last;
  while (iter.moveNext()) {
    if (iter.current == _curChatId) {
      if (last != null) {
        _switchChat(last);
        return;
      }
    }
    last = iter.current;
  }
}

void _storeChat(String chatId) {
  final chat = _allHistories[chatId];
  if (chat == null) {
    final msg = 'Store Chat($chatId) not found';
    Loggers.app.warning(msg);
    return;
  }

  chat.save();
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

void _onTapDelChatItem(
  BuildContext context,
  List<ChatHistoryItem> chatItems,
  ChatHistoryItem chatItem,
) async {
  // Capture it.
  final chatId = _curChatId;
  final idx = chatItems.indexOf(chatItem) + 1;
  final result = await context.showRoundDialog<bool>(
    title: l10n.attention,
    child: Text(
      l10n.delFmt('${chatItem.role.localized}#$idx', l10n.chat),
    ),
    actions: Btnx.okReds,
  );
  if (result != true) return;
  chatItems.remove(chatItem);
  _storeChat(chatId);
  _historyRNMap[chatId]?.notify();
  _chatRN.notify();
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
  if (entity.items.isEmpty) return _onDeleteChat(chatId);

  /// #119
  final diffTS = DateTime.now().millisecondsSinceEpoch - _noChatDeleteConfirmTS;
  if (diffTS < 30 * 1000) {
    return _onDeleteChat(chatId);
  }

  if (!Stores.setting.confrimDel.fetch()) return _onDeleteChat(chatId);

  final name = entity.name ?? 'Untitled';
  void onTap() {
    _onDeleteChat(chatId);
    context.pop();
  }

  context.showRoundDialog(
    title: l10n.attention,
    child: Text(l10n.delFmt(name, l10n.chat)),
    actions: [
      Btn.text(
        text: l10n.remember30s,
        onTap: () {
          _noChatDeleteConfirmTS = DateTime.now().millisecondsSinceEpoch;
          onTap();
        },
      ),
      Btn.ok(onTap: onTap),
    ],
  );
}

void _onDeleteChat(String chatId) {
  Stores.history.delete(chatId);
  if (_curChatId == chatId) {
    _switchPreviousChat();
  }
  _allHistories.remove(chatId);
  _historyRN.notify();
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
    actions: Btn.ok(onTap: () => context.pop(ctrl.text)).toList,
  );
  if (title == null || title.isEmpty) return;
  final ne = entity.copyWith(name: title)..save();
  _allHistories[chatId] = ne;
  _historyRNMap[chatId]?.notify();
  _storeChat(chatId);
  _appbarTitleRN.notify();
}

/// Used in send btn and [_onCreateText]
void _onStopStreamSub(String chatId) async {
  _loadingChatIds.remove(chatId);
  _loadingChatIdRN.notify();
  _sendBtnRN.notify();
  _chatFabAutoHideKey.currentState?.autoHideEnabled = true;
}

void _onShareChat(BuildContext context) async {
  final curChat = _curChat;
  if (curChat == null) {
    final msg = 'Share Chat($_curChatId): null';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final type = await context.showPickSingleDialog(
    title: l10n.share,
    items: ['img', 'txt'],
    name: (p0) => switch (p0) {
      'txt' => l10n.text,
      _ => l10n.image,
    },
  );
  if (type == null) return;

  if (type == 'txt') {
    final md = curChat.toMarkdown;
    Pfs.copy(md);
    context.showSnackBar(l10n.copied);
    return;
  }

  final result = curChat.gen4Share(context);
  var compressImg = false;
  final (pic, err) = await context.showLoadingDialog(fn: () async {
    final raw = await _screenshotCtrl.captureFromLongWidget(
      result,
      context: context,
      constraints: const BoxConstraints(maxWidth: 577),
      pixelRatio: _media?.devicePixelRatio ?? 1,
      delay: Durations.short4,
    );
    compressImg = Stores.setting.compressImg.fetch();
    if (compressImg) {
      return await ImageUtil.compress(raw);
    }
    return raw;
  });
  if (err != null || pic == null) return;

  final title = _curChat?.name ?? l10n.untitled;
  final ext = compressImg ? 'jpg' : 'png';
  final mime = compressImg ? 'image/jpeg' : 'image/png';
  await Pfs.share(bytes: pic, name: '$title.$ext', mime: mime);
}

Future<void> _onTapImgPick(BuildContext context) async {
  final val = _filePicked.value;
  if (val != null) {
    final delete = await context.showRoundDialog(
      title: libL10n.file,
      child: Image.file(File(val), fit: BoxFit.cover),
      actions: [
        TextButton(
          onPressed: () => context.pop(true),
          child: Text(libL10n.clear, style: UIs.textRed),
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

  final imgPath = Paths.img.joinPath(shortid.generate());
  var isCompressed = Stores.setting.compressImg.fetch();
  if (isCompressed) {
    final (compressed, err) = await context.showLoadingDialog(
      fn: () async => ImageUtil.compress(await result.readAsBytes()),
    );
    if (err != null || compressed == null) {
      context.showSnackBar('${libL10n.fail}: ${l10n.compress}');
      isCompressed = false;
    } else {
      await File(imgPath).writeAsBytes(compressed);
    }
  }

  if (!isCompressed) await result.saveTo(imgPath);
  _filePicked.value = imgPath;
}

Set<String> findAllDuplicateIds(Map<String, ChatHistory> allHistories) {
  final existTitles = <String, List<String>>{}; // {"title": ["id"]}
  for (final item in allHistories.values) {
    final title = item.name ?? '';
    existTitles.putIfAbsent(title, () => []).add(item.id);
  }

  final rmIds = <String>{};
  for (final entry in existTitles.entries) {
    /// If only one chat with the same title, skip
    if (entry.value.length == 1) continue;
    final ids = entry.value;

    /// If the title is the same, first compare whether the content is the same

    /// Collect all assist's reply content
    final contentMap = <String, List<String>>{}; // {"id": ["content"]}
    final timeMap = <String, int>{}; // {"id": time}
    for (final id in ids) {
      final history = allHistories[id];
      if (history == null) continue;
      for (final item in history.items) {
        /// Only compare assist's reply which is variety
        if (!item.role.isAssist) continue;
        final content = item.toMarkdown;
        contentMap.putIfAbsent(content, () => []).add(id);
        final time = timeMap[id];
        if (time == null || item.createdAt.millisecondsSinceEpoch > time) {
          timeMap[id] = item.createdAt.millisecondsSinceEpoch;
        }
      }
    }

    /// Find out the same content
    var anyDup = false;
    for (var idx = 0; idx < contentMap.length - 1; idx++) {
      final contentsA = contentMap.values.elementAt(idx);
      final contentsB = contentMap.values.elementAt(idx + 1);
      anyDup = contentsA.any((e) => contentsB.contains(e));
      if (anyDup) break;
    }

    /// If there is no same content, skip
    if (!anyDup) continue;

    /// If there is same content, delete the old one
    var latestTime = timeMap.values.first;
    for (final entry in timeMap.entries) {
      if (entry.value > latestTime) {
        latestTime = entry.value;
      }
    }

    rmIds.addAll(timeMap.entries
        .where((e) => e.value != latestTime)
        .map((e) => e.key)
        .toList());
  }
  return rmIds;
}

void _removeDuplicateHistory(BuildContext context) async {
  final rmIds = await compute(findAllDuplicateIds, _allHistories);
  if (rmIds.isEmpty) {
    return;
  }

  final rmCount = rmIds.length;
  final children = <Widget>[Text(l10n.rmDuplicationFmt(rmCount))];
  for (int idx = 0; idx < rmCount; idx++) {
    final id = rmIds.elementAt(idx);
    final item = _allHistories[id];
    if (item == null) continue;
    children.add(Text(
      '${idx + 1}. ${item.items.firstOrNull?.toMarkdown ?? libL10n.empty}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: UIs.text12Grey,
    ));
  }
  context.showRoundDialog(
    title: l10n.attention,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          for (final id in rmIds) {
            Stores.history.delete(id);
            _allHistories.remove(id);
          }
          _historyRN.notify();
          if (!_allHistories.keys.contains(_curChatId)) {
            _switchChat();
          }
        },
        child: Text(l10n.delete, style: UIs.textRed),
      ),
    ],
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
  BuildContext context,
  String chatId,
  ChatHistoryItem item,
) async {
  if (!item.role.isUser) return;
  final sure = await context.showRoundDialog<bool>(
    title: l10n.attention,
    child: Text('${l10n.replay} ?\n${l10n.replayTip}'),
    actions: Btnx.okReds,
  );
  if (sure != true) return;
  _onReplay(context: context, chatId: chatId, item: item);
}

void _onTapEditMsg(BuildContext context, ChatHistoryItem chatItem) async {
  final ctrl = TextEditingController(text: chatItem.toMarkdown);
  void onSubmit() {
    chatItem.content.clear();
    chatItem.content.add(ChatContent.text(ctrl.text));
    _storeChat(_curChatId);
    _chatRN.notify();
    context.pop();
  }

  await context.showRoundDialog(
    title: libL10n.edit,
    child: Input(
      controller: ctrl,
      maxLines: 7,
      minLines: 1,
      autoCorrect: true,
      autoFocus: true,
      action: TextInputAction.send,
      onSubmitted: (_) => onSubmit(),
    ),
    actions: Btn.ok(onTap: onSubmit).toList,
  );
}

void _autoScroll(String chatId) {
  if (Stores.setting.scrollBottom.fetch()) {
    Funcs.throttle(() {
      // Only scroll to bottom when current chat is the working chat
      final isCurrentChat = chatId == _curChatId;
      if (isCurrentChat) {
        _scrollBottom();
      }
    }, id: 'autoScroll', duration: 100);
  }
}

void _scrollBottom() async {
  final isDisplaying = _chatScrollCtrl.hasClients;
  if (isDisplaying) {
    await _chatScrollCtrl.animateTo(
      _chatScrollCtrl.position.maxScrollExtent,
      duration: _durationShort,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
    // Sometimes the scroll is not at the bottom due to the caclulation of
    // [ListView.builder], so scroll again.
    _chatScrollCtrl.jumpTo(_chatScrollCtrl.position.maxScrollExtent);
  }
}

void _onSwitchModel(BuildContext context, {bool notifyKey = false}) async {
  final cfg = OpenAICfg.current;
  if (cfg.key.isEmpty) {
    if (notifyKey) {
      context.showRoundDialog(
        title: l10n.attention,
        child: Text(l10n.needOpenAIKey),
        actions: Btnx.oks,
      );
    }
    return;
  }

  final models = OpenAICfg.models.value;
  final model = await context.showPickSingleDialog(
    items: models,
    initial: cfg.model,
    title: l10n.model,
  );
  if (model == null) return;
  final newModel = switch (_chatType.value) {
    ChatType.text => cfg.copyWith(model: model),
    ChatType.img => cfg.copyWith(imgModel: model),
    ChatType.audio => cfg.copyWith(speechModel: model),
  };
  OpenAICfg.setTo(newModel);
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

Future<void> _switchPage(HomePageEnum page) {
  return _pageCtrl.animateToPage(
    page.index,
    duration: _durationMedium,
    curve: Curves.fastEaseInToSlowEaseOut,
  );
}

Future<bool> _askToolConfirm(
  BuildContext context,
  ToolFunc func,
  String help,
) async {
  final permittedTools = Stores.tool.permittedTools.fetch();
  if (permittedTools.contains(func.name)) return true;

  final permitted = await context.showRoundDialog(
    title: l10n.attention,
    child: Text('${l10n.toolConfirmFmt(func.name)}\n\n$help'),
    actions: Btnx.okReds,
  );
  if (permitted == true) {
    permittedTools.add(func.name);
    Stores.tool.permittedTools.put(permittedTools);
  }
  return permitted == true;
}
