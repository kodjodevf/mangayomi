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
    test('finds the archive the downloader writes', () async {
      write('Chapter 1.cbz');
      expect(
        (await findChapterArchive(directory, 'Chapter 1'))?.path,
        endsWith('Chapter 1.cbz'),
      );
    });

    test(
      'finds it when the title held a colon the downloader stripped',
      () async {
        // The downloader replaces forbidden characters with spaces, so this is
        // the name on disk for a chapter called "Chapter 1: Beginnings". The
        // reader used to rebuild the raw name and never match it.
        write('Chapter 1  Beginnings.cbz');
        expect(
          (await findChapterArchive(directory, 'Chapter 1: Beginnings'))?.path,
          endsWith('Chapter 1  Beginnings.cbz'),
        );
      },
    );

    test('finds it under a name with nothing to sanitise', () async {
      write('Chapter 1 - 1_2.cbz');
      expect(
        (await findChapterArchive(directory, 'Chapter 1 - 1_2'))?.path,
        endsWith('Chapter 1 - 1_2.cbz'),
      );
    });

    test('is null when nothing was downloaded', () async {
      expect(await findChapterArchive(directory, 'Chapter 1'), isNull);
    });

    test('does not match another chapter in the same manga folder', () async {
      write('Chapter 2.cbz');
      expect(await findChapterArchive(directory, 'Chapter 1'), isNull);
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

    Future<DownloadedChapter?> find({bool isComplete = true}) =>
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

    test('is null when nothing was downloaded anywhere', () async {
      expect(await find(), isNull);
    });

    test('finds an archive in the downloads directory', () async {
      writeArchive(downloads);
      expect((await find())?.archive?.path, startsWith(downloads.path));
    });

    test('falls back to a local folder, where older builds put it', () async {
      writeArchive(localFolder);
      expect((await find())?.archive?.path, startsWith(localFolder.path));
    });

    test('prefers the downloads directory when both hold a copy', () async {
      writeArchive(downloads);
      writeArchive(localFolder);
      expect((await find())?.archive?.path, startsWith(downloads.path));
    });

    test('finds a page folder and counts it', () async {
      writePages(downloads, 3);
      final found = await find();
      expect(found?.pagesDirectory?.path, startsWith(downloads.path));
      expect(found?.pageCount, 3);
    });

    test('finds a page folder in a local folder too', () async {
      writePages(localFolder, 2);
      expect(
        (await find())?.pagesDirectory?.path,
        startsWith(localFolder.path),
      );
    });

    test('ignores a page folder while the download is still running', () async {
      writePages(downloads, 3);
      expect((await find(isComplete: false)), isNull);
    });

    test('still takes an archive while a download is running, since an archive '
        'is only written once the download finished', () async {
      writeArchive(downloads);
      expect((await find(isComplete: false))?.archive, isNotNull);
    });

    test('prefers the archive over a page folder beside it', () async {
      writeArchive(downloads);
      writePages(downloads, 3);
      expect((await find())?.archive, isNotNull);
      expect((await find())?.pagesDirectory, isNull);
    });
  });

  group('listDownloadedPageFiles', () {
    Future<List<String>> names(Directory directory) async => [
      for (final file in await listDownloadedPageFiles(directory))
        p.basename(file.path),
    ];

    test('lists a complete chapter in reading order', () async {
      for (final name in ['003.jpg', '001.jpg', '002.jpg']) {
        write(name);
      }
      expect(await names(directory), ['001.jpg', '002.jpg', '003.jpg']);
    });

    test('keeps each page under the extension it was saved with', () async {
      write('001.jpg');
      write('002.webp');
      write('003.avif');
      expect(await names(directory), ['001.jpg', '002.webp', '003.avif']);
    });

    test(
      'takes the first known extension when a page is there twice',
      () async {
        write('001.png');
        write('001.jpg');
        expect(await names(directory), ['001.jpg']);
      },
    );

    test(
      'stops at the first gap, since the reader asks by page index',
      () async {
        write('001.jpg');
        write('002.jpg');
        write('004.jpg');
        expect(await names(directory), ['001.jpg', '002.jpg']);
      },
    );

    test('is empty for a folder holding no first page', () async {
      write('cover.jpg');
      Directory(p.join(directory.path, '001.jpg.d')).createSync();
      expect(await names(directory), isEmpty);
    });

    test('is empty for a folder that was never created', () async {
      expect(
        await listDownloadedPageFiles(
          Directory(p.join(directory.path, 'missing')),
        ),
        isEmpty,
      );
    });
  });
}
