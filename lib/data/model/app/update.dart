/*
{
    "changelog": {
        "mac": "xxx",
        "ios": "xxx",
        "android": ""
    },
    "build": {
        "min": {
            "mac": 1,
            "ios": 1,
            "android": 1
        },
        "last": {
            "mac": 1,
            "ios": 1,
            "android": 1
        }
    },
    "url": {
        "mac": "",
        "ios": "",
        "android": ""
    }
}
*/

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_chatgpt/core/util/platform/base.dart';

class AppUpdate {
  const AppUpdate({
    required this.changelog,
    required this.build,
    required this.url,
  });

  final AppUpdatePlatformSpecific<String> changelog;
  final AppUpdateBuild build;
  final AppUpdatePlatformSpecific<String> url;

  static Future<AppUpdate> fromUrl() async {
    final resp = await Dio().get('https://res.lolli.tech/gpt/update.json');
    return AppUpdate.fromJson(resp.data);
  }

  factory AppUpdate.fromRawJson(String str) =>
      AppUpdate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
        changelog: AppUpdatePlatformSpecific.fromJson(json["changelog"]),
        build: AppUpdateBuild.fromJson(json["build"]),
        url: AppUpdatePlatformSpecific.fromJson(json["url"]),
      );

  Map<String, dynamic> toJson() => {
        "changelog": changelog.toJson(),
        "build": build.toJson(),
        "url": url.toJson(),
      };
}

class AppUpdateBuild {
  AppUpdateBuild({
    required this.min,
    required this.last,
  });

  final AppUpdatePlatformSpecific<int> min;
  final AppUpdatePlatformSpecific<int> last;

  factory AppUpdateBuild.fromRawJson(String str) =>
      AppUpdateBuild.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUpdateBuild.fromJson(Map<String, dynamic> json) => AppUpdateBuild(
        min: AppUpdatePlatformSpecific.fromJson(json["min"]),
        last: AppUpdatePlatformSpecific.fromJson(json["last"]),
      );

  Map<String, dynamic> toJson() => {
        "min": min.toJson(),
        "last": last.toJson(),
      };
}

class AppUpdatePlatformSpecific<T> {
  AppUpdatePlatformSpecific({
    required this.mac,
    required this.ios,
    required this.android,
    required this.windows,
    required this.linux,
  });

  final T mac;
  final T ios;
  final T android;
  final T windows;
  final T linux;

  factory AppUpdatePlatformSpecific.fromRawJson(String str) =>
      AppUpdatePlatformSpecific.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUpdatePlatformSpecific.fromJson(Map<String, dynamic> json) =>
      AppUpdatePlatformSpecific(
        mac: json["mac"],
        ios: json["ios"],
        android: json["android"],
        windows: json["windows"],
        linux: json["linux"],
      );

  Map<String, dynamic> toJson() => {
        "mac": mac,
        "ios": ios,
        "android": android,
        "windows": windows,
        "linux": linux,
      };

  T? get current {
    switch (OS.type) {
      case OS.macos:
        return mac;
      case OS.ios:
        return ios;
      case OS.android:
        return android;
      case OS.windows:
        return windows;
      case OS.linux:
        return linux;

      /// Not implemented yet.
      case OS.web || OS.fuchsia || OS.unknown:
        return null;
    }
  }
}
