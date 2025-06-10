import 'dart:async';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:gpt_box/data/model/app/backup2.dart';
import 'package:gpt_box/data/model/app/utils.dart';

final icloud = ICloud(containerId: 'iCloud.tech.lolli.gptbox');

final class BakSync extends SyncIface {
  const BakSync._() : super();

  static const instance = BakSync._();

  @override
  void init() {
    Webdav.shared.prefix = 'gptbox/';
  }

  @override
  Future<void> saveToFile() => BackupV2.backup();

  @override
  Future<Mergeable> fromFile(String path) async {
    final content = await File(path).readAsString();
    return MergeableUtils.fromJsonString(content).$1;
  }

  @override
  RemoteStorage? get remoteStorage {
    final icloudEnabled = PrefProps.icloudSync.get();
    if (icloudEnabled) return icloud;

    final webdavEnabled = PrefProps.webdavSync.get();
    if (webdavEnabled) return Webdav.shared;

    return null;
  }
}
