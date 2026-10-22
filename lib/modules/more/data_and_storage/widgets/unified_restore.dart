import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_decoder.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_format.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/rollback_last_change_tile.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:shiori/shiori.dart';

/// Whether there's a sync server configured to ask about (regardless of
/// whether sync is currently on or off) and, if so, whether it's on.
(bool hasServer, bool syncOn) _syncState(WidgetRef ref) {
  final syncPreference = ref.read(synchingProvider(syncId: 1));
  final hasServer =
      (syncPreference.authToken?.isNotEmpty ?? false) &&
      (syncPreference.server?.isNotEmpty ?? false);
  return (hasServer, syncPreference.syncOn);
}

/// Runs the restore flow and reports whether anything was actually restored.
///
/// False covers every way out that leaves the app as it was: no file chosen,
/// a confirmation declined, a conflict sheet dismissed. Callers that act on
/// the result, like the first-run screen, need to tell that apart from a
/// restore that went through.
Future<bool> performRestore(BuildContext context, WidgetRef ref) async {
  String? safetyBackupPath;
  try {
    final file = await FilePicker.pickFile(
      linuxOptions: const LinuxOptions(lockParentWindow: true),
    );
    if (file?.path == null || !context.mounted) return false;
    final path = file!.path!;
    // A successful restore pushes to the sync server automatically, so a
    // wrong backup here could overwrite good server data — ask first.
    final (hasServer, syncOn) = _syncState(ref);

    final backupType = peekBackupType(path);
    final isMihonFamily =
        backupType == BackupType.mihon ||
        backupType == BackupType.aniyomi ||
        backupType == BackupType.neko;

    if (backupType == BackupType.mangayomi) {
      return await _performMangayomiRestore(context, ref, path);
    }

    if (!isMihonFamily) {
      if (!context.mounted) return false;
      final confirmed = await _confirmPlainRestore(context);
      if (confirmed != true || !context.mounted) return false;
      bool? syncAfterRestore;
      if (hasServer) {
        if (!context.mounted) return false;
        syncAfterRestore = await confirmSyncAfterRestore(
          context,
          syncOn: syncOn,
        );
        if (!context.mounted) return false;
      }
      showBusyDialog(context, context.l10n.restoring_backup);
      try {
        await ref.watch(
          doRestoreProvider(
            path: path,
            context: context,
            syncAfterRestore: syncAfterRestore,
          ).future,
        );
      } finally {
        if (context.mounted) hideBusyDialog(context);
      }
      return true;
    }

    final l10n = context.l10n;
    final preview = await previewTachiBkImport(path);
    if (preview == null) {
      botToast("Unsupported or unrecognized backup file.");
      return false;
    }

    if (!context.mounted) return false;
    final keepExisting = await _chooseImportMode(context);
    if (keepExisting == null || !context.mounted) return false;

    var categoryDecisions = const <String, bool>{};
    var sourceDecisions = const <String, int>{};

    if (keepExisting && preview.conflictingCategories.isNotEmpty) {
      if (!context.mounted) return false;
      final decisions = await _resolveCategoryConflicts(
        context,
        preview.conflictingCategories,
      );
      if (decisions == null || !context.mounted) return false;
      categoryDecisions = decisions;
    }

    if (preview.unmatchedSourceNames.isNotEmpty) {
      if (!context.mounted) return false;
      final decisions = await _resolveSourceConflicts(
        context,
        preview.unmatchedSourceNames,
      );
      if (decisions == null || !context.mounted) return false;
      sourceDecisions = decisions;
    }

    if (!context.mounted) return false;
    final proceed = keepExisting
        ? await _confirmImportSummary(context, preview)
        : await _confirmReplaceSummary(context, preview);
    if (proceed != true || !context.mounted) return false;

    bool? syncAfterRestore;
    if (hasServer) {
      if (!context.mounted) return false;
      syncAfterRestore = await confirmSyncAfterRestore(context, syncOn: syncOn);
      if (!context.mounted) return false;
    }

    final resultDescription = keepExisting
        ? l10n.import_result_message(
            preview.newSeriesCount,
            preview.updatedSeriesCount,
            preview.newChapterCount,
          )
        : l10n.replace_result_message(
            preview.newSeriesCount + preview.updatedSeriesCount,
          );

    if (!context.mounted) return false;
    showBusyDialog(context, l10n.restoring_backup);
    try {
      try {
        safetyBackupPath = await createLibrarySafetyBackup();
        await writeLastLibrarySnapshot(
          LibrarySafetySnapshot(
            backupPath: safetyBackupPath,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            description: resultDescription,
          ),
        );
      } catch (e, s) {
        safetyBackupPath = null;
        recordError(
          e,
          stack: s,
          source: "safety_backup",
          level: LogLevel.warning,
        );
      }

      // false, not a bare return: performRestore reports whether anything was
      // actually restored, so the first-run screen can tell a cancel from a
      // completed restore. ref.watch is upstream's.
      if (!context.mounted) return false;
      await ref.watch(
        doRestoreProvider(
          path: path,
          context: context,
          merge: keepExisting,
          categoryDecisions: categoryDecisions,
          sourceDecisions: sourceDecisions,
          syncAfterRestore: syncAfterRestore,
        ).future,
      );
    } finally {
      if (context.mounted) hideBusyDialog(context);
    }
    if (!context.mounted) return false;
    ref.invalidate(lastLibrarySnapshotProvider);

    _showImportResultToast(context, ref, resultDescription, safetyBackupPath);
    return true;
  } catch (e, s) {
    toastError(e, stack: s, source: 'restore');
    if (safetyBackupPath != null && context.mounted) {
      offerLibraryRollback(context, ref, safetyBackupPath);
    }
    return false;
  }
}

