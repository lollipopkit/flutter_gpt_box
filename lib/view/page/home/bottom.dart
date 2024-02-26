part of 'home.dart';

Widget _buildBottom(BuildContext context) {
  return Container(
    padding: isDesktop
        ? const EdgeInsets.only(left: 11, right: 11, top: 7, bottom: 17)
        : const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
      color: UIs.bgColor.fromBool(_isDark),
      boxShadow: _isDark ? _boxShadowDark : _boxShadow,
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
                  _historyRN.rebuild();
                },
                icon: const Icon(Icons.add),
                tooltip: l10n.newChat,
              ),
              IconButton(
                onPressed: () => _onTapRenameChat(_curChatId, context),
                icon: const Icon(Icons.abc, size: 19),
                tooltip: l10n.rename,
              ),
              IconButton(
                onPressed: () => _onTapDeleteChat(_curChatId, context),
                icon: const Icon(Icons.delete, size: 19),
                tooltip: l10n.delete,
              ),
              const Spacer(),
              _buildSwitchChatType(),
            ],
          ),
          _buildTextField(context),
          SizedBox(height: _media?.padding.bottom),
        ],
      ),
    ),
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
    autoCorrect: true,
    suggestion: true,
    onSubmitted: (p0) {
      _onCreateRequest(context, _curChatId);
    },
    onTap: () {
      if (_curPage.value != HomePageEnum.chat) {
        _pageCtrl.animateToPage(
          HomePageEnum.chat.index,
          duration: Durations.medium1,
          curve: Curves.fastEaseInToSlowEaseOut,
        );
      }
    },
    contextMenuBuilder: (context, editableTextState) {
      final TextEditingValue value = editableTextState.textEditingValue;
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
          final newValue = value.copyWith(
            text: '${value.text}\n',
            selection: TextSelection.collapsed(offset: value.selection.end + 1),
          );
          editableTextState.updateEditingValue(newValue);
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
            : ListenableBuilder(
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

// Widget _buildSwitchPageBtn() {
//   return ValueListenableBuilder(
//     valueListenable: _isWide,
//     builder: (_, isWide, __) => isWide
//         ? UIs.placeholder
//         : ValueListenableBuilder(
//             valueListenable: _curPage,
//             builder: (_, page, __) {
//               final next = page.next;
//               return IconButton(
//                 onPressed: () => _pageCtrl.animateToPage(
//                   next.index,
//                   duration: Durations.medium1,
//                   curve: Curves.fastEaseInToSlowEaseOut,
//                 ),
//                 icon: Icon(next.icon, size: 19),
//               );
//             },
//           ),
//   );
// }
