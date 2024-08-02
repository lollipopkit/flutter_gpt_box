import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supa = Supabase.instance;

abstract final class SupaUtils {
  static String? _url;
  static String get url => _url!;
  static String? _annoKey;
  static String get annoKey => _annoKey!;

  static Future<void> init(String url, String key) async {
    _url = url;
    _annoKey = key;

    await Supabase.initialize(
      url: url,
      anonKey: key,

      /// TODO: Allow detect session in uri
      authOptions: const FlutterAuthClientOptions(detectSessionInUri: false),
      debug: BuildMode.isDebug,
    );

    /// TODO: Remove this
    if (supa.client.auth.currentUser == null) {
      debugPrint('Signing in with email and password');
      await supa.client.auth.signInWithPassword(
        password: '',
        email: '',
      );
    }

    if (supa.client.auth.currentUser != null) {
      supa.client.auth.startAutoRefresh();
    }

    debugPrint('Supa user [${supa.client.auth.currentUser?.email}]');
  }

  static String? get userId => supa.client.auth.currentUser?.id;

  static String? get userEmail => supa.client.auth.currentUser?.email;

  static Session? get session => supa.client.auth.currentSession;

  static String? get accessToken => session?.accessToken;

  static Map<String, String> get authHeaders => {
        'Authorization': 'Bearer $accessToken',
        'apikey': annoKey,
      };
}

abstract final class Supa {
  static StorageFileApi? _imgBucket;
  static StorageFileApi get imgBucket =>
      _imgBucket ??= supa.client.storage.from('gptbox_img');
}