/// Native mangayomi-format restore, with the same merge/replace choice and
/// category/source conflict resolution the Mihon-family path already has -
/// the dialogs below are shared with it, not duplicated.
Future<bool> _performMangayomiRestore(
  BuildContext context,
  WidgetRef ref,
  String path,
) async {
  String? safetyBackupPath;
  try {
    final Map<String, dynamic> backup;
    try {
      backup = await decodeMangayomiBackup(path, context);
    } catch (e, s) {
      recordError(
        e,
        stack: s,
        source: 'restore_decode',
        level: LogLevel.warning,
      );
      if (context.mounted) botToast("$e");
      return false;
    }
    if (!context.mounted) return false;
    final l10n = context.l10n;
    final preview = previewMangayomiBackup(backup);

    final keepExisting = await _chooseImportMode(context);
    if (keepExisting == null || !context.mounted) return false;

    var categoryDecisions = const <String, bool>{};
    var sourceDecisions = const <String, int>{};

    if (keepExisting && preview.conflictingCategories.isNotEmpty) {
      if (!context.mounted) return false;
      final decisions = await _resolveCategoryConflicts(
        context,
        preview.conflictingCategories,
      );
      if (decisions == null || !context.mounted) return false;
      categoryDecisions = decisions;
    }

    if (preview.unmatchedSourceNames.isNotEmpty) {
      if (!context.mounted) return false;
      final decisions = await _resolveSourceConflicts(
        context,
        preview.unmatchedSourceNames,
      );
      if (decisions == null || !context.mounted) return false;
      sourceDecisions = decisions;
    }

    if (!context.mounted) return false;
    final proceed = keepExisting
        ? await _confirmImportSummary(context, preview)
        : await _confirmReplaceSummary(context, preview);
    if (proceed != true || !context.mounted) return false;

    // Same question the other backup formats ask: a restore that the sync
    // server is never told about leaves the server on the old library.
    bool? syncAfterRestore;
    final (hasServer, syncOn) = _syncState(ref);
    if (hasServer) {
      syncAfterRestore = await confirmSyncAfterRestore(context, syncOn: syncOn);
      if (!context.mounted) return false;
    }

    final resultDescription = keepExisting
        ? l10n.import_result_message(
            preview.newSeriesCount,
            preview.updatedSeriesCount,
            preview.newChapterCount,
          )
        : l10n.replace_result_message(
            preview.newSeriesCount + preview.updatedSeriesCount,
          );

    if (!context.mounted) return false;
    showBusyDialog(context, l10n.restoring_backup);
    try {
      try {
        safetyBackupPath = await createLibrarySafetyBackup();
        await writeLastLibrarySnapshot(
          LibrarySafetySnapshot(
            backupPath: safetyBackupPath,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            description: resultDescription,
          ),
        );
      } catch (e, s) {
        safetyBackupPath = null;
        recordError(
          e,
          stack: s,
          source: "safety_backup",
          level: LogLevel.warning,
        );
      }

      if (!context.mounted) return false;
      await ref.watch(
        doRestoreProvider(
          path: path,
          context: context,
          merge: keepExisting,
          categoryDecisions: categoryDecisions,
          sourceDecisions: sourceDecisions,
          decodedMangayomiBackup: backup,
          syncAfterRestore: syncAfterRestore,
        ).future,
      );
    } finally {
      if (context.mounted) hideBusyDialog(context);
    }
    if (!context.mounted) return false;
    ref.invalidate(lastLibrarySnapshotProvider);

    _showImportResultToast(context, ref, resultDescription, safetyBackupPath);
    return true;
  } catch (e, s) {
    toastError(e, stack: s, source: 'restore');
    if (safetyBackupPath != null && context.mounted) {
      offerLibraryRollback(context, ref, safetyBackupPath);
    }
    return false;
  }
}

