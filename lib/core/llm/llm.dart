import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';
import 'package:gpt_box/core/llm/credentials.dart';
import 'package:gpt_box/core/llm/store.dart';
import 'package:gpt_box/data/store/all.dart';

/// The app's one fl_pi_llm runtime, and what it knows about providers.
abstract final class Llm {
  static FlPiLlm? _rt;

  static FlPiLlm get rt {
    final rt = _rt;
    if (rt == null) throw StateError('Llm.init() has not completed');
    return rt;
  }

  /// Every provider and its models, as last read.
  static final providers = <LlmProviderInfo>[].vn;

  /// Providers with a credential in the keychain.
  static final configured = <String>{}.vn;

  static LlmCredentials _credentials = KeychainCredentials.instance;

  /// After the stores: sessions live in the same encrypted database.
  ///
  /// [credentials] and [externalLibrary] are for tests, which have neither a
  /// keychain nor an app bundle.
  static Future<void> init({LlmCredentials? credentials, ExternalLibrary? externalLibrary}) async {
    if (credentials != null) _credentials = credentials;
    _rt ??= await FlPiLlm.start(
      store: SqlitePiSessionStore.instance,
      credentials: _credentials,
      externalLibrary: externalLibrary,
      logger: (level, msg) => switch (level) {
        'error' => Loggers.app.warning('[llm] $msg'),
        'warn' => Loggers.app.info('[llm] $msg'),
        _ => Loggers.app.fine('[llm] $msg'),
      },
    );
    await applyCustomProviders();
    // The network part runs behind: the cached lists are already usable.
    unawaited(refresh().catchError((Object e, StackTrace s) {
      Loggers.app.warning('Refresh models', e, s);
      return const <String, String>{};
    }));
  }

  /// Hands the stored custom providers to the runtime.
  static Future<void> applyCustomProviders() async {
    if (_rt == null) return;
    try {
      await rt.setCustomProviders(Stores.llm.customProviders.get() ?? const []);
    } catch (e, s) {
      Loggers.app.warning('Apply custom providers', e, s);
    }
    await reload();
  }

  /// Rereads the catalog and which providers have a credential.
  static Future<void> reload() async {
    providers.value = await rt.providers();
    configured.value = (await _credentials.list()).toSet();
  }

  /// Why the last listing of a provider's models failed, by provider id.
  static final modelErrors = <String, String>{}.vn;

  /// Lists the models of dynamic providers again. Returns the errors.
  static Future<Map<String, String>> refresh({List<String>? only, bool force = false}) async {
    final errors = await rt.refreshModels(providers: only, force: force);
    for (final MapEntry(:key, :value) in errors.entries) {
      Loggers.app.info('Models of $key: $value');
    }
    modelErrors.value = {
      for (final e in modelErrors.value.entries)
        if (only != null && !only.contains(e.key)) e.key: e.value,
      ...errors,
    };
    await reload();
    return errors;
  }

  /// Ids of chats whose session mentions [needle].
  static Set<String> sessionsContaining(String needle) {
    final paths = SqlitePiSessionStore.instance.search(needle);
    final ids = <String>{};
    for (final path in paths) {
      // pi names a session file `<created>_<encoded id>.jsonl`.
      final name = path.split('/').last;
      if (!name.endsWith('.jsonl')) continue;
      for (final meta in Stores.chat.all()) {
        if (name.endsWith('_${Uri.encodeComponent(meta.id)}.jsonl')) ids.add(meta.id);
      }
    }
    return ids;
  }

  static LlmModelInfo? info(LlmModelRef? ref) {
    if (ref == null) return null;
    for (final p in providers.value) {
      if (p.id != ref.provider) continue;
      for (final m in p.models) {
        if (m.id == ref.id) return m;
      }
    }
    return null;
  }

  static LlmProviderInfo? provider(String id) => providers.value.firstWhereOrNull((p) => p.id == id);

  /// Models whose provider has a credential, favorites first.
  static List<LlmModelInfo> get usableModels {
    final fav = Stores.llm.favoriteModels.get().toSet();
    final out = [
      for (final p in providers.value)
        if (configured.value.contains(p.id)) ...p.models,
    ];
    out.sort((a, b) {
      final fa = fav.contains(a.ref.toString()), fb = fav.contains(b.ref.toString());
      if (fa != fb) return fa ? -1 : 1;
      return 0;
    });
    return out;
  }

  /// What a new chat talks to: the chosen default, or the first usable model.
  static LlmModelRef? get defaultModel => Stores.llm.defaultModel.get() ?? usableModels.firstOrNull?.ref;

  static Future<LlmCredential?> readCredential(String providerId) =>
      _credentials.read(providerId);

  static Future<void> setCredential(String providerId, LlmCredential? credential) async {
    if (credential == null) {
      await _credentials.delete(providerId);
    } else {
      await _credentials.write(providerId, credential);
    }
    configured.value = (await _credentials.list()).toSet();
  }
}
