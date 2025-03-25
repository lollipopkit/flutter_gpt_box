import 'dart:convert';
import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';

extension FileX on File {
  Future<String?> get base64 async {
    final format = await mimeType;
    final bytes = await readAsBytes();
    if (format == null) {
      return compute(utf8.decode, bytes);
    }
    return 'data:$format;base64,${base64Encode(bytes)}';
  }
}
