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
              IconButton(
                onPressed: () => _onTapRenameChat(_curChatId, context),
                icon: const Icon(Icons.abc, size: 19),
                tooltip: l10n.rename,
              ),
              _buildSwitchPageBtn(),
              if (isMobile)
                IconButton(
                  onPressed: () => _focusNode.unfocus(),
                  icon: const Icon(Icons.keyboard_hide, size: 19),
                ),
              const Spacer(),
              _buildCounter(context),
            ],
          ),
          Input(
            controller: _inputCtrl,
            label: l10n.message,
            node: _focusNode,
            action: TextInputAction.send,
            maxLines: 5,
            minLines: 1,
            autoCorrect: true,
            suggestion: true,
            onSubmitted: (p0) {
              _onSend(_curChatId, context);
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

Widget _buildSwitchPageBtn() {
  return ValueListenableBuilder(
    valueListenable: _isWide,
    builder: (_, isWide, __) => isWide
        ? UIs.placeholder
        : ValueListenableBuilder(
            valueListenable: _curPage,
            builder: (_, page, __) => switch (page) {
              HomePageEnum.history => IconButton(
                  onPressed: () => _pageCtrl.animateToPage(
                    HomePageEnum.chat.index,
                    duration: Durations.medium1,
                    curve: Curves.fastEaseInToSlowEaseOut,
                  ),
                  icon: const Icon(Icons.chat, size: 19),
                ),
              HomePageEnum.chat => IconButton(
                  onPressed: () => _pageCtrl.animateToPage(
                    HomePageEnum.history.index,
                    duration: Durations.medium1,
                    curve: Curves.fastEaseInToSlowEaseOut,
                  ),
                  icon: const Icon(Icons.history, size: 19),
                ),
            },
          ),
  );
}

Widget _buildCounter(BuildContext context) {
  return ListenableBuilder(
    listenable: _chatRN,
    builder: (_, __) {
      final curChat = _curChat;
      if (curChat == null) return UIs.placeholder;
      final model = _getChatConfig(_curChatId).model;
      final tiktoken = encodingForModel(model);
      final tokens = tiktoken
          .encode(curChat.items.map((e) => e.toMarkdown).join(''))
          .length;
      if (tokens == 0) return UIs.placeholder;
      final price = TiktokenUtils.getPrice(model);
      return TextButton(
        onPressed: () {
          context.showRoundDialog(
            title: l10n.attention,
            child: Text(l10n.priceCounterTip),
          );
        },
        child: switch (price) {
          final double price => Text(
              '\$ ${(tokens * price).toStringAsFixed(5)}',
              style: UIs.text11Grey,
            ),
          _ => Text('$tokens tokens', style: UIs.text11Grey),
        },
      );
    },
  );
}
