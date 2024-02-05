part of 'home.dart';

Widget _buildInput(BuildContext context) {
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
            ],
          ),
          Input(
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
            prefix: const IconButton(
              onPressed: _onTapImgPick,
              icon: Icon(Icons.photo, size: 19),
            ),
            onTap: () {
              if (_curPage.value != HomePageEnum.chat) {
                _pageCtrl.animateToPage(
                  HomePageEnum.chat.index,
                  duration: Durations.medium1,
                  curve: Curves.fastEaseInToSlowEaseOut,
                );
              }
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
                    : UIs.placeholder;
              },
            ),
          ),
          SizedBox(height: _media?.padding.bottom),
        ],
      ),
    ),
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
