part of 'home.dart';

final _homeBottomRN = RNode();

class _HomeBottom extends StatelessWidget {
  const _HomeBottom();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _homeBottomRN,
      builder: (_, __) {
        final isDark = RNode.dark.value;
        return Container(
          padding: isDesktop
              ? const EdgeInsets.only(left: 11, right: 11, top: 7, bottom: 17)
              : const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            color: UIs.bgColor.fromBool(isDark),
            boxShadow: isDark ? _boxShadowDark : _boxShadow,
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
                        _historyRN.build();
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
                    ListenableBuilder(
                      listenable: _filePicked,
                      builder: (_, __) {
                        return ListenableBuilder(
                          listenable: _chatType,
                          builder: (_, __) {
                            return switch (_chatType.value) {
                              ChatType.text || ChatType.img => Badge(
                                  isLabelVisible: _filePicked.value != null,
                                  child: IconButton(
                                    onPressed: () => _onTapImgPick(context),
                                    icon: const Icon(Icons.photo, size: 19),
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
                    ),
                    const Spacer(),
                    ValueListenableBuilder(
                      valueListenable: Stores.setting.calcTokenLen.listenable(),
                      builder: (_, calc, __) {
                        return ListenableBuilder(
                          listenable: _inputCtrl,
                          builder: (_, __) {
                            final encoder =
                                encodingForModel(OpenAICfg.current.model);
                            final len = encoder.encode(_inputCtrl.text).length;
                            return Text(
                              '#$len',
                              style: UIs.text13Grey,
                            );
                          },
                        );
                      },
                    ),
                    UIs.width13,
                    _buildSwitchChatType(),
                    UIs.width7,
                  ],
                ),
                _buildTextField(context),
                SizedBox(height: _media?.padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Input(
      controller: _inputCtrl,
      label: l10n.message,
      node: _imeFocus,
      action: TextInputAction.send,
      maxLines: 5,
      minLines: 1,

      /// Keep this, or 'Wrap' will not work on iOS
      type: TextInputType.multiline,
      autoCorrect: true,
      suggestion: true,
      onSubmitted: (p0) {
        _onCreateRequest(context, _curChatId);
      },
      onTap: () {
        if (_curPage.value != HomePageEnum.chat) {
          _switchPage(HomePageEnum.chat);
        }
      },
      contextMenuBuilder: (context, editableTextState) {
        //final TextEditingValue value = editableTextState.textEditingValue;
        final List<ContextMenuButtonItem> buttonItems =
            editableTextState.contextMenuButtonItems;
        if (_inputCtrl.text.isNotEmpty) {
          buttonItems.add(ContextMenuButtonItem(
            label: l10n.clear,
            onPressed: () {
              _inputCtrl.clear();
            },
          ));
        }
        buttonItems.add(ContextMenuButtonItem(
          label: l10n.wrap,
          onPressed: () {
            _inputCtrl.text += '\n';
          },
        ));
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
      suffix: ListenableBuilder(
        listenable: _sendBtnRN,
        builder: (_, __) {
          final isWorking = _chatStreamSubs.containsKey(_curChatId);
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
    return ListenableBuilder(
      listenable: _chatType,
      builder: (_, __) {
        return PopupMenu(
          items: ChatType.values
              .map(
                (e) => PopupMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      Icon(e.icon, size: 19),
                      UIs.width7,
                      Text(e.name, style: UIs.text13),
                    ],
                  ),
                ),
              )
              .toList(),
          onSelected: (val) => _chatType.value = val,
          initialValue: _chatType.value,
          tooltip: l10n.choose,
          child: Row(
            children: [
              Text(_chatType.value.name, style: UIs.text13),
              UIs.width7,
              const Icon(Icons.keyboard_arrow_down, size: 19),
            ],
          ),
        );
      },
    );
  }
}
