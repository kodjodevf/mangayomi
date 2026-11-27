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
      }
    }

    final oldToNewChapterId = <int, int>{};
    if (chapters != null) {
      final chapterIndexByMangaId = <int, _MangaChapterIndex>{};
      for (final tempChapter in chapters) {
        final newMangaId = tempChapter.mangaId != null
            ? oldToNewMangaId[tempChapter.mangaId]
            : null;
        if (newMangaId == null) continue;
        final index = chapterIndexByMangaId.putIfAbsent(
          newMangaId,
          () => _MangaChapterIndex.fromChapters(
            chapterRepository.getAllByMangaId(newMangaId),
          ),
        );
        final existingChapter = index.findMatch(tempChapter);
        if (existingChapter != null) {
          if (_reconcileChapterReadingState(existingChapter, tempChapter)) {
            chapterRepository.putSync(existingChapter);
          }
          if (tempChapter.id != null && existingChapter.id != null) {
            oldToNewChapterId[tempChapter.id!] = existingChapter.id!;
          }
          continue;
        }
        final mangaRef = mangaRepository.findById(newMangaId);
        if (mangaRef == null) continue;
        final oldId = tempChapter.id;
        tempChapter.id = null;
        tempChapter.mangaId = newMangaId;
        chapterRepository.putSync(tempChapter..manga.value = mangaRef);
        tempChapter.manga.saveSync();
        index.add(tempChapter);
        if (oldId != null) oldToNewChapterId[oldId] = tempChapter.id!;
      }
    }

    if (history != null) {
      final historyByMangaId = <int, List<History>>{};
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

        final existingList = historyByMangaId.putIfAbsent(
          newMangaId,
          () => historyRepository.getAllByMangaId(newMangaId).toList(),
        );
        final existing = _pickHistoryToMerge(existingList, newChapterId);
        if (existing != null) {
          final existingTime = existing.readingTimeSeconds ?? 0;
          final incomingTime = tempHistory.readingTimeSeconds ?? 0;
          final mergedTime = incomingTime > existingTime
              ? incomingTime
              : existingTime;
          final incomingIsNewer = _isIncomingNewer(
            existingUpdatedAt: existing.updatedAt,
            existingDate: existing.date,
            incomingUpdatedAt: tempHistory.updatedAt,
            incomingDate: tempHistory.date,
          );
          if (incomingIsNewer) {
            existing
              ..mangaId = newMangaId
              ..chapterId = newChapterId
              ..chapter.value = chapterRef
              ..date = tempHistory.date ?? existing.date
              ..updatedAt = tempHistory.updatedAt ?? existing.updatedAt
              ..readingTimeSeconds = mergedTime;
            historyRepository.putSync(existing);
            existing.chapter.saveSync();
          } else if (mergedTime > existingTime) {
            existing.readingTimeSeconds = mergedTime;
            historyRepository.putSync(existing);
          }
          continue;
        }

        tempHistory.id = null;
        tempHistory.mangaId = newMangaId;
        tempHistory.chapterId = newChapterId;
        historyRepository.putSync(tempHistory..chapter.value = chapterRef);
        tempHistory.chapter.saveSync();
        existingList.add(tempHistory);
      }
    }

    if (updates != null) {
      final updatesByMangaAndName = <int, Map<String, Update>>{};
      for (final tempUpdate in updates) {
        final newMangaId = tempUpdate.mangaId != null
            ? oldToNewMangaId[tempUpdate.mangaId]
            : null;
        final chapterName = tempUpdate.chapterName;
        if (newMangaId == null || chapterName == null) continue;
        final chapter = chapterRepository.findByMangaIdAndName(
          newMangaId,
          chapterName,
        );
        if (chapter == null) continue;

        final existingByName = updatesByMangaAndName.putIfAbsent(
          newMangaId,
          () => {
            for (final u in updateRepository.getAllByMangaId(newMangaId))
              if (u.chapterName != null) u.chapterName!: u,
          },
        );
        final existing = existingByName[chapterName];
        if (existing != null) {
          if (_isIncomingNewer(
            existingUpdatedAt: existing.updatedAt,
            existingDate: existing.date,
            incomingUpdatedAt: tempUpdate.updatedAt,
            incomingDate: tempUpdate.date,
          )) {
            existing
              ..date = tempUpdate.date ?? existing.date
              ..updatedAt = tempUpdate.updatedAt ?? existing.updatedAt
              ..chapter.value = chapter;
            updateRepository.putSync(existing);
            existing.chapter.saveSync();
          }
          continue;
        }

        tempUpdate.id = null;
        tempUpdate.mangaId = newMangaId;
        updateRepository.putSync(tempUpdate..chapter.value = chapter);
        tempUpdate.chapter.saveSync();
        existingByName[chapterName] = tempUpdate;
      }
    }
  }

  static bool _reconcileChapterReadingState(
    Chapter existing,
    Chapter incoming,
  ) {
    final existingUpdatedAt = existing.updatedAt ?? 0;
    final incomingUpdatedAt = incoming.updatedAt ?? 0;
    if (existingUpdatedAt > incomingUpdatedAt) return false;

    var changed = false;
    if (incomingUpdatedAt > existingUpdatedAt) {
      if (incoming.isRead != null && existing.isRead != incoming.isRead) {
        existing.isRead = incoming.isRead;
        changed = true;
      }
      if (incoming.isBookmarked != null &&
          existing.isBookmarked != incoming.isBookmarked) {
        existing.isBookmarked = incoming.isBookmarked;
        changed = true;
      }
      if ((incoming.lastPageRead ?? '').isNotEmpty &&
          existing.lastPageRead != incoming.lastPageRead) {
        existing.lastPageRead = incoming.lastPageRead;
        changed = true;
      }
      if (existing.updatedAt != incoming.updatedAt) {
        existing.updatedAt = incoming.updatedAt;
        changed = true;
      }
      return changed;
    }

    // Equal timestamps (including both 0): merge reading progress additively.
    if (incoming.isRead == true && existing.isRead != true) {
      existing.isRead = true;
      changed = true;
    }
    if (incoming.isBookmarked == true && existing.isBookmarked != true) {
      existing.isBookmarked = true;
      changed = true;
    }
    if ((existing.lastPageRead ?? '').isEmpty &&
        (incoming.lastPageRead ?? '').isNotEmpty) {
      existing.lastPageRead = incoming.lastPageRead;
      changed = true;
    }
    return changed;
  }

  static History? _pickHistoryToMerge(List<History> entries, int chapterId) {
    if (entries.isEmpty) return null;
    final byChapter = entries.firstWhereOrNull((h) => h.chapterId == chapterId);
    if (byChapter != null) return byChapter;
    return entries.reduce(
      (best, current) =>
          _isIncomingNewer(
            existingUpdatedAt: best.updatedAt,
            existingDate: best.date,
            incomingUpdatedAt: current.updatedAt,
            incomingDate: current.date,
          )
          ? current
          : best,
    );
  }

  static bool _isIncomingNewer({
    required int? existingUpdatedAt,
    required String? existingDate,
    required int? incomingUpdatedAt,
    required String? incomingDate,
  }) {
    final existingTs = existingUpdatedAt ?? 0;
    final incomingTs = incomingUpdatedAt ?? 0;
    if (existingTs > 0 && incomingTs > 0 && existingTs != incomingTs) {
      return incomingTs > existingTs;
    }
    final existingEffective = existingTs > 0
        ? existingTs
        : (int.tryParse(existingDate ?? '') ?? 0);
    final incomingEffective = incomingTs > 0
        ? incomingTs
        : (int.tryParse(incomingDate ?? '') ?? 0);
    if (incomingEffective != existingEffective) {
      return incomingEffective > existingEffective;
    }
    return (int.tryParse(incomingDate ?? '') ?? 0) >
        (int.tryParse(existingDate ?? '') ?? 0);
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

/// Per-manga chapter index used during merge restore to resolve existing
/// chapters by non-empty URL first, then by name/scanlator or archive path.
class _MangaChapterIndex {
  _MangaChapterIndex();

  final Map<String, Chapter> _byUrl = {};
  final Map<(String, String), Chapter> _byNameAndScanlator = {};
  final Map<String, Chapter> _byName = {};
  final Map<String, Chapter> _byArchivePath = {};

  factory _MangaChapterIndex.fromChapters(List<Chapter> chapters) {
    final index = _MangaChapterIndex();
    for (final chapter in chapters) {
      index.add(chapter);
    }
    return index;
  }

  void add(Chapter chapter) {
    final url = chapter.url;
    if (url != null && url.isNotEmpty) {
      _byUrl.putIfAbsent(url, () => chapter);
    }
    final name = chapter.name;
    if (name != null && name.isNotEmpty) {
      final scanlator = (chapter.scanlator ?? '').trim();
      _byNameAndScanlator.putIfAbsent((name, scanlator), () => chapter);
      _byName.putIfAbsent(name, () => chapter);
    }
    final archivePath = chapter.archivePath;
    if (archivePath != null && archivePath.isNotEmpty) {
      _byArchivePath.putIfAbsent(archivePath, () => chapter);
    }
  }

  Chapter? findMatch(Chapter incoming) {
    final url = incoming.url;
    if (url != null && url.isNotEmpty) {
      return _byUrl[url];
    }
    final name = incoming.name;
    if (name != null && name.isNotEmpty) {
      final scanlator = (incoming.scanlator ?? '').trim();
      final exact = _byNameAndScanlator[(name, scanlator)];
      if (exact != null) return exact;
      if (scanlator.isEmpty) {
        return _byName[name];
      }
      final unscoped = _byNameAndScanlator[(name, '')];
      if (unscoped != null) return unscoped;
    }
    final archivePath = incoming.archivePath;
    if (archivePath != null && archivePath.isNotEmpty) {
      return _byArchivePath[archivePath];
    }
    return null;
  }
}
