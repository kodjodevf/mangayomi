import 'dart:convert';
import 'package:archive/archive_io.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupAniyomi.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupMihon.pb.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:protobuf/protobuf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'restore.g.dart';

@riverpod
void doRestore(Ref ref, {required String path, required BuildContext context}) {
  final inputStream = InputFileStream(path);
  try {
    final archive = ZipDecoder().decodeStream(inputStream);
    final backupType = checkBackupType(path, archive);
    switch (backupType) {
      case BackupType.mangayomi:
        final backup =
            jsonDecode(utf8.decode(archive.files.first.content))
                as Map<String, dynamic>;
        ref.read(restoreBackupProvider(backup));
        break;
      case BackupType.kotatsu:
        ref.read(restoreKotatsuBackupProvider(archive));
        break;
      case BackupType.mihon:
      case BackupType.aniyomi:
      case BackupType.neko:
        ref.read(restoreTachiBkBackupProvider(path, backupType));
        break;
      default:
    }
    if (backupType != BackupType.unknown) {
      showBotToast("Backup restored!");
    } else {
      showBotToast("Backup Type not supported!");
    }
  } catch (e, s) {
    botToast('$e\n$s');
  } finally {
    inputStream.close();
  }
}

void showBotToast(String text) {
  BotToast.showNotification(
    animationDuration: const Duration(milliseconds: 200),
    animationReverseDuration: const Duration(milliseconds: 200),
    duration: const Duration(seconds: 5),
    backButtonBehavior: BackButtonBehavior.none,
    leading: (_) => Image.asset('assets/app_icons/icon-red.png', height: 40),
    title: (_) => Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    enableSlideOff: true,
    onlyOne: true,
    crossPage: true,
  );
}

enum BackupType { unknown, mangayomi, mihon, aniyomi, kotatsu, neko }

BackupType checkBackupType(String path, Archive archive) {
  if (path.toLowerCase().contains("mangayomi") &&
      (archive.files.firstOrNull?.name ?? "").endsWith(".backup.db")) {
    return BackupType.mangayomi;
  } else if (path.toLowerCase().contains("kotatsu") &&
      archive.files.where((f) {
            switch (f.name) {
              case "categories":
              case "favourites":
                return true;
              default:
                return false;
            }
          }).length ==
          2) {
    return BackupType.kotatsu;
  } else if (path.toLowerCase().endsWith(".tachibk") ||
      path.toLowerCase().endsWith(".proto.gz")) {
    return path.contains("xyz.jmir.tachiyomi.mi") || path.contains("aniyomi.mi")
        ? BackupType.aniyomi
        : path.contains("tachiyomi") || path.contains("mihon")
        ? BackupType.mihon
        : path.contains("neko")
        ? BackupType.neko
        : BackupType.unknown;
  }
  return BackupType.unknown;
}

