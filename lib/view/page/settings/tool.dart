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
            final data = _toolStore.memories.fetch();
            final dataMap = <String, String>{};
            for (var idx = 0; idx < data.length; idx++) {
              dataMap['$idx'] = data[idx];
            }
            final res = await KvEditor.route.go(
              context,
              KvEditorArgs(data: dataMap),
            );
            if (res != null) {
              _toolStore.memories.put(res.values.toList());
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
        child: listenable.listenVal((val) => Text(
              val,
              style: UIs.textGrey,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )),
      ),
      onTap: () {
        final ctrl = TextEditingController(text: listenable.value);
        void onSave(String v) {
          prop.put(v);
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
                true => prop.put(vals..remove(name)),
                false => prop.put(vals..add(name)),
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
