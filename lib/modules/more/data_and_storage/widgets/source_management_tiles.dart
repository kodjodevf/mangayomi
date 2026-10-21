import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/mass_migration/mass_migration_preview_screen.dart';
import 'package:mangayomi/modules/mass_migration/models/mass_migration_models.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/delete_source.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/router/router.dart';

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
    return ShioriSettingRow(
      icon: Symbols.delete_sweep_rounded,
      title: l10n.delete_source_title,
      subtitle: l10n.delete_source_subtitle,
      destructive: true,
      onTap: () => _deleteSource(context, ref),
    );
  }
}

class MissingSourceCheckTile extends ConsumerWidget {
  const MissingSourceCheckTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ShioriSettingRow(
      icon: Symbols.extension_off_rounded,
      title: l10n.missing_source_check_title,
      subtitle: l10n.missing_source_check_subtitle,
      onTap: () => _checkMissingSources(context),
    );
  }
}

class MergeDuplicateMangaTile extends ConsumerWidget {
  const MergeDuplicateMangaTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return ShioriSettingRow(
      icon: Symbols.join_full_rounded,
      title: l10n.merge_manga_title,
      subtitle: l10n.merge_manga_subtitle,
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

  // Each broken source opens a migration for exactly its series.
  await showShioriSheet<void>(
    context,
    title: l10n.missing_source_check_result_title(groups.length),
    builder: (sheetContext) => ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            ShioriSpace.s16,
            0,
            ShioriSpace.s16,
            ShioriSpace.s8,
          ),
          child: Text(
            l10n.missing_source_check_result_message,
            style: context.shiori.caption,
          ),
        ),
        for (final g in groups)
          ShioriSettingRow(
            icon: Symbols.warning_rounded,
            title: _groupName(g),
            subtitle:
                "${_itemTypeLabel(sheetContext, g.itemType)} · ${g.mangaCount}",
            trailing: const Icon(Symbols.chevron_forward_rounded),
            onTap: () {
              // Straight to picking a destination for this exact group -
              // unlike the normal mass-migration entry points, we already
              // know which source is broken, so there's no reason to ask
              // again.
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
              Navigator.pop(sheetContext);
              if (migrationGroup == null || !context.mounted) return;
              Navigator.push(
                context,
                createRoute(
                  page: MassMigrationPreviewScreen(sourceGroup: migrationGroup),
                ),
              );
            },
          ),
      ],
    ),
  );
}

String _groupName(LibrarySourceGroup g) =>
    g.lang != null ? "${g.sourceName} (${g.lang})" : g.sourceName;

Future<void> _deleteSource(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final groups = librarySourceGroups();
  if (groups.isEmpty) {
    botToast(l10n.delete_source_empty);
    return;
  }

  final group = await showShioriChoice<LibrarySourceGroup>(
    context,
    title: l10n.delete_source_pick_title,
    options: [
      for (final g in groups)
        ShioriChoice(
          g,
          _groupName(g),
          subtitle: "${_itemTypeLabel(context, g.itemType)} · ${g.mangaCount}",
        ),
    ],
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
          return ShioriDialog(
            title: l10n.delete_source_confirm_title(
              "${group.sourceName} (${_itemTypeLabel(context, group.itemType)})",
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
                    style: context.shiori.text.row,
                  ),
                  value: keepHistory,
                  onChanged: (value) =>
                      setState(() => keepHistory = value ?? false),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.delete_source_keep_downloads,
                    style: context.shiori.text.row,
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
                      style: context.shiori.text.row,
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
              confirmColor: context.shiori.color.error.foreground,
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

  final picked = await showShioriChoice<_TaggedMangaCluster>(
    context,
    title: l10n.merge_manga_pick_title,
    options: [
      for (final t in taggedClusters)
        ShioriChoice(
          t,
          t.cluster.mangaList.first.name ?? '',
          subtitle:
              "${_itemTypeLabel(context, t.group.itemType)} · ${t.group.sourceName} · "
              "${t.cluster.mangaList.length}",
        ),
    ],
  );
  if (picked == null || !context.mounted) return;

  final mangaList = [...picked.cluster.mangaList];
  final chapterCounts = <int, int>{
    for (final m in mangaList) m.id!: chapterRepository.countByMangaId(m.id),
  };
  mangaList.sort(
    (a, b) => (chapterCounts[b.id!] ?? 0).compareTo(chapterCounts[a.id!] ?? 0),
  );

  // The series with the most chapters comes first and is the likely
  // keeper; the choice closes the sheet.
  final primary = await showShioriChoice<Manga>(
    context,
    title: l10n.merge_manga_choose_primary_title,
    message: l10n.merge_manga_choose_primary_message,
    selected: mangaList.first,
    options: [
      for (final m in mangaList)
        ShioriChoice(
          m,
          m.name ?? '',
          subtitle: l10n.merge_manga_chapters_subtitle(
            chapterCounts[m.id!] ?? 0,
          ),
        ),
    ],
  );
  if (primary == null || !context.mounted) return;

  final others = mangaList.where((m) => m.id != primary.id).toList();
  final preview = previewMergeManga(primary, others);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return ShioriDialog(
        title: l10n.merge_preview_title,
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
