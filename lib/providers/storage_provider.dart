// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
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
  static bool _hasPermission = false;
  Future<bool> requestPermission() async {
    if (_hasPermission || !Platform.isAndroid) return true;
    Permission permission = Permission.manageExternalStorage;
    if (await permission.isGranted) return true;
    if (await permission.request().isGranted) {
      _hasPermission = true;
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
      if (Platform.isIOS || Platform.isMacOS) return dir;
      directory = Directory(path.join(dir.path, 'Mangayomi'));
    }
    return directory;
  }

  Future<Directory?> getBtDirectory() async {
    String dbDir = await _btDirectoryPath();
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<String> _btDirectoryPath() async {
    final defaultDirectory = await getDefaultDirectory();
    return path.join(defaultDirectory!.path, 'torrents');
  }

  Future<Directory?> getTmpDirectory() async {
    String tmpPath = await _tempDirectoryPath();
    await Directory(tmpPath).create(recursive: true);
    return Directory(tmpPath);
  }

  Future<String> _tempDirectoryPath() async {
    final defaultDirectory = await getDirectory();
    return path.join(defaultDirectory!.path, 'tmp');
  }

  Future<Directory?> getIosBackupDirectory() async {
    final defaultDirectory = await getDefaultDirectory();
    String dbDir = path.join(defaultDirectory!.path, 'backup');
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<Directory?> getDirectory() async {
    Directory? directory;
    String dPath = isar.settings.getSync(227)!.downloadLocation ?? "";
    if (Platform.isAndroid) {
      directory = Directory(
        dPath.isEmpty ? "/storage/emulated/0/Mangayomi/" : "$dPath/",
      );
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final p = dPath.isEmpty ? dir.path : dPath;
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
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      String dbDir = path.join(dir.path, 'databases');
      await Directory(dbDir).create(recursive: true);
      return Directory(dbDir);
    } else {
      String dbDir = path.join(dir.path, 'Mangayomi', 'databases');
      await Directory(dbDir).create(recursive: true);
      return Directory(dbDir);
    }
  }

  Future<Directory?> getGalleryDirectory() async {
    String gPath = (await getDirectory())!.path;
    if (Platform.isAndroid) {
      gPath = "/storage/emulated/0/Pictures/Mangayomi/";
    } else {
      gPath = path.join(gPath, 'Pictures');
    }
    await Directory(gPath).create(recursive: true);
    return Directory(gPath);
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

    final settings = await isar.settings.filter().idEqualTo(227).findFirst();
    if (settings == null) {
      await isar.writeTxn(() async => isar.settings.put(Settings()));
    }

    return isar;
  }
}
