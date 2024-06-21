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
    return AutoHide(
      key: _chatFabAutoHideKey,
      controller: _chatScrollCtrl,
      direction: AxisDirection.down,
      offset: 75,
      child: ListenBuilder(
        listenable: _chatFabRN,
        builder: () {
          final valid = _chatScrollCtrl.positions.length == 1 &&
              _chatScrollCtrl.position.hasContentDimensions &&
              _chatScrollCtrl.position.maxScrollExtent > 0;
          return AnimatedSwitcher(
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween<double>(begin: 0.5, end: 0).animate(animation),
                child: child,
              );
            },
            duration: _durationShort,
            switchInCurve: Curves.fastEaseInToSlowEaseOut,
            switchOutCurve: Curves.fastEaseInToSlowEaseOut,
            child: valid ? _buildFABBtn() : UIs.placeholder,
          );
        },
      ),
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
    var switchDirection = SwitchDirection.next;
    final scrollSwitchChat = Stores.setting.scrollSwitchChat.fetch();

    final child = ListenBuilder(
      listenable: _chatRN,
      builder: () {
        final item = _curChat?.items;
        if (item == null) return UIs.placeholder;
        final listView = ListView.builder(
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
        );
        if (!scrollSwitchChat) return listView;
        return AnimatedSwitcher(
          duration: _durationShort,
          switchInCurve: Easing.standardDecelerate,
          switchOutCurve: Easing.standardDecelerate,
          transitionBuilder: (child, animation) => SlideTransitionX(
            position: animation,
            direction: switchDirection == SwitchDirection.next
                ? AxisDirection.up
                : AxisDirection.down,
            child: child,
          ),
          child: listView,
        );
      },
    );

    if (!scrollSwitchChat) return child;

    return SwitchIndicator(
      onSwitchPage: (direction) {
        switchDirection = direction;
        switch (direction) {
          case SwitchDirection.previous:
            _switchPreviousChat();
            break;
          case SwitchDirection.next:
            _switchNextChat();
            break;
        }
        return Future.value();
      },
      child: child,
    );
  }

  Widget _buildChatItem(List<ChatHistoryItem> chatItems, int idx) {
    final chatItem = chatItems[idx];
    final node = _chatItemRNMap.putIfAbsent(chatItem.id, () => RNode());
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onLongPress: () {
        final funcs = _buildChatItemFuncs(chatItems, chatItem);
        context.showRoundDialog(
          contentPadding: const EdgeInsets.all(11),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: funcs,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 11, left: 11, right: 11, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChatItemTitle(chatItems, chatItem),
            UIs.height13,
            ListenBuilder(
              listenable: node,
              builder: () {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: chatItem.content
                      .map((e) => switch (e.type) {
                            ChatContentType.audio => _buildAudio(e),
                            ChatContentType.image => _buildImage(e),
                            _ => _buildText(e),
                          })
                      .toList()
                      .joinWith(UIs.height13),
                );
              },
            ).paddingSymmetric(horizontal: 2),
            UIs.height13,
          ],
        ),
      ),
    );
  }

  Widget _buildText(ChatContent content) {
    return MarkdownBody(
      data: content.raw,
      builders: {
        'code': CodeElementBuilder(onCopy: Pfs.copy),
        'latex': LatexElementBuilder(),
      },
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        codeblockDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      extensionSet: MarkdownUtils.extensionSet,
      onTapLink: MarkdownUtils.onLinkTap,
      shrinkWrap: false,

      /// Keep it false, or the ScrollView's height calculation will be wrong.
      fitContent: false,

      /// User experience is better when this is false.
      selectable: false,
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

  Widget _buildChatItemTitle(
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
      ],
    );
  }

  List<Widget> _buildChatItemFuncs(
    List<ChatHistoryItem> chatItems,
    ChatHistoryItem chatItem,
  ) {
    final replayEnabled =
        chatItem.role == ChatRole.user && Stores.setting.replay.fetch();

    Widget buildCircleBtn({
      required VoidCallback onTap,
      required String text,
      required IconData icon,
    }) {
      return InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          context.pop();
          onTap();
        },
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 27),
            Text(text, style: const TextStyle(fontSize: 16.5)),
          ],
        ).paddingSymmetric(horizontal: 23, vertical: 15),
      );
    }

    return [
      buildCircleBtn(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _MarkdownCopyPage(text: chatItem.toMarkdown),
          ),
        ),
        text: l10n.freeCopy,
        icon: BoxIcons.bxs_crop,
      ),
      if (replayEnabled)
        ListenBuilder(
          listenable: _sendBtnRN,
          builder: () {
            final isWorking = _chatStreamSubs.containsKey(_curChatId);
            if (isWorking) return UIs.placeholder;
            return buildCircleBtn(
              onTap: () => _onTapReplay(context, _curChatId, chatItem),
              text: l10n.replay,
              icon: Icons.refresh,
            );
          },
        ),
      if (replayEnabled)
        buildCircleBtn(
          onTap: () => _onTapEditMsg(context, chatItem),
          text: l10n.edit,
          icon: Icons.edit,
        ),
      buildCircleBtn(
        onTap: () => _onTapDelChatItem(context, chatItems, chatItem),
        text: l10n.delete,
        icon: Icons.delete,
      ),
      buildCircleBtn(
        onTap: () => Pfs.copy(chatItem.toMarkdown),
        text: l10n.copy,
        icon: MingCute.copy_2_fill,
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
