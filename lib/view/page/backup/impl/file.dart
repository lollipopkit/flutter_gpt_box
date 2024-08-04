part of '../view.dart';

Widget _buildFile(BuildContext context) {
  return CardX(
    child: ExpandTile(
      leading: const Icon(MingCute.file_fill),
      title: Text(libL10n.file),
      children: [
        ListTile(
          title: Text(libL10n.backup),
          trailing: const Icon(Icons.save),
          onTap: () async {
            await Backup.backupToFile();
            await Pfs.share(path: Paths.bak);
          },
        ),
        ListTile(
          trailing: const Icon(Icons.restore),
          title: Text(libL10n.restore),
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
    final (backup, err) = await context.showLoadingDialog(
      fn: () async => await compute(Backup.fromJsonString, text.trim()),
    );
    if (err != null || backup == null) return;

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
          child: Text(libL10n.restore),
        ),
      ],
    );
    if (suc == true) {
      context.pop(const BackupPageRet(isRestoreSuc: true));
    }
  } catch (e, trace) {
    Loggers.app.warning('Import backup failed', e, trace);
    context.showSnackBar(e.toString());
  }
}
