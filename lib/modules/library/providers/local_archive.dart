import 'package:file_picker/file_picker.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/archive_reader/providers/archive_reader_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'local_archive.g.dart';

@riverpod
Future importArchivesFromDirectory(ImportArchivesFromDirectoryRef ref) async {
  String? result = await FilePicker.platform.getDirectoryPath();

  if (result != null) {
    final datas =
        await ref.watch(getArchivesDataFromDirectoryProvider(result).future);
    for (var data in datas) {
      final manga = Manga(
          favorite: true,
          source: 'archive',
          author: '',
          genre: [],
          imageUrl: '',
          lang: '',
          link: '',
          name: data.$1,
          dateAdded: DateTime.now().millisecondsSinceEpoch,
          lastUpdate: DateTime.now().millisecondsSinceEpoch,
          status: Status.unknown,
          description: '',
          isLocalArchive: true,
          customCoverImage: data.$3);
      isar.writeTxnSync(() {
        isar.mangas.putSync(manga);
        final chapters = Chapter(name: data.$1, archivePath: data.$4)
          ..manga.value = manga;
        isar.chapters.putSync(chapters);
        chapters.manga.saveSync();
      });
    }
  }
  return "";
}

@riverpod
Future importArchivesFromFile(
    ImportArchivesFromFileRef ref, Manga? mManga) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'cbz',
        'zip',
      ]);
  if (result != null) {
    for (var file in result.files) {
      final data =
          await ref.watch(getArchivesDataFromFileProvider(file.path!).future);
      final manga = mManga ??
          Manga(
              favorite: true,
              source: 'archive',
              author: '',
              genre: [],
              imageUrl: '',
              lang: '',
              link: '',
              name: data.$1,
              dateAdded: DateTime.now().millisecondsSinceEpoch,
              lastUpdate: DateTime.now().millisecondsSinceEpoch,
              status: Status.unknown,
              description: '',
              isLocalArchive: true,
              customCoverImage: data.$3);
      isar.writeTxnSync(() {
        isar.mangas.putSync(manga);
        final chapters = Chapter(name: data.$1, archivePath: data.$4)
          ..manga.value = manga;
        isar.chapters.putSync(chapters);
        chapters.manga.saveSync();
      });
    }
  }
  return "";
}
