part of '../view.dart';

Widget _buildWebdav(BuildContext context) {
  return CardX(
    child: ExpandTile(
      leading: const Icon(Icons.storage),
      title: const Text('WebDAV'),
      children: [
        ListTile(
          title: Text(libL10n.setting),
          trailing: const Icon(Icons.settings),
          onTap: () async => _onTapWebdavSetting(context),
        ),
        ListTile(
          title: Text(l10n.auto),
          trailing: StoreSwitch(
            prop: PrefProps.webdavSync,
            validator: (p0) {
              if (Stores.setting.icloudSync.get() && p0) {
                context.showSnackBar(l10n.syncConflict('iCloud', 'WebDAV'));
                return false;
              }
              if (p0) {
                if (PrefProps.webdavUrl.get() == null ||
                    PrefProps.webdavUser.get() == null ||
                    PrefProps.webdavPwd.get() == null) {
                  context.showSnackBar(l10n.emptyFields(libL10n.setting));
                  return false;
                }
              }
              BakSync.instance.sync(rs: Webdav.shared);
              return true;
            },
          ),
        ),
        ListTile(
          title: Text(l10n.manual),
          trailing: ValBuilder(
            listenable: _webdavLoading,
            builder: (val) {
              if (val) return SizedLoading.small;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Btn.text(
                    onTap: () => _onTapWebdavDl(context),
                    text: libL10n.restore,
                  ),
                  UIs.width7,
                  Btn.text(
                    onTap: () => _onTapWebdavUp(context),
                    text: libL10n.backup,
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
    final files = await Webdav.shared.list();
    if (files.isEmpty) return context.showSnackBar(libL10n.empty);

    final fileName = await context.showPickSingleDialog(
      title: libL10n.select,
      items: files,
    );
    if (fileName == null) return;

    await Webdav.shared.download(relativePath: fileName);
    final dlFile = await File('${Paths.doc}/$fileName').readAsString();
    final dlBak = await compute(Backup.fromJsonString, dlFile);
    await dlBak.merge(force: true);
    context.showSnackBar(libL10n.success);

    context.pop(const SettingsPageRet(restored: true));
  } catch (e, s) {
    context.showErrDialog(e, s, 'Download webdav backup');
  } finally {
    _webdavLoading.value = false;
  }
}

Future<void> _onTapWebdavUp(BuildContext context) async {
  _webdavLoading.value = true;
  try {
    final content = await Backup.backup();
    await File(Paths.bak).writeAsString(content);
    await Webdav.shared.upload(relativePath: Paths.bakName);
    context.showSnackBar(libL10n.success);
  } catch (e, s) {
    context.showErrDialog(e, s, 'Upload webdav backup');
  } finally {
    _webdavLoading.value = false;
  }
}

Future<void> _onTapWebdavSetting(BuildContext context) async {
  final urlCtrl = TextEditingController(
    text: PrefProps.webdavUrl.get(),
  );
  final userCtrl = TextEditingController(
    text: PrefProps.webdavUser.get(),
  );
  final pwdCtrl = TextEditingController(
    text: PrefProps.webdavPwd.get(),
  );

  void onSubmit() async {
    final (_, err) = await context.showLoadingDialog(fn: () async {
      Webdav.shared.client = WebdavClient.basicAuth(
        url: urlCtrl.text,
        user: userCtrl.text,
        pwd: pwdCtrl.text,
      );
    });
    if (err != null) return;
    PrefProps.webdavUrl.set(urlCtrl.text);
    PrefProps.webdavUser.set(userCtrl.text);
    PrefProps.webdavPwd.set(pwdCtrl.text);

    context.pop();
    context.showSnackBar(libL10n.success);
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
    actions: Btn.ok(onTap: onSubmit).toList,
  );
}
