import 'package:isar_community/isar.dart';
part 'sync_preference.g.dart';

@collection
@Name("Sync Preference")
class SyncPreference {
  Id? syncId;

  String? email;

  String? authToken;

  int? since;

  String? sessionToken;

  String? server;

  bool syncOn = false;

  int autoSyncFrequency = 0;

  int? lastSync;

  SyncPreference({
    this.syncId,
    this.email,
    this.authToken,
    this.since,
    this.sessionToken,
    this.server,
    this.syncOn = false,
    this.autoSyncFrequency = 0,
    this.lastSync,
  });

  SyncPreference.fromJson(Map<String, dynamic> json) {
    syncId = json['syncId'];
    email = json['email'];
    authToken = json['authToken'];
    since = json['since'];
    sessionToken = json['sessionToken'];
    server = json['server'];
    syncOn = json['syncOn'] ?? false;
    autoSyncFrequency = json['autoSyncFrequency'] ?? 0;
    lastSync = json['lastSync'];
  }

  Map<String, dynamic> toJson() => {
    'syncId': syncId,
    'email': email,
    'authToken': authToken,
    'since': since,
    'sessionToken': sessionToken,
    'server': server,
    'syncOn': syncOn,
    'autoSyncFrequency': autoSyncFrequency,
    'lastSync': lastSync,
  };
}
