import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_box/core/ext/context/base.dart';
import 'package:gpt_box/core/ext/context/dialog.dart';
import 'package:gpt_box/core/ext/context/snackbar.dart';
import 'package:gpt_box/core/util/ui.dart';
import 'package:gpt_box/data/provider/debug.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/view/widget/appbar.dart';

class DebugPage extends StatelessWidget {
  final Never? args;

  const DebugPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('Logs', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () async {
              final sure = await context.showRoundDialog(
                title: l10n.delFmt('#${DebugNotifier.logs.length}', 'logs'),
                actions: Btns.oks(onTap: () => context.pop(true), red: true),
              );
              if (sure == true) {
                DebugNotifier.logs.clear();
                DebugNotifier.state.clear();
                DebugNotifier.node.build();
              }
            },
            icon: const Icon(Icons.delete, color: Colors.white, size: 21),
          ),
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: DebugNotifier.logsStr));
              context.showSnackBar(l10n.copied);
            },
            icon: const Icon(Icons.copy, color: Colors.white, size: 19),
          ),
        ],
      ),
      body: _buildTerminal(),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildTerminal() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.black,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: DebugNotifier.node,
            builder: (_, __) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: DebugNotifier.state,
            ),
          ),
        ),
      ),
    );
  }
}
