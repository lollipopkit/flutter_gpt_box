import 'package:fl_lib/fl_lib.dart';
import 'package:dio/dio.dart';
import 'package:gpt_box/data/res/openai.dart';

abstract final class ApiBalance {
  static const _balance = ApiBalanceState(loading: true);
  static final balance = _balance.vn;

  static Future<void> refresh() async {
    balance.value = _balance;
    final provider = ApiBalanceProvider.fromEndpoint(Cfg.current.url);
    try {
      final newBalance = await provider?.refresh();
      balance.value = ApiBalanceState(loading: false, state: newBalance);
    } catch (e, s) {
      balance.value = const ApiBalanceState(loading: false);
      Loggers.app.warning('Refresh balance', e, s);
    }
  }
}

final class ApiBalanceState {
  final bool loading;
  final String? state;

  const ApiBalanceState({
    required this.loading,
    this.state,
  });
}

enum ApiBalanceProvider {
  deepseek,
  chatanywhere,
  oneapi,
  openrouter,
  siliconflow,
  ;

  static ApiBalanceProvider? fromEndpoint(String value) {
    return switch (value) {
      // No balance api for openai
      'https://api.openai.com' => null,
      _ when value.startsWith('https://api.deepseek.com') => deepseek,
      _ when value.startsWith('https://api.chatanywhere.') => chatanywhere,
      _ when value.startsWith('https://openrouter.ai') => openrouter,
      _ when value.startsWith('https://api.siliconflow.cn') => siliconflow,

      /// TODO
      /// Change it to [oneapi] after correctly impl the [_refreshOneapi]
      _ => null,
    };
  }

  Future<String> refresh() async {
    return switch (this) {
      deepseek => _refreshDeepseek(),
      chatanywhere => _refreshChatanywhere(),
      oneapi => _refreshOneapi(),
      openrouter => _refreshOpenrouter(),
      siliconflow => _refreshSiliconflow(),
    };
  }

  /// ```json
  /// {"data":{"total_credits":50,"total_usage":0.4743325}}
  /// ```
  Future<String> _refreshOpenrouter() async {
    final endpoint = 'https://openrouter.ai/api/v1/credits';
    final resp = await myDio.get(
      endpoint,
      options: Options(headers: {
        'Authorization': 'Bearer ${Cfg.current.key}',
      }),
    );
    final data = (resp.data as Map<String, dynamic>)['data'];
    final usage = data['total_usage'] as num? ?? 0;
    final credit = data['total_credits'] as num? ?? 0;
    return '${usage.toStringAsFixed(2)} / ${credit.toStringAsFixed(1)}';
  }

  // {
  //  "is_available":true,
  //  "balance_infos":[
  //    {
  //      "currency":"CNY",
  //      "total_balance":"9.26",
  //      "granted_balance":"0.00",
  //      "topped_up_balance":"9.26"
  //    },
  //    {
  //      "currency":"USD",
  //      "total_balance":"0.00",
  //      "granted_balance":"0.00",
  //      "topped_up_balance":"0.00"
  //    }
  //   ],
  //  }
  Future<String> _refreshDeepseek() async {
    const endpoint = 'https://api.deepseek.com/user/balance';
    final resp = await myDio.get(
      endpoint,
      options: Options(headers: {
        'Authorization': 'Bearer ${Cfg.current.key}',
      }),
    );
    final data = resp.data as Map<String, dynamic>;
    final vals = <String>[];
    final infos = data['balance_infos'] as List;
    for (final info in infos) {
      final amount = info['total_balance'];
      final currency = info['currency'];
      final balance = '$amount $currency';
      vals.add(balance);
    }
    return vals.join(' | ');
  }

  //  {
  //    "data": {
  //        "id": 0,
  //        "username": "",
  //        "password": "",
  //        "display_name": "",
  //        "role": 1,
  //        "status": 1,
  //        "email": "",
  //        "github_id": "",
  //        "wechat_id": "",
  //        "lark_id": "",
  //        "verification_code": "",
  //        "access_token": "",
  //        "quota": 16533006,
  //        "used_quota": 8566994,
  //        "request_count": 638,
  //        "group": "default",
  //        "aff_code": "peek",
  //        "inviter_id": 0
  //    },
  //    "message": "",
  //    "success": true
  //  }
  Future<String> _refreshOneapi() async {
    final uri = Uri.parse(Cfg.current.url);
    const path = '/api/user/self';
    final resp = await myDio.get(
      '${uri.scheme}://${uri.host}$path',
      options: Options(headers: {'Authorization': 'Bearer ${Cfg.current.key}'}),
    );
    final data = resp.data as Map<String, dynamic>;
    final quota = data['data']['quota'] as int? ?? 0;
    return '\$${(quota / 500000).toStringAsFixed(2)}';
  }

  /// ```json
  /// {
  ///  "code": 20000,
  ///  "message": "OK",
  ///  "status": true,
  ///  "data": {
  ///    "id": "userid",
  ///    "name": "username",
  ///    "image": "user_avatar_image_url",
  ///    "email": "user_email_address",
  ///    "isAdmin": false,
  ///    "balance": "0.88",
  ///    "status": "normal",
  ///    "introduction": "user_introduction",
  ///    "role": "user_role",
  ///    "chargeBalance": "88.00",
  ///    "totalBalance": "88.88"
  ///  }
  ///}
  /// ```
  Future<String> _refreshSiliconflow() async {
    final endpoint = 'https://api.siliconflow.cn/v1/user/info';
    final resp = await myDio.get(
      endpoint,
      options: Options(headers: {'Authorization': Cfg.current.key}),
    );
    final data = resp.data as Map<String, dynamic>;
    final balance = data['data']['balance'] as String? ?? '0.00';
    final total = data['data']['totalBalance'] as String? ?? '0.00';
    return '$balance / $total';
  }

  // {
  //     "id": 1,
  //     "apiKey": "sk-",
  //     "adminKeyId": 9,
  //     "balanceTotal": 0,
  //     "balanceUsed": 0.4659565,
  //     "status": 1
  // }
  Future<String> _refreshChatanywhere() async {
    final uri = Uri.parse(Cfg.current.url);
    const path = '/v1/query/balance';
    final endpoint = 'https://${uri.host}$path';
    final resp = await myDio.post(
      endpoint,
      options: Options(headers: {'Authorization': Cfg.current.key}),
    );
    final data = resp.data as Map<String, dynamic>;
    final total = data['balanceTotal'] as num? ?? 0;
    final used = data['balanceUsed'] as num? ?? 0;
    return (total - used).toStringAsFixed(2);
  }
}
