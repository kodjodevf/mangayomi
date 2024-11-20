import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/archive_reader/models/models.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'local_archive.g.dart';

@riverpod
Future importArchivesFromFile(Ref ref, Manga? mManga,
    {required bool isManga, required bool init}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: isManga
          ? ['cbz', 'zip']
          : ['mp4', 'mov', 'avi', 'flv', 'wmv', 'mpeg', 'mkv']);
  if (result != null) {
    final dateNow = DateTime.now().millisecondsSinceEpoch;
    final manga = mManga ??
        Manga(
          favorite: true,
          source: 'archive',
          author: '',
          isManga: isManga,
          genre: [],
          imageUrl: '',
          lang: '',
          link: '',
          name: _getName(result.files.first.path!),
          dateAdded: dateNow,
          lastUpdate: dateNow,
          status: Status.unknown,
          description: '',
          isLocalArchive: true,
          artist: '',
        );
    for (var file in result.files.reversed.toList()) {
      (String, LocalExtensionType, Uint8List, String)? data = isManga
          ? await ref.watch(getArchivesDataFromFileProvider(file.path!).future)
          : null;
      String name = _getName(file.path!);

      if (init) {
        manga.customCoverImage = isManga ? data!.$3 : null;
      }

      isar.writeTxnSync(() {
        isar.mangas.putSync(manga);
        final chapters = Chapter(
            name: isManga ? data!.$1 : name,
            archivePath: isManga ? data!.$4 : file.path,
            mangaId: manga.id)
          ..manga.value = manga;
        isar.chapters.putSync(chapters);
        chapters.manga.saveSync();
      });
    }
  }
  return "";
}

String _getName(String path) {
  return path.split('/').last.split("\\").last.replaceAll(
      RegExp(r'\.(mp4|mov|avi|flv|wmv|mpeg|mkv|cbz|zip|cbt|tar)'), '');
}
