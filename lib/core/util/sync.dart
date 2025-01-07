import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/app/backup.dart';
import 'package:gpt_box/data/store/all.dart';

final icloud = ICloud(containerId: 'iCloud.tech.lolli.gptbox');

final class BakSync extends SyncIface {
  const BakSync._() : super();

  static const instance = BakSync._();

  @override
  void init() {
    Webdav.shared.prefix = 'gptbox/';
  }

  @override
  Future<void> saveToFile() => Backup.backupToFile();

  @override
  Future<Mergeable> fromFile(String path) async {
    final content = await File(path).readAsString();
    return Backup.fromJsonString(content);
  }

  static final _set = Stores.setting;

  @override
  RemoteStorage? get remoteStorage {
    final icloudEnabled = _set.icloudSync.fetch();
    if (icloudEnabled) return icloud;

    final webdavEnabled = _set.webdavSync.fetch();
    if (webdavEnabled) return Webdav.shared;

    return null;
  }
}
