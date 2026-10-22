import 'dart:async';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_decoder.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_format.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/kotatsu_restore_service.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/mangayomi_restore_service.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/tachiyomi_restore_service.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restore.g.dart';

/// Restores the backup at [path], replacing or merging into the library.
///
/// Throws when the restore fails, and leaves reporting it to the caller: the
/// restore flows announce the outcome themselves, so an error swallowed here
/// used to be followed by their success message.
@riverpod
Future<void> doRestore(
  Ref ref, {
  required String path,
  required BuildContext context,
  bool merge = false,
  Map<String, bool> categoryDecisions = const {},
  Map<String, int> sourceDecisions = const {},
  // Already-decoded/decrypted mangayomi-format backup, if the caller ran
  // decodeMangayomiBackup itself to preview it first. Skips re-decoding
  // (and re-prompting for a password) here.
  Map<String, dynamic>? decodedMangayomiBackup,
  // Caller's answer to "upload this restore to your sync server?", asked
  // only when a server was connected. true = upload, false = the user chose
  // to turn sync off instead (so stale server data can't come back and
  // undo this restore), null = no server was connected, nothing to do.
  bool? syncAfterRestore,
}) async {
  // Without this, doRestore is autoDispose with only the calling widget's
  // watch keeping it alive — if that widget unmounts mid-restore (dialog
  // closes, screen pops), the provider gets disposed mid-flight and every
  // ref use below throws UnmountedRefException.
  final keepAliveLink = ref.keepAlive();
  // Resolved before any await, so it's safe to use after one.
  final l10n = l10nLocalizations(context);
  // Yield once first: doRestore is itself a provider, and mutating another
  // provider synchronously before its first await counts as modifying it
  // "during initialization", which Riverpod forbids. A microtask (not a
  // real delay) so no frame runs in between — a real delay let the busy
  // dialog close and unmount this autoDispose provider's context first.
  await Future<void>.value();
  // Blocks the auto-sync timer and any manual sync trigger until this
  // restore (and its post-restore upload, if any) finishes — otherwise
  // either could race the restore and pull stale server data back down.
  ref.read(restoreSyncGuardProvider.notifier).start();
  var uploadStarted = false;
  try {
    // Zip filenames aren't encrypted even when file content is, so this
    // initial pass (no password) is always enough to list files and
    // determine backup type. Password resolution only happens below, and
    // only for the mangayomi format, right before reading file *content*.
    final probeStream = InputFileStream(path);
    final Archive archive;
    try {
      archive = ZipDecoder().decodeStream(probeStream);
    } finally {
      probeStream.close();
    }
    final backupType = checkBackupType(path, archive);
    switch (backupType) {
      case BackupType.mangayomi:
        if (!context.mounted) return;
        final backup =
            decodedMangayomiBackup ??
            await decodeMangayomiBackup(path, context);
        final restoreProvider = restoreBackupProvider(
          backup,
          merge: merge,
          categoryDecisions: categoryDecisions,
          sourceDecisions: sourceDecisions,
        );
        // Listened to so the auto-dispose sub-provider lives until we're done.
        ref.listen(restoreProvider, (_, _) {}, onError: (_, _) {});
        await ref.read(restoreProvider.future);
        break;
      case BackupType.kotatsu:
        final restoreProvider = restoreKotatsuBackupProvider(archive);
        ref.listen(restoreProvider, (_, _) {}, onError: (_, _) {});
        await ref.read(restoreProvider.future);
        break;
      case BackupType.mihon:
      case BackupType.aniyomi:
      case BackupType.neko:
        final restoreProvider = restoreTachiBkBackupProvider(
          path,
          backupType,
          merge: merge,
          categoryDecisions: categoryDecisions,
          sourceDecisions: sourceDecisions,
        );
        ref.listen(restoreProvider, (_, _) {}, onError: (_, _) {});
        await ref.read(restoreProvider.future);
        break;
      default:
    }
    if (backupType != BackupType.unknown) {
      showBotToast("Backup restored!");
      if (syncAfterRestore == false) {
        // User declined to push this restore to the server — turn sync off
        // rather than leave it running, since the next sync would otherwise
        // pull the server's old data back down and undo the restore.
        final syncNotifier = ref.read(synchingProvider(syncId: 1).notifier);
        syncNotifier.setSyncOn(false);
        syncNotifier.setAutoSyncFrequency(0);
        if (l10n != null) botToast(l10n.sync_disabled_after_restore);
      } else if (syncAfterRestore == true && l10n != null) {
        // Sync may have been disabled by a previous restore — re-enable it
        // before pushing, since startSync below is the connection check
        // (its own error handling reports a bad server/credentials).
        ref.read(synchingProvider(syncId: 1).notifier).setSyncOn(true);
        // Not awaited: this pushes to the sync server over the network, and
        // shouldn't hold up the restore flow (e.g. a caller's busy dialog)
        // waiting on it. It owns clearing the guard once it settles.
        uploadStarted = true;
        unawaited(
          _uploadToSyncServerIfConnected(ref, l10n, keepAliveLink.close),
        );
      }
    } else {
      showBotToast("Backup Type not supported!");
    }
  } finally {
    if (!uploadStarted) {
      ref.read(restoreSyncGuardProvider.notifier).finish();
      // Released on a later event-loop turn so the provider isn't disposed
      // before its future has delivered the result to the caller.
      Timer.run(keepAliveLink.close);
    }
  }
}

