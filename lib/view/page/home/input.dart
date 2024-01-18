part of 'home.dart';

class _Input extends StatelessWidget {
  const _Input();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isDesktop
          ? const EdgeInsets.only(left: 11, right: 11, top: 7, bottom: 17)
          : const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
        color: _bg,
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
                //   onPressed: _onImgPick,
                //   icon: const Icon(Icons.photo, size: 19),
                // ),
                IconButton(
                  onPressed: () => _onTapSetting(context),
                  icon: const Icon(Icons.settings, size: 19),
                  tooltip: l10n.settings,
                ),
                IconButton(
                  onPressed: () {
                    _switchChat(_newChat().id);
                    _historyRN.rebuild();
                  },
                  icon: const Icon(Icons.add),
                  tooltip: l10n.newChat,
                ),
                ListenableBuilder(
                  listenable: _chatRN,
                  builder: (_, __) {
                    final curIdx = _allChatIds.indexOf(_curChatId);
                    final isLast = curIdx == _allChatIds.length - 1;
                    final isFirst = curIdx == 0;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isLast)
                          IconButton(
                            onPressed: () =>
                                _switchChat(_allChatIds[curIdx + 1]),
                            icon: const Icon(Icons.keyboard_arrow_up, size: 19),
                          ),
                        if (!isFirst)
                          IconButton(
                            onPressed: () =>
                                _switchChat(_allChatIds[curIdx - 1]),
                            icon:
                                const Icon(Icons.keyboard_arrow_down, size: 19),
                          ),
                      ],
                    );
                  },
                ),
                const Spacer(),
                ListenableBuilder(
                  listenable: _pageIndicatorRN,
                  builder: (_, __) {
                    if (_curPageIdx == 0) {
                      return IconButton(
                        onPressed: () => _pageCtrl.animateToPage(
                          1,
                          duration: Durations.medium1,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                        icon: const Icon(Icons.chat, size: 19),
                      );
                    }
                    return IconButton(
                      onPressed: () => _pageCtrl.animateToPage(
                        0,
                        duration: Durations.medium1,
                        curve: Curves.fastEaseInToSlowEaseOut,
                      ),
                      icon: const Icon(Icons.history, size: 19),
                    );
                  },
                ),
                if (isMobile)
                  IconButton(
                    onPressed: () => _focusNode.unfocus(),
                    icon: const Icon(Icons.keyboard_hide, size: 19),
                  ),
              ],
            ),
            Input(
              controller: _inputCtrl,
              label: l10n.message,
              node: _focusNode,
              type: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
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
                          icon: const Icon(Icons.send),
                          onPressed: () => _onSend(_curChatId, context),
                        );
                },
              ),
            ),
            SizedBox(height: _media?.padding.bottom),
          ],
        ),
      ),
    );
  }
}
