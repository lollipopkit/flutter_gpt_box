import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Due to web platform limitation, return Uint8List instead of File.
Future<Uint8List?> pickOneFile() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.any);
  return result?.files.single.bytes;
}