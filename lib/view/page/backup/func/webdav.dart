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
    final result = await Webdav.download(
      relativePath: Paths.bakName,
    );
    if (result != null) {
      Loggers.app.warning('Download webdav backup failed: $result');
      return;
    }
  } catch (e, s) {
    Loggers.app.warning('Download webdav backup failed', e, s);
    context.showSnackBar(e.toString());
    _webdavLoading.value = false;
    return;
  }
  final dlFile = await File(await Paths.bak).readAsString();
  final dlBak = await Computer.shared.start(
    Backup.fromJsonString,
    param: dlFile,
  );
  await dlBak.restore(force: true);
  _webdavLoading.value = false;
}

Future<void> _onTapWebdavUp(BuildContext context) async {
  _webdavLoading.value = true;
  await Backup.backup();
  final uploadResult = await Webdav.upload(relativePath: Paths.bakName);
  if (uploadResult != null) {
    Loggers.app.warning('Upload webdav backup failed: $uploadResult');
  } else {
    Loggers.app.info('Upload webdav backup success');
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
    actions: [
      TextButton(
        onPressed: () {
          context.pop(true);
        },
        child: Text(l10n.ok),
      ),
    ],
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
