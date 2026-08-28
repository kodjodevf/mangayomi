import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// #925 is `Assertion failed: "[Player] has been disposed"`.
///
/// media_kit guards every entry point with `if (disposed) throw
/// AssertionError('[Player] has been disposed')`, so that message means the
/// app used the player after tearing it down. The player view starts its
/// playback by chaining off an async font load:
///
/// ```dart
/// _loadAndroidFont().then((_) {
///   _openMedia(...);          // -> _player.open()
///   _setPlaybackSpeed(...);   // -> _player.setRate()
///   _initAniSkip();           // -> _player.stream...
/// });
/// ```
///
/// Loading the font writes a file, so that callback can land after the reader
/// has already pressed back. These cover the shape of that, since the real
/// widget needs a video, a native player and a source to build at all.
void main() {
  testWidgets('a pending callback fires after the widget is gone', (
    tester,
  ) async {
    // The premise. If this were not true there would be nothing to guard.
    final completer = Completer<void>();
    var firedAfterDisposal = false;
    late _ProbeState state;

    await tester.pumpWidget(
      MaterialApp(
        home: _Probe(
          work: completer.future,
          onDone: (s) {
            if (!s.mounted) firedAfterDisposal = true;
          },
          onState: (s) => state = s,
        ),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(state.mounted, false, reason: 'the reader has left');

    completer.complete();
    await tester.pump();

    expect(firedAfterDisposal, true);
  });

  testWidgets('guarding on mounted keeps it off the disposed player', (
    tester,
  ) async {
    final completer = Completer<void>();
    var touchedPlayer = false;

    await tester.pumpWidget(
      MaterialApp(
        home: _Probe(
          work: completer.future,
          // The shape the fix uses: bail before anything touches the player.
          onDone: (s) {
            if (!s.mounted) return;
            touchedPlayer = true;
          },
          onState: (_) {},
        ),
      ),
    );

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    completer.complete();
    await tester.pump();

    expect(touchedPlayer, false);
  });

  testWidgets('and still runs normally when the reader stays', (tester) async {
    final completer = Completer<void>();
    var touchedPlayer = false;

    await tester.pumpWidget(
      MaterialApp(
        home: _Probe(
          work: completer.future,
          onDone: (s) {
            if (!s.mounted) return;
            touchedPlayer = true;
          },
          onState: (_) {},
        ),
      ),
    );

    completer.complete();
    await tester.pump();

    expect(touchedPlayer, true, reason: 'the guard must not break the app');
  });
}

/// Stands in for the player view: kicks off async work in initState and acts
/// on it when it finishes.
class _Probe extends StatefulWidget {
  const _Probe({
    required this.work,
    required this.onDone,
    required this.onState,
  });
  final Future<void> work;
  final void Function(_ProbeState) onDone;
  final void Function(_ProbeState) onState;
  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  @override
  void initState() {
    super.initState();
    widget.onState(this);
    widget.work.then((_) => widget.onDone(this));
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}
