import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as p;

/// Shows a dialog for deleting selected manga from library and/or device.
void showDeleteMangaDialog({
  required BuildContext context,
  required WidgetRef ref,
  required ItemType itemType,
}) {
  List<int> fromLibList = [];
  List<int> downloadedChapsList = [];
  showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          final mangaIdsList = ref.watch(mangasListStateProvider);
          final l10n = l10nLocalizations(context)!;
          final List<Manga> mangasList = [];
          for (var id in mangaIdsList) {
            mangasList.add(isar.mangas.getSync(id)!);
          }
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(l10n.remove),
                content: SizedBox(
                  height: 100,
                  width: context.width(0.8),
                  child: Column(
                    children: [
                      ListTileChapterFilter(
                        label: l10n.from_library,
                        onTap: () {
                          setState(() {
                            if (fromLibList == mangaIdsList) {
                              fromLibList = [];
                            } else {
                              fromLibList = mangaIdsList;
                            }
                          });
                        },
                        type: fromLibList.isNotEmpty ? 1 : 0,
                      ),
                      ListTileChapterFilter(
                        label: itemType != ItemType.anime
                            ? l10n.downloaded_chapters
                            : l10n.downloaded_episodes,
                        onTap: () {
                          setState(() {
                            if (downloadedChapsList == mangaIdsList) {
                              downloadedChapsList = [];
                            } else {
                              downloadedChapsList = mangaIdsList;
                            }
                          });
                        },
                        type: downloadedChapsList.isNotEmpty ? 1 : 0,
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.cancel),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () async {
                          // From Library
                          if (fromLibList.isNotEmpty) {
                            isar.writeTxnSync(() {
                              for (var manga in mangasList) {
                                if (manga.isLocalArchive ?? false) {
                                  _removeImport(ref, manga);
                                } else {
                                  manga.favorite = false;
                                  manga.updatedAt =
                                      DateTime.now().millisecondsSinceEpoch;
                                  isar.mangas.putSync(manga);
                                }
                              }
                            });
                          }
                          // Downloaded Chapters
                          if (downloadedChapsList.isNotEmpty) {
                            for (var manga in mangasList) {
                              if (!(manga.isLocalArchive ?? false)) {
                                String mangaDirectory = "";
                                if (manga.isLocalArchive ?? false) {
                                  mangaDirectory = _deleteImport(
                                    manga,
                                    mangaDirectory,
                                  );
                                  isar.writeTxnSync(() {
                                    _removeImport(ref, manga);
                                  });
                                } else {
                                  mangaDirectory = await _deleteDownload(
                                    manga,
                                    mangaDirectory,
                                  );
                                }
                                if (mangaDirectory.isNotEmpty) {
                                  final path = Directory(mangaDirectory);
                                  if (path.existsSync() &&
                                      path.listSync().isEmpty) {
                                    path.deleteSync(recursive: true);
                                  }
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
                        child: Text(l10n.ok),
                      ),
                    ],
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

void _removeImport(WidgetRef ref, Manga manga) {
  final provider = ref.read(synchingProvider(syncId: 1).notifier);
  final histories = isar.historys
      .filter()
      .mangaIdEqualTo(manga.id)
      .findAllSync();
  for (var history in histories) {
    isar.historys.deleteSync(history.id!);
    provider.addChangedPart(ActionType.removeHistory, history.id, "{}", false);
  }

  for (var chapter in manga.chapters) {
    final updates = isar.updates
        .filter()
        .mangaIdEqualTo(chapter.mangaId)
        .chapterNameEqualTo(chapter.name)
        .findAllSync();
    for (var update in updates) {
      isar.updates.deleteSync(update.id!);
      provider.addChangedPart(ActionType.removeUpdate, update.id, "{}", false);
    }
    // Remove associated download record to prevent ghost entries
    isar.downloads.deleteSync(chapter.id!);
    isar.chapters.deleteSync(chapter.id!);
    provider.addChangedPart(ActionType.removeChapter, chapter.id, "{}", false);
  }
  isar.mangas.deleteSync(manga.id!);
  provider.addChangedPart(ActionType.removeItem, manga.id, "{}", false);
}

String _deleteImport(Manga manga, String mangaDirectory) {
  for (var chapter in manga.chapters) {
    final path = chapter.archivePath;
    if (path == null) continue;
    final chapterFile = File(path);
    if (mangaDirectory.isEmpty) {
      mangaDirectory = p.dirname(path);
    }
    try {
      if (chapterFile.existsSync()) {
        chapterFile.deleteSync();
      }
    } catch (_) {}
  }
  return mangaDirectory;
}

Future<String> _deleteDownload(Manga manga, String mangaDirectory) async {
  final storageProvider = StorageProvider();
  Directory? mangaDir;
  final idsToDelete = <int>{};
  final downloadedIds = (await isar.downloads.where().idProperty().findAll())
      .toSet();

  if (downloadedIds.isEmpty) return mangaDirectory;

  for (var chapter in manga.chapters) {
    if (chapter.id == null || !downloadedIds.contains(chapter.id)) continue;

    mangaDir ??= await storageProvider.getMangaMainDirectory(chapter);
    final chapterDir = await storageProvider.getMangaChapterDirectory(
      chapter,
      mangaMainDirectory: mangaDir,
    );
    File? file;

    if (mangaDirectory.isEmpty) mangaDirectory = mangaDir!.path;
    if (manga.itemType == ItemType.manga) {
      file = File(p.join(mangaDir!.path, "${chapter.name}.cbz"));
    } else if (manga.itemType == ItemType.anime) {
      file = File(
        p.join(
          mangaDir!.path,
          "${chapter.name!.replaceForbiddenCharacters(' ')}.mp4",
        ),
      );
    }

    try {
      if (file != null && file.existsSync()) {
        file.deleteSync();
      }
      if (chapterDir!.existsSync()) {
        chapterDir.deleteSync(recursive: true);
      }
    } catch (_) {}
    idsToDelete.add(chapter.id!);
  }
  if (idsToDelete.isNotEmpty) {
    isar.writeTxnSync(() {
      isar.downloads.deleteAllSync(idsToDelete.toList());
    });
  }
  return mangaDirectory;
}

/// Shows a dialog for importing local files (zip, cbz, epub, video).
void showImportLocalDialog(BuildContext context, ItemType itemType) {
  final l10n = l10nLocalizations(context)!;
  final filesText = switch (itemType) {
    ItemType.manga => ".zip, .cbz",
    ItemType.anime => ".mp4, .mkv, .avi, and more",
    ItemType.novel => ".epub",
  };
  bool isLoading = false;
  bool splitChapters = true;
  showDialog(
    context: context,
    barrierDismissible: !isLoading,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.import_local_file),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, ref, child) {
                return SizedBox(
                  height: itemType == ItemType.novel ? 150 : 100,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          if (itemType == ItemType.novel)
                            SwitchListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                l10n.split_epub_chapters,
                                style: const TextStyle(fontSize: 13),
                              ),
                              subtitle: Text(
                                l10n.split_epub_chapters_description,
                                style: const TextStyle(fontSize: 10),
                              ),
                              value: splitChapters,
                              onChanged: (v) =>
                                  setState(() => splitChapters = v),
                            ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
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
                                        setState(() => isLoading = false);
                                        if (!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Icon(Icons.archive_outlined),
                                          Text(
                                            "${l10n.import_files} ( $filesText )",
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodySmall!.color,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isLoading)
                        Container(
                          width: context.width(1),
                          height: context.height(1),
                          color: Colors.transparent,
                          child: UnconstrainedBox(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                              ),
                              height: 50,
                              width: 50,
                              child: const Center(child: ProgressCenter()),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      );
    },
  );
}
