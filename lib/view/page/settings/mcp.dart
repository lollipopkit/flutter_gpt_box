part of 'setting.dart';

/// Tools: the switch, the built-in ones, and the MCP servers.
class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  static final _store = Stores.mcp;

  static IconData _iconOf(ToolFunc t) => switch (t) {
    TfHistory() => Icons.history,
    TfHttpReq() => Icons.language,
    TfMemory() => Icons.psychology_alt_outlined,
    _ => Icons.extension_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return SectionList(
      children: [
        SettingsGroup(
          title: l10n.tool,
          rows: [
            SettingsRow(
              icon: Icons.build_outlined,
              title: l10n.useTools,
              subtitle: l10n.useToolsTip,
              trailing: StoreSwitch(prop: _store.enabled, callback: (_) => Chats.reconfigureSoon()),
            ),
          ],
        ),
        _store.disabledTools.listenable().listenVal((disabled) {
          return SettingsGroup(
            title: l10n.builtIn,
            rows: [
              for (final t in Tools.internalTools)
                SettingsRow(
                  icon: _iconOf(t),
                  title: t.l10nName,
                  subtitle: t.l10nTip,
                  trailing: SwitchX(
                    value: !disabled.contains(t.name),
                    onChanged: (on) {
                      _store.disabledTools.set(on ? [...disabled.where((e) => e != t.name)] : [...disabled, t.name]);
                      Chats.reconfigureSoon();
                    },
                  ),
                ),
              _store.memories.listenable().listenVal((list) {
                return SettingsRow(
                  icon: Icons.edit_note,
                  title: l10n.memories,
                  trailing: RowValue(l10n.entriesFmt(list.length)),
                  onTap: () => _editMemories(context, list),
                );
              }),
              _store.permittedTools.listenable().listenVal((list) {
                return SettingsRow(
                  icon: Icons.verified_user_outlined,
                  title: l10n.allowedWithoutAsking,
                  trailing: Flexible(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: RowValue(list.isEmpty ? libL10n.empty : list.map(Tools.labelOf).join(', ')),
                    ),
                  ),
                  onTap: list.isEmpty ? null : () => _editPermitted(context, list),
                );
              }),
            ],
          );
        }),
        ListenableBuilder(
          listenable: Listenable.merge([_store.mcpServers.listenable(), McpTools.changes]),
          builder: (context, _) {
            final urls = _store.mcpServers.get();
            return SettingsGroup(
              title: l10n.mcpServers,
              rows: [
                for (final url in urls) _server(context, url),
                SettingsRow(icon: Icons.add, title: l10n.addServer, onTap: () => _addServer(context)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _server(BuildContext context, String url) {
    final name = McpTools.nameFor(url);
    final on = McpTools.isServerConnected(name);
    final err = McpTools.errorOf(name);
    void menu([Offset? at]) => showContextMenu(
      context,
      [
        ContextMenuAction(text: libL10n.delete, icon: Icons.delete_outline, destructive: true, onTap: () => _removeServer(context, url)),
      ],
      title: url,
      at: at,
      sheet: at == null && isMobile,
    );
    return SettingsRow(
      leading: RowDot(on ? StateColors.running : StateColors.failed),
      title: url.replaceFirst(RegExp(r'^https?://'), ''),
      mono: true,
      subtitle: on
          ? l10n.connectedFmt(McpTools.toolCounts[name] ?? 0)
          : [l10n.disconnected, ?err].join(' · '),
      trailing: on
          ? null
          : Btn.text(
              text: libL10n.retry,
              onTap: () async {
                await McpTools.retryConnection(name);
                Chats.reconfigureSoon();
              },
            ),
      onLongPress: menu,
    ).onSecondary(menu);
  }

  Future<void> _addServer(BuildContext context) async {
    final ctrl = TextEditingController();
    final url = await context.showRoundDialog<String>(
      title: l10n.addServer,
      child: Input(controller: ctrl, autoFocus: true, hint: 'https://mcp.example.net/sse', onSubmitted: context.pop),
      actions: [Btn.ok(onTap: () => context.pop(ctrl.text))],
    );
    ctrl.dispose();
    final u = url?.trim();
    if (u == null || u.isEmpty || !context.mounted) return;
    if (_store.mcpServers.get().contains(u)) return;
    // Stored first: a server that is down now is still one the user added,
    // and it shows as disconnected with a retry.
    _store.mcpServers.set([..._store.mcpServers.get(), u]);
    await context.showLoadingDialog(fn: () => McpTools.addTs(McpTools.newHttpTs(url: u), McpTools.nameFor(u)));
    Chats.reconfigureSoon();
  }

  Future<void> _removeServer(BuildContext context, String url) async {
    final ok = await context.showRoundDialog<bool>(
      title: libL10n.delete,
      child: Text(libL10n.askContinue('${libL10n.delete} $url')),
      actions: Btnx.cancelRedOk,
    );
    if (ok != true) return;
    _store.mcpServers.set([..._store.mcpServers.get().where((e) => e != url)]);
    try {
      await McpTools.removeServer(McpTools.nameFor(url));
    } catch (e, s) {
      Loggers.app.warning('Remove MCP server', e, s);
    }
    Chats.reconfigureSoon();
  }

  Future<void> _editMemories(BuildContext context, List<String> list) async {
    final res = await KvEditor.route.go(context, KvEditorArgs(data: {for (final (i, m) in list.indexed) '$i': m}));
    if (res == null) return;
    _store.memories.set(res.values.toList());
    Chats.reconfigureSoon();
  }

  Future<void> _editPermitted(BuildContext context, List<String> list) async {
    await context.showRoundDialog(
      title: l10n.allowedWithoutAsking,
      child: _store.permittedTools.listenable().listenVal((now) {
        if (now.isEmpty) return Text(libL10n.empty, style: UIs.textGrey);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final name in now)
              ListTile(
                title: Text(Tools.labelOf(name)),
                trailing: Btn.icon(
                  icon: const Icon(Icons.close, size: 19),
                  text: libL10n.delete,
                  onTap: () => _store.permittedTools.set([...now.where((e) => e != name)]),
                ),
              ),
          ],
        );
      }),
      actions: Btnx.oks,
    );
  }
}
