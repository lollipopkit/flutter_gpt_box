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
    final resp = await Dio().get('https://cdn.lolli.tech/gptbox/update.json');
    return AppUpdate.fromJson(resp.data);
  }

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
    required this.web,
  });

  final T? mac;
  final T? ios;
  final T? android;
  final T? windows;
  final T? linux;
  final T? web;

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
        web: json["web"],
      );

  Map<String, dynamic> toJson() => {
        "mac": mac,
        "ios": ios,
        "android": android,
        "windows": windows,
        "linux": linux,
        "web": web,
      };

  T? get current {
    return switch (Pfs.type) {
      Pfs.macos => mac,
      Pfs.ios => ios,
      Pfs.android => android,
      Pfs.windows => windows,
      Pfs.linux => linux,
      Pfs.web => web,
      _ => null,
    };
  }
}
