import 'dart:io';
import 'dart:typed_data';
import 'package:epubx/epubx.dart';
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
Future importArchivesFromFile(
  Ref ref,
  Manga? mManga, {
  required ItemType itemType,
  required bool init,
}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: switch (itemType) {
      ItemType.manga => ['cbz', 'zip'],
      ItemType.anime => ['mp4', 'mov', 'avi', 'flv', 'wmv', 'mpeg', 'mkv'],
      ItemType.novel => ['epub'],
    },
  );
  if (result != null) {
    final dateNow = DateTime.now().millisecondsSinceEpoch;
    final manga =
        mManga ??
        Manga(
          favorite: true,
          source: 'archive',
          author: '',
          itemType: itemType,
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
          updatedAt: dateNow,
          sourceId: null,
        );

    for (var file in result.files.reversed.toList()) {
      (String, LocalExtensionType, Uint8List, String)? data =
          itemType == ItemType.manga
          ? await ref.watch(getArchivesDataFromFileProvider(file.path!).future)
          : null;
      String name = _getName(file.path!);

      if (init) {
        manga.customCoverImage = itemType == ItemType.manga ? data!.$3 : null;
      }

      await isar.writeTxn(() async {
        final mangaId = await isar.mangas.put(manga);
        final List<Chapter> chapters = [];
        if (itemType == ItemType.novel) {
          final bytes = await File(file.path!).readAsBytes();
          final book = await EpubReader.readBook(bytes);
          if (book.Content != null && book.Content!.Images != null) {
            final coverImage =
                book.Content!.Images!.containsKey("media/file0.png")
                ? book.Content!.Images!["media/file0.png"]!.Content
                : book.Content!.Images!.values.first.Content;
            await isar.mangas.put(manga..customCoverImage = coverImage);
          }
          for (var chapter in book.Chapters ?? []) {
            chapters.add(
              Chapter(
                mangaId: mangaId,
                name: chapter.Title is String && chapter.Title.isEmpty
                    ? "Book"
                    : chapter.Title,
                archivePath: file.path,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
              )..manga.value = manga,
            );
          }
        } else {
          chapters.add(
            Chapter(
              name: itemType == ItemType.manga ? data!.$1 : name,
              archivePath: itemType == ItemType.manga ? data!.$4 : file.path,
              mangaId: manga.id,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            )..manga.value = manga,
          );
        }
        for (final chapter in chapters) {
          await isar.chapters.put(chapter);
          await chapter.manga.save();
        }
      });
    }
  }
  return "";
}

String _getName(String path) {
  return path
      .split('/')
      .last
      .split("\\")
      .last
      .replaceAll(
        RegExp(r'\.(mp4|mov|avi|flv|wmv|mpeg|mkv|cbz|zip|cbt|tar|epub)'),
        '',
      );
}
