part of '../view.dart';

Widget _buildFile(BuildContext context) {
  return CardX(
    child: ExpandTile(
      leading: const Icon(Icons.file_open),
      title: Text(l10n.file),
      children: [
        ListTile(
          title: Text(l10n.backup),
          trailing: const Icon(Icons.save),
          onTap: () async {
            final content = await Backup.backup();
            await FileUtil.save('gptbox_bak.json', content, suffix: 'json');
          },
        ),
        ListTile(
          trailing: const Icon(Icons.restore),
          title: Text(l10n.restore),
          onTap: () async => _onTapFileRestore(context),
        ),
      ],
    ),
  );
}

void _onTapFileRestore(BuildContext context) async {
  final text = await FileUtil.pickString();
  if (text == null) return;

  try {
    context.showLoadingDialog();
    final backup = await compute(Backup.fromJsonString, text.trim());
    context.pop();
    if (backupFormatVersion != backup.version) {
      context.showSnackBar('Backup version not match');
      return;
    }

    final time = DateTime.fromMillisecondsSinceEpoch(backup.date);
    await context.showRoundDialog(
      title: l10n.attention,
      child: Text(l10n.sureRestoreFmt(time)),
      actions: [
        TextButton(
          onPressed: () async {
            await backup.restore(force: true);
            context.pop();
          },
          child: Text(l10n.restore),
        ),
      ],
    );
  } catch (e, trace) {
    Loggers.app.warning('Import backup failed', e, trace);
    context.showSnackBar(e.toString());
  }
}
