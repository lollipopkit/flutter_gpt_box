import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/context/base.dart';
import 'package:flutter_chatgpt/core/ext/context/dialog.dart';
import 'package:flutter_chatgpt/core/ext/context/snackbar.dart';
import 'package:flutter_chatgpt/core/logger.dart';
import 'package:flutter_chatgpt/core/util/platform/file.dart';
import 'package:flutter_chatgpt/data/model/app/backup.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';
import 'package:flutter_chatgpt/view/widget/appbar.dart';
import 'package:flutter_chatgpt/view/widget/card.dart';
import 'package:flutter_chatgpt/view/widget/expand_tile.dart';

final class BackupPage extends StatelessWidget {
  const BackupPage({super.key, Never? args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Backup'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(17),
      children: [
        _buildTip(),
        // if (isMacOS || isIOS) _buildIcloud(context),
        // _buildWebdav(context),
        _buildFile(context),
      ],
    );
  }

  Widget _buildTip() {
    return const CardX(
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Attention'),
        subtitle: Text(
          'The exported data is simply encrypted. \nPlease keep it safe.',
          style: UIs.textGrey,
        ),
      ),
    );
  }

  Widget _buildFile(BuildContext context) {
    return CardX(
      child: ExpandTile(
        leading: const Icon(Icons.file_open),
        title: const Text('File'),
        initiallyExpanded: true,
        children: [
          ListTile(
            title: const Text('Backup'),
            trailing: const Icon(Icons.save),
            onTap: () async {
              final content = await Backup.backup();
              await FileUtil.save('gptbox_bak.json', content);
            },
          ),
          ListTile(
            trailing: const Icon(Icons.restore),
            title: const Text('Restore'),
            onTap: () async => _onTapFileRestore(context),
          ),
        ],
      ),
    );
  }

  // Widget _buildIcloud(BuildContext context) {
  //   return CardX(
  //     child: ListTile(
  //       leading: const Icon(Icons.cloud),
  //       title: const Text('iCloud'),
  //       trailing: StoreSwitch(
  //         prop: Stores.setting.icloudSync,
  //         validator: (p0) {
  //           if (p0 && Stores.setting.webdavSync.fetch()) {
  //             context.showSnackBar(l10n.autoBackupConflict);
  //             return false;
  //           }
  //           return true;
  //         },
  //         callback: (val) async {
  //           if (val) {
  //             icloudLoading.value = true;
  //             await ICloud.sync();
  //             icloudLoading.value = false;
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildWebdav(BuildContext context) {
  //   return CardX(
  //     child: ExpandTile(
  //       leading: const Icon(Icons.storage),
  //       title: const Text('WebDAV'),
  //       initiallyExpanded:
  //           !(isIOS || isMacOS) && Stores.setting.webdavSync.fetch(),
  //       children: [
  //         ListTile(
  //           title: Text(l10n.setting),
  //           trailing: const Icon(Icons.settings),
  //           onTap: () async => _onTapWebdavSetting(context),
  //         ),
  //         ListTile(
  //           title: Text(l10n.auto),
  //           trailing: StoreSwitch(
  //             prop: Stores.setting.webdavSync,
  //             validator: (p0) {
  //               if (p0) {
  //                 if (Stores.setting.webdavUrl.fetch().isEmpty ||
  //                     Stores.setting.webdavUser.fetch().isEmpty ||
  //                     Stores.setting.webdavPwd.fetch().isEmpty) {
  //                   context.showSnackBar(l10n.webdavSettingEmpty);
  //                   return false;
  //                 }
  //               }
  //               if (Stores.setting.icloudSync.fetch()) {
  //                 context.showSnackBar(l10n.autoBackupConflict);
  //                 return false;
  //               }
  //               return true;
  //             },
  //             callback: (val) async {
  //               if (val) {
  //                 webdavLoading.value = true;
  //                 await Webdav.sync();
  //                 webdavLoading.value = false;
  //               }
  //             },
  //           ),
  //         ),
  //         ListTile(
  //           title: Text(l10n.manual),
  //           trailing: ListenableBuilder(
  //             listenable: webdavLoading,
  //             builder: (_, __) {
  //               if (webdavLoading.value) {
  //                 return UIs.centerSizedLoadingSmall;
  //               }
  //               return Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   TextButton(
  //                     onPressed: () async => _onTapWebdavDl(context),
  //                     child: Text(l10n.restore),
  //                   ),
  //                   UIs.width7,
  //                   TextButton(
  //                     onPressed: () async => _onTapWebdavUp(context),
  //                     child: Text(l10n.backup),
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _onTapFileRestore(BuildContext context) async {
    final data = await FileUtil.pick();
    if (data == null) return;

    final text = utf8.decode(data);
    try {
      context.showLoadingDialog();
      final backup = await compute(Backup.fromJsonString, text.trim());
      if (backupFormatVersion != backup.version) {
        context.showSnackBar('Backup version not match');
        return;
      }

      final time = DateTime.fromMillisecondsSinceEpoch(backup.date);
      await context.showRoundDialog(
        title: 'Restore',
        child: Text('Are you sure to restore [$time]?'),
        actions: [
          TextButton(
            onPressed: () async {
              await backup.restore(force: true);
              context.pop();
            },
            child: const Text('Ok'),
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

  // Future<void> _onTapWebdavDl(BuildContext context) async {
  //   webdavLoading.value = true;
  //   try {
  //     final result = await Webdav.download(
  //       relativePath: Paths.bakName,
  //     );
  //     if (result != null) {
  //       Loggers.app.warning('Download webdav backup failed: $result');
  //       return;
  //     }
  //   } catch (e, s) {
  //     Loggers.app.warning('Download webdav backup failed', e, s);
  //     context.showSnackBar(e.toString());
  //     webdavLoading.value = false;
  //     return;
  //   }
  //   final dlFile = await File(await Paths.bak).readAsString();
  //   final dlBak = await compute(Backup.fromJsonString, dlFile);
  //   await dlBak.restore(force: true);
  //   webdavLoading.value = false;
  // }

  // Future<void> _onTapWebdavUp(BuildContext context) async {
  //   webdavLoading.value = true;
  //   await Backup.backup();
  //   final uploadResult = await Webdav.upload(relativePath: Paths.bakName);
  //   if (uploadResult != null) {
  //     Loggers.app.warning('Upload webdav backup failed: $uploadResult');
  //   } else {
  //     Loggers.app.info('Upload webdav backup success');
  //   }
  //   webdavLoading.value = false;
  // }

  // Future<void> _onTapWebdavSetting(BuildContext context) async {
  //   final urlCtrl = TextEditingController(
  //     text: Stores.setting.webdavUrl.fetch(),
  //   );
  //   final userCtrl = TextEditingController(
  //     text: Stores.setting.webdavUser.fetch(),
  //   );
  //   final pwdCtrl = TextEditingController(
  //     text: Stores.setting.webdavPwd.fetch(),
  //   );
  //   final result = await context.showRoundDialog<bool>(
  //     title: const Text('WebDAV'),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Input(
  //           label: 'URL',
  //           hint: 'https://example.com/webdav/',
  //           controller: urlCtrl,
  //         ),
  //         Input(
  //           label: l10n.user,
  //           controller: userCtrl,
  //         ),
  //         Input(
  //           label: l10n.pwd,
  //           controller: pwdCtrl,
  //         ),
  //       ],
  //     ),
  //     actions: [
  //       TextButton(
  //         onPressed: () {
  //           context.pop(true);
  //         },
  //         child: Text(l10n.ok),
  //       ),
  //     ],
  //   );
  //   if (result == true) {
  //     final result =
  //         await Webdav.test(urlCtrl.text, userCtrl.text, pwdCtrl.text);
  //     if (result == null) {
  //       context.showSnackBar(l10n.success);
  //     } else {
  //       context.showSnackBar(result);
  //       return;
  //     }
  //     Webdav.changeClient(urlCtrl.text, userCtrl.text, pwdCtrl.text);
  //   }
  // }
}
