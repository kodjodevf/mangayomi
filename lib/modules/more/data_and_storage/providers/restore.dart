import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:isar_community/isar.dart';
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
import 'package:mangayomi/modules/more/data_and_storage/widgets/backup_encryption_password_dialog.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/backup_password_storage.dart';
import 'package:mangayomi/utils/isar_txn_retry.dart';
import 'package:protobuf/protobuf.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'restore.g.dart';

@riverpod
Future<void> doRestore(
  Ref ref, {
  required String path,
  required BuildContext context,
  bool merge = false,
  Map<String, bool> categoryDecisions = const {},
  Map<String, int> sourceDecisions = const {},
}) async {
  try {
    // Zip filenames aren't encrypted even when file content is, so this
    // initial pass (no password) is always enough to list files and
    // determine backup type. Password resolution only happens below, and
    // only for the mangayomi format, right before reading file *content*.
    final probeStream = InputFileStream(path);
    final Archive archive;
    try {
      archive = ZipDecoder().decodeStream(probeStream);
    } finally {
      probeStream.close();
    }
    final backupType = checkBackupType(path, archive);
    switch (backupType) {
      case BackupType.mangayomi:
        if (!context.mounted) return;
        final backup = await _decodeMangayomiBackup(path, context);
        await ref.read(restoreBackupProvider(backup).future);
        break;
      case BackupType.kotatsu:
        await ref.read(restoreKotatsuBackupProvider(archive).future);
        break;
      case BackupType.mihon:
      case BackupType.aniyomi:
      case BackupType.neko:
        await ref.read(
          restoreTachiBkBackupProvider(
            path,
            backupType,
            merge: merge,
            categoryDecisions: categoryDecisions,
            sourceDecisions: sourceDecisions,
          ).future,
        );
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
  }
}

/// Decodes a mangayomi-format backup's JSON contents, transparently
/// handling AES-encrypted backups: tries with no password, then the
/// locally-stored password (if any), then prompts the user - retrying on a
/// wrong password until it succeeds or the user cancels.
///
/// On success, if the backup embeds an encryption password (see
/// `backup.dart`), persists it locally so future backups/restores on this
/// device don't need it retyped - mirroring how every other part of a
/// restored backup overwrites the local settings, just kept out of the
/// generic Settings JSON round-trip (see backup_password_fallback.dart).
Future<Map<String, dynamic>> _decodeMangayomiBackup(
  String path,
  BuildContext context,
) async {
  String? passwordToTry;
  var triedStoredPassword = false;
  var wasIncorrect = false;
  final l10n = l10nLocalizations(context)!;

  while (true) {
    final stream = InputFileStream(path);
    try {
      final archive = ZipDecoder().decodeStream(
        stream,
        password: passwordToTry,
      );
      // decodeStream() only parses headers and buffers raw compressed
      // bytes - it doesn't verify/decrypt content (and so won't throw on a
      // wrong password) until the content is actually read, hence forcing
      // that access here rather than after returning.
      final bytes = archive.files.first.content as List<int>;
      final backup = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;

      final embeddedPassword = backup['backupEncryptionPassword'] as String?;
      if (embeddedPassword != null && context.mounted) {
        await persistResolvedPassword(embeddedPassword, context);
      }
      return backup;
    } catch (_) {
      if (!triedStoredPassword) {
        triedStoredPassword = true;
        final stored = await BackupPasswordStorage.get();
        if (stored != null) {
          passwordToTry = stored;
          continue;
        }
      }
      if (!context.mounted) rethrow;
      final entered = await showBackupDecryptPasswordDialog(
        context,
        wasIncorrect: wasIncorrect,
      );
      if (entered == null) {
        throw Exception(l10n.password_required_to_restore);
      }
      passwordToTry = entered;
      wasIncorrect = true;
    } finally {
      stream.close();
    }
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
        : path.contains("tachiyomi") ||
              path.contains("mihon") ||
              path.contains("komikku")
        ? BackupType.mihon
        : path.contains("neko")
        ? BackupType.neko
        : BackupType.unknown;
  }
  return BackupType.unknown;
}

BackupType peekBackupType(String path) {
  final inputStream = InputFileStream(path);
  try {
    final archive = ZipDecoder().decodeStream(inputStream);
    return checkBackupType(path, archive);
  } finally {
    inputStream.close();
  }
}

class TachiBkImportPreview {
  TachiBkImportPreview({
    required this.conflictingCategories,
    required this.unmatchedSourceNames,
    required this.newSeriesCount,
    required this.updatedSeriesCount,
    required this.newChapterCount,
  });

  final List<String> conflictingCategories;

  final Map<String, ItemType> unmatchedSourceNames;

  final int newSeriesCount;
  final int updatedSeriesCount;
  final int newChapterCount;
}

TachiBkImportPreview? previewTachiBkImport(String path) {
  final backupType = peekBackupType(path);
  if (backupType != BackupType.mihon &&
      backupType != BackupType.aniyomi &&
      backupType != BackupType.neko) {
    return null;
  }
  final inputStream = InputFileStream(path);
  final content = GZipDecoder().decodeBytes(inputStream.toUint8List());
  inputStream.close();
  final backup = BackupMihon.create();
  backup.mergeFromCodedBufferReader(
    CodedBufferReader(content, sizeLimit: 250 << 20),
  );

  final existingCategoryNames = isar.categorys
      .where()
      .findAllSync()
      .map((c) => c.name)
      .whereType<String>()
      .toSet();
  final categoryNames = <String>{for (var c in backup.backupCategories) c.name};

  final installedSourceNames = isar.sources
      .where()
      .findAllSync()
      .where((s) => s.sourceCode != null)
      .map((s) => (s.itemType, s.name?.toLowerCase()))
      .toSet();
  final unmatchedSources = <String, ItemType>{};

  final existingMangaByLink = {
    for (var m
        in isar.mangas.filter().itemTypeEqualTo(ItemType.manga).findAllSync())
      if (m.link != null) m.link!: m,
  };
  int newSeries = 0, updatedSeries = 0, newChapters = 0;
  for (var m in backup.backupManga) {
    final sourceId = _protoInt(m.source);
    final srcName =
        backup.backupSources
            .firstWhereOrNull((s) => _protoInt(s.sourceId) == sourceId)
            ?.name ??
        "Unknown";
    if (!installedSourceNames.contains((
      ItemType.manga,
      srcName.toLowerCase(),
    ))) {
      unmatchedSources[srcName] = ItemType.manga;
    }
    final existing = existingMangaByLink[m.url];
    if (existing != null) {
      updatedSeries++;
      final existingUrls = isar.chapters
          .filter()
          .mangaIdEqualTo(existing.id)
          .findAllSync()
          .map((c) => c.url)
          .whereType<String>()
          .toSet();
      newChapters += m.chapters
          .where((c) => !existingUrls.contains(c.url))
          .length;
    } else {
      newSeries++;
      newChapters += m.chapters.length;
    }
  }

  if (backupType == BackupType.aniyomi) {
    final backupAnime = BackupAniyomi.fromBuffer(content);
    final animeCategories = backupAnime.backupAnimeCategories.isNotEmpty
        ? backupAnime.backupAnimeCategories
        : backupAnime.legacyBackupAnimeCategories;
    final animeEntries = backupAnime.backupAnime.isNotEmpty
        ? backupAnime.backupAnime
        : backupAnime.legacyBackupAnime;
    final animeSources = backupAnime.backupAnimeSources.isNotEmpty
        ? backupAnime.backupAnimeSources
        : backupAnime.legacyBackupAnimeSources;
    categoryNames.addAll(animeCategories.map((c) => c.name));
    final existingAnimeByLink = {
      for (var m
          in isar.mangas.filter().itemTypeEqualTo(ItemType.anime).findAllSync())
        if (m.link != null) m.link!: m,
    };
    for (var a in animeEntries) {
      final sourceId = _protoInt(a.source);
      final srcName =
          animeSources
              .firstWhereOrNull((s) => _protoInt(s.sourceId) == sourceId)
              ?.name ??
          "Unknown";
      if (!installedSourceNames.contains((
        ItemType.anime,
        srcName.toLowerCase(),
      ))) {
        unmatchedSources[srcName] = ItemType.anime;
      }
      final existing = existingAnimeByLink[a.url];
      if (existing != null) {
        updatedSeries++;
        final existingUrls = isar.chapters
            .filter()
            .mangaIdEqualTo(existing.id)
            .findAllSync()
            .map((c) => c.url)
            .whereType<String>()
            .toSet();
        newChapters += a.episodes
            .where((c) => !existingUrls.contains(c.url))
            .length;
      } else {
        newSeries++;
        newChapters += a.episodes.length;
      }
    }
  }

  return TachiBkImportPreview(
    conflictingCategories: categoryNames
        .where(existingCategoryNames.contains)
        .toList(),
    unmatchedSourceNames: unmatchedSources,
    newSeriesCount: newSeries,
    updatedSeriesCount: updatedSeries,
    newChapterCount: newChapters,
  );
}

List<Source> installedSourcesFor(ItemType itemType) => isar.sources
    .where()
    .findAllSync()
    .where((s) => s.itemType == itemType && s.sourceCode != null)
    .toList();

int currentFavoriteMangaCount() =>
    isar.mangas.filter().favoriteEqualTo(true).countSync();

@riverpod
Future<void> restoreBackup(
  Ref ref,
  Map<String, dynamic> backup, {
  bool full = true,
}) async {
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

      final currentSettings = isar.settings.getSync(227);
      await writeTxnSyncWithRetry(() {
        isar.mangas.clearSync();
        if (manga != null) {
          isar.mangas.putAllSync(manga);
          if (chapters != null) {
            isar.chapters.clearSync();
            final mangaMap = {
              for (var m in isar.mangas.where().findAllSync()) m.id!: m,
            };
            final chaptersToPut = <Chapter>[];
            for (var chapter in chapters) {
              final manga = mangaMap[chapter.mangaId];
              if (manga != null) {
                chapter.manga.value = manga;
                chaptersToPut.add(chapter);
              }
            }
            isar.chapters.putAllSync(chaptersToPut);
            for (var chapter in chaptersToPut) {
              chapter.manga.saveSync();
            }

            final chapterMap = {
              for (var c in isar.chapters.where().findAllSync()) c.id!: c,
            };

            if (full) {
              isar.downloads.clearSync();
              if (downloads != null) {
                final downloadsToPut = <Download>[];
                for (var download in downloads) {
                  final chapter = chapterMap[download.id];
                  if (chapter != null) {
                    download.chapter.value = chapter;
                    downloadsToPut.add(download);
                  }
                }
                isar.downloads.putAllSync(downloadsToPut);
                for (var download in downloadsToPut) {
                  download.chapter.saveSync();
                }
              }
            }

            isar.historys.clearSync();
            if (history != null) {
              final historyToPut = <History>[];
              for (var element in history) {
                final chapter = chapterMap[element.chapterId];
                if (chapter != null) {
                  element.chapter.value = chapter;
                  historyToPut.add(element);
                }
              }
              isar.historys.putAllSync(historyToPut);
              for (var element in historyToPut) {
                element.chapter.saveSync();
              }
            }

            isar.updates.clearSync();
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
              isar.updates.putAllSync(updatesToPut);
              for (var update in updatesToPut) {
                update.chapter.saveSync();
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
            isar.settings.putAllSync(
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
Future<void> restoreKotatsuBackup(Ref ref, Archive archive) async {
  try {
    for (var f in archive.files) {
      List<Category> cats = [];
      switch (f.name) {
        case "categories":
          final categories = jsonDecode(utf8.decode(f.content)) as List? ?? [];
          await writeTxnSyncWithRetry(() {
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
          await writeTxnSyncWithRetry(() {
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
    await writeTxnSyncWithRetry(() {
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
Future<void> restoreTachiBkBackup(
  Ref ref,
  String path,
  BackupType bkType, {
  bool merge = false,
  Map<String, bool> categoryDecisions = const {},
  Map<String, int> sourceDecisions = const {},
}) async {
  final inputStream = InputFileStream(path);
  final content = GZipDecoder().decodeBytes(inputStream.toUint8List());
  inputStream.close();
  final backup = BackupMihon.create();
  backup.mergeFromCodedBufferReader(
    CodedBufferReader(content, sizeLimit: 250 << 20),
  );
  final installedSources = isar.sources
      .where()
      .findAllSync()
      .where((s) => s.sourceCode != null)
      .toList();
  Source? resolveSource(String originalName, ItemType itemType) {
    final decision = sourceDecisions[originalName];
    if (decision != null) return isar.sources.getSync(decision);
    return installedSources.firstWhereOrNull(
      (s) =>
          s.itemType == itemType &&
          s.name?.toLowerCase() == originalName.toLowerCase(),
    );
  }

  final categoryByOrder = <int, Category>{};
  await writeTxnSyncWithRetry(() {
    if (!merge) {
      isar.categorys.clearSync();
      isar.mangas.clearSync();
      isar.chapters.clearSync();
      isar.historys.clearSync();
    }
    final existingCategories = merge
        ? isar.categorys
              .filter()
              .forItemTypeEqualTo(ItemType.manga)
              .findAllSync()
        : <Category>[];
    for (var category in backup.backupCategories) {
      final order = _protoInt(category.order);
      final existing = existingCategories.firstWhereOrNull(
        (c) => c.name == category.name,
      );
      if (existing != null) {
        if (categoryDecisions[category.name] == false) continue;
        categoryByOrder[order] = existing;
        continue;
      }
      final cat = Category(
        name: category.name,
        forItemType: ItemType.manga,
        pos: order,
      );
      isar.categorys.putSync(cat);
      categoryByOrder[order] = cat;
    }
    final existingMangaByLink = merge
        ? {
            for (var m
                in isar.mangas
                    .filter()
                    .itemTypeEqualTo(ItemType.manga)
                    .findAllSync())
              if (m.link != null) m.link!: m,
          }
        : <String, Manga>{};
    for (var tempManga in backup.backupManga) {
      final sourceId = _protoInt(tempManga.source);
      final categoryOrders = tempManga.categories.map(_protoInt).toSet();
      final newCategoryIds = categoryOrders
          .map((o) => categoryByOrder[o]?.id)
          .whereType<int>()
          .toList();
      final existingManga = existingMangaByLink[tempManga.url];
      final Manga manga;
      final bool isNewManga = existingManga == null;
      if (existingManga != null) {
        manga = existingManga;
        manga.favorite = true;
        manga.categories = {...?manga.categories, ...newCategoryIds}.toList();
      } else {
        final originalSourceName =
            backup.backupSources
                .firstWhereOrNull((src) => _protoInt(src.sourceId) == sourceId)
                ?.name ??
            "Unknown";
        final boundSource = resolveSource(originalSourceName, ItemType.manga);
        manga = Manga(
          source: boundSource?.name ?? originalSourceName,
          author: tempManga.author,
          artist: tempManga.artist,
          genre: tempManga.genre,
          imageUrl: tempManga.thumbnailUrl,
          lang: boundSource?.lang ?? 'en',
          link: tempManga.url,
          name: tempManga.title,
          status: _convertStatusFromTachiBk(tempManga.status),
          description: tempManga.description,
          categories: newCategoryIds,
          itemType: ItemType.manga,
          favorite: true,
          dateAdded: _protoInt(tempManga.dateAdded),
          lastUpdate: _protoInt(tempManga.lastModifiedAt),
          sourceId: boundSource?.id,
        );
        if (bkType == BackupType.neko && boundSource == null) {
          manga.source = "MangaDex";
        }
      }
      isar.mangas.putSync(manga);
      final existingChaptersByUrl = merge && !isNewManga
          ? {
              for (var c
                  in isar.chapters
                      .filter()
                      .mangaIdEqualTo(manga.id)
                      .findAllSync())
                if (c.url != null) c.url!: c,
            }
          : <String, Chapter>{};
      History? history;
      for (var tempChapter in tempManga.chapters) {
        if (existingChaptersByUrl.containsKey(tempChapter.url)) continue;
        final chapter = Chapter(
          mangaId: manga.id!,
          name: tempChapter.name,
          dateUpload: bkType != BackupType.neko
              ? "${_protoInt(tempChapter.dateUpload)}"
              : "${DateTime.now().millisecondsSinceEpoch - _protoInt(tempChapter.dateUpload).abs()}",
          isBookmarked: tempChapter.bookmark,
          isRead: tempChapter.read,
          lastPageRead: _protoInt(tempChapter.lastPageRead) != 0
              ? "${_protoInt(tempChapter.lastPageRead)}"
              : "1",
          scanlator: tempChapter.scanlator,
          url: tempChapter.url,
        );
        isar.chapters.putSync(chapter..manga.value = manga);
        chapter.manga.saveSync();
        if ((history == null ||
            int.parse(history.date ?? "0") <
                _protoInt(tempChapter.lastModifiedAt))) {
          history = History(
            mangaId: manga.id,
            date: bkType != BackupType.neko
                ? "${_protoInt(tempChapter.lastModifiedAt)}"
                : "${DateTime.now().millisecondsSinceEpoch - _protoInt(tempChapter.dateUpload).abs()}",
            itemType: ItemType.manga,
            chapterId: chapter.id,
          )..chapter.value = chapter;
        }
      }
      if (history != null &&
          (!merge ||
              isar.historys.filter().mangaIdEqualTo(manga.id).findFirstSync() ==
                  null)) {
        isar.historys.putSync(history);
        history.chapter.saveSync();
      }
    }
  });
  if (bkType == BackupType.aniyomi) {
    final backupAnime = BackupAniyomi.fromBuffer(content);
    final animeCategories = backupAnime.backupAnimeCategories.isNotEmpty
        ? backupAnime.backupAnimeCategories
        : backupAnime.legacyBackupAnimeCategories;
    final animeEntries = backupAnime.backupAnime.isNotEmpty
        ? backupAnime.backupAnime
        : backupAnime.legacyBackupAnime;
    final animeSources = backupAnime.backupAnimeSources.isNotEmpty
        ? backupAnime.backupAnimeSources
        : backupAnime.legacyBackupAnimeSources;
    final categoryByOrder = <int, Category>{};
    await writeTxnSyncWithRetry(() {
      final existingAnimeCategories = merge
          ? isar.categorys
                .filter()
                .forItemTypeEqualTo(ItemType.anime)
                .findAllSync()
          : <Category>[];
      for (var category in animeCategories) {
        final order = _protoInt(category.order);
        final existing = existingAnimeCategories.firstWhereOrNull(
          (c) => c.name == category.name,
        );
        if (existing != null) {
          if (categoryDecisions[category.name] == false) continue;
          categoryByOrder[order] = existing;
          continue;
        }
        final cat = Category(
          name: category.name,
          forItemType: ItemType.anime,
          pos: order,
        );
        isar.categorys.putSync(cat);
        categoryByOrder[order] = cat;
      }
      final existingAnimeByLink = merge
          ? {
              for (var m
                  in isar.mangas
                      .filter()
                      .itemTypeEqualTo(ItemType.anime)
                      .findAllSync())
                if (m.link != null) m.link!: m,
            }
          : <String, Manga>{};
      for (var tempAnime in animeEntries) {
        final sourceId = _protoInt(tempAnime.source);
        final categoryOrders = tempAnime.categories.map(_protoInt).toSet();
        final newCategoryIds = categoryOrders
            .map((o) => categoryByOrder[o]?.id)
            .whereType<int>()
            .toList();
        final existingAnime = existingAnimeByLink[tempAnime.url];
        final Manga anime;
        final bool isNewAnime = existingAnime == null;
        if (existingAnime != null) {
          anime = existingAnime;
          anime.favorite = true;
          anime.categories = {...?anime.categories, ...newCategoryIds}.toList();
        } else {
          final originalSourceName =
              animeSources
                  .firstWhereOrNull(
                    (src) => _protoInt(src.sourceId) == sourceId,
                  )
                  ?.name ??
              "Unknown";
          final boundSource = resolveSource(originalSourceName, ItemType.anime);
          anime = Manga(
            source: boundSource?.name ?? originalSourceName,
            author: tempAnime.author,
            artist: tempAnime.artist,
            genre: tempAnime.genre,
            imageUrl: tempAnime.thumbnailUrl,
            lang: boundSource?.lang ?? 'en',
            link: tempAnime.url,
            name: tempAnime.title,
            status: _convertStatusFromTachiBk(tempAnime.status),
            description: tempAnime.description,
            categories: newCategoryIds,
            itemType: ItemType.anime,
            favorite: true,
            dateAdded: _protoInt(tempAnime.dateAdded),
            lastUpdate: _protoInt(tempAnime.lastModifiedAt),
            sourceId: boundSource?.id,
          );
        }
        isar.mangas.putSync(anime);
        final existingEpisodesByUrl = merge && !isNewAnime
            ? {
                for (var c
                    in isar.chapters
                        .filter()
                        .mangaIdEqualTo(anime.id)
                        .findAllSync())
                  if (c.url != null) c.url!: c,
              }
            : <String, Chapter>{};
        History? history;
        for (var tempEpisode in tempAnime.episodes) {
          if (existingEpisodesByUrl.containsKey(tempEpisode.url)) continue;
          final episode = Chapter(
            mangaId: anime.id!,
            name: tempEpisode.name,
            dateUpload: "${_protoInt(tempEpisode.dateUpload)}",
            isBookmarked: tempEpisode.bookmark,
            isRead: tempEpisode.seen,
            lastPageRead: _protoInt(tempEpisode.lastSecondSeen) != 0
                ? "${_secondsToMillis(tempEpisode.lastSecondSeen)}"
                : "1",
            scanlator: tempEpisode.scanlator,
            url: tempEpisode.url,
          );
          isar.chapters.putSync(episode..manga.value = anime);
          episode.manga.saveSync();
          if ((history == null ||
              int.parse(history.date ?? "0") <
                  _protoInt(tempEpisode.lastModifiedAt))) {
            history = History(
              mangaId: anime.id,
              date: "${_protoInt(tempEpisode.lastModifiedAt)}",
              itemType: ItemType.anime,
              chapterId: episode.id,
            )..chapter.value = episode;
          }
        }
        if (history != null &&
            (!merge ||
                isar.historys
                        .filter()
                        .mangaIdEqualTo(anime.id)
                        .findFirstSync() ==
                    null)) {
          isar.historys.putSync(history);
          history.chapter.saveSync();
        }
      }
    });
  }
  await writeTxnSyncWithRetry(() {
    if (!merge) {
      isar.downloads.clearSync();
      isar.updates.clearSync();
      isar.tracks.clearSync();
      isar.trackPreferences.clearSync();
    }
    _invalidateCommonState(ref);
  });
}

int _protoInt(Object value) {
  if (value is int) {
    return value;
  }
  return (value as dynamic).toInt() as int;
}

int _secondsToMillis(Object seconds) => _protoInt(seconds) * 1000;

Settings _preserveDeviceLocalSettings(Settings incoming, Settings current) {
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
