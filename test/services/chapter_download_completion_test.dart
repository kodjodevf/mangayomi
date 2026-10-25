// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/manga/download/providers/convert_to_cbz.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _Paths extends PathProviderPlatform {
  _Paths(this.path);
  final String path;
  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HttpOverrides.global = null;
    await Isar.initializeIsarCore(download: true);
  });

  testWidgets(
    'a cold download does not wait for a stalled optional cover, which '
    'replaces the page standing in for it once it comes',
    (tester) => _runDownloadTest(tester, 0, stalledCover: true),
  );
  testWidgets(
    'partial resume packs cached and newly fetched pages',
    (tester) => _runDownloadTest(tester, 1),
  );
  testWidgets(
    'an entirely cached chapter packs every page without image HTTP',
    (tester) => _runDownloadTest(tester, 2),
  );
  testWidgets(
    'the download stays active until asynchronous packing finishes',
    (tester) => _runDownloadTest(tester, 0, holdPacking: true),
  );
  testWidgets(
    'a failed page leaves cached files and reading progress intact',
    (tester) => _runDownloadTest(tester, 1, failPages: true),
  );
}

Future<void> _runDownloadTest(
  WidgetTester tester,
  int cachedPages, {
  bool stalledCover = false,
  bool holdPacking = false,
  bool failPages = false,
}) async {
  await tester.pumpWidget(
    MaterialApp(builder: BotToastInit(), home: const SizedBox()),
  );
  try {
    // Real loopback HTTP, isolates and filesystem I/O need real async time.
    await tester.runAsync(
      () => _checkDownload(
        cachedPages,
        stalledCover: stalledCover,
        holdPacking: holdPacking,
        failPages: failPages,
      ),
    );
  } finally {
    BotToast.cleanAll();
    await tester.pumpAndSettle();
  }
}

