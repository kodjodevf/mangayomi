// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/dart/model/source_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed_items.dart';
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
  Future<bool> requestPermission() async {
    Permission permission = Permission.manageExternalStorage;
    if (Platform.isAndroid) {
      if (await permission.isGranted) {
        return true;
      } else {
        final result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
        return false;
      }
    }
    return true;
  }

  Future<void> deleteBtDirectory() async {
    final d = await getBtDirectory();
    await Directory(d!.path).delete(recursive: true);
  }

  Future<Directory?> getDefaultDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Mangayomi/");
    } else {
      final dir = await getApplicationDocumentsDirectory();
      directory = Directory(path.join(dir.path, 'Mangayomi'));
    }
    return directory;
  }

  Future<Directory?> getBtDirectory() async {
    final gefaultDirectory = await getDefaultDirectory();
    String dbDir = path.join(gefaultDirectory!.path, 'torrents');
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<Directory?> getIosBackupDirectory() async {
    final gefaultDirectory = await getDefaultDirectory();
    String dbDir = path.join(gefaultDirectory!.path, 'backup');
    await Directory(dbDir).create(recursive: true);
    return Directory(dbDir);
  }

  Future<Directory?> getDirectory() async {
    Directory? directory;
    String customPath = isar.settings.getSync(227)!.downloadLocation ?? "";
    if (Platform.isAndroid) {
      directory =
          Directory(customPath.isEmpty ? "/storage/emulated/0/Mangayomi/" : "$customPath/");
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final basePath = customPath.isEmpty ? dir.path : customPath;
      directory = Directory(path.join(basePath, "Mangayomi"));
    }
    return directory;
  }

  Future<Directory?> getMangaChapterDirectory(
    Chapter chapter,
  ) async {
    final manga = chapter.manga.value!;
    String scanlator = chapter.scanlator?.isNotEmpty ?? false
        ? "${chapter.scanlator!.replaceForbiddenCharacters('_')}_"
        : "";
    final isManga = manga.isManga!;
    final dir = await getDirectory();
    final directoryPath = path.join(
      dir!.path,
      "downloads",
      isManga ? "Manga" : "Anime",
      "${manga.source} (${manga.lang!.toUpperCase()})",
      manga.name!.replaceForbiddenCharacters('_'),
      "$scanlator${chapter.name!.replaceForbiddenCharacters('_')}",
    );
    return Directory(directoryPath);
  }

  Future<Directory?> getMangaMainDirectory(Chapter chapter) async {
    final manga = chapter.manga.value!;
    final isManga = manga.isManga!;
    final dir = await getDirectory();
    final directoryPath = path.join(
      dir!.path,
      "downloads",
      isManga ? "Manga" : "Anime",
      "${manga.source} (${manga.lang!.toUpperCase()})",
      manga.name!.replaceForbiddenCharacters('_'),
    );
    return Directory(directoryPath);
  }

  Future<Directory?> getDatabaseDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      return dir;
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

  Future<Isar> initDB(String? path, {bool? inspector = false}) async {
    Directory? dir;
    if (path == null) {
      dir = await getDatabaseDirectory();
    } else {
      dir = Directory(path);
    }

    final isar = Isar.openSync([
      MangaSchema,
      ChangedItemsSchema,
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
    ], directory: dir!.path, name: "mangayomiDb", inspector: inspector!);

    if (isar.settings.filter().idEqualTo(227).isEmptySync()) {
      isar.writeTxnSync(
        () {
          isar.settings.putSync(Settings());
        },
      );
    }

    return isar;
  }
}
