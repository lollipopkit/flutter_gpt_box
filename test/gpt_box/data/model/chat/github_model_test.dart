import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/chat/github_model.dart';

void main() {
  group('GithubModelItem', () {
    test('constructor sets all properties', () {
      final item = GithubModelItem(
        id: 'gpt-4',
        name: 'GPT-4',
        friendlyName: 'GPT-4 Turbo',
        modelVersion: 2,
        publisher: 'OpenAI',
        modelFamily: 'gpt-4',
        modelRegistry: 'openai',
        license: 'MIT',
        task: 'text-generation',
        description: 'A large language model',
        summary: 'GPT-4 is great',
        tags: ['popular', 'fast'],
      );
      expect(item.id, 'gpt-4');
      expect(item.name, 'GPT-4');
      expect(item.friendlyName, 'GPT-4 Turbo');
      expect(item.modelVersion, 2);
      expect(item.publisher, 'OpenAI');
      expect(item.tags, ['popular', 'fast']);
    });

    test('fromJson and toJson round-trip', () {
      final json = {
        'id': 'gpt-4',
        'name': 'GPT-4',
        'friendly_name': 'GPT-4 Turbo',
        'model_version': 2,
        'publisher': 'OpenAI',
        'model_family': 'gpt-4',
        'model_registry': 'openai',
        'license': 'MIT',
        'task': 'text-generation',
        'description': 'A large language model',
        'summary': 'GPT-4 is great',
        'tags': ['popular', 'fast'],
      };
      final item = GithubModelItem.fromJson(json);
      expect(item.id, 'gpt-4');
      expect(item.name, 'GPT-4');
      expect(item.friendlyName, 'GPT-4 Turbo');
      expect(item.modelVersion, 2);
      expect(item.tags, ['popular', 'fast']);

      final toJson = item.toJson();
      expect(toJson['id'], 'gpt-4');
      expect(toJson['friendly_name'], 'GPT-4 Turbo');
      expect(toJson['model_version'], 2);
    });

    test('copyWith modifies specified fields', () {
      final item = GithubModelItem(
        id: 'gpt-4',
        name: 'GPT-4',
        friendlyName: 'GPT-4',
        modelVersion: 1,
        publisher: 'OpenAI',
        modelFamily: 'gpt-4',
        modelRegistry: 'openai',
        license: 'MIT',
        task: 'text-generation',
        description: 'Old description',
        summary: 'Old summary',
        tags: ['old'],
      );
      final modified = item.copyWith(
        name: 'GPT-4o',
        description: 'New description',
      );
      expect(modified.name, 'GPT-4o');
      expect(modified.description, 'New description');
      expect(modified.id, 'gpt-4'); // unchanged
      expect(item.name, 'GPT-4'); // original unchanged
    });
  });

  group('GithubModelsList', () {
    test('fromJson parses valid list', () {
      final json = [
        {
          'id': 'gpt-4',
          'name': 'GPT-4',
          'friendly_name': 'GPT-4',
          'model_version': 1,
          'publisher': 'OpenAI',
          'model_family': 'gpt-4',
          'model_registry': 'openai',
          'license': 'MIT',
          'task': 'text-generation',
          'description': 'A model',
          'summary': 'Great',
          'tags': ['popular'],
        },
        {
          'id': 'gpt-3.5-turbo',
          'name': 'GPT-3.5 Turbo',
          'friendly_name': 'GPT-3.5',
          'model_version': 1,
          'publisher': 'OpenAI',
          'model_family': 'gpt-3.5',
          'model_registry': 'openai',
          'license': 'MIT',
          'task': 'text-generation',
          'description': 'A cheaper model',
          'summary': 'Fast',
          'tags': [],
        },
      ];
      final list = GithubModelsList.fromJson(json);
      expect(list.models.length, 2);
      expect(list.models[0].id, 'gpt-4');
      expect(list.models[1].id, 'gpt-3.5-turbo');
    });

    test('fromJson skips invalid items', () {
      final json = [
        {
          'id': 'gpt-4',
          'name': 'GPT-4',
          'friendly_name': 'GPT-4',
          'model_version': 1,
          'publisher': 'OpenAI',
          'model_family': 'gpt-4',
          'model_registry': 'openai',
          'license': 'MIT',
          'task': 'text-generation',
          'description': 'A model',
          'summary': 'Great',
          'tags': [],
        },
        {'invalid': 'data'}, // Missing required fields - should be skipped
        {
          'id': 'gpt-3.5',
          'name': 'GPT-3.5',
          'friendly_name': 'GPT-3.5',
          'model_version': 1,
          'publisher': 'OpenAI',
          'model_family': 'gpt-3.5',
          'model_registry': 'openai',
          'license': 'MIT',
          'task': 'text-generation',
          'description': 'Fast',
          'summary': 'Cheap',
          'tags': [],
        },
      ];
      final list = GithubModelsList.fromJson(json);
      expect(list.models.length, 2);
    });

    test('fromJson handles empty list', () {
      final list = GithubModelsList.fromJson([]);
      expect(list.models, isEmpty);
    });

    test('toJson produces correct output', () {
      final list = GithubModelsList(models: [
        GithubModelItem(
          id: 'gpt-4',
          name: 'GPT-4',
          friendlyName: 'GPT-4',
          modelVersion: 1,
          publisher: 'OpenAI',
          modelFamily: 'gpt-4',
          modelRegistry: 'openai',
          license: 'MIT',
          task: 'text-generation',
          description: 'A model',
          summary: 'Great',
          tags: ['popular'],
        ),
      ]);
      final json = list.toJson();
      expect(json.length, 1);
      expect(json[0]['id'], 'gpt-4');
    });
  });
}