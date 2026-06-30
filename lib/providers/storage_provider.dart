// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/custom_button.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class StorageProvider {
  static final StorageProvider _instance = StorageProvider._internal();
  StorageProvider._internal();
  factory StorageProvider() => _instance;

  static const _dbName = "mangayomiDb";

  Future<bool> requestPermission() async {
    if (!Platform.isAndroid) return true;
    Permission permission = Permission.manageExternalStorage;
    if (await permission.isGranted) return true;
    if (await permission.request().isGranted) {
      return true;
    }
    return false;
  }

  Future<void> deleteBtDirectory() async {
    final btDir = Directory(await _btDirectoryPath());
    if (await btDir.exists()) await btDir.delete(recursive: true);
  }

  Future<void> deleteTmpDirectory() async {
    final tmpDir = Directory(await _tempDirectoryPath());
    if (await tmpDir.exists()) await tmpDir.delete(recursive: true);
  }

  Future<Directory?> getDefaultDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Mangayomi/");
    } else {
      final dir = await getApplicationDocumentsDirectory();
      // The documents dir in iOS is already named "Mangayomi".
      // Appending "Mangayomi" to the documents dir would create
      // unnecessarily nested Mangayomi/Mangayomi/ folder.
      if (Platform.isIOS) return dir;
      directory = Directory(path.join(dir.path, 'Mangayomi'));
    }
    return directory;
  }

  Future<Directory?> getMpvDirectory() async {
    final defaultDirectory = await getDefaultDirectory();
    String dbDir = path.join(defaultDirectory!.path, 'mpv');
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<Directory?> getExtensionServerDirectory() async {
    final defaultDirectory = await getDefaultDirectory();
    String dbDir = path.join(defaultDirectory!.path, 'extension_server');
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<Directory?> getBtDirectory() async {
    final dbDir = await _btDirectoryPath();
    await createDirectorySafely(dbDir);
    return Directory(dbDir);
  }

  Future<String> _btDirectoryPath() async {
    final defaultDirectory = await getDefaultDirectory();
    return path.join(defaultDirectory!.path, 'torrents');
  }

  Future<Directory?> getTmpDirectory() async {
    final tmpPath = await _tempDirectoryPath();
    await createDirectorySafely(tmpPath);
    return Directory(tmpPath);
  }

  Future<Directory> getCacheDirectory(String? imageCacheFolderName) async {
    final cacheImagesDirectory = path.join(
      (await getApplicationCacheDirectory()).path,
      imageCacheFolderName ?? 'cacheimagecover',
    );
    return Directory(cacheImagesDirectory);
  }

  Future<Directory> createCacheDirectory(String? imageCacheFolderName) async {
    final cachePath = await getCacheDirectory(imageCacheFolderName);
    await createDirectorySafely(cachePath.path);
    return cachePath;
  }

  Future<String> _tempDirectoryPath() async {
    final defaultDirectory = await getDirectory();
    return path.join(defaultDirectory!.path, 'tmp');
  }

  Future<Directory?> getIosBackupDirectory() async {
    final defaultDirectory = await getDefaultDirectory();
    String dbDir = path.join(defaultDirectory!.path, 'backup');
    await createDirectorySafely(dbDir);
    return Directory(dbDir);
  }

  Future<Directory?> getDirectory() async {
    Directory? directory;
    String dPath = "";
    try {
      final setting = isar.settings.getSync(227);
      dPath = setting?.downloadLocation ?? "";
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Could not get downloadLocation from Isar settings: $e");
      }
    }
    if (Platform.isAndroid) {
      directory = Directory(
        dPath.isEmpty ? "/storage/emulated/0/Mangayomi/" : "$dPath/",
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final p = dPath.isEmpty ? dir.path : dPath;
      // The documents dir in iOS is already named "Mangayomi".
      // Appending "Mangayomi" to the documents dir would create
      // unnecessarily nested Mangayomi/Mangayomi/ folder.
      if (Platform.isIOS) return Directory(p);
      directory = Directory(path.join(p, 'Mangayomi'));
    }
    return directory;
  }

  Future<Directory?> getMangaMainDirectory(Chapter chapter) async {
    final manga = chapter.manga.value!;
    final itemType = chapter.manga.value!.itemType;
    final itemTypePath = itemType == ItemType.manga
        ? "Manga"
        : itemType == ItemType.anime
        ? "Anime"
        : "Novel";
    final dir = await getDirectory();
    return Directory(
      path.join(
        dir!.path,
        'downloads',
        itemTypePath,
        '${manga.source} (${manga.lang!.toUpperCase()})',
        manga.name!.replaceForbiddenCharacters('_'),
      ),
    );
  }

  Future<Directory?> getMangaChapterDirectory(
    Chapter chapter, {
    Directory? mangaMainDirectory,
  }) async {
    final basedir = mangaMainDirectory ?? await getMangaMainDirectory(chapter);
    String scanlator = chapter.scanlator?.isNotEmpty ?? false
        ? "${chapter.scanlator!.replaceForbiddenCharacters('_')}_"
        : "";
    return Directory(
      path.join(
        basedir!.path,
        scanlator + chapter.name!.replaceForbiddenCharacters('_').trim(),
      ),
    );
  }

  Future<Directory?> getDatabaseDirectory() async {
    // On macOS, host the libmdbx / Isar database under Application Support
    // (app-private, not TCC-gated) instead of Documents. macOS denies
    // unsigned/sideloaded/dev builds access to ~/Documents when iCloud
    // "Desktop & Documents Folders" sync is enabled, surfacing as
    // `IsarError: Cannot open Environment: MdbxError (13): Permission denied`
    // and a black screen on launch. iOS keeps Documents so the DB remains
    // visible alongside backups via the Files app. Windows / Linux are
    // untouched — Documents is the conventional location there.
    final dir = Platform.isMacOS
        ? await getApplicationSupportDirectory()
        : await getApplicationDocumentsDirectory();
    String dbDir;
    if (Platform.isAndroid) return dir;
    if (Platform.isIOS) {
      // Put the database files inside /databases like on Windows, Linux
      // So they are not just in the app folders root dir
      dbDir = path.join(dir.path, 'databases');
    } else {
      dbDir = path.join(dir.path, 'Mangayomi', 'databases');
    }
    if (Platform.isMacOS) {
      await _migrateLegacyMacosDatabase(dbDir);
    }
    await createDirectorySafely(dbDir);
    return Directory(dbDir);
  }

  /// One-shot migration: if a pre-existing macOS user has their database
  /// under the legacy Documents path and the new Application Support path
  /// is empty, rename it across so library / history / progress are not
  /// silently reset. Subsequent launches skip this branch because the new
  /// path already exists.
  Future<void> _migrateLegacyMacosDatabase(String newDbDir) async {
    try {
      final docs = await getApplicationDocumentsDirectory();
      final legacyDir = Directory(
        path.join(docs.path, 'Mangayomi', 'databases'),
      );
      if (!await legacyDir.exists()) return;
      final newDir = Directory(newDbDir);
      if (await newDir.exists()) {
        // Only migrate when the new location is empty — never overwrite.
        final entries = await newDir.list(followLinks: false).take(1).toList();
        if (entries.isNotEmpty) return;
      }
      await Directory(path.dirname(newDbDir)).create(recursive: true);
      await legacyDir.rename(newDbDir);
      if (kDebugMode) {
        debugPrint(
          '[storage] Migrated macOS DB from ${legacyDir.path} to $newDbDir',
        );
      }
    } catch (e) {
      // Migration is best-effort. Falling back to a fresh DB is preferable
      // to crashing on launch — the user can manually move the legacy
      // ~/Documents/Mangayomi/databases/ contents if needed.
      if (kDebugMode) {
        debugPrint('[storage] macOS DB migration skipped: $e');
      }
    }
  }

  Future<Directory?> getGalleryDirectory() async {
    String gPath;
    if (Platform.isAndroid) {
      gPath = "/storage/emulated/0/Pictures/Mangayomi/";
    } else {
      gPath = path.join((await getDirectory())!.path, 'Pictures');
    }
    await createDirectorySafely(gPath);
    return Directory(gPath);
  }

  Future<void> createDirectorySafely(String dirPath) async {
    final dir = Directory(dirPath);
    try {
      await dir.create(recursive: true);
    } catch (_) {
      if (await requestPermission()) {
        try {
          await dir.create(recursive: true);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Initial directory creation failed for $dirPath: $e');
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint('Permission denied. Cannot create: $dirPath');
        }
      }
    }
  }

  Future<Isar> initDB(String? path, {bool inspector = false}) async {
    final Directory dir = path == null
        ? (await getDatabaseDirectory())!
        : Directory(path);

    // Open the database, recovering automatically from a corrupt or
    // schema-incompatible file. This commonly happens after reinstalling over
    // an older build: the leftover database can no longer be opened and
    // Isar.open throws. Before this guard the exception escaped main() ahead of
    // runApp(), leaving a blank, unresponsive window. We instead archive the
    // bad database and open a fresh one so the app still launches; the old
    // files are renamed (not deleted) for manual recovery.
    Isar isar;
    try {
      isar = await _openIsar(dir, inspector);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Isar.open failed, recovering corrupt DB: $e\n$st');
      }
      await _backupCorruptDatabase(dir);
      isar = await _openIsar(dir, inspector);
    }
    try {
      final settings = await isar.settings.filter().idEqualTo(227).findFirst();
      if (settings == null) {
        await isar.writeTxn(() async => isar.settings.put(Settings()));
      }
    } catch (_) {
      if (await requestPermission()) {
        try {
          final settings = await isar.settings
              .filter()
              .idEqualTo(227)
              .findFirst();
          if (settings == null) {
            await isar.writeTxn(() async => isar.settings.put(Settings()));
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint("Failed after retry with permission: $e");
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint("Permission denied during Database init fallback.");
        }
      }
    }

    final prefs = await isar.trackPreferences
        .filter()
        .syncIdIsNotNull()
        .findAll();
    await isar.writeTxn(() async {
      for (final pref in prefs) {
        await isar.trackPreferences.put(pref..refreshing = true);
      }
    });

    final customButton = await isar.customButtons
        .filter()
        .idIsNotNull()
        .findFirst();
    if (customButton == null) {
      await isar.writeTxn(() async {
        await isar.customButtons.put(
          CustomButton(
            title: "+85 s",
            codePress:
                """local intro_length = mp.get_property_native("user-data/current-anime/intro-length")
aniyomi.right_seek_by(intro_length)""",
            codeLongPress:
                """aniyomi.int_picker("Change intro length", "%ds", 0, 255, 1, "user-data/current-anime/intro-length")""",
            codeStartup: """function update_button(_, length)
  if length ~= nil then
    if length == 0 then
	  aniyomi.hide_button()
	  return
	else
	  aniyomi.show_button()
	end
    aniyomi.set_button_title("+" .. length .. " s")
  end
end

if \$isPrimary then
  mp.observe_property("user-data/current-anime/intro-length", "number", update_button)
end""",
            isFavourite: true,
            pos: 0,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      });
    }

    return isar;
  }

  Future<Isar> _openIsar(Directory dir, bool inspector) {
    return Isar.open(
      [
        MangaSchema,
        ChangedPartSchema,
        ChapterSchema,
        CategorySchema,
        CustomButtonSchema,
        UpdateSchema,
        HistorySchema,
        DownloadSchema,
        SourceSchema,
        SettingsSchema,
        TrackPreferenceSchema,
        TrackSchema,
        SyncPreferenceSchema,
        SourcePreferenceSchema,
        SourcePreferenceStringValueSchema,
      ],
      directory: dir.path,
      name: _dbName,
      inspector: inspector,
    );
  }

  /// Moves a corrupt / schema-incompatible database aside so [initDB] can open
  /// a fresh one. Files are renamed (kept as `.corrupt-<ts>.bak`) rather than
  /// deleted so the user can recover their data manually. Best-effort: any
  /// failure here must not block launch, so if a file can't be renamed we fall
  /// back to deleting it (e.g. a stale lock) and otherwise swallow the error.
  Future<void> _backupCorruptDatabase(Directory dir) async {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    for (final suffix in const ['.isar', '.isar.lock']) {
      final file = File(path.join(dir.path, '$_dbName$suffix'));
      try {
        if (await file.exists()) {
          await file.rename('${file.path}.corrupt-$stamp.bak');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Could not archive corrupt DB file ${file.path}: $e');
        }
        // Fallback delete only ever applies to the disposable lock file — never
        // the `.isar` data file. A failed rename must not destroy user data
        // (it stays put, and a still-failing reopen surfaces the error screen
        // rather than causing irreversible loss).
        if (suffix == '.isar.lock') {
          try {
            if (await file.exists()) await file.delete();
          } catch (_) {}
        }
      }
    }
  }
}
