import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:gpt_box/data/res/l10n.dart';
import 'package:gpt_box/data/res/url.dart';
import 'package:gpt_box/data/store/all.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:shortid/shortid.dart';

part 'history.g.dart';
part 'history.ext.dart';

@HiveType(typeId: 5)
@JsonSerializable()
final class ChatHistory {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<ChatHistoryItem> items;
  @HiveField(2)
  @JsonKey(includeIfNull: false)
  final String? name;

  // Fields with id 3/4/5 are deleted, keep it for backward compatibility

  @HiveField(6)
  @JsonKey(includeIfNull: false)
  final ChatSettings? settings;

  ChatHistory({
    required this.items,
    required this.id,
    this.name,
    this.settings,
  });

  ChatHistory.noid({
    required this.items,
    this.name,
    this.settings,
  }) : id = shortid.generate();

  factory ChatHistory.fromJson(Map<String, dynamic> json) =>
      _$ChatHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHistoryToJson(this);

  /// Returns the last modified time of the history.
  DateTime? get lastTime {
    if (items.isEmpty) return null;
    var last = items.first.createdAt;
    for (final item in items) {
      if (item.createdAt.isAfter(last)) {
        last = item.createdAt;
      }
    }
    return last;
  }

  @override
  String toString() => 'ChatHistory($id, $name, $lastTime)';
}

@HiveType(typeId: 0)
@JsonSerializable()
final class ChatHistoryItem {
  @HiveField(0)
  final ChatRole role;
  @HiveField(1)
  final List<ChatContent> content;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final String id;
  @HiveField(4)
  @JsonKey(includeIfNull: false)
  final String? toolCallId;
  @HiveField(5)
  @JsonKey(includeIfNull: false)
  final List<ChatCompletionMessageToolCall>? toolCalls;
  @HiveField(6)
  @JsonKey(includeIfNull: false)
  String? reasoning;

  ChatHistoryItem({
    required this.role,
    required this.content,
    required this.createdAt,
    required this.id,
    this.toolCallId,
    this.toolCalls,
    this.reasoning,
  });

  ChatHistoryItem.gen(
      {required this.role,
      required this.content,
      this.toolCallId,
      this.toolCalls,
      this.reasoning})
      : createdAt = DateTime.now(),
        id = shortid.generate();

  ChatHistoryItem.single({
    required this.role,
    String raw = '',
    ChatContentType type = ChatContentType.text,
    DateTime? createdAt,
    this.toolCallId,
    this.toolCalls,
    this.reasoning,
  })  : content = [ChatContent.noid(type: type, raw: raw)],
        createdAt = createdAt ?? DateTime.now(),
        id = shortid.generate();

  factory ChatHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$ChatHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHistoryItemToJson(this);

  @override
  String toString() {
    return 'ChatHistoryItem($role, $content, $createdAt)';
  }
}

/// Handle [audio] and [image] as url (/path & https://) or base64
@HiveType(typeId: 1)
@JsonEnum()
enum ChatContentType {
  @HiveField(0)
  text,
  @HiveField(1)
  audio,
  @HiveField(2)
  image,
  @HiveField(3)
  file,
  ;

  bool get isText => this == text;
  bool get isAudio => this == audio;
  bool get isImage => this == image;
  bool get isFile => this == file;
}

@HiveType(typeId: 2)
@JsonSerializable()
final class ChatContent with EquatableMixin {
  @HiveField(0)
  final ChatContentType type;
  @HiveField(1)
  final String raw;
  @HiveField(2, defaultValue: '')
  final String id;

  ChatContent({
    required this.type,
    required this.raw,
    required String id,
  }) : id = id.isEmpty ? shortid.generate() : id;
  ChatContent.noid({required this.type, required this.raw})
      : id = shortid.generate();
  ChatContent.text(this.raw)
      : type = ChatContentType.text,
        id = shortid.generate();
  ChatContent.audio(this.raw)
      : type = ChatContentType.audio,
        id = shortid.generate();
  ChatContent.image(this.raw)
      : type = ChatContentType.image,
        id = shortid.generate();
  ChatContent.file(this.raw)
      : type = ChatContentType.file,
        id = shortid.generate();

  factory ChatContent.fromJson(Map<String, dynamic> json) =>
      _$ChatContentFromJson(json);

  Map<String, dynamic> toJson() => _$ChatContentToJson(this);
  
  @override
  List<Object?> get props => [type, raw, id];
}

@HiveType(typeId: 3)
@JsonEnum()
enum ChatRole {
  @HiveField(0)
  user,
  @HiveField(1)
  assist,
  @HiveField(2)
  system,
  @HiveField(3)
  tool,
  ;

  bool get isUser => this == user;
  bool get isAssist => this == assist;
  bool get isSystem => this == system;
  bool get isTool => this == tool;

  String get localized => switch (this) {
        user => Stores.setting.avatar.get(),
        assist => '🤖',
        system => '⚙️',
        tool => '🛠️',
      };

  Color get color {
    final c = switch (this) {
      user => UIs.primaryColor,
      assist => UIs.primaryColor.withBlue(233),
      system => UIs.primaryColor.withRed(233),
      tool => UIs.primaryColor.withBlue(33),
    };
    return c.withValues(alpha: 0.5);
  }

  static ChatRole? fromString(String? val) => switch (val) {
        'assistant' => assist,
        _ => values.firstWhereOrNull((p0) => p0.name == val),
      };
}

@HiveType(typeId: 8)
@JsonSerializable()
final class ChatSettings {
  @HiveField(0)
  @JsonKey(name: 'htm')
  final bool headTailMode;
  @HiveField(1)
  @JsonKey(name: 'ut')
  final bool useTools;
  @HiveField(2)
  @JsonKey(name: 'icc')
  final bool ignoreContextConstraint;

  /// Use this constrctor pattern to avoid null value as the [ChatSettings]'s
  /// properties are changing frequently.
  const ChatSettings({
    bool? headTailMode,
    bool? useTools,
    bool? ignoreContextConstraint,
  })  : headTailMode = headTailMode ?? false,
        useTools = useTools ?? true,
        ignoreContextConstraint = ignoreContextConstraint ?? false;

  ChatSettings copyWith({
    bool? headTailMode,
    bool? useTools,
    bool? ignoreContextConstraint,
  }) {
    return ChatSettings(
      headTailMode: headTailMode ?? this.headTailMode,
      useTools: useTools ?? this.useTools,
      ignoreContextConstraint:
          ignoreContextConstraint ?? this.ignoreContextConstraint,
    );
  }

  @override
  String toString() => 'ChatSettings($hashCode)';

  factory ChatSettings.fromJson(Map<String, dynamic> json) =>
      _$ChatSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSettingsToJson(this);
}
