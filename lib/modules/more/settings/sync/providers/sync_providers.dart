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

  void setLastSyncManga(int timestamp) {
    syncPreferenceRepository.save(state..lastSyncManga = timestamp);
  }

  void setLastSyncHistory(int timestamp) {
    syncPreferenceRepository.save(state..lastSyncHistory = timestamp);
  }

  void setLastSyncUpdate(int timestamp) {
    syncPreferenceRepository.save(state..lastSyncUpdate = timestamp);
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

  void setSyncHistories(bool value) {
    syncPreferenceRepository.save(state..syncHistories = value);
    ref.invalidateSelf();
  }

  void setSyncUpdates(bool value) {
    syncPreferenceRepository.save(state..syncUpdates = value);
    ref.invalidateSelf();
  }

  void setSyncSettings(bool value) {
    syncPreferenceRepository.save(state..syncSettings = value);
    ref.invalidateSelf();
  }

  List<ChangedPart> getAllChangedParts() => changedPartRepository.getAll();

  List<ChangedPart> getChangedParts(List<ActionType> actionTypes) =>
      changedPartRepository.getByActions(actionTypes);

  void addChangedPart(
    ActionType action,
    int? isarId,
    Object data,
    bool writeTxn,
  ) {
    if (!state.syncOn) return;
    changedPartRepository.add(action, isarId, data, writeTxn);
  }

  Future<void> addChangedPartAsync(
    ActionType action,
    int? isarId,
    Object data,
    bool writeTxn,
  ) async {
    if (!state.syncOn) return;
    await changedPartRepository.addAsync(action, isarId, data, writeTxn);
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
