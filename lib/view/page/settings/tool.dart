part of 'setting.dart';

class ToolPage extends StatefulWidget {
  const ToolPage({super.key});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

final class _ToolPageState extends State<ToolPage>
    with AutomaticKeepAliveClientMixin {
  final _toolStore = Stores.tool;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiList(
      children: [
        [
          CenterGreyTitle(l10n.tool),
          _buildUseTool(),
          _buildModelRegExp(),
          _buildMcpServers(),
        ],
        [
          CenterGreyTitle(l10n.list),
          _buildSwitchTile(TfHistory.instance).cardx,
          _buildSwitchTile(TfHttpReq.instance).cardx,
          _buildMemory(),
        ],
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
            final data = _toolStore.memories.get();
            final dataMap = <String, String>{};
            for (var idx = 0; idx < data.length; idx++) {
              dataMap['$idx'] = data[idx];
            }
            final res = await KvEditor.route.go(
              context,
              KvEditorArgs(data: dataMap),
            );
            if (res != null) {
              _toolStore.memories.set(res.values.toList());
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
      trailing: StoreSwitch(prop: _toolStore.enabled),
    ).cardx;
  }

  Widget _buildModelRegExp() {
    final prop = _toolStore.toolsRegExp;
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
    final prop = _toolStore.mcpServers;
    return prop.listenable().listenVal((servers) {
      return ExpandTile(
        leading: const Icon(MingCute.cloud_line),
        title: Text('MCP'),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: servers.length + 1,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, idx) {
                      if (idx >= servers.length) {
                        return ListTile(
                    title: Text(libL10n.add),
                    trailing: const Icon(Icons.add),
                    onTap: () => _onTapAddMcpServer(prop, servers),
                  );
                      }
                      final url = servers[idx];
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
                          final newList = List<String>.from(servers)
                            ..removeAt(idx);
                          prop.set(newList);
                          await _refreshMcpTools(newList);
                        },
                        child: ListTile(
                          title: Text(
                            url,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final newList = List<String>.from(servers)
                                ..removeAt(idx);
                              prop.set(newList);
                              await _refreshMcpTools(newList);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    }).cardx;
  }

  Future<void> _refreshMcpTools(List<String> servers) async {
    McpTools.tools.clear();
    for (final url in servers) {
      final transport = await McpTools.initTransport(url);
      if (transport != null) {
        await McpTools.addTools();
      }
    }
    setState(() {});
  }

  Widget _buildSwitchTile(ToolFunc e, {String? title}) {
    final prop = _toolStore.disabledTools;
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}

extension on _ToolPageState {
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
    if (ok != null && ok.trim().isNotEmpty) {
      final newList = List<String>.from(servers)..add(ok.trim());
      prop.set(newList);
      await _refreshMcpTools(newList);
    }
  }
}
