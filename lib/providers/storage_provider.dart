// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
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
      // The documents dir in iOS and macOS is already named "Mangayomi".
      // Appending "Mangayomi" to the documents dir would create
      // unnecessarily nested Mangayomi/Mangayomi/ folder.
      if (Platform.isIOS || Platform.isMacOS) return dir;
      directory = Directory(path.join(dir.path, 'Mangayomi'));
    }
    return directory;
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
      debugPrint("Could not get downloadLocation from Isar settings: $e");
    }
    if (Platform.isAndroid) {
      directory = Directory(
        dPath.isEmpty ? "/storage/emulated/0/Mangayomi/" : "$dPath/",
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final p = dPath.isEmpty ? dir.path : dPath;
      // The documents dir in iOS and macOS is already named "Mangayomi".
      // Appending "Mangayomi" to the documents dir would create
      // unnecessarily nested Mangayomi/Mangayomi/ folder.
      if (Platform.isIOS || Platform.isMacOS) return Directory(p);
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
    final dir = await getApplicationDocumentsDirectory();
    String dbDir;
    if (Platform.isAndroid) return dir;
    if (Platform.isIOS || Platform.isMacOS) {
      // Put the database files inside /databases like on Windows, Linux
      // So they are not just in the app folders root dir
      dbDir = path.join(dir.path, 'databases');
    } else {
      dbDir = path.join(dir.path, 'Mangayomi', 'databases');
    }
    await createDirectorySafely(dbDir);
    return Directory(dbDir);
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
          debugPrint('Initial directory creation failed for $dirPath: $e');
        }
      } else {
        debugPrint('Permission denied. Cannot create: $dirPath');
      }
    }
  }

  Future<Isar> initDB(String? path, {bool inspector = false}) async {
    Directory? dir;
    if (path == null) {
      dir = await getDatabaseDirectory();
    } else {
      dir = Directory(path);
    }

    final isar = await Isar.open(
      [
        MangaSchema,
        ChangedPartSchema,
        ChapterSchema,
        CategorySchema,
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
      directory: dir!.path,
      name: "mangayomiDb",
      inspector: inspector,
    );
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
          debugPrint("Failed after retry with permission: $e");
        }
      } else {
        debugPrint("Permission denied during Database init fallback.");
      }
    }

    return isar;
  }
}
