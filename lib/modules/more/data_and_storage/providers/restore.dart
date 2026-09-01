import 'dart:async';
import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
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
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/error_toast.dart';
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
  // Already-decoded/decrypted mangayomi-format backup, if the caller ran
  // decodeMangayomiBackup itself to preview it first. Skips re-decoding
  // (and re-prompting for a password) here.
  Map<String, dynamic>? decodedMangayomiBackup,
  // Caller's answer to "upload this restore to your sync server?", asked
  // only when a server was connected. true = upload, false = the user chose
  // to turn sync off instead (so stale server data can't come back and
  // undo this restore), null = no server was connected, nothing to do.
  bool? syncAfterRestore,
}) async {
  // Without this, doRestore is autoDispose with only the calling widget's
  // watch keeping it alive — if that widget unmounts mid-restore (dialog
  // closes, screen pops), the provider gets disposed mid-flight and every
  // ref use below throws UnmountedRefException.
  ref.keepAlive();
  // Resolved before any await, so it's safe to use after one.
  final l10n = l10nLocalizations(context);
  // Yield once first: doRestore is itself a provider, and mutating another
  // provider synchronously before its first await counts as modifying it
  // "during initialization", which Riverpod forbids. A microtask (not a
  // real delay) so no frame runs in between — a real delay let the busy
  // dialog close and unmount this autoDispose provider's context first.
  await Future<void>.value();
  // Blocks the auto-sync timer and any manual sync trigger until this
  // restore (and its post-restore upload, if any) finishes — otherwise
  // either could race the restore and pull stale server data back down.
  ref.read(restoreSyncGuardProvider.notifier).start();
  var uploadStarted = false;
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
        final backup =
            decodedMangayomiBackup ??
            await decodeMangayomiBackup(path, context);
        await ref.read(
          restoreBackupProvider(
            backup,
            merge: merge,
            categoryDecisions: categoryDecisions,
            sourceDecisions: sourceDecisions,
          ).future,
        );
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
      if (syncAfterRestore == false) {
        // User declined to push this restore to the server — turn sync off
        // rather than leave it running, since the next sync would otherwise
        // pull the server's old data back down and undo the restore.
        final syncNotifier = ref.read(synchingProvider(syncId: 1).notifier);
        syncNotifier.setSyncOn(false);
        syncNotifier.setAutoSyncFrequency(0);
        if (l10n != null) botToast(l10n.sync_disabled_after_restore);
      } else if (syncAfterRestore == true && l10n != null) {
        // Sync may have been disabled by a previous restore — re-enable it
        // before pushing, since startSync below is the connection check
        // (its own error handling reports a bad server/credentials).
        ref.read(synchingProvider(syncId: 1).notifier).setSyncOn(true);
        // Not awaited: this pushes to the sync server over the network, and
        // shouldn't hold up the restore flow (e.g. a caller's busy dialog)
        // waiting on it. It owns clearing the guard once it settles.
        uploadStarted = true;
        unawaited(_uploadToSyncServerIfConnected(ref, l10n));
      }
    } else {
      showBotToast("Backup Type not supported!");
    }
  } catch (e, s) {
    toastError(e, stack: s, source: 'restore');
  } finally {
    if (!uploadStarted) {
      ref.read(restoreSyncGuardProvider.notifier).finish();
    }
  }
}

