import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' hide File;

import 'base.dart';

abstract final class FileUtil {
  /// Due to web platform limitation, return Uint8List instead of File.
  static Future<PlatformFile?> pick() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    return result?.files.single;
  }

  static Future<String?> pickString() async {
    final picked = await pick();
    if (picked == null) return null;

    switch (Pfs.type) {
      case Pfs.web:
        final bytes = picked.bytes;
        if (bytes == null) return null;
        return utf8.decode(bytes);
      default:
        final path = picked.path;
        if (path == null) return null;
        return await File(path).readAsString();
    }
  }

  static Future<void> save(String name, String data, {String? suffix}) async {
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
        await Share.shareXFiles([
          XFile.fromData(
            utf8.encode(data),
            name: name,
            mimeType: suffix,
          )
        ]);
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
