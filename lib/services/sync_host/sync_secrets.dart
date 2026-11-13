// What makes this device known to the others it syncs with, kept in the
// OS secure storage: its key and certificate, and on a host, which devices
// may sync with it. A device that cannot keep them there cannot host or
// pair: there is no plain-text fallback for a private key.
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi/src/rust/api/sync_host.dart';

/// Where the secrets go: the OS secure storage, or a map in tests.
abstract interface class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecureSecretStore implements SecretStore {
  const SecureSecretStore();

  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class SyncSecrets {
  SyncSecrets([this._store = const SecureSecretStore()]);

  final SecretStore _store;

  static const _identityKey = 'sync_identity';
  static const _pairedKey = 'sync_host_paired_devices';
  static const _portKey = 'sync_host_port';

  /// This device's identity, made the first time it is needed.
  Future<SyncIdentity> identity() async {
    final stored = await _store.read(_identityKey);
    if (stored != null) {
      final json = jsonDecode(stored) as Map<String, dynamic>;
      final certificatePem = json['certificatePem'] as String;
      return SyncIdentity(
        privateKeyPem: json['privateKeyPem'] as String,
        certificatePem: certificatePem,
        // Worked out again rather than trusted from storage.
        fingerprint: syncFingerprintOfCertificate(
          certificatePem: certificatePem,
        ),
      );
    }
    final identity = await syncGenerateIdentity();
    await _store.write(
      _identityKey,
      jsonEncode({
        'privateKeyPem': identity.privateKeyPem,
        'certificatePem': identity.certificatePem,
      }),
    );
    return identity;
  }

  /// Forgets this device's identity: every device it paired with, or that
  /// paired with it, has to pair again.
  Future<void> resetIdentity() async {
    await _store.delete(_identityKey);
    await _store.delete(_pairedKey);
  }

  Future<List<PairedDevice>> pairedDevices() async {
    final stored = await _store.read(_pairedKey);
    if (stored == null) return const [];
    return [
      for (final json in jsonDecode(stored) as List)
        PairedDevice.fromJson(json as Map<String, dynamic>),
    ];
  }

  Future<void> addPairedDevice(PairedDevice device) async {
    final devices = await pairedDevices();
    await _savePaired([
      for (final known in devices)
        if (known.fingerprint != device.fingerprint) known,
      device,
    ]);
  }

  Future<void> removePairedDevice(String fingerprint) async {
    final devices = await pairedDevices();
    await _savePaired([
      for (final known in devices)
        if (known.fingerprint != fingerprint) known,
    ]);
  }

  Future<void> _savePaired(List<PairedDevice> devices) => _store.write(
    _pairedKey,
    jsonEncode([for (final device in devices) device.toJson()]),
  );

  /// The port the host last listened on, so paired devices find it again.
  Future<int?> hostPort() async =>
      int.tryParse(await _store.read(_portKey) ?? '');

  Future<void> saveHostPort(int port) => _store.write(_portKey, '$port');
}
