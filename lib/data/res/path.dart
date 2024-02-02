import 'dart:io';

import 'package:flutter_chatgpt/core/util/platform/base.dart';
import 'package:flutter_chatgpt/core/util/platform/file.dart';
import 'package:path_provider/path_provider.dart';

abstract final class Paths {
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
      final dir = FileUtil.joinPath(
          Platform.environment['APPDATA'] ??
              (await getApplicationDocumentsDirectory()).path,
          "GPTBox");
      Directory(dir).createSync();
      _docDir = dir;
    } else {
      final Directory dir = await getApplicationDocumentsDirectory();
      _docDir = dir.path;
    }
    return _docDir!;
  }

  static const String bakName = 'gptbox_bak.json';

  static Future<String> get bak async => '${await doc}/$bakName';

  static Future<String> get dl async => FileUtil.joinPath(await doc, 'dl');
}
