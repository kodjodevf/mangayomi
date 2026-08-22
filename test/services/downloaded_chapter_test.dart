import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory directory;

  setUp(() => directory = Directory.systemTemp.createTempSync('downloaded'));
  tearDown(() => directory.deleteSync(recursive: true));

  void write(String name) =>
      File(p.join(directory.path, name)).writeAsStringSync('');

  group('findChapterArchive', () {
    test('finds the archive the downloader writes', () {
      write('Chapter 1.cbz');
      expect(
        findChapterArchive(directory, 'Chapter 1')?.path,
        endsWith('Chapter 1.cbz'),
      );
    });

    test('finds it when the title held a colon the downloader stripped', () {
      // The downloader replaces forbidden characters with spaces, so this is
      // the name on disk for a chapter called "Chapter 1: Beginnings". The
      // reader used to rebuild the raw name and never match it.
      write('Chapter 1  Beginnings.cbz');
      expect(
        findChapterArchive(directory, 'Chapter 1: Beginnings')?.path,
        endsWith('Chapter 1  Beginnings.cbz'),
      );
    });

    test('finds it under a name with nothing to sanitise', () {
      write('Chapter 1 - 1_2.cbz');
      expect(
        findChapterArchive(directory, 'Chapter 1 - 1_2')?.path,
        endsWith('Chapter 1 - 1_2.cbz'),
      );
    });

    test('is null when nothing was downloaded', () {
      expect(findChapterArchive(directory, 'Chapter 1'), isNull);
    });

    test('does not match another chapter in the same manga folder', () {
      write('Chapter 2.cbz');
      expect(findChapterArchive(directory, 'Chapter 1'), isNull);
    });
  });

  group('findDownloadedChapterIn', () {
    late Directory downloads;
    late Directory localFolder;

    setUp(() {
      downloads = Directory(p.join(directory.path, 'downloads', 'Manga'))
        ..createSync(recursive: true);
      localFolder = Directory(p.join(directory.path, 'local', 'Manga'))
        ..createSync(recursive: true);
    });

    DownloadedChapter? find({bool isComplete = true}) =>
        findDownloadedChapterIn(
          [downloads, localFolder],
          chapterName: 'Chapter 1',
          chapterDirectoryName: 'Chapter 1',
          isComplete: isComplete,
        );

    void writeArchive(Directory into) =>
        File(p.join(into.path, 'Chapter 1.cbz')).writeAsStringSync('');

    void writePages(Directory into, int count) {
      final pages = Directory(p.join(into.path, 'Chapter 1'))..createSync();
      for (var i = 1; i <= count; i++) {
        File(p.join(pages.path, '${i.toString().padLeft(3, '0')}.jpg'))
            .writeAsStringSync('');
      }
    }

    test('is null when nothing was downloaded anywhere', () {
      expect(find(), isNull);
    });

    test('finds an archive in the downloads directory', () {
      writeArchive(downloads);
      expect(find()?.archive?.path, startsWith(downloads.path));
    });

    test('falls back to a local folder, where older builds put it', () {
      writeArchive(localFolder);
      expect(find()?.archive?.path, startsWith(localFolder.path));
    });

    test('prefers the downloads directory when both hold a copy', () {
      writeArchive(downloads);
      writeArchive(localFolder);
      expect(find()?.archive?.path, startsWith(downloads.path));
    });

    test('finds a page folder and counts it', () {
      writePages(downloads, 3);
      final found = find();
      expect(found?.pagesDirectory?.path, startsWith(downloads.path));
      expect(found?.pageCount, 3);
    });

    test('finds a page folder in a local folder too', () {
      writePages(localFolder, 2);
      expect(find()?.pagesDirectory?.path, startsWith(localFolder.path));
    });

    test('ignores a page folder while the download is still running', () {
      writePages(downloads, 3);
      expect(find(isComplete: false), isNull);
    });

    test('still takes an archive while a download is running, since an archive '
        'is only written once the download finished', () {
      writeArchive(downloads);
      expect(find(isComplete: false)?.archive, isNotNull);
    });

    test('prefers the archive over a page folder beside it', () {
      writeArchive(downloads);
      writePages(downloads, 3);
      expect(find()?.archive, isNotNull);
      expect(find()?.pagesDirectory, isNull);
    });
  });

  group('countDownloadedPages', () {
    test('counts a complete chapter', () {
      for (final name in ['001.jpg', '002.jpg', '003.jpg']) {
        write(name);
      }
      expect(countDownloadedPages(directory), 3);
    });

    test('stops at the first gap, since the reader asks by page index', () {
      write('001.jpg');
      write('002.jpg');
      write('004.jpg');
      expect(countDownloadedPages(directory), 2);
    });

    test('is zero for a folder holding no first page', () {
      write('cover.jpg');
      expect(countDownloadedPages(directory), 0);
    });

    test('is zero for a folder that was never created', () {
      expect(
        countDownloadedPages(Directory(p.join(directory.path, 'missing'))),
        0,
      );
    });
  });
}
