// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:mangayomi/models/chapter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageProvider {
  RegExp regExpChar = RegExp(r'[^a-zA-Z0-9 .()\-\s]');
  Future<bool> requestPermission() async {
    Permission permission = Permission.manageExternalStorage;
    if (Platform.isAndroid || Platform.isIOS) {
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

  Future<Directory?> getDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Mangayomi/");
    } else {
      final dir = await getApplicationDocumentsDirectory();
      directory = Directory("${dir.path}/Mangayomi/");
    }
    return directory;
  }

  Future<Directory?> getMangaChapterDirectory(
    Chapter chapter,
  ) async {
    final manga = chapter.manga.value!;
    String scanlator = chapter.scanlator!.isNotEmpty
        ? "${chapter.scanlator!.replaceAll(regExpChar, '_')}_"
        : "";
    final dir = await getDirectory();
    return Directory(
        "${dir!.path}/downloads/${manga.source} (${manga.lang!.toUpperCase()})/${manga.name!.replaceAll(regExpChar, '_')}/$scanlator${chapter.name!.replaceAll(regExpChar, '_')}/");
  }

  Future<Directory?> getMangaMainDirectory(Chapter chapter) async {
    final manga = chapter.manga.value!;
    final dir = await getDirectory();
    return Directory(
        "${dir!.path}/downloads/${manga.source} (${manga.lang!.toUpperCase()})/${manga.name!.replaceAll(regExpChar, '_')}/");
  }
}
