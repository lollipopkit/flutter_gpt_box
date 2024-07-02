import 'dart:convert';
import 'dart:io';

extension FileX on File? {
  Future<String?> get base64 async {
    final format = switch (this?.path.split('.').lastOrNull){
      null => null,
      'png' => 'png',
      'jpeg' => 'jpeg',
      'gif' => 'gif',
      'webp' => 'webp',
      // default to jpeg
      _ => 'jpeg',
    };
    if (format == null) return null;
    final bytes = await this?.readAsBytes();
    if (bytes == null) return null;
    return 'data:image/$format;base64,${base64Encode(bytes)}';
  }
}
