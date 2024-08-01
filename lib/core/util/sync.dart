import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/app/backup.dart';
import 'package:gpt_box/data/store/all.dart';

const sync = Sync._();

final class Sync extends SyncCfg {
  const Sync._() : super();

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
    final icloudEnabled = _set.icloudSync.fetch() && (isMacOS || isIOS);
    if (icloudEnabled) {
      await icloud.init('iCloud.tech.lolli.gptbox');
      return icloud;
    }

    final webdavEnabled = _set.webdavSync.fetch();
    if (webdavEnabled) {
      await webdav.init(WebdavInitArgs(
          url: _set.webdavUrl.fetch(),
          user: _set.webdavUser.fetch(),
          pwd: _set.webdavPwd.fetch(),
          prefix: 'gptbox/'));
      return webdav;
    }
    return null;
  }
}
