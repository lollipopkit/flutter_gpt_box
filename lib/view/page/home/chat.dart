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
        if (!isWide) return _buildChat();
        return Scaffold(
          body: _buildChat(),
          bottomNavigationBar: const _HomeBottom(),
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
    final icon = up ? Icons.arrow_upward : Icons.arrow_downward;
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
                mainAxisSize: MainAxisSize.min,
                children: chatItem.content
                    .map((e) => switch (e.type) {
                          ChatContentType.audio => _buildAudio(chatItem),
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
    return ImageListTile(
      imageUrl: content.raw,
      heroTag: content.hashCode.toString(),
    );
  }

  /// Current design only allows one audio of each chat item.
  Widget _buildAudio(ChatHistoryItem chatItem) {
    final listenable = _audioPlayerMap.putIfAbsent(
      chatItem.id,
      () => ValueNotifier(AudioPlayStatus.fromChatItem(chatItem)),
    );
    final initWidget = () async {
      await _audioLoadingMap[chatItem.id]?.future;
      final path = '${await Paths.audio}/${chatItem.id}.mp3';
      if (!await File(path).exists()) {
        throw 'File not found: $path';
      }
      final player = AudioPlayer();
      player.setSource(DeviceFileSource(path));
      return player.getDuration();
    }();
    return FutureWidget(
      future: initWidget,
      error: (error, trace) {
        Loggers.app.warning('Failed to get audio duration', error, trace);
        return Text('$error');
      },
      loading: UIs.centerSizedLoading,
      success: (duration) {
        listenable.value = listenable.value.copyWith(
          total: duration?.inMilliseconds ?? 0,
        );
        return ValueListenableBuilder(
          valueListenable: listenable,
          builder: (_, val, __) {
            return ListTile(
              leading: IconButton(
                icon: val.playing
                    ? const Icon(Icons.stop, size: 19)
                    : const Icon(Icons.play_arrow, size: 19),
                onPressed: () => _onTapAudioCtrl(val, chatItem, listenable),
              ),
              title: Slider(
                value: duration == null ? 0.0 : val.played / val.total,
                onChanged: (v) {
                  final nowMilli = (val.total * v).toInt();
                  final duration = Duration(milliseconds: nowMilli);
                  _audioPlayer.seek(duration);
                  listenable.value = val.copyWith(played: nowMilli);
                },
              ),
            );
          },
        );
      },
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
                l10n.delFmt('${chatItem.role.name}#$idx', l10n.chat),
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
    context.showSnackBar(l10n.copied);
  }

  @override
  bool get wantKeepAlive => true;
}
