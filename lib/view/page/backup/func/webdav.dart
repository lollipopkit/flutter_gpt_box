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
              return true;
            },
            callback: (val) async {
              if (val) {
                _webdavLoading.value = true;
                await Webdav.sync();
                _webdavLoading.value = false;
              }
            },
          ),
        ),
        ListTile(
          title: Text(l10n.manual),
          trailing: ListenableBuilder(
            listenable: _webdavLoading,
            builder: (_, __) {
              if (_webdavLoading.value) {
                return UIs.centerSizedLoadingSmall;
              }
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
    final result = await Webdav.download(relativePath: Paths.bakName);
    if (result != null) {
      Loggers.app.warning('Download webdav backup failed: $result');
      context.showSnackBar(l10n.backupRestorationFailed(result.toString()));
      return;
    }
    final dlFile = await File(await Paths.bak).readAsString();
    final dlBak = await compute(Backup.fromJsonString, dlFile);
    await dlBak?.merge(force: true);
    context.showSnackBar(l10n.backupRestorationSuccessful);
  } catch (e, s) {
    Loggers.app.warning('Download webdav backup failed', e, s);
    context.showSnackBar(e.toString());
  } finally {
    _webdavLoading.value = false;
  }
}

Future<void> _onTapWebdavUp(BuildContext context) async {
  _webdavLoading.value = true;
  final content = await Backup.backup();
  await File(await Paths.bak).writeAsString(content);
  final uploadResult = await Webdav.upload(relativePath: Paths.bakName);
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
  final result = await context.showRoundDialog<bool>(
    title: 'WebDAV',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Input(
          label: 'URL',
          hint: 'https://example.com/webdav/',
          controller: urlCtrl,
        ),
        Input(
          label: l10n.user,
          controller: userCtrl,
        ),
        Input(
          label: l10n.passwd,
          controller: pwdCtrl,
        ),
      ],
    ),
    actions: Btns.oks(onTap: () => context.pop(true)),
  );
  if (result == true) {
    final result = await Webdav.test(urlCtrl.text, userCtrl.text, pwdCtrl.text);
    if (result == null) {
      context.showSnackBar(l10n.success);
    } else {
      context.showSnackBar(result);
      return;
    }
    Webdav.changeClient(urlCtrl.text, userCtrl.text, pwdCtrl.text);
  }
}
