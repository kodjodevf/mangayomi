import 'package:isar/isar.dart';
part 'sync_preference.g.dart';

@collection
@Name("Sync Preference")
class SyncPreference {
  Id? syncId;

  String? email;

  String? authToken;

  int? lastSync;

  int? lastUpload;

  int? lastDownload;

  String? server;

  bool syncOn = false;

  SyncPreference({
    this.syncId,
    this.email,
    this.authToken,
    this.lastSync,
    this.lastUpload,
    this.lastDownload,
    this.server,
    this.syncOn = false,
  });

  SyncPreference.fromJson(Map<String, dynamic> json) {
    syncId = json['syncId'];
    email = json['email'];
    authToken = json['authToken'];
    lastSync = json['lastSync'];
    lastUpload = json['lastUpload'];
    lastDownload = json['lastDownload'];
    server = json['server'];
    syncOn = json['syncOn'] ?? false;
  }

  Map<String, dynamic> toJson() => {
        'syncId': syncId,
        'email': email,
        'authToken': authToken,
        'lastSync': lastSync,
        'lastUpload': lastUpload,
        'lastDownload': lastDownload,
        'syncOn': syncOn
      };
}