Future<bool?> _confirmPlainRestore(BuildContext context) {
  final l10n = context.l10n;
  return showShioriConfirm(
    context,
    title: l10n.restore_backup,
    message: l10n.restore_backup_warning_title,
    confirmLabel: l10n.restore_backup,
  );
}

/// Keep what is in the library and add the backup's, or replace it.
Future<bool?> _chooseImportMode(BuildContext context) {
  final l10n = context.l10n;
  return showShioriChoice<bool>(
    context,
    title: l10n.import_mode_title,
    message: l10n.import_mode_message,
    options: [
      ShioriChoice(
        true,
        l10n.import_mode_keep_existing,
        subtitle: l10n.import_mode_keep_existing_subtitle,
        icon: Symbols.merge_type_rounded,
      ),
      ShioriChoice(
        false,
        l10n.import_mode_replace,
        subtitle: l10n.import_mode_replace_subtitle,
        icon: Symbols.delete_sweep_rounded,
      ),
    ],
  );
}

/// The categories both sides have: the ticked ones are kept.
Future<Map<String, bool>?> _resolveCategoryConflicts(
  BuildContext context,
  List<String> conflicts,
) async {
  final l10n = context.l10n;
  final kept = await showShioriMultiChoice<String>(
    context,
    title: l10n.category_conflict_title,
    message: l10n.category_conflict_message,
    selected: conflicts.toSet(),
    confirmLabel: l10n.ok,
    options: [for (final name in conflicts) ShioriChoice(name, name)],
  );
  if (kept == null) return null;
  return {for (final name in conflicts) name: kept.contains(name)};
}

/// For each source the backup names and this device lacks, an installed
/// one to use instead, or none.
Future<Map<String, int>?> _resolveSourceConflicts(
  BuildContext context,
  Map<String, ItemType> unmatched,
) async {
  final l10n = context.l10n;
  // The choice sheet answers null when dismissed; "keep" needs its own
  // value.
  const keep = -1;
  final selections = <String, int>{
    for (final name in unmatched.keys) name: keep,
  };
  return showDialog<Map<String, int>>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return ShioriDialog(
            title: l10n.source_conflict_title,
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.source_conflict_message),
                  const SizedBox(height: ShioriSpace.s8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final MapEntry(key: name, value: itemType)
                            in unmatched.entries)
                          ShioriValueRow<int>(
                            title: name,
                            value: selections[name]!,
                            options: [
                              ShioriChoice(keep, l10n.source_conflict_keep),
                              for (final source in installedSourcesFor(
                                itemType,
                              ))
                                ShioriChoice(
                                  source.id!,
                                  "${source.name} (${source.lang})",
                                ),
                            ],
                            onChanged: (v) =>
                                setState(() => selections[name] = v),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: dialogCancelConfirmActions(
              dialogContext: dialogContext,
              confirmLabel: l10n.ok,
              onCancel: () => Navigator.pop(dialogContext, null),
              onConfirm: () => Navigator.pop(dialogContext, {
                for (final e in selections.entries)
                  if (e.value != keep) e.key: e.value,
              }),
            ),
          );
        },
      );
    },
  );
}

Future<bool?> _confirmImportSummary(
  BuildContext context,
  TachiBkImportPreview preview,
) {
  final l10n = context.l10n;
  return showShioriConfirm(
    context,
    title: l10n.import_summary_title,
    message: l10n.import_summary_message(
      preview.newSeriesCount,
      preview.updatedSeriesCount,
      preview.newChapterCount,
    ),
    confirmLabel: l10n.import_summary_confirm,
  );
}

Future<bool?> _confirmReplaceSummary(
  BuildContext context,
  TachiBkImportPreview preview,
) {
  final l10n = context.l10n;
  final currentCount = currentFavoriteMangaCount();
  final backupCount = preview.newSeriesCount + preview.updatedSeriesCount;
  return showShioriConfirm(
    context,
    title: l10n.replace_summary_title,
    message: l10n.replace_summary_message(currentCount, backupCount),
    confirmLabel: l10n.replace_summary_confirm,
    destructive: true,
  );
}

void _showImportResultToast(
  BuildContext context,
  WidgetRef ref,
  String resultDescription,
  String? safetyBackupPath,
) {
  final l10n = context.l10n;
  botToast(
    resultDescription,
    tone: ShioriToastTone.success,
    second: 8,
    actions: [
      if (safetyBackupPath != null)
        ShioriToastAction(
          l10n.roll_back,
          () => offerLibraryRollback(context, ref, safetyBackupPath),
        ),
    ],
  );
}
