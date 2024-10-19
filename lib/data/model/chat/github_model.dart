import 'package:json_annotation/json_annotation.dart';

part 'github_model.g.dart';

@JsonSerializable()
class GithubModelItem {
  final String id;
  final String name;
  @JsonKey(name: "friendly_name")
  final String friendlyName;
  @JsonKey(name: "model_version")
  final int modelVersion;
  final String publisher;
  @JsonKey(name: "model_family")
  final String modelFamily;
  @JsonKey(name: "model_registry")
  final String modelRegistry;
  final String license;
  final String task;
  final String description;
  final String summary;
  final List<String> tags;

  GithubModelItem({
    required this.id,
    required this.name,
    required this.friendlyName,
    required this.modelVersion,
    required this.publisher,
    required this.modelFamily,
    required this.modelRegistry,
    required this.license,
    required this.task,
    required this.description,
    required this.summary,
    required this.tags,
  });

  GithubModelItem copyWith({
    String? id,
    String? name,
    String? friendlyName,
    int? modelVersion,
    String? publisher,
    String? modelFamily,
    String? modelRegistry,
    String? license,
    String? task,
    String? description,
    String? summary,
    List<String>? tags,
  }) =>
      GithubModelItem(
        id: id ?? this.id,
        name: name ?? this.name,
        friendlyName: friendlyName ?? this.friendlyName,
        modelVersion: modelVersion ?? this.modelVersion,
        publisher: publisher ?? this.publisher,
        modelFamily: modelFamily ?? this.modelFamily,
        modelRegistry: modelRegistry ?? this.modelRegistry,
        license: license ?? this.license,
        task: task ?? this.task,
        description: description ?? this.description,
        summary: summary ?? this.summary,
        tags: tags ?? this.tags,
      );

  factory GithubModelItem.fromJson(Map<String, dynamic> json) =>
      _$GithubModelItemFromJson(json);

  Map<String, dynamic> toJson() => _$GithubModelItemToJson(this);
}

/// A list of GithubModelItem
final class GithubModelsList {
  final List<GithubModelItem> models;

  GithubModelsList({required this.models});

  factory GithubModelsList.fromJson(List<dynamic> json) {
    final list = List.generate(
      json.length,
      (index) {
        try {
          return GithubModelItem.fromJson(json[index]);
        } catch (_) {
          return null;
        }
      },
      growable: false,
    );
    return GithubModelsList(models: list.whereType<GithubModelItem>().toList());
  }

  List<Map<String, dynamic>> toJson() {
    return models.map((e) => e.toJson()).toList();
  }
}
