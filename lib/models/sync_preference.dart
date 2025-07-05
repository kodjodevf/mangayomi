import 'package:isar/isar.dart';
part 'sync_preference.g.dart';

@collection
@Name("Sync Preference")
class SyncPreference {
  Id? syncId;

  String? email;

  String? authToken;

  int? lastSyncManga;

  int? lastSyncHistory;

  int? lastSyncUpdate;

  String? server;

  bool syncOn = false;

  int autoSyncFrequency = 0;

  SyncPreference({
    this.syncId,
    this.email,
    this.authToken,
    this.lastSyncManga,
    this.lastSyncHistory,
    this.lastSyncUpdate,
    this.server,
    this.syncOn = false,
    this.autoSyncFrequency = 0,
  });

  SyncPreference.fromJson(Map<String, dynamic> json) {
    syncId = json['syncId'];
    email = json['email'];
    authToken = json['authToken'];
    lastSyncManga = json['lastSyncManga'];
    lastSyncHistory = json['lastSyncHistory'];
    lastSyncUpdate = json['lastSyncUpdate'];
    server = json['server'];
    syncOn = json['syncOn'] ?? false;
    syncOn = json['autoSyncFrequency'] ?? 0;
  }

  Map<String, dynamic> toJson() => {
    'syncId': syncId,
    'email': email,
    'authToken': authToken,
    'lastSyncManga': lastSyncManga,
    'lastSyncHistory': lastSyncHistory,
    'lastSyncUpdate': lastSyncUpdate,
    'syncOn': syncOn,
    'autoSyncFrequency': autoSyncFrequency,
  };
}
