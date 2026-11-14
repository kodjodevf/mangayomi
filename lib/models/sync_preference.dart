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

  /// `https://ip:port` of a host on another device, the sync server's URL,
  /// or [thisDeviceHost].
  String? server;

  /// The SHA-256 of the host's certificate when [server] is a host on
  /// another device: the only certificate this device accepts from it.
  String? hostFingerprint;

  /// Every address the host's invite gave, [server] among them: tried in
  /// turn when [server] does not answer, such as a home network address
  /// away from home.
  List<String>? hostAddresses;

  /// Whether this device hosts sync for the others, from app launch on.
  bool hostEnabled = false;

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
    this.hostFingerprint,
    this.hostAddresses,
    this.hostEnabled = false,
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
    hostFingerprint = json['hostFingerprint'];
    hostAddresses = (json['hostAddresses'] as List?)?.cast<String>();
    hostEnabled = json['hostEnabled'] ?? false;
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
    'hostFingerprint': hostFingerprint,
    'hostAddresses': hostAddresses,
    'hostEnabled': hostEnabled,
    'syncOn': syncOn,
    'autoSyncFrequency': autoSyncFrequency,
    'lastSync': lastSync,
  };

  /// [server] when this device syncs with the host it runs itself.
  static const thisDeviceHost = 'mangayomi-sync://this-device';

  /// The addresses to try for the host, the one that last answered first.
  @ignore
  List<String> get peerAddresses => [
    ?server,
    for (final address in hostAddresses ?? const <String>[])
      if (address != server) address,
  ];

  /// Whether this device has something to sync with: the sync server it
  /// logged into, or a host, its own or one it paired with.
  @ignore
  bool get isConnected =>
      (server?.isNotEmpty ?? false) &&
      ((authToken?.isNotEmpty ?? false) ||
          hostFingerprint != null ||
          server == thisDeviceHost);
}
