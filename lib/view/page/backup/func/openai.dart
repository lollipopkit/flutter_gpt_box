part of '../view.dart';

Widget _buildOpenAI(BuildContext context) {
  return ListTile(
    title: const Text('OpenAI'),
    leading: const Icon(MingCute.openai_fill),
    subtitle: MarkdownBody(
      data: l10n.restoreOpenaiTip(Urls.openaiRestoreDoc),
      onTapLink: (text, href, title) {
        if (href != null) launchUrlString(href);
      },
    ),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => _onTapRestoreOpenAI(context),
  ).card;
}

void _onTapRestoreOpenAI(BuildContext context) async {
  final picked = await FileUtil.pickString();
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

  context.showRoundDialog(
    title: l10n.attention,
    child: SizedBox(
      width: 300,
      child: Text(
        l10n.sureRestoreFmt('${chats.length} ${l10n.chat}'),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () async {
          for (final chat in chats) {
            Stores.history.put(chat);
          }
          context.pop();
          HomePage.afterRestore();
        },
        child: Text(l10n.restore),
      ),
    ],
  );
}
