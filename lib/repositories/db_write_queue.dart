import 'dart:async';

class DbWriteQueue {
  Future<void> _tail = Future.value();

  // Chains every write onto the same Future tail so none overlap in Isar's transaction lock.
  Future<T> run<T>(FutureOr<T> Function() body) {
    final result = _tail.then((_) => body());
    _tail = result.then((_) {}, onError: (_) {});
    return result;
  }
}

// Only serializes the main isolate; isolate_service.dart's worker isar instance isn't covered.
final dbWriteQueue = DbWriteQueue();
