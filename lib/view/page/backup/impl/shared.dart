part of '../view.dart';

void _askConfirm(BuildContext context, List<ChatHistory> chats) {
  var skipSameTitle = true;
  context.showRoundDialog(
    title: l10n.attention,
    child: SizedBox(
      width: 300,
      child: Column(
        children: [
          Text(
            l10n.sureRestoreFmt('${chats.length} ${l10n.chat}'),
          ),
          StatefulBuilder(
            builder: (_, setState) {
              return CheckboxListTile(
                value: skipSameTitle,
                onChanged: (value) => setState(() => skipSameTitle = value!),
                title: Text(l10n.skipSameTitle),
              );
            },
          )
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () async {
          final keys = Stores.history.box.keys;
          for (final chat in chats) {
            if (skipSameTitle && keys.contains(chat.id)) continue;
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
