import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'sync_providers.g.dart';

@riverpod
class Synching extends _$Synching {
  @override
  SyncPreference? build({required int? syncId}) {
    return isar.syncPreferences.getSync(syncId!);
  }

  void login(SyncPreference syncPreference) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(syncPreference);
    });
  }

  void logout() {
    isar.writeTxnSync(() {
      isar.syncPreferences.deleteSync(syncId!);
    });
  }

  void setLastSync(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(isar.syncPreferences.getSync(syncId!)!..lastSync = timestamp);
    });
  }

  void setLastUpload(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(isar.syncPreferences.getSync(syncId!)!..lastUpload = timestamp);
    });
  }

  void setLastDownload(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(isar.syncPreferences.getSync(syncId!)!..lastDownload = timestamp);
    });
  }

  void setServer(String? server) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(isar.syncPreferences.getSync(syncId!)!..server = server);
    });
  }
}

@riverpod
class SyncOnAppLaunchState extends _$SyncOnAppLaunchState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.syncOnAppLaunch ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..syncOnAppLaunch = value));
  }
}

@riverpod
class SyncAfterReadingState extends _$SyncAfterReadingState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.syncAfterReading ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..syncAfterReading = value));
  }
}
