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

  /// The providers with a credential. Kept beside them so listing does not
  /// read every secret in the keychain into memory.
  static const _indexKey = 'llm.credentialIds';

  @override
  Future<List<String>> list() async {
    final raw = await SecureStore.storage.read(key: _indexKey);
    if (raw != null) {
      try {
        return (json.decode(raw) as List).cast<String>();
      } catch (e) {
        Loggers.app.warning('Credential index is unreadable', e);
      }
    }
    // TODO: remove once every install has the index (it was added after
    // the first release on fl_pi_llm): built from a full read, once.
    final all = await SecureStore.storage.readAll();
    final ids = [
      for (final k in all.keys)
        if (k.startsWith(_prefix)) k.substring(_prefix.length),
    ];
    await _saveIndex(ids);
    return ids;
  }

  static Future<void> _saveIndex(List<String> ids) =>
      SecureStore.storage.write(key: _indexKey, value: json.encode(ids.toSet().toList()..sort()));

  @override
  Future<void> write(String providerId, LlmCredential credential) async {
    await SecureStore.storage.write(key: '$_prefix$providerId', value: json.encode(credential.json));
    await _saveIndex([...await list(), providerId]);
  }

  @override
  Future<void> delete(String providerId) async {
    await SecureStore.storage.delete(key: '$_prefix$providerId');
    await _saveIndex([...(await list()).where((e) => e != providerId)]);
  }
}
