import 'dart:typed_data';

import 'package:image/image.dart';

abstract final class ImageUtil {
  static Future<Uint8List?> compress(Uint8List data, {int quality = 80}) async {
    final img = decodeImage(data);
    if (img == null) return null;
    return encodeJpg(img, quality: quality);
  }
}
