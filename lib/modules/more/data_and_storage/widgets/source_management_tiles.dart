import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/delete_source.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/widgets/beta_badge.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class DeleteSourceTile extends ConsumerWidget {
  const DeleteSourceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
      title: Text(
        l10n.delete_source_title,
        style: const TextStyle(color: Colors.red),
      ),
      subtitle: Text(
        l10n.delete_source_subtitle,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      trailing: const BetaBadge(),
      onTap: () => _deleteSource(context, ref),
    );
  }
}

class MergeDuplicateSourcesTile extends ConsumerWidget {
  const MergeDuplicateSourcesTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(Icons.merge_type_rounded),
      title: Text(l10n.merge_sources_title),
      subtitle: Text(
        l10n.merge_sources_subtitle,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      trailing: const BetaBadge(),
      onTap: () => _mergeDuplicateSources(context, ref),
    );
  }
}

Future<void> _deleteSource(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final groups = librarySourceGroups();
  if (groups.isEmpty) {
    botToast(l10n.delete_source_empty);
    return;
  }

  final group = await showDialog<LibrarySourceGroup>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.delete_source_pick_title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: groups.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final g = groups[index];
              return ListTile(
                title: Text(
                  g.lang != null ? "${g.sourceName} (${g.lang})" : g.sourceName,
                ),
                subtitle: Text("${g.mangaCount} manga"),
                onTap: () => Navigator.pop(dialogContext, g),
              );
            },
          ),
        ),
        actions: dialogCancelOnlyAction(dialogContext),
      );
    },
  );
  if (group == null || !context.mounted) return;

  final mangaList = mangaForGroup(group);
  final counts = previewDeleteSource(mangaList);
  var removeExtension = group.sourceId != null;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(l10n.delete_source_confirm_title(group.sourceName)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.delete_source_confirm_message(
                    counts.mangaCount,
                    counts.chapterCount,
                    counts.historyCount,
                    counts.updateCount,
                    counts.trackCount,
                  ),
                ),
                if (group.sourceId != null)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.delete_source_also_remove_extension,
                      style: const TextStyle(fontSize: 13),
                    ),
                    value: removeExtension,
                    onChanged: (value) =>
                        setState(() => removeExtension = value ?? true),
                  ),
              ],
            ),
            actions: dialogCancelConfirmActions(
              dialogContext: dialogContext,
              confirmLabel: l10n.delete_source_button,
              confirmColor: Colors.red,
            ),
          );
        },
      );
    },
  );
  if (confirmed != true || !context.mounted) return;

  try {
    final safetyBackupPath = await createLibrarySafetyBackup();
    await writeLastLibrarySnapshot(
      LibrarySafetySnapshot(
        backupPath: safetyBackupPath,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        description: l10n.delete_source_result_message(
          counts.mangaCount,
          group.sourceName,
        ),
      ),
    );
    await deleteSourceLibrary(
      mangaList,
      group,
      alsoRemoveExtension: removeExtension,
    );
    if (!context.mounted) return;
    ref.invalidate(lastLibrarySnapshotProvider);
    botToast(
      l10n.delete_source_result_message(counts.mangaCount, group.sourceName),
    );
  } catch (e) {
    botToast("Error deleting source: $e");
  }
}

Future<void> _mergeDuplicateSources(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final clusters = findDuplicateSourceClusters();
  if (clusters.isEmpty) {
    botToast(l10n.merge_sources_none_found);
    return;
  }

  final cluster = await showDialog<DuplicateSourceCluster>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.merge_sources_pick_title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: clusters
                .map(
                  (c) => ListTile(
                    title: Text(c.groups.map((g) => g.sourceName).join(' / ')),
                    subtitle: Text(
                      "${c.groups.fold<int>(0, (s, g) => s + g.mangaCount)} manga total",
                    ),
                    onTap: () => Navigator.pop(dialogContext, c),
                  ),
                )
                .toList(),
          ),
        ),
        actions: dialogCancelOnlyAction(dialogContext),
      );
    },
  );
  if (cluster == null || !context.mounted) return;

  final sortedGroups = [...cluster.groups]
    ..sort((a, b) => b.mangaCount.compareTo(a.mangaCount));

  final primary = await showDialog<LibrarySourceGroup>(
    context: context,
    builder: (dialogContext) {
      var selected = sortedGroups.first;
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(l10n.merge_sources_choose_primary_title),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.merge_sources_choose_primary_message,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.secondaryColor,
                    ),
                  ),
                  ...sortedGroups.map(
                    (g) => RadioListTile<LibrarySourceGroup>(
                      value: g,
                      // ignore: deprecated_member_use
                      groupValue: selected,
                      // ignore: deprecated_member_use
                      onChanged: (v) => setState(() => selected = v!),
                      title: Text(
                        g.lang != null
                            ? "${g.sourceName} (${g.lang})"
                            : g.sourceName,
                      ),
                      subtitle: Text("${g.mangaCount} manga"),
                    ),
                  ),
                ],
              ),
            ),
            actions: dialogCancelConfirmActions(
              dialogContext: dialogContext,
              confirmLabel: l10n.merge_sources_button,
              onCancel: () => Navigator.pop(dialogContext, null),
              onConfirm: () => Navigator.pop(dialogContext, selected),
            ),
          );
        },
      );
    },
  );
  if (primary == null || !context.mounted) return;

  final others = sortedGroups.where((g) => g != primary).toList();
  final mergedCount = others.fold<int>(0, (s, g) => s + g.mangaCount);

  try {
    final safetyBackupPath = await createLibrarySafetyBackup();
    await writeLastLibrarySnapshot(
      LibrarySafetySnapshot(
        backupPath: safetyBackupPath,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        description: l10n.merge_sources_result_message(
          mergedCount,
          primary.sourceName,
        ),
      ),
    );
    await mergeSourceGroups(primary, others);
    if (!context.mounted) return;
    ref.invalidate(lastLibrarySnapshotProvider);
    botToast(
      l10n.merge_sources_result_message(mergedCount, primary.sourceName),
    );
  } catch (e) {
    botToast("Error merging sources: $e");
  }
}