/// Pushes the just-restored data to the sync server (if connected) so it
/// isn't left holding the pre-restore state, which the next sync would
/// otherwise pull back down and undo the restore. Silently skipped when no
/// server is configured. Always clears the restore guard on the way out,
/// since doRestore hands off ownership of it to this function once called.
Future<void> _uploadToSyncServerIfConnected(
  Ref ref,
  AppLocalizations l10n,
  void Function() releaseKeepAlive,
) async {
  try {
    final syncPreference = ref.read(synchingProvider(syncId: 1));
    final connected =
        (syncPreference.authToken?.isNotEmpty ?? false) &&
        (syncPreference.server?.isNotEmpty ?? false);
    if (!connected) return;
    botToast(l10n.restore_sync_uploading);
    // silent: true suppresses startSync's own generic "Starting/Finished"
    // toasts (this one is restore-specific below) - it still shows its own
    // "Sync failed" toast on failure, so that case doesn't need one here.
    final success = await ref
        .read(syncServerProvider(syncId: 1).notifier)
        .startSync(l10n, true, upload: true, bypassRestoreGuard: true);
    if (success) {
      botToast(l10n.restore_sync_upload_success);
    }
  } catch (e, s) {
    recordError(e, stack: s, source: 'restore_sync_upload');
    botToast(
      "Backup restored, but couldn't push it to your sync server: $e. "
      "The server still has the old data until the next successful sync.",
    );
  } finally {
    ref.read(restoreSyncGuardProvider.notifier).finish();
    releaseKeepAlive();
  }
}

void showBotToast(String text) {
  botToast(text, second: 5);
}

@riverpod
Future<void> restoreBackup(
  Ref ref,
  Map<String, dynamic> backup, {
  bool full = true,
  bool merge = false,
  Map<String, bool> categoryDecisions = const {},
  Map<String, int> sourceDecisions = const {},
}) async {
  await MangayomiRestoreService.restore(
    ref,
    backup,
    full: full,
    merge: merge,
    categoryDecisions: categoryDecisions,
    sourceDecisions: sourceDecisions,
  );
}

@riverpod
Future<void> restoreKotatsuBackup(Ref ref, Archive archive) async {
  await KotatsuRestoreService.restore(ref, archive);
}

@riverpod
Future<void> restoreTachiBkBackup(
  Ref ref,
  String path,
  BackupType bkType, {
  bool merge = false,
  Map<String, bool> categoryDecisions = const {},
  Map<String, int> sourceDecisions = const {},
}) async {
  await TachiyomiRestoreService.restore(
    ref,
    path,
    bkType,
    merge: merge,
    categoryDecisions: categoryDecisions,
    sourceDecisions: sourceDecisions,
  );
}
