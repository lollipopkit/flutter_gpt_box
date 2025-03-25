import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';

extension FileX on File {
  Future<String?> get base64 async {
    final format = await mimeType;
    final bytes = await readAsBytes();
    if (format == null) {
      if (bytes.length > 1024 * 5) {
        // Offload large arrays to a separate isolate.
        return await compute(utf8.decode, bytes);
      } else {
        // For smaller arrays, decode directly to avoid overhead.
        return utf8.decode(bytes);
      }
    }
    return 'data:$format;base64,${base64Encode(bytes)}';
  }
}
