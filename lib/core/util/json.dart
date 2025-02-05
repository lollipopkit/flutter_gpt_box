List<T> fromJsonList<T>(List? json, T Function(Map<String, dynamic>) fromJson) {
  final items = <T>[];
  if (json == null) {
    return items;
  }
  for (final item in json) {
    try {
      final item2 = fromJson(item as Map<String, dynamic>);
      items.add(item2);
    } catch (_) {}
  }
  return items;
}

Map<String, T> fromJsonMap<T>(Map? json, T Function(Map<String, dynamic>) fromJson) {
  final map = <String, T>{};
  if (json == null) {
    return map;
  }
  for (final entry in json.entries) {
    try {
      final item = fromJson(entry.value as Map<String, dynamic>);
      map[entry.key] = item;
    } catch (_) {}
  }
  return map;
}
