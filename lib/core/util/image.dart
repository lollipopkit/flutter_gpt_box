import 'package:flutter/foundation.dart';
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
}
