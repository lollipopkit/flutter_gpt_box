part of 'home.dart';

class _HomeBottom extends StatefulWidget {
  final bool isHome;

  const _HomeBottom({required this.isHome});

  @override
  State<_HomeBottom> createState() => _HomeBottomState();
}

final class _HomeBottomState extends State<_HomeBottom> {
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
            padding: EdgeInsets.only(bottom: _media?.viewInsets.bottom ?? 0),
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
                    IconButton(
                      onPressed: () => _onTapRenameChat(_curChatId, context),
                      icon: const Icon(Icons.edit, size: 19),
                      tooltip: l10n.rename,
                    ),
                    IconButton(
                      onPressed: () => _onTapDeleteChat(_curChatId, context),
                      icon: const Icon(Icons.delete, size: 19),
                      tooltip: l10n.delete,
                    ),
                    _buildFileBtn(),
                    _buildSettingsBtn(),
                    const Spacer(),
                    // _buildTokenCount(),
                    UIs.width7,
                    _buildSwitchChatType(),
                    UIs.width7,
                  ],
                ),
                _buildTextField(),
                SizedBox(height: _media?.padding.bottom),
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
    return ListenBuilder(
      listenable: _filePicked,
      builder: () {
        return ListenBuilder(
          listenable: _chatType,
          builder: () {
            return switch (_chatType.value) {
              ChatType.text || ChatType.img => IconButton(
                  onPressed: () => _onTapImgPick(context),
                  icon: Badge(
                    isLabelVisible: _filePicked.value != null,
                    child: const Icon(Icons.image, size: 19),
                  ),
                ),
              // ChatType.audio => const IconButton(
              //   onPressed: _onTapAudioPick,
              //   icon: Icon(Icons.mic, size: 19),
              // ),
              _ => UIs.placeholder,
            };
          },
        );
      },
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
      suffix: ListenBuilder(
        listenable: _sendBtnRN,
        builder: () {
          final isWorking = _loadingChatIds.contains(_curChatId);
          return isWorking
              ? IconButton(
                  onPressed: () => _onStopStreamSub(_curChatId),
                  icon: const Icon(Icons.stop),
                )
              : IconButton(
                  onPressed: () => _onCreateRequest(context, _curChatId),
                  icon: const Icon(Icons.send, size: 19),
                );
        },
      ),
    );
  }

  Widget _buildSwitchChatType() {
    return ValBuilder(
      listenable: _chatType,
      builder: (chatT) {
        return FadeIn(
          key: ValueKey(chatT),
          child: PopupMenu(
            items: ChatType.btns,
            onSelected: (val) => _chatType.value = val,
            initialValue: _chatType.value,
            tooltip: libL10n.select,
            child: _buildRoundRect(Row(
              children: [
                Icon(_chatType.value.icon, size: 15),
                UIs.width7,
                Text(_chatType.value.name, style: UIs.text13),
              ],
            )),
          ),
        );
      },
    );
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
        borderRadius: BorderRadius.circular(17),
        color: const Color.fromARGB(35, 151, 151, 151),
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
    context.showRoundDialog(
      title: '${l10n.current}: ${chat.name ?? l10n.untitled}',
      child: _ChatSettings(chat),
      actions: [Btn.ok()],
    );
  }
}

final class _ChatSettings extends StatefulWidget {
  final ChatHistory chat;

  const _ChatSettings(this.chat);

  @override
  State<_ChatSettings> createState() => _ChatSettingsState();
}

final class _ChatSettingsState extends State<_ChatSettings> {
  late final settings = (widget.chat.settings ?? const ChatSettings()).vn;

  @override
  void initState() {
    super.initState();
    // After creating a new chat in UI, the chat is not saved to DB yet
    widget.chat.save();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeadTailMode(),
        _buildUseTools(),
        _buildIgnoreCtxConstraint(),
      ].map((e) => e.cardx).toList(),
    );
  }

  Widget _buildIgnoreCtxConstraint() {
    return ListTile(
      title: Text(l10n.ignoreContextConstraint),
      trailing: settings.listenVal((val) {
        return Switch(
          value: val.ignoreContextConstraint,
          onChanged: (_) {
            settings.value = settings.value.copyWith(
              ignoreContextConstraint: !val.ignoreContextConstraint,
            );
            if (settings.value.headTailMode &&
                settings.value.ignoreContextConstraint) {
              settings.value = settings.value.copyWith(headTailMode: false);
            }
            _save();
          },
        );
      }),
    );
  }

  Widget _buildUseTools() {
    return ListTile(
      title: Text(l10n.tool),
      trailing: settings.listenVal((val) {
        return Switch(
          value: val.useTools,
          onChanged: (_) {
            settings.value = settings.value.copyWith(useTools: !val.useTools);
            _save();
          },
        );
      }),
    );
  }

  Widget _buildHeadTailMode() {
    return ListTile(
      title: TipText(l10n.headTailMode, l10n.headTailModeTip),
      trailing: settings.listenVal((val) {
        return Switch(
          value: val.headTailMode,
          onChanged: (_) {
            settings.value =
                settings.value.copyWith(headTailMode: !val.headTailMode);
            if (settings.value.headTailMode &&
                settings.value.ignoreContextConstraint) {
              settings.value =
                  settings.value.copyWith(ignoreContextConstraint: false);
            }
            _save();
          },
        );
      }),
    );
  }

  void _save() {
    final newOne = widget.chat.copyWith(
      settings: settings.value,
    );
    newOne.save();
    _allHistories[_curChatId] = newOne;
  }
}
