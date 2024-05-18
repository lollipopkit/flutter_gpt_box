part of '../view.dart';

Widget _buildOpenAI(BuildContext context) {
  return ListTile(
    title: const Text('OpenAI'),
    leading: const Icon(MingCute.openai_fill),
    subtitle: SimpleMarkdown(
      data: l10n.restoreOpenaiTip(Urls.openaiRestoreDoc),
      styleSheet: MarkdownStyleSheet(
        p: UIs.textGrey,
      ),
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => _onTapRestoreOpenAI(context),
  ).cardx;
}

void _onTapRestoreOpenAI(BuildContext context) async {
  final picked = await Pfs.pickFileString();
  if (picked == null) return;

  final chats = await context.showLoadingDialog(fn: () async {
    return await compute(
      (params) async {
        final obj = json.decode(params) as List;
        final chats = <ChatHistory>[];

        /// Use for-loop for exception handling
        /// Instead of `sessions.map((e) => ChatHistory.fromOpenAI(e)).toList()`
        for (final item in obj) {
          try {
            chats.add(OpenAIConvertor.toChatHistory(item));
          } catch (_) {}
        }
        return chats;
      },
      picked,
    );
  });

  _askConfirm(context, chats);
}
