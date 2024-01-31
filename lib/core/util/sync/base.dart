import 'dart:async';

import 'package:flutter_chatgpt/core/util/func.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/core/util/sync/icloud.dart';
import 'package:flutter_chatgpt/core/util/sync/webdav.dart';
import 'package:flutter_chatgpt/data/store/all.dart';

abstract final class SyncService {
  static bool _dirty = true;

  static Future<void> sync({bool force = false}) async {
    if (force || Stores.setting.onlySyncOnLaunch.fetch()) return;
    _dirty = true;
    Funcs.throttle(
      () async {
        if (_dirty) {
          _dirty = false;
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
      },
      id: 'SyncService.sync',
      duration: 30000,
    );
  }
}
