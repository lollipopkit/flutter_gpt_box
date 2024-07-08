import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/core/util/tool_func/tool.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/store/all.dart';

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
        _buildUseTool().cardx,
        _buildTitle('~'),
        _buildSwicthes(),
        const SizedBox(height: 37),
      ],
    );
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
      leading: const Icon(Icons.functions),
      title: Text(l10n.tool),
      subtitle: Text(l10n.toolAvailability, style: UIs.textGrey),
      trailing: StoreSwitch(prop: _store.enabled),
    );
  }

  Widget _buildSwicthes() {
    final prop = _store.enabledTools;
    return ValBuilder(
      listenable: prop.listenable(),
      builder: (vals) {
        return Column(
          children: OpenAIFuncCalls.internalTools.map((e) {
            return ListTile(
              title: Text(e.name),
              subtitle: Text(e.l10nName),
              trailing: Switch(
                value: vals.contains(e.name),
                onChanged: (val) {
                  final _ = switch (val) {
                    true => prop.put(vals..add(e.name)),
                    false => prop.put(vals..remove(e.name)),
                  };
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
