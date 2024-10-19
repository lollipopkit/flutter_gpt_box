// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubModelItem _$GithubModelItemFromJson(Map<String, dynamic> json) =>
    GithubModelItem(
      id: json['id'] as String,
      name: json['name'] as String,
      friendlyName: json['friendly_name'] as String,
      modelVersion: (json['model_version'] as num).toInt(),
      publisher: json['publisher'] as String,
      modelFamily: json['model_family'] as String,
      modelRegistry: json['model_registry'] as String,
      license: json['license'] as String,
      task: json['task'] as String,
      description: json['description'] as String,
      summary: json['summary'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$GithubModelItemToJson(GithubModelItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'friendly_name': instance.friendlyName,
      'model_version': instance.modelVersion,
      'publisher': instance.publisher,
      'model_family': instance.modelFamily,
      'model_registry': instance.modelRegistry,
      'license': instance.license,
      'task': instance.task,
      'description': instance.description,
      'summary': instance.summary,
      'tags': instance.tags,
    };
