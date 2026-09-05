import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_progress_provider.g.dart';

/// UI-only, unpersisted progress for a sync's network round trip; `total` mixes upload chunks and download rows as generic units of work and stays null until the server's totalCounts arrives.
class SyncProgressState {
  final bool active;
  final int done;
  final int? total;

  const SyncProgressState({this.active = false, this.done = 0, this.total});

  double? get fraction =>
      (!active || total == null || total == 0) ? null : (done / total!).clamp(0.0, 1.0);
}

@riverpod
class SyncProgress extends _$SyncProgress {
  @override
  SyncProgressState build({required int syncId}) {
    ref.keepAlive();
    return const SyncProgressState();
  }

  void begin() => state = const SyncProgressState(active: true);

  void addTotal(int n) {
    if (n == 0) return;
    state = SyncProgressState(active: true, done: state.done, total: (state.total ?? 0) + n);
  }

  void addDone(int n) {
    if (n == 0) return;
    state = SyncProgressState(active: true, done: state.done + n, total: state.total);
  }

  void finish() => state = const SyncProgressState();
}
