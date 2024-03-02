import 'dart:convert';
import 'dart:typed_data';

extension Uint8ListX on Uint8List {
  String get base64 => base64Encode(this);
}
