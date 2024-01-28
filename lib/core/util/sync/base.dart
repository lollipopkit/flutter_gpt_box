import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/core/util/sync/icloud.dart';
import 'package:flutter_chatgpt/core/util/sync/webdav.dart';
import 'package:flutter_chatgpt/data/store/all.dart';

abstract final class SyncService {
  static Future<void> sync() async {
    if (isIOS || isMacOS) {
      if (Stores.setting.icloudSync.fetch()) {
        await ICloud.sync();
        return;
      }
    }
    if (Stores.setting.webdavSync.fetch()) {
      await Webdav.sync();
      return;
    }
  }
}
