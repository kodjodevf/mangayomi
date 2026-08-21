import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/modules/more/data_and_storage/widgets/rollback_last_change_tile.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

Future<void> performRestore(BuildContext context, WidgetRef ref) async {
  String? safetyBackupPath;
  try {
    final file = await FilePicker.pickFile();
    if (file?.path == null || !context.mounted) return;
    final path = file!.path!;

    final backupType = peekBackupType(path);
    final isMihonFamily =
        backupType == BackupType.mihon ||
        backupType == BackupType.aniyomi ||
        backupType == BackupType.neko;

    if (!isMihonFamily) {
      if (!context.mounted) return;
      final confirmed = await _confirmPlainRestore(context);
      if (confirmed != true || !context.mounted) return;
      showBusyDialog(context, context.l10n.restoring_backup);
      try {
        await ref.watch(doRestoreProvider(path: path, context: context).future);
      } finally {
        if (context.mounted) hideBusyDialog(context);
      }
      return;
    }

    final l10n = context.l10n;
    final preview = previewTachiBkImport(path);
    if (preview == null) {
      botToast("Unsupported or unrecognized backup file.");
      return;
    }

    if (!context.mounted) return;
    final keepExisting = await _chooseImportMode(context);
    if (keepExisting == null || !context.mounted) return;

    var categoryDecisions = const <String, bool>{};
    var sourceDecisions = const <String, int>{};

    if (keepExisting && preview.conflictingCategories.isNotEmpty) {
      if (!context.mounted) return;
      final decisions = await _resolveCategoryConflicts(
        context,
        preview.conflictingCategories,
      );
      if (decisions == null || !context.mounted) return;
      categoryDecisions = decisions;
    }

    if (preview.unmatchedSourceNames.isNotEmpty) {
      if (!context.mounted) return;
      final decisions = await _resolveSourceConflicts(
        context,
        preview.unmatchedSourceNames,
      );
      if (decisions == null || !context.mounted) return;
      sourceDecisions = decisions;
    }

    if (!context.mounted) return;
    final proceed = keepExisting
        ? await _confirmImportSummary(context, preview)
        : await _confirmReplaceSummary(context, preview);
    if (proceed != true || !context.mounted) return;

    final resultDescription = keepExisting
        ? l10n.import_result_message(
            preview.newSeriesCount,
            preview.updatedSeriesCount,
            preview.newChapterCount,
          )
        : l10n.replace_result_message(
            preview.newSeriesCount + preview.updatedSeriesCount,
          );

    if (!context.mounted) return;
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
      } catch (_) {
        safetyBackupPath = null;
      }

      if (!context.mounted) return;
      await ref.watch(
        doRestoreProvider(
          path: path,
          context: context,
          merge: keepExisting,
          categoryDecisions: categoryDecisions,
          sourceDecisions: sourceDecisions,
        ).future,
      );
    } finally {
      if (context.mounted) hideBusyDialog(context);
    }
    if (!context.mounted) return;
    ref.invalidate(lastLibrarySnapshotProvider);

    _showImportResultToast(context, ref, resultDescription, safetyBackupPath);
  } catch (e) {
    botToast("Error restoring backup: $e");
    if (safetyBackupPath != null && context.mounted) {
      offerLibraryRollback(context, ref, safetyBackupPath);
    }
  }
}

Future<bool?> _confirmPlainRestore(BuildContext context) {
  final l10n = context.l10n;
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.restore_backup),
        content: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: context.secondaryColor),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.restore_backup_warning_title)),
          ],
        ),
        actions: dialogCancelConfirmActions(
          dialogContext: dialogContext,
          confirmLabel: l10n.ok,
        ),
      );
    },
  );
}

Future<bool?> _chooseImportMode(BuildContext context) {
  final l10n = context.l10n;
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.import_mode_title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              l10n.import_mode_message,
              style: TextStyle(fontSize: 12, color: context.secondaryColor),
            ),
            const SizedBox(height: 4),
            ListTile(
              leading: const Icon(Icons.merge_type_rounded),
              title: Text(l10n.import_mode_keep_existing),
              subtitle: Text(
                l10n.import_mode_keep_existing_subtitle,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onTap: () => Navigator.pop(dialogContext, true),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_sweep_outlined,
                color: Colors.red,
              ),
              title: Text(
                l10n.import_mode_replace,
                style: const TextStyle(color: Colors.red),
              ),
              subtitle: Text(
                l10n.import_mode_replace_subtitle,
                style: TextStyle(fontSize: 11, color: context.secondaryColor),
              ),
              onTap: () => Navigator.pop(dialogContext, false),
            ),
          ],
        ),
        actions: dialogCancelOnlyAction(dialogContext),
      );
    },
  );
}

