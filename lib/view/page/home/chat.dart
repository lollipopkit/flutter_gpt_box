part of 'home.dart';

class _ChatPage extends StatefulWidget {
  const _ChatPage();

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<_ChatPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder(valueListenable: _isWide, builder: (_, isWide, __) {
      if (!isWide) return _buildChat();
      return Scaffold(
        body: _buildChat(),
        bottomNavigationBar: _buildInput(context),
      );
    },);
  }

  Widget _buildChat() {
    var switchDirection = SwitchPageDirection.next;
    return SwitchPageIndicator(
      onSwitchPage: (direction) {
        switchDirection = direction;
        switch (direction) {
          case SwitchPageDirection.previous:
            _switchPreviousChat();
            break;
          case SwitchPageDirection.next:
            _switchNextChat();
            break;
        }
        return Future.value();
      },
      child: ListenableBuilder(
        listenable: _chatRN,
        builder: (_, __) {
          final item = _curChat?.items;
          if (item == null) return UIs.placeholder;
          return AnimatedSwitcher(
            duration: Durations.short4,
            switchInCurve: Easing.standardDecelerate,
            switchOutCurve: Easing.standardDecelerate,
            transitionBuilder: (child, animation) => SlideTransitionX(
              position: animation,
              direction: switchDirection == SwitchPageDirection.next
                  ? AxisDirection.up
                  : AxisDirection.down,
              child: child,
            ),
            child: ListView.builder(
              key: Key(_curChatId),
              controller: _chatScrollCtrl,
              padding: const EdgeInsets.only(left: 7, right: 7, bottom: 47),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: item.length,
              itemBuilder: (_, index) {
                return _buildChatItem(item, index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatItem(List<ChatHistoryItem> chatItems, int idx) {
    final chatItem = chatItems[idx];
    final node = _mdRNMap.putIfAbsent(chatItem.id, () => RebuildNode());
    final child = ListenableBuilder(
      listenable: node,
      builder: (_, __) {
        return MarkdownBody(
          data: chatItem.toMarkdown,
          builders: {
            'code': CodeElementBuilder(onCopy: _onCopy),
          },
          extensionSet: md.ExtensionSet(
            [
              LatexBlockSyntax(),
              ...md.ExtensionSet.gitHubFlavored.blockSyntaxes
            ],
            [
              LatexInlineSyntax(),
              md.EmojiSyntax(),
              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
            ],
          ),
          onTapLink: MarkdownUtils.onLinkTap,
          shrinkWrap: false,
          fitContent: false,

          /// User experience is better when this is false.
          selectable: false,
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChatItemBtn(chatItems, chatItem),
          Stores.setting.softWrap.fetch()
              ? child
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: child,
                ),
        ],
      ),
    );
  }

  Widget _buildChatItemBtn(
    List<ChatHistoryItem> chatItems,
    ChatHistoryItem chatItem,
  ) {
    final isBright = UIs.primaryColor.isBrightColor;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: UIs.primaryColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
          child: Text(
            chatItem.role.name,
            style: TextStyle(
              fontSize: 12,
              color: isBright ? Colors.black : Colors.white,
            ),
          ),
        ),
        const Spacer(),
        if (chatItem.role == ChatRole.user)
          ListenableBuilder(
            listenable: _sendBtnRN,
            builder: (_, __) {
              final isWorking = _chatStreamSubs.containsKey(_curChatId);
              if (isWorking) return UIs.placeholder;
              return IconButton(
                onPressed: () => _onReplay(
                  context: context,
                  chatId: _curChatId,
                  item: chatItem,
                ),
                icon: const Icon(Icons.refresh, size: 17),
              );
            },
          ),
        if (chatItem.role == ChatRole.user)
          IconButton(
            onPressed: () async {
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
                    chatItem.content.add(ChatContent(
                      type: ChatContentType.text,
                      raw: p0,
                    ));
                    _storeChat(_curChatId, context);
                    _chatRN.rebuild();
                    context.pop();
                  },
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 17),
          ),
        IconButton(
          onPressed: () async {
            final idx = chatItems.indexOf(chatItem) + 1;
            final result = await context.showRoundDialog<bool>(
              title: l10n.attention,
              child: Text(
                l10n.delFmt('${chatItem.role.name}#$idx', l10n.chat),
              ),
              actions: Btns.oks(onTap: () => context.pop(true), red: true),
            );
            if (result != true) return;
            chatItems.remove(chatItem);
            _storeChat(_curChatId, context);
            _chatRN.rebuild();
          },
          icon: const Icon(Icons.delete, size: 17),
        ),
        IconButton(
          onPressed: () => _onCopy(chatItem.toMarkdown),
          icon: const Icon(Icons.copy, size: 15),
        ),
      ],
    );
  }

  void _onCopy(String content) {
    Clipboard.setData(ClipboardData(text: content));
    context.showSnackBar(l10n.copied);
  }

  @override
  bool get wantKeepAlive => true;
}
