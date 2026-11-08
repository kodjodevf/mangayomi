import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/fetch_gate.dart';

void main() {
  test('lets only so many fetch at once, then the rest in turn', () async {
    final gate = FetchGate(2);
    final started = <int>[];
    final finish = [for (var i = 0; i < 5; i++) Completer<void>()];
    var active = 0;
    var mostActive = 0;

    final fetches = [
      for (var i = 0; i < 5; i++)
        () async {
          await gate.acquire();
          try {
            started.add(i);
            active++;
            if (active > mostActive) mostActive = active;
            await finish[i].future;
            active--;
          } finally {
            gate.release();
          }
        }(),
    ];

    await pumpEventQueue();
    expect(started, [0, 1]);

    finish[1].complete();
    await pumpEventQueue();
    expect(started, [0, 1, 2]);

    for (final completer in finish) {
      if (!completer.isCompleted) completer.complete();
    }
    await Future.wait(fetches);
    expect(started, [0, 1, 2, 3, 4]);
    expect(mostActive, 2);
  });
}
