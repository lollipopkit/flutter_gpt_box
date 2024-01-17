part of '../view.dart';

Widget _buildGPTNext(BuildContext context) {
  return ListTile(
    title: const Text('ChatGPT Next Web'),
    trailing: Text(l10n.restore),
    onTap: () => _onTapRestoreGPTNext(context),
  ).card;
}

void _onTapRestoreGPTNext(BuildContext context) async {
  final data = await FileUtil.pick();
  if (data == null) return;

  final text = utf8.decode(data);
  final obj = json.decode(text) as Map<String, dynamic>;
  try {
    final {
      'chat-next-web-store': {
        'sessions': List<Map<String, dynamic>> sessions,
      }
    } = obj;
    final chats = sessions.map((e) => ChatHistory.fromGPTNext(e)).toList();
    await context.showRoundDialog(
      title: l10n.attention,
      child: Text(l10n.sureRestoreFmt('${chats.length} ${l10n.chat}')),
      actions: [
        TextButton(
          onPressed: () async {
            for (final chat in chats) {
              Stores.history.put(chat);
            }
            context.pop();
          },
          child: Text(l10n.restore),
        ),
      ],
    );
  } catch (e, trace) {
    Loggers.app.warning('Import ChatGPT Next Web backup failed', e, trace);
    context.showSnackBar(e.toString());
  } finally {
    context.pop();
  }
}
