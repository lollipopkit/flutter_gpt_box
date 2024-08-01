part of '../view.dart';

Widget _buildGPTNext(BuildContext context) {
  return ListTile(
    title: const Text('ChatGPT Next Web'),
    leading: const Icon(MingCute.chat_2_fill),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => _onTapRestoreGPTNext(context),
  ).cardx;
}

void _onTapRestoreGPTNext(BuildContext context) async {
  final picked = await Pfs.pickFileString();
  if (picked == null) return;

  final (chats, err) = await context.showLoadingDialog(fn: () async {
    return await compute(
      (params) async {
        final obj = json.decode(params) as Map<String, dynamic>;
        final {
          'chat-next-web-store': {
            'sessions': List sessions,
          }
        } = obj;
        final chats = <ChatHistory>[];

        /// Use for-loop for exception handling
        /// Instead of `sessions.map((e) => ChatHistory.fromGPTNext(e)).toList()`
        for (final item in sessions) {
          try {
            chats.add(GPTNextConvertor.toChatHistory(item));
          } catch (_) {}
        }
        return chats;
      },
      picked,
    );
  });

  if (err != null || chats == null) return;
  _askConfirm(context, chats);
}
