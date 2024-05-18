import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/l10n.dart';

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

  static List<PopupMenuItem<ChatType>> get btns => ChatType.values
      .map(
        (e) => PopupMenuItem(
          value: e,
          child: Row(
            children: [
              Icon(e.icon, size: 19),
              UIs.width13,
              Text(e.name, style: UIs.text13),
            ],
          ),
        ),
      )
      .toList();
}

enum ChatApiType {
  /// Chat in plain text
  text,

  /// Text chat with img
  textImg,

  /// Create img
  img,
  imgEdit,
  tts,
  stt,
  ;

  int toJson() => index;
  static ChatApiType? fromJson(int val) {
    try {
      return ChatApiType.values[val];
    } catch (e) {
      return null;
    }
  }
}
