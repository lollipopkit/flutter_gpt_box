import 'dart:async';

import 'package:flutter_chatgpt/core/util/func.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/core/util/sync/icloud.dart';
import 'package:flutter_chatgpt/core/util/sync/webdav.dart';
import 'package:flutter_chatgpt/data/store/all.dart';

abstract final class SyncService {
  static Future<void> sync({bool force = false, bool throttle = true}) async {
    if (!force && Stores.setting.onlySyncOnLaunch.fetch()) return;
    if (!throttle) return await _sync();
    await Funcs.throttle(
      _sync,
      id: 'SyncService.sync',

      /// In common case, a chat will be ended in 10 seconds.
      durationMills: 10000,
    );
  }

  static Future<void> _sync() async {
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