@riverpod
void restoreBackup(Ref ref, Map<String, dynamic> backup, {bool full = true}) {
  final version = backup['version'];
  if (["1", "2"].any((e) => e == version)) {
    try {
      final manga = (backup["manga"] as List?)
          ?.map((e) => Manga.fromJson(e)..itemType = _convertToItemType(e))
          .toList();
      final chapters = (backup["chapters"] as List?)
          ?.map((e) => Chapter.fromJson(e))
          .toList();
      final categories = (backup["categories"] as List?)
          ?.map(
            (e) =>
                Category.fromJson(e)
                  ..forItemType = _convertToItemTypeCategory(e),
          )
          .toList();
      final track = (backup["tracks"] as List?)
          ?.map((e) => Track.fromJson(e)..itemType = _convertToItemType(e))
          .toList();
      final trackPreferences = (backup["trackPreferences"] as List?)
          ?.map((e) => TrackPreference.fromJson(e))
          .toList();
      final history = (backup["history"] as List?)
          ?.map((e) => History.fromJson(e)..itemType = _convertToItemType(e))
          .toList();
      final downloads = (backup["downloads"] as List?)
          ?.map((e) => Download.fromJson(e))
          .toList();
      final settings = (backup["settings"] as List?)
          ?.map((e) => Settings.fromJson(e))
          .toList();
      final extensions = (backup["extensions"] as List?)
          ?.map((e) => Source.fromJson(e)..itemType = _convertToItemType(e))
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

      isar.writeTxnSync(() {
        isar.mangas.clearSync();
        if (manga != null) {
          isar.mangas.putAllSync(manga);
          if (chapters != null) {
            isar.chapters.clearSync();
            for (var chapter in chapters) {
              final manga = isar.mangas.getSync(chapter.mangaId!);
              if (manga != null) {
                isar.chapters.putSync(chapter..manga.value = manga);
                chapter.manga.saveSync();
              }
            }

            if (full) {
              isar.downloads.clearSync();
              if (downloads != null) {
                for (var download in downloads) {
                  final chapter = isar.chapters.getSync(download.id!);
                  if (chapter != null) {
                    isar.downloads.putSync(download..chapter.value = chapter);
                    download.chapter.saveSync();
                  }
                }
              }
            }

            isar.historys.clearSync();
            if (history != null) {
              for (var element in history) {
                final chapter = isar.chapters.getSync(element.chapterId!);
                if (chapter != null) {
                  isar.historys.putSync(element..chapter.value = chapter);
                  element.chapter.saveSync();
                }
              }
            }

            isar.updates.clearSync();
            if (updates != null) {
              final tempChapters = isar.chapters
                  .filter()
                  .idIsNotNull()
                  .findAllSync()
                  .toList();
              for (var update in updates) {
                final matchingChapter = tempChapters
                    .where(
                      (chapter) =>
                          chapter.mangaId == update.mangaId &&
                          chapter.name == update.chapterName,
                    )
                    .firstOrNull;
                if (matchingChapter != null) {
                  isar.updates.putSync(update..chapter.value = matchingChapter);
                  update.chapter.saveSync();
                }
              }
            }
          }

          isar.categorys.clearSync();
          if (categories != null) {
            isar.categorys.putAllSync(categories);
          }
        }

        isar.tracks.clearSync();
        if (track != null) {
          isar.tracks.putAllSync(track);
        }

        if (full) {
          if (trackPreferences != null) {
            isar.trackPreferences.clearSync();
            isar.trackPreferences.putAllSync(trackPreferences);
          }
          isar.sources.clearSync();
          if (extensions != null) {
            isar.sources.putAllSync(extensions);
          }
          isar.sourcePreferences.clearSync();
          if (sourcesPrefs != null) {
            isar.sourcePreferences.putAllSync(sourcesPrefs);
          }
          isar.settings.clearSync();
          if (settings != null) {
            isar.settings.putAllSync(settings);
          }
          isar.customButtons.clearSync();
          if (customButtons != null) {
            isar.customButtons.putAllSync(customButtons);
          }
          _invalidateCommonState(ref);
        }
      });
    } catch (e) {
      rethrow;
    }
  } else {
    throw "Failed to restore the backup";
  }
}

ItemType _convertToItemType(Map<String, dynamic> backup) {
  final isManga = backup['isManga'];
  return isManga == null
      ? ItemType.values[backup['itemType'] ?? 0]
      : isManga
      ? ItemType.manga
      : ItemType.anime;
}

ItemType _convertToItemTypeCategory(Map<String, dynamic> backup) {
  final forManga = backup['forManga'];
  return forManga == null
      ? ItemType.values[backup['forItemType'] ?? 0]
      : forManga
      ? ItemType.manga
      : ItemType.anime;
}

