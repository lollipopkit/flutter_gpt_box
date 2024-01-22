import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:webdav_client/webdav_client.dart';

import '../../../data/model/app/backup.dart';
import '../../../data/model/app/error.dart';
import '../../../data/res/path.dart';
import '../../../data/store/all.dart';

abstract final class Webdav {
  /// Some WebDAV provider only support non-root path
  static const _prefix = 'gptbox/';

  static var _client = WebdavClient(
    url: Stores.setting.webdavUrl.fetch(),
    user: Stores.setting.webdavUser.fetch(),
    pwd: Stores.setting.webdavPwd.fetch(),
  );

  static final _logger = Logger('Webdav');

  static Future<String?> test(String url, String user, String pwd) async {
    final client = WebdavClient(url: url, user: user, pwd: pwd);
    try {
      await client.ping();
      return null;
    } catch (e, s) {
      _logger.warning('Test failed', e, s);
      return e.toString();
    }
  }

  static Future<WebdavErr?> upload({
    required String relativePath,
    String? localPath,
  }) async {
    try {
      await _client.writeFile(
        localPath ?? '${await Paths.doc}/$relativePath',
        _prefix + relativePath,
      );
    } catch (e, s) {
      _logger.warning('Upload $relativePath failed', e, s);
      return WebdavErr(type: WebdavErrType.generic, message: '$e');
    }
    return null;
  }

  static Future<WebdavErr?> delete(String relativePath) async {
    try {
      await _client.remove(_prefix + relativePath);
    } catch (e, s) {
      _logger.warning('Delete $relativePath failed', e, s);
      return WebdavErr(type: WebdavErrType.generic, message: '$e');
    }
    return null;
  }

  static Future<WebdavErr?> download({
    required String relativePath,
    String? localPath,
  }) async {
    try {
      await _client.readFile(
        _prefix + relativePath,
        localPath ?? '${await Paths.doc}/$relativePath',
      );
    } catch (e) {
      _logger.warning('Download $relativePath failed');
      return WebdavErr(type: WebdavErrType.generic, message: '$e');
    }
    return null;
  }

  static Future<List<String>> list() async {
    try {
      final list = await _client.readDir(_prefix);
      final names = <String>[];
      for (final item in list) {
        if ((item.isDir ?? true) || item.name == null) continue;
        names.add(item.name!);
      }
      return names;
    } catch (e, s) {
      _logger.warning('List failed', e, s);
      return [];
    }
  }

  static void changeClient(String url, String user, String pwd) {
    _client = WebdavClient(url: url, user: user, pwd: pwd);
    Stores.setting.webdavUrl.put(url);
    Stores.setting.webdavUser.put(user);
    Stores.setting.webdavPwd.put(pwd);
  }

  static Future<void> sync() async {
    final result = await download(relativePath: Paths.bakName);
    if (result != null) {
      await backup();
      return;
    }
    final dlFile = await compute((message) async {
      try {
        final file = await File(message).readAsString();
        final bak = Backup.fromJsonString(file);
        return bak;
      } catch (_) {
        return null;
      }
    }, await Paths.bak);
    if (dlFile == null) {
      await backup();
      return;
    }
    final restore = await dlFile.restore();
    switch (restore) {
      case true:
        _logger.info('Restore from ${dlFile.lastModTime} success');
        break;
      case false:
        await backup();
        break;
      case null:
        _logger.info('Skip sync');
        break;
    }
  }

  /// Create a local backup and upload it to WebDAV
  static Future<void> backup() async {
    final content = await Backup.backup();
    await File(await Paths.bak).writeAsString(content);
    final uploadResult = await upload(relativePath: Paths.bakName);
    if (uploadResult != null) {
      _logger.warning('Upload failed: $uploadResult');
    } else {
      _logger.info('Upload success');
    }
  }
}
