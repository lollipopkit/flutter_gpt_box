import 'package:fl_lib/fl_lib.dart';
import 'package:dio/dio.dart';
import 'package:gpt_box/data/res/openai.dart';

abstract final class ApiBalance {
  static const _balance = ApiBalanceState(loading: true);
  static final balance = _balance.vn;

  static Future<void> refresh() async {
    balance.value = _balance;
    final provider = ApiBalanceProvider.fromEndpoint(OpenAICfg.current.url);
    final newBalance = await provider?.refresh();
    balance.value = ApiBalanceState(loading: false, state: newBalance);
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
  ;

  static ApiBalanceProvider? fromEndpoint(String value) {
    return switch (value) {
      // No balance api for openai
      'https://api.openai.com' => null,
      _ when value.startsWith('https://api.deepseek.com') => deepseek,
      _ when value.startsWith('https://api.chatanywhere.') => chatanywhere,

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
    };
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
        'Authorization': 'Bearer ${OpenAICfg.current.key}',
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
    final resp = await myDio.get(
      '${OpenAICfg.current.url}/api/user/self',
      options: Options(
          headers: {'Authorization': 'Bearer ${OpenAICfg.current.key}'}),
    );
    final data = resp.data as Map<String, dynamic>;
    final quota = data['data']['quota'] as int? ?? 0;
    return '\$${(quota / 500000).toStringAsFixed(2)}';
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
    final endpoint = '${OpenAICfg.current.url}/v1/query/balance';
    final resp = await myDio.post(
      endpoint,
      options: Options(headers: {'Authorization': OpenAICfg.current.key}),
    );
    final data = resp.data as Map<String, dynamic>;
    final total = data['balanceTotal'] as num? ?? 0;
    final used = data['balanceUsed'] as num? ?? 0;
    final usedFixed = used.toStringAsFixed(2);
    if (total == 0) return '$usedFixed of 0';
    return '$usedFixed / $total';
  }
}
