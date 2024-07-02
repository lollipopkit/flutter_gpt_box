import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gpt_box/core/ext/file.dart';
import 'package:image/image.dart';

abstract final class ImageUtil {
  static Future<Uint8List?> compress(Uint8List data, {int quality = 80}) async {
    final img = await compute(decodeImage, data);
    if (img == null) return null;
    Future<Uint8List?> encode(Image decoded) async {
      return encodeJpg(decoded, quality: quality);
    }

    return compute(encode, img);
  }

  static Future<(String? url, String? path)> normalizeUrl(String? path) async {
    if (path == null) return (null, null);
    if (path.startsWith('http')) {
      return (path, path);
    }
    if (path.startsWith('/')) {
      return (await File(path).base64, path);
    }
    return (null, null);
  }
}
