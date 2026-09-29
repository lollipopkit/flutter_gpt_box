import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/app/backup.dart';
import 'package:gpt_box/data/model/app/backup2.dart';
import 'package:gpt_box/data/model/app/utils.dart';

void main() {
  group('MergeableUtils', () {
    test('fromJsonString parses BackupV2 format', () {
      final v2Json = json.encode({
        'version': 2,
        'date': 1700000000000,
        'cfgs': {},
        'tools': {},
        'histories': {},
        'trashes': {},
      });

      final (mergeable, dateStr) = MergeableUtils.fromJsonString(v2Json);
      expect(mergeable, isA<BackupV2>());
      expect(dateStr, isNotEmpty);
    });

    test('fromJsonString falls back to BackupV1 format', () {
      final v1Json = json.encode({
        'version': 1,
        'lastModTime': 1700000000000,
        'configs': [],
        'history': [],
        'tools': {},
      });

      final (mergeable, dateStr) = MergeableUtils.fromJsonString(v1Json);
      expect(mergeable, isA<Backup>());
      expect(dateStr, isNotEmpty);
    });

    test('fromJsonString handles V2 with data', () {
      final v2Json = json.encode({
        'version': 2,
        'date': 1700000000000,
        'cfgs': {
          'defaultId': {
            'id': 'defaultId',
            'url': 'https://api.openai.com/v1',
            'key': '',
            'model': '',
          },
        },
        'tools': {'enabled': false},
        'histories': {},
        'trashes': {},
      });

      final (mergeable, _) = MergeableUtils.fromJsonString(v2Json);
      expect(mergeable, isA<BackupV2>());
    });

    test('fromJsonString throws for invalid JSON gracefully', () {
      // If the V2 parsing fails, it falls back to V1 which also fails for truly invalid data.
      // This tests that both parsers are tried.
      expect(
        () => MergeableUtils.fromJsonString('not json at all'),
        throwsA(anything),
      );
    });
  });
}