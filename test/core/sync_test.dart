import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:llmbox/core/util/sync.dart';

void main() {
  test('runs one at a time; a burst during one is one more', () async {
    final runs = SerialRuns();
    var running = 0, started = 0;
    final gate = Completer<void>();
    Future<void> body() async {
      expect(running, 0, reason: 'never two at once');
      running++;
      started++;
      if (started == 1) await gate.future;
      running--;
    }

    final first = runs.soon(body);
    await Future<void>.delayed(Duration.zero);
    expect(started, 1);
    // Edits while the first is slow: they wait as one.
    final waiting = [for (var i = 0; i < 50; i++) runs.soon(body)];
    expect(waiting.toSet(), hasLength(1));
    gate.complete();
    await first;
    await waiting.first;
    expect(started, 2);
    // A later burst is a run of its own.
    await runs.soon(body);
    expect(started, 3);
  });
}
