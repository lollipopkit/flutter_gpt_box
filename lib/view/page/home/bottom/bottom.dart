part of '../home.dart';

class _HomeBottom extends StatefulWidget {
  final bool isHome;

  const _HomeBottom({required this.isHome});

  @override
  State<_HomeBottom> createState() => _HomeBottomState();
}

final class _HomeBottomState extends State<_HomeBottom> {
  static const _boxShadow = [
    BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, -0.5)),
  ];

  static const _boxShadowDark = [
    BoxShadow(color: Colors.white12, blurRadius: 3, offset: Offset(0, -0.5)),
  ];

  @override
  Widget build(BuildContext context) {
    final child = ListenBuilder(
      listenable: _homeBottomRN,
      builder: () {
        return Container(
          padding: isDesktop
              ? const EdgeInsets.only(left: 11, right: 11, top: 5, bottom: 17)
              : const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            boxShadow: RNodes.dark.value ? _boxShadow : _boxShadowDark,
          ),
          child: AnimatedPadding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom),
            curve: Curves.fastEaseInToSlowEaseOut,
            duration: Durations.short1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // IconButton(
                    //   onPressed: () => _onTapSetting(context),
                    //   icon: const Icon(Icons.settings, size: 19),
                    //   tooltip: l10n.settings,
                    // ),
                    IconButton(
                      onPressed: () {
                        _switchChat(_newChat().id);
                        _historyRN.notify();
                        if (_curPage.value == HomePageEnum.history) {
                          _switchPage(HomePageEnum.chat);
                        }
                      },
                      icon: const Icon(MingCute.add_fill, size: 17),
                      tooltip: l10n.newChat,
                    ),
                    // IconButton(
                    //   onPressed: () =>
                    //       _onTapRenameChat(_curChatId.value, context),
                    //   icon: const Icon(Icons.edit, size: 19),
                    //   tooltip: l10n.rename,
                    // ),
                    IconButton(
                      onPressed: () =>
                          _onTapDeleteChat(_curChatId.value, context),
                      icon: const Icon(Icons.delete, size: 19),
                      tooltip: l10n.delete,
                    ),
                    _buildFileBtn(),
                    _buildSettingsBtn(),
                    _buildRight(),
                    const Spacer(),
                    // _buildTokenCount(),
                    UIs.width7,
                    _buildSwitchChatType(),
                    UIs.width7,
                  ],
                ),
                _buildTextField(),
                SizedBox(height: MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        );
      },
    );

    return ValBuilder(
      listenable: _isWide,
      builder: (isWide) {
        if (isWide != widget.isHome) return child;
        return UIs.placeholder;
      },
    );
  }

  Widget _buildSettingsBtn() {
    return IconButton(
      onPressed: _onTapSetting,
      icon: const Icon(Icons.settings, size: 19),
      tooltip: libL10n.setting,
    );
  }

  Widget _buildFileBtn() {
    return _filePicked.listenVal(
      (file) => Cfg.chatType.listenVal(
        (chatType) {
          return switch (chatType) {
            ChatType.text || ChatType.img => IconButton(
                onPressed: () => _onTapFilePick(context),
                icon: Badge(
                  isLabelVisible: file != null,
                  child: const Icon(MingCute.file_upload_fill, size: 19),
                ),
              ),
            // ChatType.audio => const IconButton(
            //   onPressed: _onTapAudioPick,
            //   icon: Icon(Icons.mic, size: 19),
            // ),
            //_ => UIs.placeholder,
          };
        },
      ),
    );
  }

  Widget _buildTextField() {
    return Input(
      controller: _inputCtrl,
      label: l10n.message,
      node: _imeFocus,
      action: TextInputAction.newline,
      maxLines: 5,
      minLines: 1,

      /// Keep this, or 'Wrap' will not work on iOS
      type: TextInputType.multiline,
      autoCorrect: true,
      suggestion: true,
      // onSubmitted: (p0) {
      //   _onCreateRequest(context, _curChatId);
      // },
      onTap: () async {
        if (_curPage.value != HomePageEnum.chat) {
          await _switchPage(HomePageEnum.chat);
        }
        // Wait IME popup
        await Future.delayed(Durations.medium4);
        _scrollBottom();
      },
      onTapOutside: (p0) {
        if (_curPage.value == HomePageEnum.chat) return;
        _imeFocus.unfocus();
      },
      contextMenuBuilder: (context, editableTextState) {
        //final TextEditingValue value = editableTextState.textEditingValue;
        final List<ContextMenuButtonItem> buttonItems =
            editableTextState.contextMenuButtonItems;
        if (_inputCtrl.text.isNotEmpty) {
          buttonItems.add(ContextMenuButtonItem(
            label: libL10n.clear,
            onPressed: () {
              _inputCtrl.clear();
            },
          ));
        }
        // buttonItems.add(ContextMenuButtonItem(
        //   label: l10n.wrap,
        //   onPressed: () {
        //     _inputCtrl.text += '\n';
        //   },
        // ));
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
      suffix: _curChatId.listenVal((chatId) {
        return _loadingChatIds.listenVal((chats) {
          final isWorking = chats.contains(chatId);
          return isWorking
              ? IconButton(
                  onPressed: () => _onStopStreamSub(chatId),
                  icon: const Icon(Icons.stop),
                )
              : IconButton(
                  onPressed: () => _onCreateRequest(context, _curChatId.value),
                  icon: const Icon(Icons.send, size: 19),
                );
        });
      }),
    );
  }

  Widget _buildSwitchChatType() {
    return Cfg.chatType.listenVal((chatT) {
      return FadeIn(
        key: ValueKey(chatT),
        child: PopupMenu(
          items: ChatType.btns,
          onSelected: (val) => Cfg.chatType.value = val,
          initialValue: chatT,
          tooltip: libL10n.select,
          borderRadius: BorderRadius.circular(17),
          child: _buildRoundRect(Row(
            children: [
              Icon(chatT.icon, size: 15),
              UIs.width7,
              Text(chatT.name, style: UIs.text13),
            ],
          )),
        ),
      );
    });
  }

  // Widget _buildTokenCount() {
  //   return ValueListenableBuilder(
  //     valueListenable: Stores.setting.calcTokenLen.listenable(),
  //     builder: (_, calc, __) {
  //       if (!calc) return UIs.placeholder;
  //       return _buildRoundRect(ListenableBuilder(
  //         listenable: _inputCtrl,
  //         builder: (_, __) {
  //           final encoder = encodingForModel(OpenAICfg.current.model);
  //           final len = encoder.encode(_inputCtrl.text).length;
  //           return Text('# $len');
  //         },
  //       ));
  //     },
  //   );
  // }

  Widget _buildRoundRect(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(35, 151, 151, 151),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      child: child,
    );
  }

  void _onTapSetting() async {
    final chat = _curChat;
    if (chat == null) {
      context.showSnackBar(libL10n.empty);
      return;
    }

    await _ChatSettings.route.go(context, chat);
  }

  Widget _buildRight() {
    return _curPage.listenVal((val) {
      return val == HomePageEnum.chat ? _buildChatMeta() : _buildSyncChats();
    });
  }

  Widget _buildSyncChats() {
    final rs = BakSync.instance.remoteStorage;
    if (rs == null) return UIs.placeholder;
    return IconButton(
      onPressed: _onTapSyncChats,
      icon: const Icon(Icons.sync, size: 19),
      tooltip: libL10n.sync,
    );
  }

  Widget _buildChatMeta() {
    return Btn.icon(
      icon: const Icon(Icons.code, size: 19),
      onTap: _onTapMeta,
    );
  }

  void _onTapMeta() {
    final chat = _curChat;
    if (chat == null) {
      context.showSnackBar(libL10n.empty);
      return;
    }

    final jsonRaw = jsonIndentEncoder.convert(chat.toJson());
    final md = '''
```json
$jsonRaw
```''';

    context.showRoundDialog(
      title: l10n.raw,
      child: SingleChildScrollView(
        child: SimpleMarkdown(data: md),
      ),
      actions: Btnx.oks,
    );
  }

  void _onTapSyncChats() async {
    await BakSync.instance.sync();
  }
}
