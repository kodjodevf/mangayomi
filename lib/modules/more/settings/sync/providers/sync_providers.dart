import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/repositories/changed_part_repository.dart';
import 'package:mangayomi/repositories/sync_preference_repository.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'sync_providers.g.dart';

@riverpod
class Synching extends _$Synching {
  @override
  SyncPreference build({required int? syncId}) {
    ref.keepAlive();
    return syncPreferenceRepository.getById(syncId!) ??
        SyncPreference(syncId: 1);
  }

  void login(String server, String email, String authToken) {
    syncPreferenceRepository.save(
      state
        ..server = server
        ..email = email
        ..authToken = authToken,
    );
    ref.invalidateSelf();
    ref.invalidate(syncServerProvider(syncId: syncId!));
  }

  void logout() {
    syncPreferenceRepository.save(state..authToken = null);
    ref.invalidateSelf();
    ref.invalidate(syncServerProvider(syncId: syncId!));
  }

  void setSince(int timestamp) {
    syncPreferenceRepository.save(state..since = timestamp);
  }

  void setLastSync(int timestamp) {
    syncPreferenceRepository.save(state..lastSync = timestamp);
  }

  void setServer(String? server) {
    syncPreferenceRepository.save(state..server = server);
  }

  void setSyncOn(bool value) {
    syncPreferenceRepository.save(state..syncOn = value);
  }

  void setAutoSyncFrequency(int value) {
    syncPreferenceRepository.save(state..autoSyncFrequency = value);
    ref.invalidateSelf();
  }

  List<ChangedPart> getAllChangedParts() => changedPartRepository.getAll();

  List<ChangedPart> getChangedParts(List<ActionType> actionTypes) =>
      changedPartRepository.getByActions(actionTypes);

  void addChangedPart(
    ActionType action,
    int? isarId,
    Object data,
    bool writeTxn, {
    int? clientId,
  }) {
    if (!state.syncOn) return;
    changedPartRepository.add(
      action,
      isarId,
      data,
      writeTxn,
      clientId: clientId,
    );
  }

  Future<void> addChangedPartAsync(
    ActionType action,
    int? isarId,
    Object data,
    bool writeTxn, {
    int? clientId,
  }) async {
    if (!state.syncOn) return;
    await changedPartRepository.addAsync(
      action,
      isarId,
      data,
      writeTxn,
      clientId: clientId,
    );
  }

  Future<void> clearChangedParts(List<ActionType> actions, bool txn) =>
      changedPartRepository.clear(actions, txn);

  void clearAllChangedParts(bool txn) => changedPartRepository.clearAll(txn);
}

/// True while a restore (and its post-restore upload) is in progress.
/// main_screen.dart pauses the auto-sync timer while this is true, and
/// syncServerProvider itself checks it too, so a manual sync trigger or an
/// already-running periodic timer can't race with an in-progress restore.
@riverpod
class RestoreSyncGuard extends _$RestoreSyncGuard {
  @override
  bool build() {
    ref.keepAlive();
    return false;
  }

  void start() => state = true;
  void finish() => state = false;
}