/// Pushes the just-restored data to the sync server (if connected) so it
/// isn't left holding the pre-restore state, which the next sync would
/// otherwise pull back down and undo the restore. Silently skipped when no
/// server is configured. Always clears the restore guard on the way out,
/// since doRestore hands off ownership of it to this function once called.
Future<void> _uploadToSyncServerIfConnected(
  Ref ref,
  AppLocalizations l10n,
) async {
  try {
    final syncPreference = ref.read(synchingProvider(syncId: 1));
    final connected =
        (syncPreference.authToken?.isNotEmpty ?? false) &&
        (syncPreference.server?.isNotEmpty ?? false);
    if (!connected) return;
    botToast(l10n.restore_sync_uploading);
    // silent: true suppresses startSync's own generic "Starting/Finished"
    // toasts (this one is restore-specific below) - it still shows its own
    // "Sync failed" toast on failure, so that case doesn't need one here.
    final success = await ref
        .read(syncServerProvider(syncId: 1).notifier)
        .startSync(l10n, true, upload: true, bypassRestoreGuard: true);
    if (success) {
      botToast(l10n.restore_sync_upload_success);
    }
  } catch (e) {
    botToast(
      "Backup restored, but couldn't push it to your sync server: $e. "
      "The server still has the old data until the next successful sync.",
    );
  } finally {
    ref.read(restoreSyncGuardProvider.notifier).finish();
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
///
/// Public so the restore UI can decode+preview a mangayomi-format backup
/// (merge/replace choice, category/source conflicts) before committing to
/// the actual restore - doRestore accepts the result back as
/// decodedMangayomiBackup so it isn't decrypted (and the password
/// re-prompted) a second time.
Future<Map<String, dynamic>> decodeMangayomiBackup(
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
    leading: (_) => Image.asset(appIconAssets[1], height: 40),
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

  final existingCategoryNames = categoryRepository
      .getAll()
      .map((c) => c.name)
      .whereType<String>()
      .toSet();
  final categoryNames = <String>{for (var c in backup.backupCategories) c.name};

  final installedSourceNames = sourceRepository
      .getAll()
      .where((s) => s.isAdded ?? false)
      .map((s) => (s.itemType, s.name?.toLowerCase()))
      .toSet();
  final unmatchedSources = <String, ItemType>{};

  final existingMangaByLink = {
    for (var m in mangaRepository.getByItemType(ItemType.manga))
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
      final existingUrls = chapterRepository
          .getAllByMangaId(existing.id)
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
      for (var m in mangaRepository.getByItemType(ItemType.anime))
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
        final existingUrls = chapterRepository
            .getAllByMangaId(existing.id)
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

List<Source> installedSourcesFor(ItemType itemType) => sourceRepository
    .getAll()
    .where((s) => s.itemType == itemType && (s.isAdded ?? false))
    .toList();

/// Same preview shape as previewTachiBkImport, but for the native
/// mangayomi backup format - already-decoded (and, for encrypted backups,
/// already-decrypted) JSON rather than a path to re-read from disk.
TachiBkImportPreview previewMangayomiBackup(Map<String, dynamic> backup) {
  final mangaList = (backup["manga"] as List?)
      ?.map((e) => Manga.fromJson(e)..itemType = _convertToItemType(e))
      .toList();
  final chapterList = (backup["chapters"] as List?)
      ?.map((e) => Chapter.fromJson(e))
      .toList();
  final categoryList = (backup["categories"] as List?)
      ?.map(
        (e) =>
            Category.fromJson(e)..forItemType = _convertToItemTypeCategory(e),
      )
      .toList();

  final existingCategoryNames = categoryRepository
      .getAll()
      .map((c) => c.name)
      .whereType<String>()
      .toSet();
  final categoryNames = <String>{
    for (final c in categoryList ?? <Category>[])
      if (c.name != null) c.name!,
  };

  final installedSourceNames = sourceRepository
      .getAll()
      .where((s) => s.isAdded ?? false)
      .map((s) => (s.itemType, s.name?.toLowerCase()))
      .toSet();
  final unmatchedSources = <String, ItemType>{};

  final existingMangaByKey = {
    for (final m in mangaRepository.getAll())
      if (m.link != null) '${m.itemType.index}|${m.link}': m,
  };
  final chaptersByMangaId = <int, List<Chapter>>{};
  for (final c in chapterList ?? <Chapter>[]) {
    if (c.mangaId == null) continue;
    chaptersByMangaId.putIfAbsent(c.mangaId!, () => []).add(c);
  }

  int newSeries = 0, updatedSeries = 0, newChapters = 0;
  for (final m in mangaList ?? <Manga>[]) {
    final srcName = m.source ?? "Unknown";
    if (!installedSourceNames.contains((m.itemType, srcName.toLowerCase()))) {
      unmatchedSources[srcName] = m.itemType;
    }
    final key = '${m.itemType.index}|${m.link}';
    final existing = m.link != null ? existingMangaByKey[key] : null;
    final mangaChapters = m.id != null
        ? chaptersByMangaId[m.id!] ?? const <Chapter>[]
        : const <Chapter>[];
    if (existing != null) {
      updatedSeries++;
      final existingUrls = chapterRepository
          .getAllByMangaId(existing.id)
          .map((c) => c.url)
          .whereType<String>()
          .toSet();
      newChapters += mangaChapters
          .where((c) => c.url != null && !existingUrls.contains(c.url))
          .length;
    } else {
      newSeries++;
      newChapters += mangaChapters.length;
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

int currentFavoriteMangaCount() => mangaRepository.countFavorites();

@riverpod
Future<void> restoreBackup(
  Ref ref,
  Map<String, dynamic> backup, {
  bool full = true,
  // When true, adds this backup's library into the existing one instead of
  // wiping it first - only categories/manga/chapters/history/updates
  // participate (mirrors what Mihon-family merge covers; device config like
  // settings/sources/customButtons is a replace-only concept either way).
  bool merge = false,
  Map<String, bool> categoryDecisions = const {},
  Map<String, int> sourceDecisions = const {},
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
        _invalidateCommonState(ref);
      }
    } catch (e) {
      rethrow;
    }
  } else {
    throw "Failed to restore the backup";
  }
}

/// Adds a mangayomi-format backup's library into the existing one instead of
/// wiping it first. Mirrors what restoreTachiBkBackup already does for
/// Mihon-family merges: match manga by link, keep the existing entry's
/// state on conflict, only carry over chapters/history/updates that don't
/// already exist. Everything here re-inserts with a fresh id rather than
/// reusing the backup's original one - unlike a full replace (which clears
/// the tables first, so reusing ids is safe), a merge runs against a
/// non-empty library where the backup's ids could belong to something else
/// entirely on this device.
void _mergeMangayomiBackup({
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
        (c) => c.name == category.name && c.forItemType == category.forItemType,
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
      final existing = tempManga.link != null ? existingMangaByKey[key] : null;
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
              (s) => s.name?.toLowerCase() == originalSourceName.toLowerCase(),
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
      // Only ever landed on genuinely new manga above - an existing manga's
      // own chapters (with real read/download state) are left untouched.
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
      // Only for chapters we just inserted above - an existing chapter's
      // history already reflects this device's own progress.
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
          await restoreRepository.run(() {
            categoryRepository.clearSync();
            for (var category in categories) {
              final cat = Category(
                id: category["id"],
                name: category["title"],
                forItemType: ItemType.manga,
                hide: !(category["show_in_lib"] ?? true),
              );
              categoryRepository.putSync(cat);
              cats.add(cat);
            }
          });
        case "favourites":
          final favourites = jsonDecode(utf8.decode(f.content)) as List? ?? [];
          await restoreRepository.run(() {
            mangaRepository.clearSync();
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
              mangaRepository.putSync(manga);
            }
          });
        default:
          continue;
      }
    }
    await restoreRepository.run(() {
      chapterRepository.clearSync();
      downloadRepository.clearSync();
      historyRepository.clearSync();
      updateRepository.clearSync();
      trackRepository.clearSync();
      trackRepository.clearPreferencesSync();
    });
    _invalidateCommonState(ref);
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
  // sourceCode is never null for a browsed-but-not-installed source (every
  // repo listing path defaults it to '' rather than leaving it null) - isAdded
  // is the only field that actually means "installed".
  final installedSources = sourceRepository
      .getAll()
      .where((s) => s.isAdded ?? false)
      .toList();
  Source? resolveSource(String originalName, ItemType itemType) {
    final decision = sourceDecisions[originalName];
    if (decision != null) return sourceRepository.getById(decision);
    return installedSources.firstWhereOrNull(
      (s) =>
          s.itemType == itemType &&
          s.name?.toLowerCase() == originalName.toLowerCase(),
    );
  }

  final categoryByOrder = <int, Category>{};
  await restoreRepository.run(() {
    if (!merge) {
      categoryRepository.clearSync();
      mangaRepository.clearSync();
      chapterRepository.clearSync();
      historyRepository.clearSync();
    }
    final existingCategories = merge
        ? categoryRepository.getByItemType(ItemType.manga)
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
      categoryRepository.putSync(cat);
      categoryByOrder[order] = cat;
    }
    final existingMangaByLink = merge
        ? {
            for (var m in mangaRepository.getByItemType(ItemType.manga))
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
      mangaRepository.putSync(manga);
      final existingChaptersByUrl = merge && !isNewManga
          ? {
              for (var c in chapterRepository.getAllByMangaId(manga.id))
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
        chapterRepository.putSync(chapter..manga.value = manga);
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
          (!merge || historyRepository.findFirstByMangaId(manga.id) == null)) {
        historyRepository.putSync(history);
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
    await restoreRepository.run(() {
      final existingAnimeCategories = merge
          ? categoryRepository.getByItemType(ItemType.anime)
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
        categoryRepository.putSync(cat);
        categoryByOrder[order] = cat;
      }
      final existingAnimeByLink = merge
          ? {
              for (var m in mangaRepository.getByItemType(ItemType.anime))
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
        mangaRepository.putSync(anime);
        final existingEpisodesByUrl = merge && !isNewAnime
            ? {
                for (var c in chapterRepository.getAllByMangaId(anime.id))
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
          chapterRepository.putSync(episode..manga.value = anime);
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
                historyRepository.findFirstByMangaId(anime.id) == null)) {
          historyRepository.putSync(history);
          history.chapter.saveSync();
        }
      }
    });
  }
  await restoreRepository.run(() {
    if (!merge) {
      downloadRepository.clearSync();
      updateRepository.clearSync();
      trackRepository.clearSync();
      trackRepository.clearPreferencesSync();
    }
  });
  _invalidateCommonState(ref);
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
  // Now called after the restore's own transaction has already closed (see
  // the three call sites above), so this needs its own transaction too.
  ref.read(synchingProvider(syncId: 1).notifier).clearAllChangedParts(true);
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
