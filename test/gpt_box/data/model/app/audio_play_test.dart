import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_box/data/model/app/audio_play.dart';

void main() {
  group('AudioPlayStatus', () {
    test('constructor sets defaults correctly', () {
      const status = AudioPlayStatus(id: 'test-id');
      expect(status.id, 'test-id');
      expect(status.played, 0);
      expect(status.total, 0);
      expect(status.playing, false);
    });

    test('constructor with all parameters', () {
      const status = AudioPlayStatus(
        id: 'audio-1',
        played: 30000,
        total: 120000,
        playing: true,
      );
      expect(status.id, 'audio-1');
      expect(status.played, 30000);
      expect(status.total, 120000);
      expect(status.playing, true);
    });

    test('copyWith modifies specified fields', () {
      const status = AudioPlayStatus(id: 'audio-1');
      final modified = status.copyWith(played: 5000, playing: true);
      expect(modified.id, 'audio-1');
      expect(modified.played, 5000);
      expect(modified.total, 0);
      expect(modified.playing, true);
    });

    test('copyWith preserves unspecified fields', () {
      const status = AudioPlayStatus(
        id: 'audio-1',
        played: 10000,
        total: 60000,
        playing: true,
      );
      final modified = status.copyWith(played: 20000);
      expect(modified.id, 'audio-1');
      expect(modified.played, 20000);
      expect(modified.total, 60000);
      expect(modified.playing, true);
    });

    group('progress', () {
      test('formats played and total time', () {
        const status = AudioPlayStatus(
          id: 'test',
          played: 65000, // 1 min 5 sec
          total: 180000,  // 3 min 0 sec
        );
        expect(status.progress, '01:05 / 03:00');
      });

      test('handles zero values', () {
        const status = AudioPlayStatus(id: 'test');
        expect(status.progress, '00:00 / 00:00');
      });

      test('pads single digit seconds', () {
        const status = AudioPlayStatus(
          id: 'test',
          played: 5000,  // 0 min 5 sec
          total: 90000,  // 1 min 30 sec
        );
        expect(status.progress, '00:05 / 01:30');
      });

      test('handles hours worth of milliseconds', () {
        const status = AudioPlayStatus(
          id: 'test',
          played: 3661000,  // 61 min 1 sec -> 61:01
          total: 7200000,  // 120 min 0 sec -> 120:00
        );
        // inMinutes returns total minutes (61), remainder gives seconds
        expect(status.progress, '61:01 / 120:00');
      });
    });

    test('toString contains useful information', () {
      const status = AudioPlayStatus(
        id: 'test-id',
        played: 1000,
        total: 5000,
        playing: true,
      );
      final str = status.toString();
      expect(str, contains('test-id'));
      expect(str, contains('1000'));
      expect(str, contains('5000'));
      expect(str, contains('true'));
    });
  });
}