part of '../view.dart';

Widget _buildFile(BuildContext context) {
  return CardX(
    child: ExpandTile(
      leading: const Icon(MingCute.file_fill),
      title: Text(l10n.file),
      children: [
        ListTile(
          title: Text(l10n.backup),
          trailing: const Icon(Icons.save),
          onTap: () async {
            await Backup.backupToFile();
            await Pfs.sharePath(Paths.bak);
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
  final text = await Pfs.pickFileString();
  if (text == null) return;

  try {
    final backup = await context.showLoadingDialog(
      fn: () async => await compute(Backup.fromJsonString, text.trim()),
    );
    if (backup == null) {
      return;
    }

    if (Backup.validVer != backup.version) {
      context.showSnackBar('Backup version not match');
      return;
    }

    final time = DateTime.fromMillisecondsSinceEpoch(backup.lastModTime);
    final suc = await context.showRoundDialog(
      title: l10n.attention,
      child: Text(l10n.sureRestoreFmt(time)),
      actions: [
        TextButton(
          onPressed: () async {
            context.pop(true);
            await backup.merge(force: true);
          },
          child: Text(l10n.restore),
        ),
      ],
    );
    if (suc == true) {
      const BackupPageRet ret = (isRestoreSuc: true);
      context.pop(ret);
    }
  } catch (e, trace) {
    Loggers.app.warning('Import backup failed', e, trace);
    context.showSnackBar(e.toString());
  }
}
