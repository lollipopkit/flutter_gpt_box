import 'dart:io';

import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/core/util/platform/file.dart';
import 'package:flutter_chatgpt/data/model/app/backup.dart';
import 'package:path_provider/path_provider.dart';

abstract final class Paths {
  static Future<void> createAll() async {
    await (Directory(await doc)).create(recursive: true);
    await (Directory(await audio)).create();
    await (Directory(await image)).create();
  }

  static String? _docDir;
  static Future<String> get doc async {
    assert(!isWeb);
    if (_docDir != null) {
      return _docDir!;
    }
    if (isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        _docDir = dir.path;
        return dir.path;
      }
      // fallthrough to getApplicationDocumentsDirectory
    }

    if (isWindows) {
      final base = Platform.environment['APPDATA'] ??
          (await getApplicationDocumentsDirectory()).path;
      final dir = FileUtil.joinPath(base, 'GPTBox');
      Directory(dir).createSync();
      _docDir = dir;
    } else {
      final Directory dir = await getApplicationDocumentsDirectory();
      _docDir = dir.path;
    }
    return _docDir!;
  }

  static Future<String> get dl async => FileUtil.joinPath(await doc, 'dl');

  static const String bakName = 'gptbox_bak_v${Backup.validVer}.json';
  static Future<String> get bak async => '${await doc}/$bakName';

  static Future<String> get audio async =>
      FileUtil.joinPath(await doc, 'audio');

  static Future<String> get image async =>
      FileUtil.joinPath(await doc, 'image');
}
