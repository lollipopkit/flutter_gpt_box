part of '../view.dart';

Widget _buildWebdav(BuildContext context) {
  return CardX(
    child: ExpandTile(
      leading: const Icon(Icons.storage),
      title: const Text('WebDAV'),
      children: [
        ListTile(
          title: Text(l10n.settings),
          trailing: const Icon(Icons.settings),
          onTap: () async => _onTapWebdavSetting(context),
        ),
        ListTile(
          title: Text(l10n.auto),
          trailing: StoreSwitch(
            prop: Stores.setting.webdavSync,
            validator: (p0) {
              if (Stores.setting.icloudSync.fetch() && p0) {
                context.showSnackBar(l10n.syncConflict('iCloud', 'WebDAV'));
                return false;
              }
              if (p0) {
                if (Stores.setting.webdavUrl.fetch().isEmpty ||
                    Stores.setting.webdavUser.fetch().isEmpty ||
                    Stores.setting.webdavPwd.fetch().isEmpty) {
                  context.showSnackBar(l10n.emptyFields(l10n.settings));
                  return false;
                }
              }
              Webdav.sync();
              return true;
            },
          ),
        ),
        ListTile(
          title: Text(l10n.manual),
          trailing: ValBuilder(
            listenable: _webdavLoading,
            builder: (val) {
              if (val) return UIs.centerSizedLoadingSmall;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async => _onTapWebdavDl(context),
                    child: Text(l10n.restore),
                  ),
                  UIs.width7,
                  TextButton(
                    onPressed: () async => _onTapWebdavUp(context),
                    child: Text(l10n.backup),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}

Future<void> _onTapWebdavDl(BuildContext context) async {
  _webdavLoading.value = true;
  try {
    final files = await Webdav.list();
    if (files.isEmpty) return context.showSnackBar(l10n.empty);

    final fileName = await context.showPickSingleDialog(
      title: l10n.choose,
      items: files,
    );
    if (fileName == null) return;

    final result = await Webdav.download(relativePath: fileName);
    if (result != null) {
      return Loggers.app.warning('Download webdav backup failed: $result');
    }
    final dlFile = await File('${Paths.doc}/$fileName').readAsString();
    final dlBak = await compute(Backup.fromJsonString, dlFile);
    await dlBak?.merge(force: true);
  } catch (e) {
    context.showSnackBar(e.toString());
    rethrow;
  } finally {
    _webdavLoading.value = false;
  }
}

Future<void> _onTapWebdavUp(BuildContext context) async {
  _webdavLoading.value = true;
  final content = await Backup.backup();
  await File(Paths.bak).writeAsString(content);
  final uploadResult = await Webdav.upload(relativePath: Miscs.bakFileName);
  if (uploadResult != null) {
    Loggers.app.warning('Upload webdav backup failed: $uploadResult');
    context.showSnackBar(l10n.backupFailed(uploadResult.toString()));
  } else {
    Loggers.app.info('Upload webdav backup success');
    context.showSnackBar(l10n.backupSuccessful);
  }
  _webdavLoading.value = false;
}

Future<void> _onTapWebdavSetting(BuildContext context) async {
  final urlCtrl = TextEditingController(
    text: Stores.setting.webdavUrl.fetch(),
  );
  final userCtrl = TextEditingController(
    text: Stores.setting.webdavUser.fetch(),
  );
  final pwdCtrl = TextEditingController(
    text: Stores.setting.webdavPwd.fetch(),
  );

  void onSubmit() async {
    final err = await context.showLoadingDialog(fn: () async {
      return await Webdav.test(urlCtrl.text, userCtrl.text, pwdCtrl.text);
    });
    if (err == null) {
      context.pop();
      context.showSnackBar(l10n.success);
      Webdav.changeClient(urlCtrl.text, userCtrl.text, pwdCtrl.text);
      return;
    }
    context.showRoundDialog(
      title: l10n.error,
      child: Text(err),
      actions: Btns.oks(onTap: context.pop),
    );
  }

  final userNode = FocusNode();
  final pwdNode = FocusNode();

  await context.showRoundDialog<bool>(
    title: 'WebDAV',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Input(
          label: 'URL',
          hint: 'https://example.com/webdav/',
          controller: urlCtrl,
          autoFocus: true,
          onSubmitted: (p0) => userNode.requestFocus(),
        ),
        Input(
          label: l10n.user,
          controller: userCtrl,
          node: userNode,
          onSubmitted: (p0) => pwdNode.requestFocus(),
        ),
        Input(
          label: l10n.passwd,
          controller: pwdCtrl,
          node: pwdNode,
          onSubmitted: (p0) => onSubmit(),
        ),
      ],
    ),
    actions: Btns.oks(onTap: onSubmit),
  );
}
