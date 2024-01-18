part of '../view.dart';

Widget _buildClipboard(BuildContext context) {
  return ExpandTile(
    leading: const Icon(Icons.content_copy),
    title: Text(l10n.clipboard),
    children: [
      ListTile(
        title: Text(l10n.backup),
        trailing: const Icon(Icons.backup),
        onTap: () => _onTapClipboardBackup(context),
      ),
      ListTile(
        title: Text(l10n.restore),
        trailing: const Icon(Icons.restore),
        onTap: () => _onTapClipboardRestore(context),
      ),
    ],
  ).card;
}

void _onTapClipboardRestore(BuildContext context) async {
  final result = await Clipboard.getData(Clipboard.kTextPlain);
  final text = result?.text;
  if (text == null || text.isEmpty) {
    context.showSnackBar(l10n.emptyFields(l10n.clipboard));
    return;
  }
  try {
    context.showLoadingDialog();
    final backup = await compute(Backup.fromJsonString, text.trim());
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
          child: Text(l10n.backup),
        ),
      ],
    );
  } catch (e, trace) {
    Loggers.app.warning('Import backup failed', e, trace);
    context.showSnackBar(e.toString());
  } finally {
    context.pop();
  }
}

void _onTapClipboardBackup(BuildContext context) async {
  try {
    context.showLoadingDialog();
    final backup = await Backup.backup();
    await Clipboard.setData(ClipboardData(text: backup));
    context.showSnackBar(l10n.success);
  } catch (e, trace) {
    Loggers.app.warning('Export backup failed', e, trace);
    context.showSnackBar(e.toString());
  } finally {
    context.pop();
  }
}
