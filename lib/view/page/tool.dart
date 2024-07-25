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
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      children: [
        _buildUseTool(),
        _buildModelRegExp(),
        _buildTitle(l10n.list),
        _buildSwitchTile(TfHttpReq.instance).cardx,
        _buildMemory(),
        const SizedBox(height: 37),
      ],
    );
  }

  Widget _buildMemory() {
    return ExpandTile(
      title: Text(l10n.memory),
      children: [
        _buildSwitchTile(TfMemory.instance, title: l10n.switcher),
        ListTile(
          title: Text(l10n.edit),
          onTap: () async {
            final data = _store.memories.fetch();
            final dataMap = <String, String>{};
            for (var idx = 0; idx < data.length; idx++) {
              dataMap['$idx'] = data[idx];
            }
            final res = await KvEditor.route.go(
              context,
              args: KvEditorArgs(data: dataMap),
            );
            if (res != null) {
              _store.memories.put(res.values.toList());
              context.showSnackBar(l10n.success);
            }
          },
          trailing: const Icon(Icons.keyboard_arrow_right),
        ),
      ],
    ).cardx;
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 23, bottom: 17),
      child: Center(
        child: Text(
          text,
          style: UIs.textGrey,
        ),
      ),
    );
  }

  Widget _buildUseTool() {
    return ListTile(
      leading: const Icon(MingCute.tool_line),
      title: Text(l10n.switcher),
      trailing: StoreSwitch(prop: _store.enabled),
    ).cardx;
  }

  Widget _buildModelRegExp() {
    final prop = Stores.setting.modelsUseTool;
    final listenable = prop.listenable();
    return ListTile(
      leading: const Icon(Bootstrap.regex),
      title: Text(l10n.regExp),
      subtitle: Text(l10n.modelRegExpTip, style: UIs.textGrey),
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
          actions: Btns.oks(onTap: () => onSave(ctrl.text)),
        );
      },
    ).cardx;
  }

  Widget _buildSwitchTile(ToolFunc e, {String? title}) {
    final prop = _store.enabledTools;
    return ValBuilder(
      listenable: prop.listenable(),
      builder: (vals) {
        final name = e.name;
        return ListTile(
          title: Text(title ?? e.l10nName),
          trailing: Switch(
            value: vals.contains(name),
            onChanged: (val) {
              final _ = switch (val) {
                true => prop.put(vals..add(name)),
                false => prop.put(vals..remove(name)),
              };
            },
          ),
        );
      },
    );
  }
}
