import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/repositories/changed_part_repository.dart';
import 'package:mangayomi/repositories/sync_preference_repository.dart';
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
    final fromHost =
        state.hostFingerprint != null ||
        state.server == SyncPreference.thisDeviceHost;
    syncPreferenceRepository.save(
      state
        ..server = server
        ..email = email
        ..authToken = authToken
        ..hostFingerprint = null
        ..hostAddresses = null,
    );
    // What the host sent says nothing of what the server has.
    if (fromHost) _startOver();
    ref.invalidateSelf();
  }

  void logout() {
    syncPreferenceRepository.save(state..authToken = null);
    ref.invalidateSelf();
  }

  /// Syncs from now on with the host at [server], whose certificate has
  /// [fingerprint], from the start: it has nothing this device sent yet.
  /// [addresses] are the others it may be reached at.
  Future<void> useHost(
    String server,
    String fingerprint, {
    List<String> addresses = const [],
  }) async {
    _startOver();
    await syncPreferenceRepository.save(
      state
        ..server = server
        ..hostFingerprint = fingerprint
        ..hostAddresses = addresses.isEmpty ? null : addresses
        ..authToken = null
        ..email = null,
    );
    ref.invalidateSelf();
  }

  /// Syncs from now on with the host this device runs, from the start.
  Future<void> useThisDeviceAsHost() async {
    _startOver();
    await syncPreferenceRepository.save(
      state
        ..server = SyncPreference.thisDeviceHost
        ..hostFingerprint = null
        ..hostAddresses = null
        ..authToken = null
        ..email = null,
    );
    ref.invalidateSelf();
  }

  Future<void> setHostEnabled(bool value) async {
    await syncPreferenceRepository.save(state..hostEnabled = value);
    ref.invalidateSelf();
  }

  /// Stops syncing with a host, this device's or another's.
  Future<void> leaveHost() async {
    await syncPreferenceRepository.save(
      state
        ..server = null
        ..hostFingerprint = null
        ..hostAddresses = null,
    );
    ref.invalidateSelf();
  }

  /// The host answered at [address], one of its others: tried first from
  /// now on. Nothing else changes, it is the same host.
  Future<void> rememberHostAddress(String address) async {
    if (state.server == address || state.hostFingerprint == null) return;
    await syncPreferenceRepository.save(state..server = address);
    ref.invalidateSelf();
  }

  /// The next sync sends everything and takes everything.
  void _startOver() {
    state
      ..since = 0
      ..sessionToken = null
      ..lastSync = null;
  }

  void setSince(int timestamp) {
    syncPreferenceRepository.save(state..since = timestamp);
    ref.invalidateSelf();
  }

  void setLastSync(int timestamp) {
    syncPreferenceRepository.save(state..lastSync = timestamp);
    ref.invalidateSelf();
  }

  /// Records a finished sync: `since` (the server's syncedAt watermark) and
  /// `lastSync` in ONE write, awaited before the provider is invalidated.
  ///
  /// Calling setSince() then setLastSync() back to back loses `since`:
  /// save() only queues the Isar write (DbWriteQueue runs it on a later
  /// microtask), and invalidateSelf() marks the provider dirty, so the very
  /// next `state` read in setLastSync() rebuilds synchronously from Isar
  /// (Riverpod flush()) and gets the row as it still is on disk - with the
  /// OLD since. That stale object is then saved with lastSync set, and its
  /// write lands after the first one, overwriting since with the old value.
  /// Net effect: since never advances and every sync is a full sync.
  Future<void> setSynced({required int since, required int lastSync}) async {
    await syncPreferenceRepository.save(
      state
        ..since = since
        ..lastSync = lastSync,
    );
    ref.invalidateSelf();
  }

  void setServer(String? server) {
    syncPreferenceRepository.save(state..server = server);
    ref.invalidateSelf();
  }

  void setSyncOn(bool value) {
    syncPreferenceRepository.save(state..syncOn = value);
    ref.invalidateSelf();
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
