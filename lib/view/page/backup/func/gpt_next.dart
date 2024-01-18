part of '../view.dart';

Widget _buildGPTNext(BuildContext context) {
  return ListTile(
    title: const Text('ChatGPT Next Web'),
    trailing: Text(l10n.restore),
    onTap: () => _onTapRestoreGPTNext(context),
  ).card;
}

void _onTapRestoreGPTNext(BuildContext context) async {
  final picked = await FileUtil.pickString();
  if (picked == null) return;

  try {
    final (chats, cfg) = await Computer.shared.start(
      (params) async {
        final obj = json.decode(params.$1) as Map<String, dynamic>;
        final {
          'chat-next-web-store': {
            'sessions': List sessions,
          }
        } = obj;
        final chats = <ChatHistory>[];

        /// Use for-loop for exception handling
        /// Instead of `sessions.map((e) => ChatHistory.fromGPTNext(e)).toList()`
        for (final item in sessions) {
          chats.add(GPTNextConvertor.toChatHistory(item));
        }
        return (chats, GPTNextConvertor.parseConfig(obj, params.$2));
      },
      param: (picked, ChatConfig.fromStore()),
    );

    var onlyRestoreHistory = false;
    context.showRoundDialog(
      title: l10n.attention,
      child: SizedBox(
        width: 300,
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.sureRestoreFmt('${chats.length} ${l10n.chat}')),
              CheckboxListTile(
                value: onlyRestoreHistory,
                onChanged: (val) {
                  setState(() {
                    onlyRestoreHistory = val ?? false;
                  });
                },
                title: Text(l10n.onlyRestoreHistory, style: UIs.text12),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            for (final chat in chats) {
              Stores.history.put(chat);
            }
            if (!onlyRestoreHistory) {
              Stores.setting.openaiApiUrl.put(cfg.url);
              Stores.setting.openaiApiKey.put(cfg.key);
            }
            context.pop();
            RebuildNode.app.rebuild();
          },
          child: Text(l10n.restore),
        ),
      ],
    );
  } catch (e, trace) {
    Loggers.app.warning('Import ChatGPT Next Web backup failed', e, trace);
    context.showSnackBar(e.toString());
  }
}
