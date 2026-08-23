import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_preview_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/delete_source.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

String _itemTypeLabel(BuildContext context, ItemType itemType) {
  final l10n = context.l10n;
  return switch (itemType) {
    ItemType.manga => l10n.manga,
    ItemType.anime => l10n.anime,
    ItemType.novel => l10n.novel,
  };
}

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
      onTap: () => _deleteSource(context, ref),
    );
  }
}

class MissingSourceCheckTile extends ConsumerWidget {
  const MissingSourceCheckTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(
        Icons.extension_off_outlined,
        color: Colors.orange,
      ),
      title: Text(l10n.missing_source_check_title),
      subtitle: Text(
        l10n.missing_source_check_subtitle,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () => _checkMissingSources(context),
    );
  }
}

class MergeDuplicateMangaTile extends ConsumerWidget {
  const MergeDuplicateMangaTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(Icons.join_full_rounded),
      title: Text(l10n.merge_manga_title),
      subtitle: Text(
        l10n.merge_manga_subtitle,
        style: TextStyle(fontSize: 11, color: context.secondaryColor),
      ),
      onTap: () => _mergeDuplicateManga(context, ref),
    );
  }
}

Future<void> _checkMissingSources(BuildContext context) async {
  final l10n = context.l10n;
  final groups = librarySourceGroupsMissingSource();
  if (groups.isEmpty) {
    botToast(l10n.missing_source_check_none_found);
    return;
  }

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.missing_source_check_result_title(groups.length)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.missing_source_check_result_message,
                style: TextStyle(
                  fontSize: 12,
                  color: dialogContext.secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (itemContext, index) {
                    final g = groups[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                      ),
                      title: Text(
                        g.lang != null
                            ? "${g.sourceName} (${g.lang})"
                            : g.sourceName,
                      ),
                      subtitle: Text(
                        "${_itemTypeLabel(itemContext, g.itemType)} • ${g.mangaCount}",
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Straight to picking a destination for this exact
                        // group - unlike the normal mass-migration entry
                        // points, we already know which source is broken,
                        // so there's no reason to ask again.
                        final migrationGroups = buildMassMigrationSourceGroups(
                          itemType: g.itemType,
                        );
                        MassMigrationSourceGroup? migrationGroup;
                        for (final mg in migrationGroups) {
                          if (mg.sourceName.trim() == g.sourceName.trim() &&
                              mg.lang == g.lang) {
                            migrationGroup = mg;
                            break;
                          }
                        }
                        Navigator.pop(dialogContext);
                        if (migrationGroup == null || !context.mounted) {
                          return;
                        }
                        Navigator.push(
                          context,
                          createRoute(
                            page: MassMigrationPreviewScreen(
                              sourceGroup: migrationGroup,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.ok),
          ),
        ],
      );
    },
  );
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
                subtitle: Text(
                  "${_itemTypeLabel(context, g.itemType)} • ${g.mangaCount}",
                ),
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
  var keepHistory = false;
  var keepDownloads = false;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(
              l10n.delete_source_confirm_title(
                "${group.sourceName} (${_itemTypeLabel(context, group.itemType)})",
              ),
            ),
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
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.delete_source_keep_history,
                    style: const TextStyle(fontSize: 13),
                  ),
                  value: keepHistory,
                  onChanged: (value) =>
                      setState(() => keepHistory = value ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.delete_source_keep_downloads,
                    style: const TextStyle(fontSize: 13),
                  ),
                  value: keepDownloads,
                  onChanged: (value) =>
                      setState(() => keepDownloads = value ?? false),
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
      keepHistory: keepHistory,
      keepDownloads: keepDownloads,
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

class _TaggedMangaCluster {
  _TaggedMangaCluster(this.group, this.cluster);

  final LibrarySourceGroup group;
  final DuplicateMangaCluster cluster;
}

Future<void> _mergeDuplicateManga(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final taggedClusters = <_TaggedMangaCluster>[];
  for (final group in librarySourceGroups(favoritesOnly: true)) {
    final mangaList = mangaForGroup(group, favoritesOnly: true);
    for (final cluster in findDuplicateMangaClusters(mangaList)) {
      taggedClusters.add(_TaggedMangaCluster(group, cluster));
    }
  }
  if (taggedClusters.isEmpty) {
    botToast(l10n.merge_manga_none_found);
    return;
  }

  final picked = await showDialog<_TaggedMangaCluster>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.merge_manga_pick_title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: taggedClusters.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final t = taggedClusters[index];
              return ListTile(
                title: Text(t.cluster.mangaList.first.name ?? ''),
                subtitle: Text(
                  "${_itemTypeLabel(context, t.group.itemType)} • ${t.group.sourceName} • "
                  "${t.cluster.mangaList.length}",
                ),
                onTap: () => Navigator.pop(dialogContext, t),
              );
            },
          ),
        ),
        actions: dialogCancelOnlyAction(dialogContext),
      );
    },
  );
  if (picked == null || !context.mounted) return;

  final mangaList = [...picked.cluster.mangaList];
  final chapterCounts = <int, int>{
    for (final m in mangaList)
      m.id!: isar.chapters.filter().mangaIdEqualTo(m.id).countSync(),
  };
  mangaList.sort(
    (a, b) => (chapterCounts[b.id!] ?? 0).compareTo(chapterCounts[a.id!] ?? 0),
  );

  final primary = await showDialog<Manga>(
    context: context,
    builder: (dialogContext) {
      var selected = mangaList.first;
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            title: Text(l10n.merge_manga_choose_primary_title),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.merge_manga_choose_primary_message,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.secondaryColor,
                    ),
                  ),
                  ...mangaList.map(
                    (m) => RadioListTile<Manga>(
                      value: m,
                      // ignore: deprecated_member_use
                      groupValue: selected,
                      // ignore: deprecated_member_use
                      onChanged: (v) => setState(() => selected = v!),
                      title: Text(m.name ?? ''),
                      subtitle: Text(
                        l10n.merge_manga_chapters_subtitle(
                          chapterCounts[m.id!] ?? 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: dialogCancelConfirmActions(
              dialogContext: dialogContext,
              confirmLabel: l10n.merge_manga_button,
              onCancel: () => Navigator.pop(dialogContext, null),
              onConfirm: () => Navigator.pop(dialogContext, selected),
            ),
          );
        },
      );
    },
  );
  if (primary == null || !context.mounted) return;

  final others = mangaList.where((m) => m.id != primary.id).toList();
  final preview = previewMergeManga(primary, others);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.merge_preview_title),
        content: Text(
          l10n.merge_manga_preview_message(
            preview.totalChapters,
            preview.duplicateChapters,
            preview.keptChapters,
            preview.duplicateTracks,
          ),
        ),
        actions: dialogCancelConfirmActions(
          dialogContext: dialogContext,
          confirmLabel: l10n.merge_manga_button,
        ),
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
        description: l10n.merge_manga_result_message(
          others.length,
          primary.name ?? '',
        ),
      ),
    );
    await mergeMangaGroup(primary, others);
    if (!context.mounted) return;
    ref.invalidate(lastLibrarySnapshotProvider);
    botToast(
      l10n.merge_manga_result_message(others.length, primary.name ?? ''),
    );
  } catch (e) {
    botToast("Error merging manga: $e");
  }
}