@riverpod
void restoreKotatsuBackup(Ref ref, Archive archive) {
  try {
    for (var f in archive.files) {
      List<Category> cats = [];
      switch (f.name) {
        case "categories":
          final categories = jsonDecode(utf8.decode(f.content)) as List? ?? [];
          isar.writeTxnSync(() {
            isar.categorys.clearSync();
            for (var category in categories) {
              final cat = Category(
                id: category["id"],
                name: category["title"],
                forItemType: ItemType.manga,
                hide: !(category["show_in_lib"] ?? true),
              );
              isar.categorys.putSync(cat);
              cats.add(cat);
            }
          });
        case "favourites":
          final favourites = jsonDecode(utf8.decode(f.content)) as List? ?? [];
          isar.writeTxnSync(() {
            isar.mangas.clearSync();
            for (var favourite in favourites) {
              final tempManga = favourite["manga"];
              final manga = Manga(
                source: tempManga["source"],
                author: tempManga["author"],
                artist: null,
                genre:
                    (tempManga["tags"] as List?)
                        ?.map((t) => t["title"] as String)
                        .toList() ??
                    [],
                imageUrl: tempManga["large_cover_url"],
                lang: 'en',
                link: tempManga["url"],
                name: tempManga["title"],
                status: Status.values.firstWhere(
                  (s) =>
                      s.name.toLowerCase() ==
                      (tempManga["state"] as String?)?.toLowerCase(),
                  orElse: () => Status.unknown,
                ),
                description: null,
                categories: [favourite["category_id"]],
                itemType: ItemType.manga,
                favorite: true,
                sourceId: null,
              );
              isar.mangas.putSync(manga);
            }
          });
        default:
          continue;
      }
    }
    isar.writeTxnSync(() {
      isar.chapters.clearSync();
      isar.downloads.clearSync();
      isar.historys.clearSync();
      isar.updates.clearSync();
      isar.tracks.clearSync();
      isar.trackPreferences.clearSync();
      _invalidateCommonState(ref);
    });
  } catch (e) {
    rethrow;
  }
}

