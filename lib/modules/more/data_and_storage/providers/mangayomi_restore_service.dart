import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_format.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore_invalidation.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/custom_button_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/restore_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/repositories/source_preference_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';

/// Service responsible for restoring Mangayomi native JSON backups.
class MangayomiRestoreService {
  const MangayomiRestoreService._();

  static Future<void> restore(
    Ref ref,
    Map<String, dynamic> backup, {
    bool full = true,
    bool merge = false,
    Map<String, bool> categoryDecisions = const {},
    Map<String, int> sourceDecisions = const {},
  }) async {
    final version = backup['version'];
    if (!["1", "2"].any((e) => e == version)) {
      throw "Failed to restore the backup";
    }

    try {
      final manga = (backup["manga"] as List?)
          ?.map((e) => Manga.fromJson(e)..itemType = convertToItemType(e))
          .toList();
      final chapters = (backup["chapters"] as List?)
          ?.map((e) => Chapter.fromJson(e))
          .toList();
      final categories = (backup["categories"] as List?)
          ?.map(
            (e) =>
                Category.fromJson(e)
                  ..forItemType = convertToItemTypeCategory(e),
          )
          .toList();
      final track = (backup["tracks"] as List?)
          ?.map((e) => Track.fromJson(e)..itemType = convertToItemType(e))
          .toList();
      final trackPreferences = (backup["trackPreferences"] as List?)
          ?.map((e) => TrackPreference.fromJson(e))
          .toList();
      final history = (backup["history"] as List?)
          ?.map((e) => History.fromJson(e)..itemType = convertToItemType(e))
          .toList();
      final downloads = (backup["downloads"] as List?)
          ?.map((e) => Download.fromJson(e))
          .toList();
      final settings = (backup["settings"] as List?)
          ?.map((e) => Settings.fromJson(e))
          .toList();
      final extensions = (backup["extensions"] as List?)
          ?.map((e) => Source.fromJson(e)..itemType = convertToItemType(e))
          .toList();
      final sourcesPrefs = (backup["extensions_preferences"] as List?)
          ?.map((e) => SourcePreference.fromJson(e))
          .toList();
      final updates = (backup["updates"] as List?)
          ?.map((e) => Update.fromJson(e))
          .toList();
      final customButtons = (backup["customButtons"] as List?)
          ?.map((e) => CustomButton.fromJson(e))
          .toList();

      final currentSettings = settingsRepository.currentOrNull;
      await restoreRepository.run(() {
        if (merge) {
          _mergeMangayomiBackup(
            manga: manga,
            chapters: chapters,
            categories: categories,
            history: history,
            updates: updates,
            categoryDecisions: categoryDecisions,
            sourceDecisions: sourceDecisions,
          );
          return;
        }
        mangaRepository.clearSync();
        if (manga != null) {
          mangaRepository.putAllSync(manga);
          if (chapters != null) {
            chapterRepository.clearSync();
            final mangaMap = {for (var m in mangaRepository.getAll()) m.id!: m};
            final chaptersToPut = <Chapter>[];
            for (var chapter in chapters) {
              final manga = mangaMap[chapter.mangaId];
              if (manga != null) {
                chapter.manga.value = manga;
                chaptersToPut.add(chapter);
              }
            }
            chapterRepository.putAllSync(chaptersToPut);
            for (var chapter in chaptersToPut) {
              chapter.manga.saveSync();
            }

            final chapterMap = {
              for (var c in chapterRepository.getAll()) c.id!: c,
            };

            if (full) {
              downloadRepository.clearSync();
              if (downloads != null) {
                final downloadsToPut = <Download>[];
                for (var download in downloads) {
                  final chapter = chapterMap[download.id];
                  if (chapter != null) {
                    download.chapter.value = chapter;
                    downloadsToPut.add(download);
                  }
                }
                downloadRepository.putAllSync(downloadsToPut);
                for (var download in downloadsToPut) {
                  download.chapter.saveSync();
                }
              }
            }

            historyRepository.clearSync();
            if (history != null) {
              final historyToPut = <History>[];
              for (var element in history) {
                final chapter = chapterMap[element.chapterId];
                if (chapter != null) {
                  element.chapter.value = chapter;
                  historyToPut.add(element);
                }
              }
              historyRepository.putAllSync(historyToPut);
              for (var element in historyToPut) {
                element.chapter.saveSync();
              }
            }

            updateRepository.clearSync();
            if (updates != null) {
              final chapterMapByKey = {
                for (var c in chapterMap.values) "${c.mangaId}_${c.name}": c,
              };
              final updatesToPut = <Update>[];
              for (var update in updates) {
                final matchingChapter =
                    chapterMapByKey["${update.mangaId}_${update.chapterName}"];
                if (matchingChapter != null) {
                  update.chapter.value = matchingChapter;
                  updatesToPut.add(update);
                }
              }
              updateRepository.putAllSync(updatesToPut);
              for (var update in updatesToPut) {
                update.chapter.saveSync();
              }
            }
          }

          categoryRepository.clearSync();
          if (categories != null) {
            categoryRepository.putAllSync(categories);
          }
        }

        trackRepository.clearSync();
        if (track != null) {
          trackRepository.putAllSync(track);
        }

        if (full) {
          if (trackPreferences != null) {
            trackRepository.clearPreferencesSync();
            trackRepository.putAllPreferencesSync(trackPreferences);
          }
          sourceRepository.clearSync();
          if (extensions != null) {
            sourceRepository.putAllSync(extensions);
          }
          sourcePreferenceRepository.clearSync();
          if (sourcesPrefs != null) {
            sourcePreferenceRepository.putAllSync(sourcesPrefs);
          }
          settingsRepository.clearSync();
          if (settings != null) {
            settingsRepository.putAllSync(
              settings
                  .map(
                    (settings) => currentSettings == null
                        ? settings
                        : _preserveDeviceLocalSettings(
                            settings,
                            currentSettings,
                          ),
                  )
                  .toList(),
            );
          }
          customButtonRepository.clearSync();
          if (customButtons != null) {
            customButtonRepository.putAllSync(customButtons);
          }
        }
      });
      if (full) {
        invalidateCommonRestoreState(ref);
      }
    } catch (e) {
      rethrow;
    }
  }

