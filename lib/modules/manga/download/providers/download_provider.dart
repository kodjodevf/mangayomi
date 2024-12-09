import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/services/background_downloader/background_downloader.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/convert_to_cbz.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/m3u8/m3u8_downloader.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'download_provider.g.dart';

@riverpod
Future<List<PageUrl>> downloadChapter(
  Ref ref, {
  required Chapter chapter,
  bool? useWifi,
}) async {
  List<PageUrl> pageUrls = [];
  List<DownloadTask> tasks = [];
  final StorageProvider storageProvider = StorageProvider();
  await storageProvider.requestPermission();
  final tempDir = await getTemporaryDirectory();
  final mangaDir = await storageProvider.getMangaMainDirectory(chapter);
  bool onlyOnWifi = useWifi ?? ref.watch(onlyOnWifiStateProvider);
  Directory? path;
  bool isOk = false;
  final manga = chapter.manga.value!;
  final path1 = await storageProvider.getDirectory();
  String scanlator = chapter.scanlator!.isNotEmpty
      ? "${chapter.scanlator!.replaceForbiddenCharacters('_')}_"
      : "";
  final chapterName = chapter.name!.replaceForbiddenCharacters(' ');

  final isManga = manga.isManga!;
  final pathSegments = [
    "downloads",
    isManga ? "Manga" : "Anime",
    "${manga.source} (${manga.lang!.toUpperCase()})",
    manga.name!.replaceForbiddenCharacters('_'),
  ];
  if (isManga) {
    pathSegments.add(scanlator);
    pathSegments.add(chapter.name!.replaceForbiddenCharacters('_'));
  }
  final finalPath = p.joinAll(pathSegments);
  path = Directory(p.join(path1!.path, finalPath));
  Map<String, String> videoHeader = {};
  bool hasM3U8File = false;
  bool nonM3U8File = false;
  M3u8Downloader? m3u8Downloader;
  Uint8List? tsKey;
  Uint8List? tsIv;
  int? m3u8MediaSequence;

  Future<void> processConvert() async {
    if (hasM3U8File) {
      await m3u8Downloader?.mergeTsToMp4(
          p.join(path!.path, "$chapterName.mp4"), p.join(path.path, chapterName));
    } else {
      if (ref.watch(saveAsCBZArchiveStateProvider)) {
        await ref.watch(convertToCBZProvider(path!.path, mangaDir!.path,
                chapter.name!, pageUrls.map((e) => e.url).toList())
            .future);
      }
    }
  }

  void savePageUrls() {
    final settings = isar.settings.getSync(227)!;
    List<ChapterPageurls>? chapterPageUrls = [];
    for (var chapterPageUrl in settings.chapterPageUrlsList ?? []) {
      if (chapterPageUrl.chapterId != chapter.id) {
        chapterPageUrls.add(chapterPageUrl);
      }
    }
    final chapterPageHeaders = pageUrls
        .map((e) => e.headers == null ? null : jsonEncode(e.headers))
        .toList();
    chapterPageUrls.add(ChapterPageurls()
      ..chapterId = chapter.id
      ..urls = pageUrls.map((e) => e.url).toList()
      ..headers = chapterPageHeaders.first != null
          ? chapterPageHeaders.map((e) => e.toString()).toList()
          : null);
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings..chapterPageUrlsList = chapterPageUrls));
  }

  if (isManga) {
    ref
        .read(getChapterPagesProvider(
      chapter: chapter,
    ).future)
        .then((value) {
      if (value.pageUrls.isNotEmpty) {
        pageUrls = value.pageUrls;
        isOk = true;
      }
    });
  } else {
    ref.read(getVideoListProvider(episode: chapter).future).then((value) async {
      final m3u8Urls = value.$1
          .where((element) =>
              element.originalUrl.endsWith(".m3u8") ||
              element.originalUrl.endsWith(".m3u"))
          .toList();
      final nonM3u8Urls = value.$1
          .where((element) => element.originalUrl.isMediaVideo())
          .toList();
      nonM3U8File = nonM3u8Urls.isNotEmpty;
      hasM3U8File = nonM3U8File ? false : m3u8Urls.isNotEmpty;
      final videosUrls = nonM3U8File ? nonM3u8Urls : m3u8Urls;
      if (videosUrls.isNotEmpty) {
        List<TsInfo> tsList = [];
        if (hasM3U8File) {
          m3u8Downloader = M3u8Downloader(
              m3u8Url: videosUrls.first.url,
              downloadDir: p.join(path!.path, chapterName),
              headers: videosUrls.first.headers ?? {});
          (tsList, tsKey, tsIv, m3u8MediaSequence) =
              await m3u8Downloader!.getTsList();
        }
        pageUrls = hasM3U8File
            ? [...tsList.map((e) => PageUrl(e.url))]
            : [PageUrl(videosUrls.first.url)];
        videoHeader.addAll(videosUrls.first.headers ?? {});
        isOk = true;
      }
    });
  }

  await Future.doWhile(() async {
    await Future.delayed(const Duration(seconds: 1));
    if (isOk == true) {
      return false;
    }
    return true;
  });

  if (pageUrls.isNotEmpty) {
    bool cbzFileExist =
        await File(p.join(mangaDir!.path, "${chapter.name}.cbz")).exists() &&
            ref.watch(saveAsCBZArchiveStateProvider);
    bool mp4FileExist = await File(p.join(mangaDir.path, "$chapterName.mp4")).exists();
    if (!cbzFileExist && isManga || !mp4FileExist && !isManga) {
      for (var index = 0; index < pageUrls.length; index++) {
        final path2 = Directory(p.join(path1.path,
                                      "downloads",
                                      isManga ? "Manga" : "Anime",
                                      "${manga.source} (${manga.lang!.toUpperCase()})",
                                      manga.name!.replaceForbiddenCharacters('_')));
        if (!(await path2.exists())) {
          await path2.create(recursive: true);
        }
        if (Platform.isAndroid) {
          if (!(await File(p.join(path1.path, ".nomedia")).exists())) {
            await File(p.join(path1.path, ".nomedia")).create();
          }
        }
        final page = pageUrls[index];
        final cookie = MClient.getCookiesPref(page.url);
        final headers = isManga
            ? ref.watch(
                headersProvider(source: manga.source!, lang: manga.lang!))
            : videoHeader;
        if (cookie.isNotEmpty) {
          final userAgent = isar.settings.getSync(227)!.userAgent!;
          headers.addAll(cookie);
          headers[HttpHeaders.userAgentHeader] = userAgent;
        }
        Map<String, String> pageHeaders = headers;
        pageHeaders.addAll(page.headers ?? {});

        if (isManga) {
          final file = File(p.join(tempDir.path, "Mangayomi", finalPath, "${padIndex(index + 1)}.jpg"));
          if (file.existsSync()) {
            Directory(path.path).createSync(recursive: true);
            await file.copy(p.join(path.path, "${padIndex(index + 1)}.jpg"));
            await file.delete();
          } else {
            if (!(await path.exists())) {
              await path.create();
            }
            if (!(await File(p.join(path.path, "${padIndex(index + 1)}.jpg")).exists())) {
              tasks.add(DownloadTask(
                  taskId: page.url,
                  headers: pageHeaders,
                  url: page.url.trim().trimLeft().trimRight(),
                  filename: "${padIndex(index + 1)}.jpg",
                  baseDirectory: BaseDirectory.temporary,
                  directory: p.join('Mangayomi', finalPath),
                  updates: Updates.statusAndProgress,
                  retries: 3,
                  allowPause: true,
                  requiresWiFi: onlyOnWifi));
            }
          }
        } else {
          final file = File(p.join(tempDir.path, "Mangayomi", finalPath, "$chapterName.mp4"));
          if (file.existsSync()) {
            await file.copy(p.join(path.path, "$chapterName.mp4"));
            await file.delete();
          } else if (hasM3U8File) {
            final tempFile = File(p.join(tempDir.path, "Mangayomi", finalPath, chapterName, "TS_${index + 1}.ts"));
            final file = File(p.join(path.path, chapterName, "TS_${index + 1}.ts"));
            if (tempFile.existsSync()) {
              Directory(p.join(path.path, chapterName)).createSync(recursive: true);
              await tempFile.copy(p.join(path.path, chapterName, "TS_${index + 1}.ts"));
              await tempFile.delete();
            } else if (!(file.existsSync())) {
              tasks.add(DownloadTask(
                  taskId: page.url,
                  headers: pageHeaders,
                  url: page.url.trim().trimLeft().trimRight(),
                  filename: "TS_${index + 1}.ts",
                  baseDirectory: BaseDirectory.temporary,
                  directory: p.join('Mangayomi', finalPath, chapterName),
                  updates: Updates.statusAndProgress,
                  allowPause: true,
                  retries: 3,
                  requiresWiFi: onlyOnWifi));
            }
          } else {
            if (!(await path.exists())) {
              await path.create();
            }
            if (!(await File(p.join(path.path, "$chapterName.mp4")).exists())) {
              tasks.add(DownloadTask(
                  taskId: page.url,
                  headers: pageHeaders,
                  url: page.url.trim().trimLeft().trimRight(),
                  filename: "$chapterName.mp4",
                  baseDirectory: BaseDirectory.temporary,
                  directory: p.join("Mangayomi", finalPath),
                  updates: Updates.statusAndProgress,
                  allowPause: true,
                  retries: 3,
                  requiresWiFi: onlyOnWifi));
            }
          }
        }
      }
    }

    if (tasks.isEmpty && pageUrls.isNotEmpty) {
      await processConvert();
      savePageUrls();
      final download = Download(
          succeeded: 0,
          failed: 0,
          total: 0,
          isDownload: true,
          taskIds: pageUrls.map((e) => e.url).toList(),
          isStartDownload: false,
          chapterId: chapter.id,
          mangaId: manga.id);

      isar.writeTxnSync(() {
        isar.downloads.putSync(download..chapter.value = chapter);
      });
    } else {
      if (hasM3U8File) {
        await Directory(p.join(path.path, chapterName)).create(recursive: true);
      }
      savePageUrls();
      await FileDownloader().downloadBatch(
        tasks,
        batchProgressCallback: (succeeded, failed) async {
          if (isManga || hasM3U8File) {
            if (succeeded == tasks.length) {
              await processConvert();
            }
            bool isEmpty = isar.downloads
                .filter()
                .chapterIdEqualTo(chapter.id!)
                .isEmptySync();
            if (isEmpty) {
              final download = Download(
                  succeeded: succeeded,
                  failed: failed,
                  total: tasks.length,
                  isDownload: (succeeded == tasks.length),
                  taskIds: pageUrls.map((e) => e.url).toList(),
                  isStartDownload: true,
                  chapterId: chapter.id,
                  mangaId: manga.id);
              isar.writeTxnSync(() {
                isar.downloads.putSync(download..chapter.value = chapter);
              });
            } else {
              final download = isar.downloads
                  .filter()
                  .chapterIdEqualTo(chapter.id!)
                  .findFirstSync()!;
              isar.writeTxnSync(() {
                isar.downloads.putSync(download
                  ..succeeded = succeeded
                  ..failed = failed
                  ..isDownload = (succeeded == tasks.length));
              });
            }
          }
        },
        taskProgressCallback: (taskProgress) async {
          final progress = taskProgress.progress;
          if (!isManga && !hasM3U8File) {
            bool isEmpty = isar.downloads
                .filter()
                .chapterIdEqualTo(chapter.id!)
                .isEmptySync();
            if (isEmpty) {
              final download = Download(
                  succeeded: (progress * 100).toInt(),
                  failed: 0,
                  total: 100,
                  isDownload: (progress == 1.0),
                  taskIds: pageUrls.map((e) => e.url).toList(),
                  isStartDownload: true,
                  chapterId: chapter.id,
                  mangaId: manga.id);
              isar.writeTxnSync(() {
                isar.downloads.putSync(download..chapter.value = chapter);
              });
            } else {
              final download = isar.downloads
                  .filter()
                  .chapterIdEqualTo(chapter.id!)
                  .findFirstSync()!;
              isar.writeTxnSync(() {
                isar.downloads.putSync(download
                  ..succeeded = (progress * 100).toInt()
                  ..failed = 0
                  ..isDownload = (progress == 1.0));
              });
            }
          }
          if (progress == 1.0) {
            final file = File(p.join(tempDir.path, taskProgress.task.directory, taskProgress.task.filename));
            if(hasM3U8File) {
              final newFile = await file.copy(p.join(path!.path, chapterName, taskProgress.task.filename));
              await file.delete();
              await m3u8Downloader?.processBytes(newFile, tsKey, tsIv, m3u8MediaSequence);
            } else {
              await file.copy(p.join(path!.path, taskProgress.task.filename));
              await file.delete();
            }
          }
        },
      );
    }
  }
  return pageUrls;
}
