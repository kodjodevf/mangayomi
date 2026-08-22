import 'dart:io';

import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
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

  /// How many pages [pagesDirectory] holds. Zero for an [archive], whose page
  /// count is only known once it is unpacked.
  final int pageCount;

  const DownloadedChapter.fromArchive(File this.archive)
    : pagesDirectory = null,
      pageCount = 0;

  const DownloadedChapter.fromPages(
    Directory this.pagesDirectory, {
    required this.pageCount,
  }) : archive = null;
}

/// Every directory a download of [chapter] could live in, most likely first.
///
/// The default is `<downloads>/<ItemType>/<source> (LANG)/<manga>/`. Versions
/// 0.8.6 and 0.8.7 sent downloads to a local folder instead, so anything the
/// user downloaded on those builds is under `<local folder>/<manga>/` and stays
/// there. The location was restored upstream but the files were not moved.
Future<List<Directory>> downloadedMangaDirectories(Chapter chapter) async {
  final directories = <Directory>[];
  final defaultDirectory = await StorageProvider().getMangaMainDirectory(
    chapter,
  );
  if (defaultDirectory != null) directories.add(defaultDirectory);

  final mangaName = chapter.manga.value?.name;
  if (mangaName == null) return directories;
  for (final folder in await getAllLocalFolders()) {
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

  final storageProvider = StorageProvider();
  // The folder is written page by page, so a download still in flight has a
  // partial one; only the Isar record knows it is finished. An archive needs no
  // such check, since it is written once, at the end, from the complete folder.
  final isComplete = isar.downloads.getSync(chapterId)?.isDownload ?? false;

  for (final mangaDirectory in await downloadedMangaDirectories(chapter)) {
    final archive = findChapterArchive(mangaDirectory, chapter.name!);
    if (archive != null) return DownloadedChapter.fromArchive(archive);

    if (!isComplete) continue;
    final pagesDirectory = await storageProvider.getMangaChapterDirectory(
      chapter,
      mangaMainDirectory: mangaDirectory,
    );
    if (pagesDirectory == null) continue;
    final pageCount = countDownloadedPages(pagesDirectory);
    if (pageCount > 0) {
      return DownloadedChapter.fromPages(pagesDirectory, pageCount: pageCount);
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
File? findChapterArchive(Directory mangaDirectory, String chapterName) {
  for (final name in {
    chapterName,
    chapterName.replaceForbiddenCharacters(' '),
  }) {
    final file = File(p.join(mangaDirectory.path, '$name.cbz'));
    if (file.existsSync()) return file;
  }
  return null;
}

/// How many pages of [directory] the reader can actually address.
///
/// The reader asks for page `i` by rebuilding `padIndex(i).jpg`, so the run has
/// to be counted from the first page and stop at the first gap. A folder
/// missing `003.jpg` can only serve two pages however many files it holds.
int countDownloadedPages(Directory directory) {
  if (!directory.existsSync()) return 0;
  var count = 0;
  while (File(p.join(directory.path, '${padIndex(count)}.jpg')).existsSync()) {
    count++;
  }
  return count;
}
