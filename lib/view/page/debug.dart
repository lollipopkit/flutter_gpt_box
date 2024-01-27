import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/data/provider/debug.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';

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
                actions: [
                  TextButton(
                    onPressed: () => context.pop(true),
                    child: Text(l10n.ok),
                  ),
                ],
              );
              if (sure == true) {
                DebugNotifier.logs.clear();
                DebugNotifier.state.clear();
                DebugNotifier.node.rebuild();
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
      body: ListenableBuilder(
          listenable: DebugNotifier.node,
          builder: (_, __) => _buildTerminal(DebugNotifier.state)),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildTerminal(List<Widget> widgets) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.black,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'monospace',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