  static void _mergeMangayomiBackup({
    required List<Manga>? manga,
    required List<Chapter>? chapters,
    required List<Category>? categories,
    required List<History>? history,
    required List<Update>? updates,
    required Map<String, bool> categoryDecisions,
    required Map<String, int> sourceDecisions,
  }) {
    final oldToNewCategoryId = <int, int>{};
    if (categories != null) {
      final existingCategories = categoryRepository.getAll();
      for (final category in categories) {
        final oldId = category.id;
        final existing = existingCategories.firstWhereOrNull(
          (c) =>
              c.name == category.name && c.forItemType == category.forItemType,
        );
        if (existing != null) {
          if (oldId != null) oldToNewCategoryId[oldId] = existing.id!;
          continue;
        }
        if (categoryDecisions[category.name] == false) continue;
        category.id = null;
        categoryRepository.putSync(category);
        if (oldId != null) oldToNewCategoryId[oldId] = category.id!;
      }
    }

    final oldToNewMangaId = <int, int>{};
    final newMangaIds = <int>{};
    if (manga != null) {
      final existingMangaByKey = {
        for (final m in mangaRepository.getAll())
          if (m.link != null) '${m.itemType.index}|${m.link}': m,
      };
      for (final tempManga in manga) {
        final oldId = tempManga.id;
        final key = '${tempManga.itemType.index}|${tempManga.link}';
        final existing = tempManga.link != null
            ? existingMangaByKey[key]
            : null;
        final remappedCategories = (tempManga.categories ?? [])
            .map((id) => oldToNewCategoryId[id])
            .whereType<int>()
            .toList();
        if (existing != null) {
          existing.favorite = true;
          existing.categories = {
            ...?existing.categories,
            ...remappedCategories,
          }.toList();
          mangaRepository.putSync(existing);
          if (oldId != null) oldToNewMangaId[oldId] = existing.id!;
          continue;
        }
        final originalSourceName = tempManga.source ?? "Unknown";
        final decidedSourceId = sourceDecisions[originalSourceName];
        final boundSource = decidedSourceId != null
            ? sourceRepository.getById(decidedSourceId)
            : installedSourcesFor(tempManga.itemType).firstWhereOrNull(
                (s) =>
                    s.name?.toLowerCase() == originalSourceName.toLowerCase(),
              );
        tempManga.id = null;
        tempManga.categories = remappedCategories;
        tempManga.favorite = true;
        if (boundSource != null) {
          tempManga.sourceId = boundSource.id;
          tempManga.source = boundSource.name;
        } else {
          tempManga.sourceId = null;
        }
        mangaRepository.putSync(tempManga);
        if (oldId != null) oldToNewMangaId[oldId] = tempManga.id!;
        newMangaIds.add(tempManga.id!);
      }
    }

    final oldToNewChapterId = <int, int>{};
    if (chapters != null) {
      final existingUrlsByMangaId = <int, Set<String>>{};
      for (final tempChapter in chapters) {
        final newMangaId = tempChapter.mangaId != null
            ? oldToNewMangaId[tempChapter.mangaId]
            : null;
        if (newMangaId == null) continue;
        if (!newMangaIds.contains(newMangaId)) continue;
        final existingUrls = existingUrlsByMangaId.putIfAbsent(
          newMangaId,
          () => chapterRepository
              .getAllByMangaId(newMangaId)
              .map((c) => c.url)
              .whereType<String>()
              .toSet(),
        );
        if (tempChapter.url != null && existingUrls.contains(tempChapter.url)) {
          continue;
        }
        final mangaRef = mangaRepository.findById(newMangaId);
        if (mangaRef == null) continue;
        final oldId = tempChapter.id;
        tempChapter.id = null;
        tempChapter.mangaId = newMangaId;
        chapterRepository.putSync(tempChapter..manga.value = mangaRef);
        tempChapter.manga.saveSync();
        if (tempChapter.url != null) existingUrls.add(tempChapter.url!);
        if (oldId != null) oldToNewChapterId[oldId] = tempChapter.id!;
      }
    }

    if (history != null) {
      for (final tempHistory in history) {
        final newChapterId = tempHistory.chapterId != null
            ? oldToNewChapterId[tempHistory.chapterId]
            : null;
        final newMangaId = tempHistory.mangaId != null
            ? oldToNewMangaId[tempHistory.mangaId]
            : null;
        if (newChapterId == null || newMangaId == null) continue;
        final chapterRef = chapterRepository.findByIdSync(newChapterId);
        if (chapterRef == null) continue;
        tempHistory.id = null;
        tempHistory.mangaId = newMangaId;
        tempHistory.chapterId = newChapterId;
        historyRepository.putSync(tempHistory..chapter.value = chapterRef);
        tempHistory.chapter.saveSync();
      }
    }

    if (updates != null) {
      for (final tempUpdate in updates) {
        final newMangaId = tempUpdate.mangaId != null
            ? oldToNewMangaId[tempUpdate.mangaId]
            : null;
        if (newMangaId == null || !newMangaIds.contains(newMangaId)) continue;
        final chapter = chapterRepository.findByMangaIdAndName(
          newMangaId,
          tempUpdate.chapterName,
        );
        if (chapter == null) continue;
        tempUpdate.id = null;
        tempUpdate.mangaId = newMangaId;
        updateRepository.putSync(tempUpdate..chapter.value = chapter);
        tempUpdate.chapter.saveSync();
      }
    }
  }

  static Settings _preserveDeviceLocalSettings(
    Settings incoming,
    Settings current,
  ) {
    return incoming
      ..id = current.id
      ..localFolders = current.localFolders
      ..namedLocalFolders = current.namedLocalFolders
      ..downloadLocalFolderName = current.downloadLocalFolderName
      ..askDownloadDestination = current.askDownloadDestination
      ..androidProxyServer = current.androidProxyServer
      ..jrePath = current.jrePath
      ..extensionServerPath = current.extensionServerPath;
  }
}