Future<Map<String, bool>?> _resolveCategoryConflicts(
  BuildContext context,
  List<String> conflicts,
) async {
  final l10n = context.l10n;
  final decisions = {for (final name in conflicts) name: true};
  return showDialog<Map<String, bool>>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(l10n.category_conflict_title),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.category_conflict_message,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: conflicts
                          .map(
                            (name) => CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(name),
                              subtitle: Text(
                                decisions[name]!
                                    ? l10n.category_conflict_keep
                                    : l10n.category_conflict_delete,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: context.secondaryColor,
                                ),
                              ),
                              value: decisions[name],
                              onChanged: (value) => setState(
                                () => decisions[name] = value ?? true,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: dialogCancelConfirmActions(
              dialogContext: dialogContext,
              confirmLabel: l10n.ok,
              onCancel: () => Navigator.pop(dialogContext, null),
              onConfirm: () => Navigator.pop(dialogContext, decisions),
            ),
          );
        },
      );
    },
  );
}

Future<Map<String, int>?> _resolveSourceConflicts(
  BuildContext context,
  Map<String, ItemType> unmatched,
) async {
  final l10n = context.l10n;
  final selections = <String, int?>{
    for (final name in unmatched.keys) name: null,
  };
  return showDialog<Map<String, int>>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(l10n.source_conflict_title),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.source_conflict_message,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: unmatched.entries.map((entry) {
                        final name = entry.key;
                        final itemType = entry.value;
                        final options = installedSourcesFor(itemType);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: DropdownButtonFormField<int?>(
                            initialValue: selections[name],
                            isExpanded: true,
                            decoration: InputDecoration(
                              label: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: Color.alphaBlend(
                                context.primaryColor.withValues(alpha: 0.05),
                                Theme.of(context).scaffoldBackgroundColor,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: context.primaryColor.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: context.primaryColor.withValues(
                                    alpha: 0.2,
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: context.primaryColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            items: [
                              DropdownMenuItem<int?>(
                                value: null,
                                child: Text(
                                  l10n.source_conflict_keep,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ...options.map(
                                (s) => DropdownMenuItem<int?>(
                                  value: s.id,
                                  child: Text(
                                    "${s.name} (${s.lang})",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => selections[name] = value),
                          ),
                        );
                      }).toList(),
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
                  if (e.value != null) e.key: e.value!,
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
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.import_summary_title),
        content: Text(
          l10n.import_summary_message(
            preview.newSeriesCount,
            preview.updatedSeriesCount,
            preview.newChapterCount,
          ),
        ),
        actions: dialogCancelConfirmActions(
          dialogContext: dialogContext,
          confirmLabel: l10n.import_summary_confirm,
        ),
      );
    },
  );
}

Future<bool?> _confirmReplaceSummary(
  BuildContext context,
  TachiBkImportPreview preview,
) {
  final l10n = context.l10n;
  final currentCount = currentFavoriteMangaCount();
  final backupCount = preview.newSeriesCount + preview.updatedSeriesCount;
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.replace_summary_title),
        content: Text(l10n.replace_summary_message(currentCount, backupCount)),
        actions: dialogCancelConfirmActions(
          dialogContext: dialogContext,
          confirmLabel: l10n.replace_summary_confirm,
          confirmColor: Colors.red,
        ),
      );
    },
  );
}

void _showImportResultToast(
  BuildContext context,
  WidgetRef ref,
  String resultDescription,
  String? safetyBackupPath,
) {
  final l10n = context.l10n;
  BotToast.showNotification(
    animationDuration: const Duration(milliseconds: 200),
    animationReverseDuration: const Duration(milliseconds: 200),
    duration: const Duration(seconds: 8),
    backButtonBehavior: BackButtonBehavior.none,
    leading: (_) => Image.asset('assets/app_icons/icon-red.png', height: 32),
    title: (_) => Text(
      resultDescription,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    trailing: safetyBackupPath == null
        ? null
        : (_) => UnconstrainedBox(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () =>
                  offerLibraryRollback(context, ref, safetyBackupPath),
              child: Text(
                l10n.roll_back,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
    enableSlideOff: true,
    onlyOne: true,
    crossPage: true,
  );
}
