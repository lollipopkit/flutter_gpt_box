part of 'home.dart';

class _HomeBottom extends StatelessWidget {
  final bool isHome;

  const _HomeBottom({required this.isHome});

  @override
  Widget build(BuildContext context) {
    final child = ListenBuilder(
      listenable: _homeBottomRN,
      builder: () {
        final isDark = RNodes.dark.value;
        return Container(
          padding: isDesktop
              ? const EdgeInsets.only(left: 11, right: 11, top: 5, bottom: 17)
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
                    _buildFileBtn(context),
                    const Spacer(),
                    // _buildTokenCount(),
                    UIs.width7,
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

    return ValBuilder(
      listenable: _isWide,
      builder: (isWide) {
        if (isWide != isHome) return child;
        return UIs.placeholder;
      },
    );
  }

  Widget _buildFileBtn(BuildContext context) {
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

  Widget _buildTextField(BuildContext context) {
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
          _dontCloseIme = true;
          await _switchPage(HomePageEnum.chat);
          _dontCloseIme = false;
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
    return ValBuilder(
      listenable: _chatType,
      builder: (chatT) {
        return FadeIn(
          key: ValueKey(chatT),
          child: PopupMenu(
            items: ChatType.btns,
            onSelected: (val) => _chatType.value = val,
            initialValue: _chatType.value,
            tooltip: l10n.choose,
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
}
