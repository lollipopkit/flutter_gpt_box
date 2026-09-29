import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/app/backup2.dart';

void main() {
  group('BackupV2', () {
    test('constructor creates valid backup', () {
      final backup = BackupV2(
        version: 2,
        date: 1700000000000,
        cfgs: {},
        tools: {},
        histories: {},
        trashes: {},
      );
      expect(backup.version, 2);
      expect(backup.date, 1700000000000);
      expect(backup.cfgs, isEmpty);
      expect(backup.tools, isEmpty);
      expect(backup.histories, isEmpty);
      expect(backup.trashes, isEmpty);
    });

    test('fromJson and toJson round-trip', () {
      final backup = BackupV2(
        version: 2,
        date: 1700000000000,
        cfgs: {
          'cfg1': {'id': 'test', 'url': 'https://api.test.com', 'key': 'sk-key', 'model': 'gpt-4'},
        },
        tools: {'enabled': true},
        histories: {},
        trashes: {},
      );
      final json = backup.toJson();
      final fromJson = BackupV2.fromJson(json);
      expect(fromJson.version, 2);
      expect(fromJson.date, 1700000000000);
      expect(fromJson.cfgs, isNotEmpty);
    });

    test('formatVer is 2', () {
      expect(BackupV2.formatVer, 2);
    });

    test('fromJsonString parses JSON string', () {
      final jsonString = json.encode({
        'version': 2,
        'date': 1700000000000,
        'cfgs': {},
        'tools': {},
        'histories': {},
        'trashes': {},
      });
      final backup = BackupV2.fromJsonString(jsonString);
      expect(backup.version, 2);
      expect(backup.date, 1700000000000);
    });

    test('dateStr formats date correctly', () {
      final backup = BackupV2(
        version: 2,
        date: 1700000000000, // Known timestamp
        cfgs: {},
        tools: {},
        histories: {},
        trashes: {},
      );
      // SimpleExtension.simple() is used, just verify it doesn't throw
      expect(backup.dateStr, isA<String>());
      expect(backup.dateStr, isNotEmpty);
    });

    test('handles empty backup data', () {
      final backup = BackupV2(
        version: BackupV2.formatVer,
        date: 0,
        cfgs: {},
        tools: {},
        histories: {},
        trashes: {},
      );
      final json = backup.toJson();
      expect(json['version'], BackupV2.formatVer);
      expect(json['date'], 0);
    });
  });
}