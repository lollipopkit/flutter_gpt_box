// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupV2 _$BackupV2FromJson(Map<String, dynamic> json) => _BackupV2(
  version: (json['version'] as num).toInt(),
  date: (json['date'] as num).toInt(),
  cfgs: json['cfgs'] as Map<String, dynamic>,
  tools: json['tools'] as Map<String, dynamic>,
  histories: json['histories'] as Map<String, dynamic>,
  trashes: json['trashes'] as Map<String, dynamic>,
);

Map<String, dynamic> _$BackupV2ToJson(_BackupV2 instance) => <String, dynamic>{
  'version': instance.version,
  'date': instance.date,
  'cfgs': instance.cfgs,
  'tools': instance.tools,
  'histories': instance.histories,
  'trashes': instance.trashes,
};
