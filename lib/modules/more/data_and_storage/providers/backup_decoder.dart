// Decoding a mangayomi-format backup's JSON contents, transparently
// handling AES-encrypted backups. Kept apart from restore.dart: this only
// reads and decrypts a file, it never touches Isar.
import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/backup_encryption_password_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/backup_password_storage.dart';

/// Tries with no password, then the locally-stored password (if any), then
/// prompts the user - retrying on a wrong password until it succeeds or the
/// user cancels.
///
/// On success, if the backup embeds an encryption password (see
/// `backup.dart`), persists it locally so future backups/restores on this
/// device don't need it retyped - mirroring how every other part of a
/// restored backup overwrites the local settings, just kept out of the
/// generic Settings JSON round-trip (see backup_password_fallback.dart).
///
/// Public so the restore UI can decode+preview a mangayomi-format backup
/// (merge/replace choice, category/source conflicts) before committing to
/// the actual restore - doRestore accepts the result back as
/// decodedMangayomiBackup so it isn't decrypted (and the password
/// re-prompted) a second time.
Future<Map<String, dynamic>> decodeMangayomiBackup(
  String path,
  BuildContext context,
) async {
  String? passwordToTry;
  var triedStoredPassword = false;
  var wasIncorrect = false;
  final l10n = l10nLocalizations(context)!;

  while (true) {
    final stream = InputFileStream(path);
    try {
      final archive = ZipDecoder().decodeStream(
        stream,
        password: passwordToTry,
      );
      // decodeStream() only parses headers and buffers raw compressed
      // bytes - it doesn't verify/decrypt content (and so won't throw on a
      // wrong password) until the content is actually read, hence forcing
      // that access here rather than after returning.
      final bytes = archive.files.first.content as List<int>;
      final backup = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;

      final embeddedPassword = backup['backupEncryptionPassword'] as String?;
      if (embeddedPassword != null && context.mounted) {
        await persistResolvedPassword(embeddedPassword, context);
      }
      return backup;
    } catch (_) {
      if (!triedStoredPassword) {
        triedStoredPassword = true;
        final stored = await BackupPasswordStorage.get();
        if (stored != null) {
          passwordToTry = stored;
          continue;
        }
      }
      if (!context.mounted) rethrow;
      final entered = await showBackupDecryptPasswordDialog(
        context,
        wasIncorrect: wasIncorrect,
      );
      if (entered == null) {
        throw Exception(l10n.password_required_to_restore);
      }
      passwordToTry = entered;
      wasIncorrect = true;
    } finally {
      stream.close();
    }
  }
}
