import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/data/model/chat.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/share.dart';

/// The chats, newest first, with search and the trash.
class ChatList extends StatefulWidget {
  const ChatList({super.key, this.onPicked});

  /// After a chat is picked — the drawer closes itself with it.
  final VoidCallback? onPicked;

  /// Focuses the search field; for the keyboard shortcut.
  static final searchRequest = RNode();

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final _query = TextEditingController();
  final _queryFocus = FocusNode();
  var _trash = false;

  @override
  void initState() {
    super.initState();
    ChatList.searchRequest.addListener(_focusSearch);
  }

  @override
  void dispose() {
    ChatList.searchRequest.removeListener(_focusSearch);
    _query.dispose();
    _queryFocus.dispose();
    super.dispose();
  }

  void _focusSearch() => _queryFocus.requestFocus();

  void _pick(String id) {
    Chats.current.value = id;
    widget.onPicked?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(9, 9, 9, 5),
          child: Row(
            children: [
              Expanded(
                child: Input(
                  controller: _query,
                  node: _queryFocus,
                  hint: libL10n.search,
                  icon: Icons.search,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              IconButton(
                tooltip: l10n.trash,
                isSelected: _trash,
                icon: const Icon(Icons.delete_outline),
                selectedIcon: const Icon(Icons.delete),
                onPressed: () => setState(() => _trash = !_trash),
              ),
            ],
          ),
        ),
        if (!_trash)
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(l10n.newChat),
            onTap: () {
              Chats.current.value = null;
              widget.onPicked?.call();
            },
          ),
        Expanded(
          child: ListenableBuilder(
            listenable: Listenable.merge([Stores.chat.changes, Chats.current]),
            builder: (context, _) {
              final q = _query.text.trim();
              final chats = _trash
                  ? Stores.chat.all(trashed: true)
                  : q.isEmpty
                  ? Stores.chat.all()
                  : Chats.search(q);
              if (chats.isEmpty) {
                return Center(child: Text(_trash ? l10n.emptyTrash : libL10n.empty, style: UIs.textGrey));
              }
              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (_, i) => _trash ? _trashTile(chats[i]) : _tile(chats[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tile(ChatMeta m) {
    final selected = m.id == Chats.current.value;
    return ListTile(
      selected: selected,
      title: Text(m.title ?? l10n.untitled, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(m.updatedAt.toAgoStr(), style: UIs.text12Grey),
      onTap: () => _pick(m.id),
      onLongPress: () => _menu(m),
      trailing: isDesktop
          ? IconButton(icon: const Icon(Icons.more_horiz, size: 19), onPressed: () => _menu(m))
          : null,
    );
  }

  Widget _trashTile(ChatMeta m) {
    return ListTile(
      title: Text(m.title ?? l10n.untitled, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(m.trashedAt!.toAgoStr(), style: UIs.text12Grey),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: libL10n.restore,
            icon: const Icon(Icons.restore),
            onPressed: () => Chats.restore(m.id),
          ),
          IconButton(
            tooltip: libL10n.delete,
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final ok = await context.showRoundDialog<bool>(
                title: libL10n.attention,
                child: Text(l10n.delFmt(m.title ?? l10n.untitled, l10n.chat)),
                actions: Btnx.okReds,
              );
              if (ok == true) await Chats.deleteForever(m.id);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _menu(ChatMeta m) async {
    final action = await context.showRoundDialog<String>(
      title: m.title ?? l10n.untitled,
      contentPadding: const EdgeInsets.symmetric(vertical: 11),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(leading: const Icon(Icons.edit), title: Text(l10n.rename), onTap: () => context.pop('rename')),
          ListTile(leading: const Icon(Icons.share), title: Text(l10n.share), onTap: () => context.pop('share')),
          ListTile(leading: const Icon(Icons.delete), title: Text(libL10n.delete), onTap: () => context.pop('trash')),
        ],
      ),
    );
    if (!mounted) return;
    switch (action) {
      case 'rename':
        final ctrl = TextEditingController(text: m.title);
        final title = await context.showRoundDialog<String>(
          title: l10n.rename,
          child: Input(controller: ctrl, autoFocus: true, onSubmitted: (v) => context.pop(v)),
          actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
        );
        ctrl.dispose();
        if (title != null && title.trim().isNotEmpty) Chats.rename(m.id, title.trim());
      case 'share':
        await shareChat(context, m.id);
      case 'trash':
        if (Chats.current.value == m.id) Chats.current.value = null;
        await Chats.trash(m.id);
    }
  }
}
