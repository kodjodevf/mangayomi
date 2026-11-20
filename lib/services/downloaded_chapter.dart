import 'dart:io';

import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/local_folders.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path/path.dart' as p;

/// Where a downloaded chapter's pages actually sit on disk.
///
/// Exactly one of [archive] and [pagesDirectory] is set: the downloader writes
/// a single `.cbz` when "save as CBZ archive" is on and deletes the page folder
/// afterwards, and leaves the folder of `001.jpg`, `002.jpg`, … when it is off.
class DownloadedChapter {
  /// The `.cbz` holding every page of the chapter.
  final File? archive;

  /// The folder holding one `padIndex(i).jpg` per page.
  final Directory? pagesDirectory;

  /// The pages of [pagesDirectory], in reading order: see
  /// [listDownloadedPageFiles]. Empty for an [archive], whose pages are only
  /// known once it is unpacked.
  final List<File> pageFiles;

  /// How many pages [pagesDirectory] holds; zero for an [archive].
  int get pageCount => pageFiles.length;

  const DownloadedChapter.fromArchive(File this.archive)
    : pagesDirectory = null,
      pageFiles = const [];

  const DownloadedChapter.fromPages(
    Directory this.pagesDirectory, {
    required this.pageFiles,
  }) : archive = null;
}

/// Every directory a download of [chapter] could live in, most likely first.
///
/// The default is `<downloads>/<ItemType>/<source> (LANG)/<manga>/`. Versions
/// 0.8.6 and 0.8.7 sent downloads to a local folder instead, so anything the
/// user downloaded on those builds is under `<local folder>/<manga>/` and stays
/// there. The location was restored upstream but the files were not moved.
Future<List<Directory>> downloadedMangaDirectories(
  Chapter chapter, {
  Settings? settings,
}) async {
  final directories = <Directory>[];
  final defaultDirectory = await StorageProvider().getMangaMainDirectory(
    chapter,
    settings: settings,
  );
  if (defaultDirectory != null) directories.add(defaultDirectory);

  final mangaName = chapter.manga.value?.name;
  if (mangaName == null) return directories;
  for (final folder in await getAllLocalFolders(settings: settings)) {
    final folderPath = folder.path;
    if (folderPath == null || folderPath.isEmpty) continue;
    directories.add(
      Directory(p.join(folderPath, mangaName.replaceForbiddenCharacters('_'))),
    );
  }
  return directories;
}

/// Finds the local copy of [chapter], or null when there is nothing complete on
/// disk to read.
///
/// Callers use this before reaching for the source so that a downloaded chapter
/// opens with the extension uninstalled, the site down, or no connection at
/// all.
Future<DownloadedChapter?> findDownloadedChapter(Chapter chapter) async {
  final chapterId = chapter.id;
  if (chapterId == null || chapter.name == null) return null;

  // The folder is written page by page, so a download still in flight has a
  // partial one; only the Isar record knows it is finished. An archive needs no
  // such check, since it is written once, at the end, from the complete folder.
  final isComplete = downloadRepository.getById(chapterId)?.isDownload ?? false;
  final chapterDirectory = await StorageProvider().getMangaChapterDirectory(
    chapter,
  );
  if (chapterDirectory == null) return null;

  return findDownloadedChapterIn(
    await downloadedMangaDirectories(chapter),
    chapterName: chapter.name!,
    chapterDirectoryName: p.basename(chapterDirectory.path),
    isComplete: isComplete,
  );
}

/// The local copy in the first of [mangaDirectories] that holds one.
///
/// The chapter's own folder carries the same name under every manga directory,
/// so [chapterDirectoryName] is the basename the downloader gave it and only
/// the parent changes. [isComplete] gates that folder and not the archive, for
/// the reason given in [findDownloadedChapter].
Future<DownloadedChapter?> findDownloadedChapterIn(
  Iterable<Directory> mangaDirectories, {
  required String chapterName,
  required String chapterDirectoryName,
  required bool isComplete,
}) async {
  for (final mangaDirectory in mangaDirectories) {
    final archive = await findChapterArchive(mangaDirectory, chapterName);
    if (archive != null) return DownloadedChapter.fromArchive(archive);

    if (!isComplete) continue;
    final pagesDirectory = Directory(
      p.join(mangaDirectory.path, chapterDirectoryName),
    );
    final pageFiles = await listDownloadedPageFiles(pagesDirectory);
    if (pageFiles.isNotEmpty) {
      return DownloadedChapter.fromPages(pagesDirectory, pageFiles: pageFiles);
    }
  }
  return null;
}

/// The `.cbz` for [chapterName] in [mangaDirectory], under either name it may
/// carry.
///
/// The downloader names it after the chapter with forbidden characters replaced
/// by spaces, while the reader used to rebuild the raw name. That is why a
/// chapter whose title holds a colon never resolved locally and fell through to
/// the network.
Future<File?> findChapterArchive(
  Directory mangaDirectory,
  String chapterName,
) async {
  for (final name in {
    chapterName,
    chapterName.replaceForbiddenCharacters(' '),
  }) {
    final file = File(p.join(mangaDirectory.path, '$name.cbz'));
    if (await file.exists()) return file;
  }
  return null;
}

/// The pages of [directory] the reader can address, in reading order: page
/// `i` under `padIndex(i)` with any of [knownPageImageExtensions], from the
/// first up to the first one missing.
///
/// The folder is listed once. Looking each page up under each extension took
/// a file-system call apiece, on the thread that draws the app.
Future<List<File>> listDownloadedPageFiles(Directory directory) async {
  if (!await directory.exists()) return const [];
  final names = <String>{
    await for (final entity in directory.list())
      if (entity is File) p.basename(entity.path),
  };
  final pages = <File>[];
  for (var index = 0; ; index++) {
    final base = padIndex(index);
    final extension = knownPageImageExtensions
        .where((extension) => names.contains('$base$extension'))
        .firstOrNull;
    if (extension == null) return pages;
    pages.add(File(p.join(directory.path, '$base$extension')));
  }
}