@riverpod
void restoreTachiBkBackup(Ref ref, String path, BackupType bkType) {
  final inputStream = InputFileStream(path);
  final content = GZipDecoder().decodeBytes(inputStream.toUint8List());
  inputStream.close();
  final backup = BackupMihon.create();
  backup.mergeFromCodedBufferReader(
    CodedBufferReader(content, sizeLimit: 250 << 20),
  );
  List<Category> cats = [];
  isar.writeTxnSync(() {
    isar.categorys.clearSync();
    isar.mangas.clearSync();
    isar.chapters.clearSync();
    isar.historys.clearSync();
    for (var category in backup.backupCategories) {
      final cat = Category(
        name: category.name,
        forItemType: ItemType.manga,
        pos: category.order,
      );
      isar.categorys.putSync(cat);
      cats.add(cat);
    }
    for (var tempManga in backup.backupManga) {
      final manga = Manga(
        source:
            backup.backupSources
                .firstWhereOrNull((src) => src.sourceId == tempManga.source)
                ?.name ??
            "Unknown",
        author: tempManga.author,
        artist: tempManga.artist,
        genre: tempManga.genre,
        imageUrl: tempManga.thumbnailUrl,
        lang: 'en',
        link: tempManga.url,
        name: tempManga.title,
        status: _convertStatusFromTachiBk(tempManga.status),
        description: tempManga.description,
        categories: cats
            .where((cat) => tempManga.categories.contains(cat.pos!))
            .map((cat) => cat.id!)
            .toList(),
        itemType: ItemType.manga,
        favorite: true,
        dateAdded: tempManga.dateAdded * 1000,
        lastUpdate: tempManga.lastModifiedAt * 1000,
        sourceId: null,
      );
      if (bkType == BackupType.neko) {
        manga.source = "MangaDex";
      }
      isar.mangas.putSync(manga);
      History? history;
      for (var tempChapter in tempManga.chapters) {
        final chapter = Chapter(
          mangaId: manga.id!,
          name: tempChapter.name,
          dateUpload: bkType != BackupType.neko
              ? "${tempChapter.dateUpload * 1000}"
              : "${DateTime.now().millisecondsSinceEpoch - tempChapter.dateUpload.abs()}",
          isBookmarked: tempChapter.bookmark,
          isRead: tempChapter.read,
          lastPageRead: tempChapter.lastPageRead != 0
              ? "${tempChapter.lastPageRead}"
              : "1",
          scanlator: tempChapter.scanlator,
          url: tempChapter.url,
        );
        isar.chapters.putSync(chapter..manga.value = manga);
        chapter.manga.saveSync();
        if ((history == null ||
            int.parse(history.date ?? "0") <
                tempChapter.lastModifiedAt * 1000)) {
          history = History(
            mangaId: manga.id,
            date: bkType != BackupType.neko
                ? "${tempChapter.lastModifiedAt * 1000}"
                : "${DateTime.now().millisecondsSinceEpoch - tempChapter.dateUpload.abs()}",
            itemType: ItemType.manga,
            chapterId: chapter.id,
          )..chapter.value = chapter;
        }
      }
      if (history != null) {
        isar.historys.putSync(history);
        history.chapter.saveSync();
      }
    }
  });
  if (bkType == BackupType.aniyomi) {
    final backupAnime = BackupAniyomi.fromBuffer(content);
    List<Category> cats = [];
    isar.writeTxnSync(() {
      for (var category in backupAnime.backupAnimeCategories) {
        final cat = Category(
          name: category.name,
          forItemType: ItemType.anime,
          pos: category.order,
        );
        isar.categorys.putSync(cat);
        cats.add(cat);
      }
      for (var tempAnime in backupAnime.backupAnime) {
        final anime = Manga(
          source:
              backupAnime.backupAnimeSources
                  .firstWhereOrNull((src) => src.sourceId == tempAnime.source)
                  ?.name ??
              "Unknown",
          author: tempAnime.author,
          artist: tempAnime.artist,
          genre: tempAnime.genre,
          imageUrl: tempAnime.thumbnailUrl,
          lang: 'en',
          link: tempAnime.url,
          name: tempAnime.title,
          status: _convertStatusFromTachiBk(tempAnime.status),
          description: tempAnime.description,
          categories: cats
              .where((cat) => tempAnime.categories.contains(cat.pos!))
              .map((cat) => cat.id!)
              .toList(),
          itemType: ItemType.anime,
          favorite: true,
          dateAdded: tempAnime.dateAdded * 1000,
          lastUpdate: tempAnime.lastModifiedAt * 1000,
          sourceId: null,
        );
        isar.mangas.putSync(anime);
        History? history;
        for (var tempEpisode in tempAnime.episodes) {
          final episode = Chapter(
            mangaId: anime.id!,
            name: tempEpisode.name,
            dateUpload: "${tempEpisode.dateUpload * 1000}",
            isBookmarked: tempEpisode.bookmark,
            isRead: tempEpisode.seen,
            lastPageRead: tempEpisode.lastSecondSeen != 0
                ? "${tempEpisode.lastSecondSeen * 1000}"
                : "1",
            scanlator: tempEpisode.scanlator,
            url: tempEpisode.url,
          );
          isar.chapters.putSync(episode..manga.value = anime);
          episode.manga.saveSync();
          if ((history == null ||
              int.parse(history.date ?? "0") <
                  tempEpisode.lastModifiedAt * 1000)) {
            history = History(
              mangaId: anime.id,
              date: "${tempEpisode.lastModifiedAt * 1000}",
              itemType: ItemType.anime,
              chapterId: episode.id,
            )..chapter.value = episode;
          }
        }
        if (history != null) {
          isar.historys.putSync(history);
          history.chapter.saveSync();
        }
      }
    });
  }
  isar.writeTxnSync(() {
    isar.downloads.clearSync();
    isar.updates.clearSync();
    isar.tracks.clearSync();
    isar.trackPreferences.clearSync();
    _invalidateCommonState(ref);
  });
}

void _invalidateCommonState(Ref ref) {
  ref.read(synchingProvider(syncId: 1).notifier).clearAllChangedParts(false);
  ref.invalidate(followSystemThemeStateProvider);
  ref.invalidate(themeModeStateProvider);
  ref.invalidate(blendLevelStateProvider);
  ref.invalidate(flexSchemeColorStateProvider);
  ref.invalidate(pureBlackDarkModeStateProvider);
  ref.invalidate(l10nLocaleStateProvider);
  ref.invalidate(navigationOrderStateProvider);
  ref.invalidate(hideItemsStateProvider);
  ref.invalidate(extensionsRepoStateProvider(ItemType.manga));
  ref.invalidate(extensionsRepoStateProvider(ItemType.anime));
  ref.invalidate(extensionsRepoStateProvider(ItemType.novel));
  ref.read(routerCurrentLocationStateProvider.notifier).refresh();
}

Status _convertStatusFromTachiBk(int idx) {
  switch (idx) {
    case 1:
      return Status.ongoing;
    case 2:
      return Status.completed;
    case 4:
      return Status.publishingFinished;
    case 5:
      return Status.canceled;
    case 6:
      return Status.onHiatus;
    default:
      return Status.unknown;
  }
}
