import 'dart:convert';

import 'package:fl_lib/fl_lib.dart';
import 'package:fl_pi_llm/fl_pi_llm.dart';

/// Provider credentials in the platform's keychain.
final class KeychainCredentials implements LlmCredentials {
  const KeychainCredentials();

  static const instance = KeychainCredentials();

  static const _prefix = 'llm.credential.';

  @override
  Future<LlmCredential?> read(String providerId) async {
    final raw = await SecureStore.storage.read(key: '$_prefix$providerId');
    if (raw == null) return null;
    try {
      return LlmCredential((json.decode(raw) as Map).cast<String, Object?>());
    } catch (e) {
      Loggers.app.warning('Credential of $providerId is unreadable', e);
      return null;
    }
  }

  @override
  Future<List<String>> list() async {
    final all = await SecureStore.storage.readAll();
    return [
      for (final k in all.keys)
        if (k.startsWith(_prefix)) k.substring(_prefix.length),
    ];
  }

  @override
  Future<void> write(String providerId, LlmCredential credential) =>
      SecureStore.storage.write(key: '$_prefix$providerId', value: json.encode(credential.json));

  @override
  Future<void> delete(String providerId) => SecureStore.storage.delete(key: '$_prefix$providerId');
}
