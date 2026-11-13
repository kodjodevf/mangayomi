/// A device allowed to sync with a host or server.
class PairedDevice {
  const PairedDevice({
    required this.fingerprint,
    required this.name,
    required this.pairedAt,
    this.lastSyncAt,
  });

  factory PairedDevice.fromJson(Map<String, dynamic> json) => PairedDevice(
    fingerprint: json['fingerprint'] as String,
    name: json['name'] as String,
    pairedAt: json['pairedAt'] as int,
    lastSyncAt: json['lastSyncAt'] as int?,
  );

  /// SHA-256 of the device's certificate: what the host checks.
  final String fingerprint;

  /// What the device called itself when it paired; for the user only.
  final String name;
  final int pairedAt;

  /// When it last synced, where the host keeps track.
  final int? lastSyncAt;

  Map<String, dynamic> toJson() => {
    'fingerprint': fingerprint,
    'name': name,
    'pairedAt': pairedAt,
    if (lastSyncAt != null) 'lastSyncAt': lastSyncAt,
  };
}
