part of 'setting.dart';

/// The model's memory files: what it keeps across chats, for the user to
/// read, fix and prune.
class MemoryPage extends StatelessWidget {
  const MemoryPage({super.key});

  static const route = AppRouteNoArg(page: MemoryPage.new, path: '/memory');

  static final _store = Stores.memory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.memory),
        actions: [
          Btn.icon(icon: const Icon(Icons.add), text: libL10n.add, onTap: () => _create(context)),
        ],
      ),
      body: _store.changes.listen(() {
        final files = _store.files();
        if (files.isEmpty) return EmptyPane(icon: Icons.psychology_alt_outlined, label: libL10n.empty);
        return SectionList(
          children: [
            SettingsGroup(
              title: MemoryStore.root,
              rows: [for (final MapEntry(:key, :value) in files.entries) _file(context, key, value)],
            ),
          ],
        );
      }),
    );
  }

  Widget _file(BuildContext context, String key, String text) {
    void menu([Offset? at]) => showContextMenu(
      context,
      [
        ContextMenuAction(text: libL10n.rename, icon: Icons.drive_file_rename_outline, onTap: () => _rename(context, key)),
        ContextMenuAction(
          text: libL10n.delete,
          icon: Icons.delete_outline,
          destructive: true,
          onTap: () => _delete(context, key),
        ),
      ],
      title: MemoryStore.pathOf(key),
      at: at,
      sheet: at == null && isMobile,
    );
    return SettingsRow(
      icon: key == MemoryStore.index ? Icons.list_alt : Icons.description_outlined,
      title: key,
      mono: true,
      subtitle: [l10n.charsFmt(text.length), ?_store.modified(key)?.toAgoStr()].join(' · '),
      trailing: const RowChevron(),
      onTap: () => MemoryFilePage.route.go(context, args: key),
      onLongPress: menu,
    ).onSecondary(menu);
  }

  /// Asks for a path: null when cancelled; a toast for one the store refuses.
  static Future<String?> _askPath(BuildContext context, {required String title, String? initial}) async {
    final ctrl = TextEditingController(text: initial);
    final res = await context.showRoundDialog<String>(
      title: title,
      child: Input(controller: ctrl, autoFocus: true, hint: 'user.md', onSubmitted: context.pop),
      actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
    );
    ctrl.dispose();
    if (res == null || res.trim().isEmpty) return null;
    try {
      final key = MemoryStore.keyOf(res);
      return key.isEmpty ? null : key;
    } on MemoryPathError catch (e) {
      Toast.show('$e');
      return null;
    }
  }

  Future<void> _create(BuildContext context) async {
    final key = await _askPath(context, title: libL10n.add);
    if (key == null || !context.mounted) return;
    if (_store.under(key).isNotEmpty) {
      Toast.show(l10n.alreadyExists(MemoryStore.pathOf(key)));
      return;
    }
    await MemoryFilePage.route.go(context, args: key);
  }

  Future<void> _rename(BuildContext context, String key) async {
    final to = await _askPath(context, title: libL10n.rename, initial: key);
    if (to == null || to == key) return;
    try {
      _store.move(key, to);
    } on MemoryPathError catch (e) {
      Toast.show('$e');
    }
  }

  Future<void> _delete(BuildContext context, String key) async {
    final ok = await context.showRoundDialog<bool>(
      title: libL10n.attention,
      child: Text(libL10n.askContinue('${libL10n.delete} ${MemoryStore.pathOf(key)}')),
      actions: Btnx.cancelRedOk,
    );
    if (ok == true) _store.delete(key);
  }
}

/// One memory file, edited as plain text. A new one is made on save.
class MemoryFilePage extends StatefulWidget {
  const MemoryFilePage({super.key, this.args});

  /// The file's key in [MemoryStore].
  final String? args;

  String get _key => args ?? MemoryStore.index;

  static const route = AppRoute<void, String>(page: MemoryFilePage.new, path: '/memory/file');

  @override
  State<MemoryFilePage> createState() => _MemoryFilePageState();
}

class _MemoryFilePageState extends State<MemoryFilePage> {
  late final _saved = (Stores.memory.read(widget._key) ?? '').vn;
  late final _ctrl = TextEditingController(text: _saved.value);

  @override
  void dispose() {
    _ctrl.dispose();
    _saved.dispose();
    super.dispose();
  }

  bool _save() {
    try {
      Stores.memory.write(widget._key, _ctrl.text);
      _saved.value = _ctrl.text;
      return true;
    } on MemoryPathError catch (e) {
      Toast.show('$e');
      return false;
    }
  }

  Future<void> _leave(bool didPop, Object? _) async {
    if (didPop) return;
    final save = await context.showRoundDialog<bool>(
      title: libL10n.attention,
      child: Text(l10n.unsavedChanges),
      actions: [
        Btn.text(text: libL10n.cancel, onTap: () => context.pop()),
        Btn.text(text: l10n.discard, textStyle: const TextStyle(color: Colors.red), onTap: () => context.pop(false)),
        Btn.ok(onTap: () => context.pop(true)),
      ],
    );
    if (save == null || !mounted) return;
    if (save && !_save()) return;
    _saved.value = _ctrl.text;
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_ctrl, _saved]),
      builder: (context, _) {
        final dirty = _ctrl.text != _saved.value;
        return PopScope(
          canPop: !dirty,
          onPopInvokedWithResult: _leave,
          child: Scaffold(
            appBar: CustomAppBar(
              title: Text(MemoryStore.pathOf(widget._key), style: Mono.style(fontSize: 14)),
              actions: [
                Btn.icon(icon: const Icon(Icons.save_outlined), text: libL10n.save, onTap: dirty ? _save : null),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(17, 8, 17, 17),
              child: TextField(
                controller: _ctrl,
                autofocus: _saved.value.isEmpty,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                style: Mono.style(fontSize: 13, height: 1.5),
                decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true),
              ),
            ),
          ),
        );
      },
    );
  }
}
