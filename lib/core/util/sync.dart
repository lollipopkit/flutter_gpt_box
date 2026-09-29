import 'dart:async';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/backup.dart';

final icloud = ICloud(containerId: 'iCloud.tech.lolli.gptbox');

final class BakSync extends SyncIface {
  BakSync._();

  static final instance = BakSync._();

  @override
  void init() {
    Webdav.shared.prefix = 'gptbox/';
  }

  @override
  Future<void> saveToFile() => Backup.toFile();

  @override
  Future<Mergeable> fromFile(String path) async => Backup.fromJsonString(await File(path).readAsString());

  @override
  RemoteStorage? get remoteStorage {
    if (PrefProps.icloudSync.get()) return icloud;
    if (PrefProps.webdavSync.get()) return Webdav.shared;
    return null;
  }
}
