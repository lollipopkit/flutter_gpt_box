import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';

/// Which models to use, and the providers the user added. Keys are not here:
/// they are in the keychain.
final class LlmStore extends SqliteStore {
  LlmStore._() : super('llm');

  static final instance = LlmStore._();

  late final customProviders = property<List<LlmCustomProvider>>(
    'customProviders',
    fromObj: (o) => [
      for (final p in (o as List? ?? const [])) LlmCustomProvider.fromJson((p as Map).cast<String, Object?>()),
    ],
    toObj: (l) => [for (final p in l ?? const <LlmCustomProvider>[]) p.toStoreJson()],
  );

  /// What a new chat talks to.
  late final defaultModel = property<LlmModelRef>(
    'defaultModel',
    fromObj: (o) => o is Map ? LlmModelRef.fromJson(o.cast<String, Object?>()) : null,
    toObj: (r) => r?.toJson(),
  );

  /// What names chats; the chat's own model when null.
  late final titleModel = property<LlmModelRef>(
    'titleModel',
    fromObj: (o) => o is Map ? LlmModelRef.fromJson(o.cast<String, Object?>()) : null,
    toObj: (r) => r?.toJson(),
  );

  /// Models pinned to the top of the picker.
  late final favoriteModels = listProperty<String>('favoriteModels');

  late final systemPrompt = propertyDefault('systemPrompt', '');

  /// A [ThinkingLevel] name.
  late final thinkingLevel = propertyDefault('thinkingLevel', ThinkingLevel.medium.name);

  late final compaction = propertyDefault('compaction', true);
}
