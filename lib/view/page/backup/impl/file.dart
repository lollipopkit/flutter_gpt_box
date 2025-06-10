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
            final path = await BackupV2.backup();
            await Pfs.sharePaths(paths: [path]);
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
      fn: () async => await compute(MergeableUtils.fromJsonString, text.trim()),
    );
    if (err != null || backup == null) return;

    final suc = await context.showRoundDialog(
      title: l10n.attention,
      child: Text(l10n.sureRestoreFmt(backup.$2)),
      actions: [
        TextButton(
          onPressed: () async {
            context.pop(true);
            await backup.$1.merge(force: true);
          },
          child: Text(libL10n.restore),
        ),
      ],
    );
    if (suc == true) {
      context.pop(const SettingsPageRet(restored: true));
    }
  } catch (e, trace) {
    Loggers.app.warning('Import backup failed', e, trace);
    context.showSnackBar(e.toString());
  }
}
