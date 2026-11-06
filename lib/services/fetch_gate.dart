import 'dart:async';

/// Caps how many source rows fetch at once.
///
/// Every row used to call getPopular/search in initState, so opening the
/// screen fired one isolate evaluation per installed source simultaneously —
/// the more extensions installed, the worse the stall. Gating it to a
/// handful in flight keeps the device's isolate pool from being flooded
/// while still finishing the full scan in the background.
class FetchGate {
  FetchGate(this._maxConcurrent);
  final int _maxConcurrent;
  int _active = 0;
  final _waiting = <Completer<void>>[];

  Future<void> acquire() async {
    if (_active < _maxConcurrent) {
      _active++;
      return;
    }
    final completer = Completer<void>();
    _waiting.add(completer);
    await completer.future;
    _active++;
  }

  void release() {
    _active--;
    if (_waiting.isNotEmpty) _waiting.removeAt(0).complete();
  }
}
