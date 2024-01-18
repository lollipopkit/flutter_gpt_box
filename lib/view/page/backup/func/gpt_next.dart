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
    final chats = await Computer.shared.compute(
      (picked) async {
        final text = await File(picked).readAsString();
        final obj = json.decode(text) as Map<String, dynamic>;
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
        return chats;
      },
      param: picked,
    );
    context.showRoundDialog(
      title: l10n.attention,
      child: Text(l10n.sureRestoreFmt('${chats.length} ${l10n.chat}')),
      actions: [
        TextButton(
          onPressed: () async {
            for (final chat in chats) {
              Stores.history.put(chat);
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
