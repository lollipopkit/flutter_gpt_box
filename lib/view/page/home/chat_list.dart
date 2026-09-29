import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/llm/chats.dart';
import 'package:gpt_box/core/llm/llm.dart';
import 'package:gpt_box/data/model/chat.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:gpt_box/view/page/home/share.dart';
import 'package:intl/intl.dart';

/// The sidebar while chatting: the app's name and a new chat, search, the
/// chats grouped by day, and the settings at the foot.
class ChatSidebar extends StatefulWidget {
  const ChatSidebar({super.key, required this.onNewChat, required this.onOpenSettings, this.onPicked});

  final VoidCallback onNewChat;
  final VoidCallback onOpenSettings;

  /// After a chat is picked — the drawer closes itself with it.
  final VoidCallback? onPicked;

  /// Focuses the search field; for the keyboard shortcut.
  static final searchRequest = RNode();

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  final _query = TextEditingController();
  final _queryFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    ChatSidebar.searchRequest.addListener(_focusSearch);
  }

  @override
  void dispose() {
    ChatSidebar.searchRequest.removeListener(_focusSearch);
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(17, 3, 7, 7),
          child: Row(
            children: [
              const Expanded(child: Text('GPT Box', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
              Btn.icon(
                icon: const Icon(Icons.edit_square, size: 20),
                text: l10n.newChat,
                onTap: widget.onNewChat,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: Input(
            controller: _query,
            node: _queryFocus,
            hint: libL10n.search,
            icon: Icons.search,
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: Listenable.merge([Stores.chat.changes, Chats.current]),
            builder: (context, _) {
              final q = _query.text.trim();
              final chats = q.isEmpty ? Stores.chat.all() : Chats.search(q);
              if (chats.isEmpty) return Center(child: Text(libL10n.empty, style: UIs.textGrey));
              final rows = <Widget>[];
              String? group;
              for (final m in chats) {
                // Searching, the order is the match's: no day headings.
                final g = q.isEmpty ? _groupOf(m.updatedAt) : null;
                if (g != null && g != group) {
                  rows.add(Padding(padding: const EdgeInsets.only(top: 13), child: SideBarSection(g)));
                  group = g;
                }
                rows.add(_tile(m));
              }
              return ListView(padding: const EdgeInsets.only(bottom: 13), children: rows);
            },
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Hairline.color(context)))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Llm.configured.listenVal((set) {
              return SideBarTile(
                icon: Icons.settings_outlined,
                title: libL10n.setting,
                trailing: Text(l10n.providersCountFmt(set.length), style: UIs.text12Grey),
                onTap: widget.onOpenSettings,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _tile(ChatMeta m) {
    return SideBarTile(
      title: m.title ?? l10n.untitled,
      selected: m.id == Chats.current.value,
      trailing: Padding(
        padding: const EdgeInsetsDirectional.only(start: 9, end: 3),
        child: Text(
          _timeOf(m.updatedAt),
          style: UIs.text12Grey.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
        ),
      ),
      onTap: () => _pick(m.id),
      onMenu: (at) => chatMenu(context, m, at: at),
    );
  }

  static String _groupOf(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (!t.isBefore(today)) return l10n.today;
    if (!t.isBefore(today.subtract(const Duration(days: 1)))) return libL10n.yesterday;
    return l10n.earlier;
  }

  /// `now`, `3 h` today; the time yesterday; the date before that.
  static String _timeOf(DateTime t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (!t.isBefore(today)) {
      final d = now.difference(t);
      if (d.inMinutes < 1) return l10n.now;
      if (d.inHours < 1) return l10n.minutesFmt(d.inMinutes);
      return l10n.hoursFmt(d.inHours);
    }
    if (!t.isBefore(today.subtract(const Duration(days: 1)))) return DateFormat.Hm(l10n.localeName).format(t);
    return DateFormat.MMMd(l10n.localeName).format(t);
  }
}

/// What can be done to a chat: rename, share, delete — at the pointer.
Future<void> chatMenu(BuildContext context, ChatMeta m, {Offset? at}) {
  return showContextMenu(
    context,
    chatActions(context, m),
    title: m.title ?? l10n.untitled,
    at: at,
    sheet: at == null && isMobile,
  );
}

List<ContextMenuAction> chatActions(BuildContext context, ChatMeta m) => [
      ContextMenuAction(text: l10n.rename, icon: Icons.edit_outlined, onTap: () => _rename(context, m)),
      ContextMenuAction(text: l10n.share, icon: Icons.ios_share, onTap: () => shareChat(context, m.id)),
      ContextMenuAction(
        text: libL10n.delete,
        icon: Icons.delete_outline,
        destructive: true,
        onTap: () async {
          if (Chats.current.value == m.id) Chats.current.value = null;
          await Chats.trash(m.id);
        },
      ),
    ];

Future<void> _rename(BuildContext context, ChatMeta m) async {
  final ctrl = TextEditingController(text: m.title);
  final title = await context.showRoundDialog<String>(
    title: l10n.rename,
    child: Input(controller: ctrl, autoFocus: true, onSubmitted: (v) => context.pop(v)),
    actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
  );
  ctrl.dispose();
  if (title != null && title.trim().isNotEmpty) Chats.rename(m.id, title.trim());
}
