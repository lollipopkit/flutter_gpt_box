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
    return ListenableBuilder(
      listenable: _chatRN,
      builder: (_, __) {
        final item = _curChat?.items;
        if (item == null) return UIs.placeholder;
        return FadeIn(
          key: ValueKey(_curChatId),
          child: ListView.builder(
            controller: _scrollCtrl,
            padding: const EdgeInsets.symmetric(horizontal: 7),
            itemCount: item.length,
            itemBuilder: (_, index) {
              return _buildChatItem(item, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildChatItem(List<ChatHistoryItem> chatItems, int idx) {
    final chatItem = chatItems[idx];
    final node = _mdRNMap.putIfAbsent(chatItem.id, () => RebuildNode());
    final md = ListenableBuilder(
      listenable: node,
      builder: (_, __) {
        return MarkdownBody(
          data: chatItem.toMarkdown,
          selectable: true,
          builders: {
            'code': CodeElementBuilder(onCopy: _onCopy),
          },
          onTapLink: MarkdownUtils.onLinkTap,
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
              ? md
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: md,
                ),
        ],
      ),
    );
  }

  Widget _buildChatItemBtn(
    List<ChatHistoryItem> chatItems,
    ChatHistoryItem chatItem,
  ) {
    return Row(
      children: [
        Text(chatItem.role.name, style: UIs.text13Grey),
        const Spacer(),
        IconButton(
          onPressed: () async {
            final result = await context.showRoundDialog<bool>(
              title: l10n.attention,
              child: Text(l10n.delFmt(chatItem.toMarkdown, chatItem.id)),
              actions: [
                TextButton(
                  onPressed: () => context.pop(true),
                  child: Text(l10n.ok),
                ),
              ],
            );
            if (result != true) return;
            chatItems.remove(chatItem);
            _storeChat(_curChatId, context);
            _chatRN.rebuild();
          },
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.delete,
            size: 17,
          ),
        ),
        IconButton(
          onPressed: () => _onCopy(chatItem.toMarkdown),
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.copy,
            size: 15,
          ),
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
