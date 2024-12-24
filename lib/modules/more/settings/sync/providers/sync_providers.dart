import 'package:mangayomi/main.dart';
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

  void setLastUpload(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(
          isar.syncPreferences.getSync(syncId!)!..lastUpload = timestamp);
    });
  }

  void setLastDownload(int timestamp) {
    isar.writeTxnSync(() {
      isar.syncPreferences.putSync(
          isar.syncPreferences.getSync(syncId!)!..lastDownload = timestamp);
    });
  }

  void setServer(String? server) {
    isar.writeTxnSync(() {
      isar.syncPreferences
          .putSync(isar.syncPreferences.getSync(syncId!)!..server = server);
    });
  }
}
