import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:icons_plus/icons_plus.dart';

class ToolPage extends StatefulWidget {
  const ToolPage({super.key, Never? args});

  @override
  State<ToolPage> createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  final _store = Stores.tool;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(l10n.tool),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
            final data = _store.memories.fetch();
            final dataMap = <String, String>{};
            for (var idx = 0; idx < data.length; idx++) {
              dataMap['$idx'] = data[idx];
            }
            final res = await KvEditor.route.go(
              context,
              KvEditorArgs(data: dataMap),
            );
            if (res != null) {
              _store.memories.put(res.values.toList());
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
      trailing: StoreSwitch(prop: _store.enabled),
    ).cardx;
  }

  Widget _buildModelRegExp() {
    final prop = _store.toolsRegExp;
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
    final prop = _store.disabledTools;
    return ValBuilder(
      listenable: prop.listenable(),
      builder: (vals) {
        final name = e.name;
        final tip = e.l10nTip;
        final titleW = tip != null
            // The width of the [Switch] is 50
            ? TipText(title ?? e.l10nName, tip, reversedWidth: 50)
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
}
