import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/backup_password_fallback.dart';

/// Thrown by [BackupPasswordStorage.save] when the OS-backed secure storage
/// (Keychain / Keystore / Credential Manager / libsecret) isn't available -
/// in practice, a Linux system with no keyring service running. The caller
/// should ask the user whether to fall back to storing the password
/// unencrypted via [BackupPasswordStorage.savePlaintextFallback], or skip
/// persisting it entirely.
class SecureStorageUnavailableException implements Exception {
  final Object cause;
  SecureStorageUnavailableException(this.cause);

  @override
  String toString() => 'SecureStorageUnavailableException: $cause';
}

/// Persists the backup-encryption password. Secure OS storage is always
/// tried first; the plaintext Isar fallback is only ever written to via an
/// explicit, separate call, never automatically - so a caller can't
/// accidentally end up storing the password unencrypted without the user
/// having been asked first.
class BackupPasswordStorage {
  BackupPasswordStorage._();

  static const _secureStorage = FlutterSecureStorage();
  static const _key = 'backup_encryption_password';

  /// Saves [password] to secure OS storage.
  ///
  /// Throws [SecureStorageUnavailableException] if secure storage isn't
  /// available on this platform/system (e.g. Linux with no keyring
  /// service) - the caller is expected to catch this and decide whether to
  /// prompt the user for the plaintext-fallback opt-in.
  static Future<void> save(String password) async {
    try {
      await _secureStorage.write(key: _key, value: password);
      // If a plaintext fallback value exists from a previous failed attempt,
      // clear it now that secure storage succeeded, so we don't end up with
      // the password sitting in both places.
      await _clearPlaintextFallback();
    } catch (e) {
      throw SecureStorageUnavailableException(e);
    }
  }

  /// Explicit opt-in path: stores [password] unencrypted in a local-only
  /// Isar collection (never synced). Only ever call this after the user has
  /// been told what it means and has agreed.
  static Future<void> savePlaintextFallback(String password) async {
    await isar.writeTxn(() async {
      await isar.backupPasswordFallbacks.put(
        BackupPasswordFallback()..password = password,
      );
    });
  }

  /// Reads the stored password, checking secure storage first and falling
  /// back to the plaintext Isar fallback collection. Returns null if
  /// nothing is stored in either place.
  static Future<String?> get() async {
    try {
      final fromSecure = await _secureStorage.read(key: _key);
      if (fromSecure != null) return fromSecure;
    } catch (_) {
      // Fall through to the plaintext fallback below.
    }
    final fallback = await isar.backupPasswordFallbacks
        .filter()
        .idEqualTo(0)
        .findFirst();
    return fallback?.password;
  }

  /// Clears the password from both secure storage and the plaintext
  /// fallback, if present in either.
  static Future<void> clear() async {
    try {
      await _secureStorage.delete(key: _key);
    } catch (_) {
      // Secure storage may be unavailable; nothing to do.
    }
    await _clearPlaintextFallback();
  }

  static Future<void> _clearPlaintextFallback() async {
    await isar.writeTxn(() async {
      await isar.backupPasswordFallbacks.delete(0);
    });
  }
}
