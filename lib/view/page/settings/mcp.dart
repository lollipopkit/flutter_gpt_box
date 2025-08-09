part of 'setting.dart';

class McpPage extends StatefulWidget {
  const McpPage({super.key});

  @override
  State<McpPage> createState() => _McpPageState();
}

final class _McpPageState extends State<McpPage>
    with AutomaticKeepAliveClientMixin {
  final _mcpStore = Stores.mcp;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AutoMultiList(children: [_buildTools, _buildMcps, _buildList]);
  }

  Widget get _buildTools {
    return Column(
      children: [
        CenterGreyTitle(l10n.tool),
        _buildUseTool(),
        _buildModelRegExp(),
      ],
    );
  }

  Widget get _buildList {
    return Column(
      children: [
        CenterGreyTitle(l10n.list),
        _buildSwitchTile(TfHistory.instance),
        _buildSwitchTile(TfHttpReq.instance),
        _buildMemory(),
      ],
    );
  }

  Widget get _buildMcps {
    return Column(
      children: [
        CenterGreyTitle('MCP'),
        _buildAddMcpServer(),
        _buildMcpServers(),
      ],
    );
  }

  Widget _buildMemory() {
    return ExpandTile(
      title: Text(l10n.memory),
      children: [
        _buildSwitchTile(TfMemory.instance, title: l10n.switcher),
        ListTile(
          title: Text(libL10n.edit),
          onTap: () async {
            final data = _mcpStore.memories.get();
            final dataMap = <String, String>{};
            for (var idx = 0; idx < data.length; idx++) {
              dataMap['$idx'] = data[idx];
            }
            final res = await KvEditor.route.go(
              context,
              KvEditorArgs(data: dataMap),
            );
            if (res != null) {
              _mcpStore.memories.set(res.values.toList());
              context.showSnackBar(libL10n.success);
            }
          },
          trailing: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    ).cardx;
  }

  Widget _buildUseTool() {
    return ListTile(
      leading: const Icon(MingCute.tool_line),
      title: Text(l10n.switcher),
      trailing: StoreSwitch(prop: _mcpStore.enabled),
    ).cardx;
  }

  Widget _buildModelRegExp() {
    final prop = _mcpStore.mcpRegExp;
    final listenable = prop.listenable();
    return ListTile(
      leading: const Icon(Bootstrap.regex),
      title: TipText(l10n.regExp, l10n.modelRegExpTip),
      trailing: SizedBox(
        width: 60,
        child: listenable.listenVal(
          (val) => Text(
            val,
            style: UIs.textGrey,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      onTap: () {
        final ctrl = TextEditingController(text: listenable.value);
        void onSave(String v) {
          prop.set(v);
          context.pop();
        }

        context.showRoundDialog(
          title: l10n.regExp,
          child: Input(
            controller: ctrl,
            maxLines: 3,
            autoFocus: true,
            onSubmitted: onSave,
          ),
          actions: Btn.ok(onTap: () => onSave(ctrl.text)).toList,
        );
      },
    ).cardx;
  }

  Widget _buildMcpServers() {
    return _mcpStore.mcpServers.listenable().listenVal((servers) {
      const maxRows = 7;
      const rowHeight = 56.0;
      final itemCount = servers.length;
      final visibleRows = itemCount < maxRows ? itemCount : maxRows;
      final height = visibleRows * rowHeight;
      return SizedBox(
        height: height,
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (ctx, idx) => _buildMcpServerItem(idx, servers),
        ),
      );
    }).cardx;
  }

  Widget _buildAddMcpServer() {
    return ListTile(
      leading: const Icon(Icons.add),
      title: Text(libL10n.add),
      onTap: () => _onTapAddMcpServer(
        _mcpStore.mcpServers,
        _mcpStore.mcpServers.get(),
      ),
    ).cardx;
  }

  Widget _buildMcpServerItem(int idx, List<String> servers) {
    final url = servers[idx];
    final serverName = 'server_$idx';
    final isConnected = McpTools.isServerConnected(serverName);
    final toolCount = McpTools.getToolsFromServer(serverName).length;
    
    return Dismissible(
      key: ValueKey(url),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        await _onDeleteMcpServer(serverName, url);
        final newList = List<String>.from(servers)..removeAt(idx);
        _mcpStore.mcpServers.set(newList);
      },
      child: ListTile(
        leading: Icon(
          isConnected ? Icons.cloud_done : Icons.cloud_off,
          color: isConnected ? Colors.green : Colors.red,
        ),
        title: Text(url, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          isConnected ? 'Connected • $toolCount tools' : 'Disconnected',
          style: TextStyle(
            color: isConnected ? Colors.green : Colors.red,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isConnected)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _onRetryMcpServer(serverName),
                tooltip: 'Retry connection',
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await _onDeleteMcpServer(serverName, url);
                final newList = List<String>.from(servers)..removeAt(idx);
                _mcpStore.mcpServers.set(newList);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(ToolFunc e, {String? title}) {
    final prop = _mcpStore.disabledTools;
    return ValBuilder(
      listenable: prop.listenable(),
      builder: (vals) {
        final name = e.name;
        final tip = e.l10nTip;
        final titleW = tip != null
            ? TipText(title ?? e.l10nName, tip)
            : Text(title ?? e.l10nName);
        return ListTile(
          title: titleW,
          trailing: Switch(
            value: !vals.contains(name),
            onChanged: (val) {
              final _ = switch (val) {
                true => prop.set(vals..remove(name)),
                false => prop.set(vals..add(name)),
              };
            },
          ),
        );
      },
    ).cardx;
  }

  @override
  bool get wantKeepAlive => true;
}

extension on _McpPageState {
  void _onTapAddMcpServer(HivePropDefault prop, List<String> servers) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(libL10n.add),
        content: Input(
          controller: ctrl,
          autoFocus: true,
          hint: 'https://your-mcp-server',
          onSubmitted: context.pop,
        ),
        actions: [
          TextButton(onPressed: context.pop, child: Text(libL10n.cancel)),
          TextButton(
            onPressed: () => context.pop(ctrl.text),
            child: Text(libL10n.ok),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (ok == null) return;
    final url = ok.trim();
    if (url.isEmpty) return;

    await context.showLoadingDialog(
      fn: () async {
        final serverName = 'server_${servers.length}';
        final ts = McpTools.newHttpTs(url: url);
        final result = await McpTools.addTs(ts, serverName);
        if (result != null) {
          final newList = List<String>.from(servers)..add(url);
          prop.set(newList);
        } else {
          throw Exception('Failed to connect to MCP server');
        }
      },
    );
  }

  Future<void> _onDeleteMcpServer(String serverName, String url) async {
    final confirm = await context.showRoundDialog(
      title: libL10n.delete,
      child: Text(libL10n.askContinue(libL10n.delete + url)),
    );
    if (confirm == true) {
      try {
        await McpTools.removeServer(serverName);
      } catch (e, s) {
        Loggers.app.warning('Disconnect MCP server failed', e, s);
      }
    }
  }
  
  Future<void> _onRetryMcpServer(String serverName) async {
    try {
      await McpTools.retryConnection(serverName);
      context.showSnackBar('Retrying connection...');
    } catch (e, s) {
      Loggers.app.warning('Retry MCP server failed', e, s);
      context.showSnackBar('Retry failed: $e');
    }
  }
}
