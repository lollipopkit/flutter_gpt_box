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

    return ValueListenableBuilder(
      valueListenable: _isWide,
      builder: (_, isWide, __) {
        return Scaffold(
          body: _buildChat(),
          bottomNavigationBar: isWide ? const _HomeBottom() : null,
          floatingActionButton: _buildFAB(),
        );
      },
    );
  }

  Widget _buildFAB() {
    return ListenableBuilder(
      listenable: _chatFabRN,
      builder: (_, __) {
        final valid = _chatScrollCtrl.positions.length == 1 &&
            _chatScrollCtrl.position.hasContentDimensions &&
            _chatScrollCtrl.position.maxScrollExtent > 0;
        return AnimatedSwitcher(
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          duration: _durationShort,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: valid ? _buildFABBtn() : UIs.placeholder,
        );
      },
    );
  }

  Widget _buildFABBtn() {
    final up =
        _chatScrollCtrl.offset >= _chatScrollCtrl.position.maxScrollExtent / 2;
    final icon = up ? MingCute.up_fill : MingCute.down_fill;
    return FloatingActionButton(
      key: ValueKey(up),
      mini: true,
      onPressed: () async {
        if (!_chatScrollCtrl.hasClients) return;
        if (up) {
          await _chatScrollCtrl.animateTo(
            0,
            duration: _durationMedium,
            curve: Curves.easeInOut,
          );
        } else {
          await _chatScrollCtrl.animateTo(
            _chatScrollCtrl.position.maxScrollExtent,
            duration: _durationMedium,
            curve: Curves.easeInOut,
          );
        }
        _chatFabRN.build();
      },
      child: Icon(icon),
    );
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
            duration: _durationShort,
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
              padding: const EdgeInsets.all(7),
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
    final node = _chatItemRNMap.putIfAbsent(chatItem.id, () => RNode());
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChatItemBtn(chatItems, chatItem),
          ListenableBuilder(
            listenable: node,
            builder: (_, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: chatItem.content
                    .map((e) => switch (e.type) {
                          ChatContentType.audio => _buildAudio(e),
                          ChatContentType.image => _buildImage(e),
                          _ => _buildText(e),
                        })
                    .joinWith(UIs.height13),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildText(ChatContent content) {
    final child = MarkdownBody(
      data: content.raw,
      builders: {
        'code': CodeElementBuilder(onCopy: _onCopy),
        'latex': LatexElementBuilder(),
      },
      extensionSet: MarkdownUtils.extensionSet,
      onTapLink: MarkdownUtils.onLinkTap,
      shrinkWrap: false,

      /// Keep it false, or the ScrollView's height calculation will be wrong.
      fitContent: false,

      /// User experience is better when this is false.
      selectable: false,
    );
    return Stores.setting.softWrap.fetch()
        ? child
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: child,
          );
  }

  Widget _buildImage(ChatContent content) {
    return ImageCard(
      imageUrl: content.raw,
      heroTag: content.hashCode.toString(),
    );
  }

  Widget _buildAudio(ChatContent content) {
    return AudioCard(id: content.id, path: content.raw);
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
            chatItem.role.localized,
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
              /// TODO: Can't replay image message.
              final isImgChat =
                  chatItem.content.any((e) => e.type == ChatContentType.image);
              if (isImgChat) return UIs.placeholder;
              final isWorking = _chatStreamSubs.containsKey(_curChatId);
              if (isWorking) return UIs.placeholder;
              return IconButton(
                onPressed: () => _onTapReplay(
                  context,
                  _curChatId,
                  chatItem,
                ),
                icon: const Icon(Icons.refresh, size: 17),
              );
            },
          ),
        if (chatItem.role == ChatRole.user)
          IconButton(
            onPressed: () => _onTapEditMsg(context, chatItem),
            icon: const Icon(Icons.edit, size: 17),
          ),
        IconButton(
          onPressed: () async {
            final idx = chatItems.indexOf(chatItem) + 1;
            final result = await context.showRoundDialog<bool>(
              title: l10n.attention,
              child: Text(
                l10n.delFmt('${chatItem.role.localized}#$idx', l10n.chat),
              ),
              actions: Btns.oks(onTap: () => context.pop(true), red: true),
            );
            if (result != true) return;
            chatItems.remove(chatItem);
            _storeChat(_curChatId, context);
            _historyRNMap[_curChatId]?.build();
            _chatRN.build();
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
    //context.showSnackBar(l10n.copied);
  }

  @override
  bool get wantKeepAlive => true;
}
