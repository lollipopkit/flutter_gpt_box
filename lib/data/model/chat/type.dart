import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/model/chat/config.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/openai.dart';
import 'package:hive_flutter/adapters.dart';

part 'type.g.dart';

@HiveType(typeId: 7)
enum ChatType {
  @HiveField(0)
  text,
  @HiveField(1)
  img,
  // @HiveField(2)
  // audio,
  ;

  static ChatType? fromString(String? val) {
    return ChatType.values.firstWhereOrNull((e) => e.name == val);
  }

  static ChatType? fromIdx(int? val) {
    try {
      return ChatType.values[val!];
    } catch (e) {
      return null;
    }
  }

  IconData get icon => switch (this) {
        text => Icons.text_fields,
        img => Icons.image,
        //audio => Icons.mic,
      };

  String get name => switch (this) {
        text => l10n.text,
        img => l10n.image,
        //audio => l10n.audio,
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

extension ChatTypeOfCfg on ChatType {
  String? get model => switch (this) {
        ChatType.text => Cfg.current.model,
        ChatType.img => Cfg.current.imgModel,
      };

  ChatConfig copyWithModel(String model, {ChatConfig? cfg}) {
    cfg ??= Cfg.current;
    return switch (this) {
      ChatType.text => cfg.copyWith(model: model),
      ChatType.img => cfg.copyWith(imgModel: model),
    };
  }
}
