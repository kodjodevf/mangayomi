import 'package:isar_community/isar.dart';
part 'backup_password_fallback.g.dart';

/// Local-only, explicit opt-in fallback storage for the backup encryption
/// password, used only when the OS-backed secure storage (Keychain /
/// Keystore / Credential Manager / libsecret) is unavailable - in practice,
/// Linux systems with no keyring service (gnome-keyring / kwallet) running.
///
/// Deliberately kept as its own collection, separate from [Settings]:
/// [Settings] can be pushed to other devices via the settings-sync feature
/// (see `syncSettings` in sync_providers.dart), and this collection must
/// never be swept up in that - it's local-device-only, opt-in, and only
/// ever populated after the user has explicitly acknowledged storing it
/// unencrypted.
@collection
@Name("BackupPasswordFallback")
class BackupPasswordFallback {
  Id id = 0;

  String? password;
}
