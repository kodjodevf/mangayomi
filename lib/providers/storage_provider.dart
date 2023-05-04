// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:mangayomi/models/model_manga.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageProvider {
  Future<bool> requestPermission() async {
    Permission permission = Permission.manageExternalStorage;
    if (Platform.isAndroid || Platform.isIOS) {
      if (await permission.isGranted) {
        return true;
      } else {
        final result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
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
      ModelManga modelManga, index) async {
    String scanlator = modelManga.chapters.toList()[index].scanlator!.isNotEmpty
        ? "${modelManga.chapters.toList()[index].scanlator!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}_"
        : "";
    final dir = await getDirectory();
    return Directory(
        "${dir!.path}/downloads/${modelManga.source} (${modelManga.lang!.toUpperCase()})/${modelManga.name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}/$scanlator${modelManga.chapters.toList()[index].name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}/");
  }

  Future<Directory?> getMangaMainDirectory(ModelManga modelManga, index) async {
    final dir = await getDirectory();
    return Directory(
        "${dir!.path}/downloads/${modelManga.source} (${modelManga.lang!.toUpperCase()})/${modelManga.name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}/");
  }
}
