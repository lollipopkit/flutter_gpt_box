import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/app/backup.dart';

void main() {
  group('Backup', () {
    test('validVer is 2', () {
      expect(Backup.validVer, 2);
    });

    test('fromJson creates Backup from valid json', () {
      final json = {
        'version': 2,
        'lastModTime': 1700000000000,
        'configs': [],
        'history': [],
        'tools': {},
      };
      final backup = Backup.fromJson(json);
      expect(backup.version, 2);
      expect(backup.lastModTime, 1700000000000);
      expect(backup.configs, isEmpty);
      expect(backup.history, isEmpty);
      expect(backup.tools, isEmpty);
    });

    test('fromJson handles missing version as 1', () {
      final json = {
        'lastModTime': 1700000000000,
        'configs': [],
        'history': [],
        'tools': {},
      };
      final backup = Backup.fromJson(json);
      expect(backup.version, 1);
    });

    test('fromJson handles missing lastModTime as 0', () {
      final json = {
        'version': 2,
        'configs': [],
        'history': [],
        'tools': {},
      };
      final backup = Backup.fromJson(json);
      expect(backup.lastModTime, 0);
    });

    test('fromJson handles null tools', () {
      final json = {
        'version': 2,
        'lastModTime': 0,
        'configs': [],
        'history': [],
        'tools': null,
      };
      final backup = Backup.fromJson(json);
      expect(backup.tools, isA<Map>());
    });

    test('fromJsonString round-trip', () {
      final original = Backup(
        version: 2,
        lastModTime: 1700000000000,
        configs: [],
        history: [],
        tools: {},
        trashes: null,
      );
      final jsonString = json.encode(original.toJson());
      final restored = Backup.fromJsonString(jsonString);
      expect(restored.version, original.version);
      expect(restored.lastModTime, original.lastModTime);
    });

    test('toJson produces correct structure', () {
      final backup = Backup(
        version: 2,
        lastModTime: 1700000000000,
        configs: [],
        history: [],
        tools: {'key': 'value'},
        trashes: null,
      );
      final json = backup.toJson();
      expect(json['version'], 2);
      expect(json['lastModTime'], 1700000000000);
      expect(json['configs'], isA<List>());
      expect(json['history'], isA<List>());
    });

    test('date formats lastModTime', () {
      final backup = Backup(
        version: 2,
        lastModTime: 1700000000000,
        configs: [],
        history: [],
        tools: {},
        trashes: null,
      );
      // Just verify it doesn't crash and returns a string
      expect(backup.date, isA<String>());
      expect(backup.date, isNotEmpty);
    });

    test('fromJson handles configs and history with data', () {
      final json = {
        'version': 2,
        'lastModTime': 1700000000000,
        'configs': [
          {
            'id': 'defaultId',
            'url': 'https://api.openai.com/v1',
            'key': '',
            'model': '',
            'prompt': '',
            'historyLen': 7,
            'name': '',
          },
        ],
        'history': [],
        'tools': {'mcpServers': []},
      };
      final backup = Backup.fromJson(json);
      expect(backup.configs.length, 1);
      expect(backup.configs.first.id, 'defaultId');
    });

    test('fromJson keeps trashes null when absent', () {
      final json = {
        'version': 2,
        'lastModTime': 1700000000000,
        'configs': [],
        'history': [],
        'tools': {},
      };
      final backup = Backup.fromJson(json);
      expect(backup.trashes, isNull);
    });

    test('fromJson handles empty trashes map', () {
      final json = {
        'version': 2,
        'lastModTime': 1700000000000,
        'configs': [],
        'history': [],
        'tools': {},
        'trashes': {},
      };
      final backup = Backup.fromJson(json);
      expect(backup.trashes, isNotNull);
      expect(backup.trashes, isEmpty);
    });

    test('fromJson skips invalid config entries', () {
      final json = {
        'version': 2,
        'lastModTime': 1700000000000,
        'configs': ['not-a-map', 42, {'historyLen': 'not-an-int'}],
        'history': [],
        'tools': {},
      };
      final backup = Backup.fromJson(json);
      // Invalid entries are skipped by fromJsonList
      expect(backup.configs.length, 0);
    });

    test('fromJson skips invalid history entries', () {
      final json = {
        'version': 2,
        'lastModTime': 1700000000000,
        'configs': [],
        'history': ['not-a-map', {'invalid': 'data'}],
        'tools': {},
      };
      final backup = Backup.fromJson(json);
      expect(backup.history.length, 0);
    });
  });
}