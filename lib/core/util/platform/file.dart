import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart';

import 'base.dart';

abstract final class FileUtil {
  /// Due to web platform limitation, return Uint8List instead of File.
  static Future<Uint8List?> pick() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    return result?.files.single.bytes;
  }

  static Future<void> save(String name, String data) async {
    switch (Pfs.type) {
      case Pfs.windows || Pfs.linux:
        await Share.share(data, subject: name);
        break;
      case Pfs.web:
        final textBytes = utf8.encode(data);
        final blob = Blob([textBytes]);
        final url = Url.createObjectUrlFromBlob(blob);
        AnchorElement(href: url)
          ..setAttribute("download", name)
          ..click();
        Url.revokeObjectUrl(url);
        break;
      default:
        await Share.shareXFiles(
          [XFile.fromData(utf8.encode(data), name: name)]
        );
        break;
    }
  }

  /// Join two paths with platform specific separator
  static String joinPath(String path1, String path2) {
    if (isWindows) {
      return path1 + (path1.endsWith('\\') ? '' : '\\') + path2;
    }
    return path1 + (path1.endsWith('/') ? '' : '/') + path2;
  }
}
