import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/app/backup.dart';
import 'package:gpt_box/data/store/all.dart';

final class BakSync extends SyncIface {
  const BakSync._() : super();

  static const instance = BakSync._();

  @override
  Future<void> saveToFile() => Backup.backupToFile();

  @override
  Future<Mergeable> fromFile(String path) async {
    final content = await File(path).readAsString();
    return Backup.fromJsonString(content);
  }

  static final _set = Stores.setting;

  @override
  Future<RemoteStorage?> get remoteStorage async {
    if (isMacOS || isIOS) await icloud.init('iCloud.tech.lolli.gptbox');
    await webdav.init(WebdavInitArgs(
      url: _set.webdavUrl.fetch(),
      user: _set.webdavUser.fetch(),
      pwd: _set.webdavPwd.fetch(),
      prefix: 'gptbox/',
    ));

    final icloudEnabled = _set.icloudSync.fetch();
    if (icloudEnabled) return icloud;

    final webdavEnabled = _set.webdavSync.fetch();
    if (webdavEnabled) return webdav;

    return null;
  }
}
