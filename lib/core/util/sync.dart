import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/app/backup.dart';
import 'package:gpt_box/data/store/all.dart';

final class BakSync extends SyncIface {
  const BakSync._() : super();

  static const instance = BakSync._();

  static final icloud = ICloud(containerId: 'iCloud.tech.lolli.gptbox');

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
    Webdav.shared.prefix = 'gptbox/';

    final icloudEnabled = _set.icloudSync.get();
    if (icloudEnabled) return icloud;

    final webdavEnabled = _set.webdavSync.get();
    if (webdavEnabled) return Webdav.shared;

    return null;
  }
}
