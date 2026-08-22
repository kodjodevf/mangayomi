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
