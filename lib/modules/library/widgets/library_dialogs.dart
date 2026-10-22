import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:path/path.dart' as p;

/// Shows a dialog for deleting selected manga from library and/or device.
void showDeleteMangaDialog({
  required BuildContext context,
  required WidgetRef ref,
  required ItemType itemType,
}) {
  bool deleteFromLib = false;
  bool deleteDownloads = false;
  showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final mangaIdsList = ref.watch(mangasListStateProvider);
          final l10n = l10nLocalizations(context)!;
          final List<Manga> mangasList = [];
          for (var id in mangaIdsList) {
            mangasList.add(mangaRepository.getById(id));
          }
          return StatefulBuilder(
            builder: (context, setState) {
              final anything = deleteFromLib || deleteDownloads;
              return ShioriDialog(
                title: '${l10n.remove} · ${mangasList.length}',
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShioriSwitchRow(
                      title: l10n.from_library,
                      value: deleteFromLib,
                      onChanged: (v) => setState(() => deleteFromLib = v),
                    ),
                    ShioriSwitchRow(
                      title: itemType != ItemType.anime
                          ? l10n.downloaded_chapters
                          : l10n.downloaded_episodes,
                      value: deleteDownloads,
                      onChanged: (v) => setState(() => deleteDownloads = v),
                    ),
                  ],
                ),
                actions: [
                  ShioriButton.quiet(
                    label: l10n.cancel,
                    onPressed: () => Navigator.pop(context),
                  ),
                  ShioriButton(
                    label: l10n.remove,
                    destructive: true,
                    onPressed: !anything
                        ? null
                        : () async {
                            // From Library
                            if (deleteFromLib) {
                              for (var manga in mangasList) {
                                await mangaRepository.removeFromLibrary(manga);
                              }
                            }
                            // Downloaded Chapters
                            if (deleteDownloads) {
                              for (var manga in mangasList) {
                                String mangaDirectory = "";
                                if (manga.isLocalArchive ?? false) {
                                  // For local archives the archive file IS the chapter — there is
                                  // nothing to re-download. So we delete the physical files and
                                  // remove all Isar records, mirroring a full library removal.
                                  mangaDirectory = await _deleteImport(
                                    manga,
                                    mangaDirectory,
                                  );
                                  await mangaRepository.removeFromLibrary(
                                    manga,
                                  );
                                } else {
                                  // Regular manga: delete downloaded files and their download
                                  // records, but leave the manga and chapter metadata intact so
                                  // the user can re-download later.
                                  mangaDirectory = await _deleteDownload(
                                    manga,
                                    mangaDirectory,
                                  );
                                }
                                // If the manga's base directory is now empty,
                                // remove it too so we don't leave orphaned folders on disk.
                                if (mangaDirectory.isNotEmpty) {
                                  final path = Directory(mangaDirectory);
                                  if (path.existsSync() &&
                                      path.listSync().isEmpty) {
                                    path.deleteSync(recursive: true);
                                  }
                                }
                              }
                            }

                            ref.read(mangasListStateProvider.notifier).clear();
                            ref
                                .read(isLongPressedStateProvider.notifier)
                                .update(false);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

/// Deletes the physical archive files (zip/cbz/mp4/epub) for a local-archive
/// manga from disk. Returns the parent directory path so the caller can clean
/// up the now-empty folder afterwards.
Future<String> _deleteImport(Manga manga, String mangaDirectory) async {
  for (var chapter in manga.chapters) {
    final path = chapter.archivePath;
    if (path == null) continue;
    final resolvedPath = await resolveLocalArchivePath(path);
    final chapterFile = File(resolvedPath);
    if (mangaDirectory.isEmpty) {
      mangaDirectory = p.dirname(resolvedPath);
    }
    try {
      if (chapterFile.existsSync()) {
        chapterFile.deleteSync();
      }
    } catch (_) {}
  }
  return mangaDirectory;
}

/// Deletes the downloaded chapter files for a regular (non-local-archive)
/// manga from disk, then cleans up the corresponding Isar download records.
/// Returns the manga's base directory path so the caller can remove the
/// folder if it is left empty.
Future<String> _deleteDownload(Manga manga, String mangaDirectory) async {
  Directory? mangaDir;
  final downloadedIds = (await downloadRepository.getAllIds()).toSet();

  if (downloadedIds.isEmpty) return mangaDirectory;

  for (var chapter in manga.chapters) {
    if (chapter.id == null || !downloadedIds.contains(chapter.id)) continue;

    await chapter.deleteDownloadedFiles();
    if (mangaDirectory.isEmpty) {
      mangaDir ??= await StorageProvider().getMangaMainDirectory(chapter);
      if (mangaDir != null) mangaDirectory = mangaDir.path;
    }
  }
  return mangaDirectory;
}

/// Shows a dialog for importing local files (zip, cbz, epub, video).
void showImportLocalDialog(BuildContext context, ItemType itemType) {
  final l10n = l10nLocalizations(context)!;
  final filesText = switch (itemType) {
    ItemType.manga => ".zip, .cbz, .rar, .cbr",
    ItemType.anime => ".mp4, .mkv, .avi, and more",
    ItemType.novel => ".epub",
  };
  bool isLoading = false;
  bool splitChapters = true;
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Consumer(
        builder: (context, ref, child) => PopScope(
          // An import in progress finishes before the dialog goes.
          canPop: !isLoading,
          child: ShioriDialog(
            title: l10n.import_local_file,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(filesText),
                if (itemType == ItemType.novel)
                  ShioriSwitchRow(
                    title: l10n.split_epub_chapters,
                    subtitle: l10n.split_epub_chapters_description,
                    value: splitChapters,
                    onChanged: isLoading
                        ? null
                        : (v) => setState(() => splitChapters = v),
                  ),
              ],
            ),
            actions: [
              ShioriButton.quiet(
                label: l10n.cancel,
                onPressed: isLoading ? null : () => Navigator.pop(context),
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(ShioriSpace.s8),
                  child: ShioriLoading.inline(),
                )
              else
                ShioriButton(
                  icon: Symbols.archive_rounded,
                  label: l10n.import_files,
                  onPressed: () async {
                    setState(() => isLoading = true);
                    await ref.watch(
                      importArchivesFromFileProvider(
                        itemType: itemType,
                        null,
                        init: true,
                        splitChapters: splitChapters,
                      ).future,
                    );
                    if (!context.mounted) return;
                    setState(() => isLoading = false);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
