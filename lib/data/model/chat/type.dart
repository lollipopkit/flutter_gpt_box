import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/core/ext/list.dart';
import 'package:flutter_chatgpt/data/res/l10n.dart';

enum ChatType {
  text,
  img,
  audio,
  ;

  static ChatType? fromString(String val) {
    return ChatType.values.firstWhereOrNull((e) => e.name == val);
  }

  IconData get icon => switch (this) {
        text => Icons.text_fields,
        img => Icons.image,
        audio => Icons.mic,
      };

  String get name => switch (this) {
        text => l10n.text,
        img => l10n.image,
        audio => l10n.audio,
      };
}
