import 'dart:convert';
import 'package:archive/archive_io.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'restore.g.dart';

@riverpod
void doRestore(Ref ref, {required String path, required BuildContext context}) {
  final inputStream = InputFileStream(path);
  final archive = ZipDecoder().decodeStream(inputStream);
  final backup = jsonDecode(utf8.decode(archive.files.first.content))
      as Map<String, dynamic>;
  try {
    ref.read(restoreBackupProvider(backup));
    BotToast.showNotification(
        animationDuration: const Duration(milliseconds: 200),
        animationReverseDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 5),
        backButtonBehavior: BackButtonBehavior.none,
        leading: (_) =>
            Image.asset('assets/app_icons/icon-red.png', height: 40),
        title: (_) => const Text(
              "Backup restored!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        enableSlideOff: true,
        onlyOne: true,
        crossPage: true);
  } catch (e) {
    botToast(e.toString());
  }
}

@riverpod
void restoreBackup(Ref ref, Map<String, dynamic> backup) {
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
          ?.map((e) =>
              Category.fromJson(e)..forItemType = _convertToItemTypeCategory(e))
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
      final updates =
          (backup["updates"] as List?)?.map((e) => Update.fromJson(e)).toList();

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
              final tempChapters =
                  isar.chapters.filter().idIsNotNull().findAllSync().toList();
              for (var update in updates) {
                final matchingChapter = tempChapters
                    .where((chapter) =>
                        chapter.mangaId == update.mangaId &&
                        chapter.name == update.chapterName)
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

        isar.trackPreferences.clearSync();
        if (trackPreferences != null) {
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
        ref.invalidate(themeModeStateProvider);
        ref.invalidate(blendLevelStateProvider);
        ref.invalidate(flexSchemeColorStateProvider);
        ref.invalidate(pureBlackDarkModeStateProvider);
        ref.invalidate(l10nLocaleStateProvider);
        ref.invalidate(navigationOrderStateProvider);
        ref.invalidate(hideItemsStateProvider);
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