Future<void> _checkDownload(
  int cachedPages, {
  bool stalledCover = false,
  bool holdPacking = false,
  bool failPages = false,
}) async {
  final directory = await Directory.systemTemp.createTemp('chapter-download-');
  addTearDown(() => directory.delete(recursive: true));
  final previousPaths = PathProviderPlatform.instance;
  PathProviderPlatform.instance = _Paths(directory.path);
  addTearDown(() => PathProviderPlatform.instance = previousPaths);
  ChapterCache().customCacheDir = Directory(p.join(directory.path, 'cache'));
  addTearDown(() => ChapterCache().customCacheDir = null);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const connectivity = MethodChannel('dev.fluttercommunity.plus/connectivity');
  messenger.setMockMethodCallHandler(connectivity, (_) async => ['wifi']);
  addTearDown(() => messenger.setMockMethodCallHandler(connectivity, null));
  final db = await Isar.open(
    [
      MangaSchema,
      ChapterSchema,
      DownloadSchema,
      SettingsSchema,
      SourceSchema,
      UpdateSchema,
    ],
    directory: directory.path,
    name: 'chapter_download',
  );
  app.isar = db;
  addTearDown(() => db.close(deleteFromDisk: true));
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  addTearDown(() => server.close(force: true));
  final releaseCover = Completer<void>();
  final releasePacking = Completer<void>();
  final packingStarted = Completer<void>();
  var imageRequests = 0;
  var coverRequests = 0;
  final image = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAAAI0lEQVR4nGP8//8/AymAiSTVDKMaiANMRKqDg1ENxACSQwkAVW0DHeN02ZEAAAAASUVORK5CYII=',
  );
  // Told apart from the pages by a trailing byte, still a PNG.
  final coverImage = [...image, 0];
  server.listen((request) async {
    if (request.uri.path == '/cover') {
      coverRequests++;
      await releaseCover.future;
    } else {
      imageRequests++;
      if (failPages) {
        request.response.statusCode = HttpStatus.internalServerError;
        await request.response.close();
        return;
      }
    }
    request.response.headers.contentType = ContentType('image', 'png');
    request.response.add(request.uri.path == '/cover' ? coverImage : image);
    await request.response.close();
  });
  db.writeTxnSync(() {
    db.settings.putSync(
      Settings()
        ..downloadLocation = directory.path
        ..saveAsCBZArchive = true
        ..chapterPageIndexList = [ChapterPageIndex(chapterId: 1, index: 6)],
    );
    final manga = Manga(
      id: 1,
      name: 'Fixture',
      source: 'test',
      sourceId: 1,
      lang: 'en',
      favorite: true,
      genre: [],
      author: '',
      artist: '',
      description: '',
      link: '/work',
      status: Status.ongoing,
      imageUrl: stalledCover ? 'http://127.0.0.1:${server.port}/cover' : '',
    );
    db.mangas.putSync(manga);
    final chapter = Chapter(
      id: 1,
      mangaId: 1,
      name: 'Chapter 1',
      url: '/chapter/1',
      lastPageRead: '7',
      isBookmarked: true,
    )..manga.value = manga;
    db.chapters.putSync(chapter);
    chapter.manga.saveSync();
    final update = Update(mangaId: 1, chapterName: chapter.name, date: '1')
      ..chapter.value = chapter;
    db.updates.putSync(update);
    update.chapter.saveSync();
  });
  // Start from the lazy chapter link used by an Updates row, without detail.
  final update = db.updates.where().findFirstSync()!;
  update.chapter.loadSync();
  final chapter = update.chapter.value!;
  expect(chapter.manga.isLoaded, false);
  final mangaDirectory = Directory(
    p.join(
      directory.path,
      'Mangayomi',
      'downloads',
      'Manga',
      'test (EN)',
      'Fixture',
    ),
  );
  final pagesDirectory = Directory(p.join(mangaDirectory.path, 'Chapter 1'));
  await pagesDirectory.create(recursive: true);
  for (var i = 0; i < cachedPages; i++) {
    await File(p.join(pagesDirectory.path, '${padIndex(i)}.png'))
        .writeAsBytes(image);
  }
  final cbz = File(p.join(mangaDirectory.path, 'Chapter 1.cbz'));
  DownloadIsolatePool.configureForTesting();
  addTearDown(() => DownloadIsolatePool.instance.dispose());
  final container = ProviderContainer(
    overrides: [
      headersProvider.overrideWith((ref, args) => {}),
      scanLocalLibraryProvider.overrideWith((ref) async {}),
      getChapterPagesProvider.overrideWith(
        (ref, args) => GetChapterPagesModel(
          path: pagesDirectory,
          pageUrls: [
            for (var i = 0; i < 2; i++)
              PageUrl('http://127.0.0.1:${server.port}/page/$i'),
          ],
          isLocaleList: [false, false],
          archiveImages: [null, null],
          uChapDataPreload: [],
          localImagePaths: [null, null],
        ),
      ),
      if (holdPacking)
        convertToCBZProvider.overrideWith((ref, args) async {
          packingStarted.complete();
          await releasePacking.future;
          return <String>[];
        }),
    ],
  );
  addTearDown(container.dispose);
  final download = container.read(
    downloadChapterProvider(chapter: chapter).future,
  );
  // Register cleanup before assertions: one failed test must not leave an open
  // Isar instance that turns the following cases into unrelated failures.
  addTearDown(() async {
    if (!releaseCover.isCompleted) releaseCover.complete();
    if (!releasePacking.isCompleted) releasePacking.complete();
    await download
        .timeout(const Duration(seconds: 10))
        .catchError((Object _) {});
    await dbWriteQueue.run(() {});
  });
  if (holdPacking) {
    await packingStarted.future.timeout(const Duration(seconds: 10));
    final state = await Future.any([
      download.then((_) => 'finished'),
      Future.delayed(const Duration(milliseconds: 150), () => 'packing'),
    ]);
    expect(state, 'packing');
    expect(db.downloads.getSync(1)?.isDownload, isNot(true));
    releasePacking.complete();
  }
  await download.timeout(const Duration(seconds: 10));
  // Completion must include packing and persistence; no post-download polling.
  expect(db.downloads.getSync(1)?.isDownload, !failPages);
  if (stalledCover) {
    // Done while the cover still hangs: a page stands in for it...
    final cover = File(p.join(mangaDirectory.path, 'cover.png'));
    expect(await cover.readAsBytes(), image);
    // ...until the series' own cover comes, fetched after the download.
    releaseCover.complete();
    final deadline = DateTime.now().add(const Duration(seconds: 10));
    while (!_sameBytes(await cover.readAsBytes(), coverImage)) {
      if (DateTime.now().isAfter(deadline)) fail('the cover was not replaced');
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    expect(coverRequests, 1);
  } else {
    expect(coverRequests, 0);
  }
  if (failPages) {
    expect(imageRequests, greaterThan(0));
    expect(await cbz.exists(), false);
    expect(
      await File(p.join(pagesDirectory.path, '${padIndex(0)}.png'))
          .readAsBytes(),
      image,
    );
  } else {
    expect(imageRequests, 2 - cachedPages);
  }
  if (!holdPacking && !failPages) {
    final archive = ZipDecoder().decodeBytes(
      await cbz.readAsBytes(),
      verify: true,
    );
    final pages = archive.files.where((f) => f.name.endsWith('.png')).toList();
    expect(pages, hasLength(2));
    for (final page in pages) {
      expect(page.content, image);
    }
    expect(
      await File(p.join(mangaDirectory.path, 'cover.png')).readAsBytes(),
      stalledCover ? coverImage : image,
    );
  }
  expect(db.chapters.getSync(1)!.lastPageRead, '7');
  expect(db.chapters.getSync(1)!.isBookmarked, true);
  expect(db.settings.getSync(227)!.chapterPageIndexList!.single.index, 6);
}

bool _sameBytes(List<int> a, List<int> b) =>
    a.length == b.length &&
    Iterable<int>.generate(a.length).every((i) => a[i] == b[i]);
