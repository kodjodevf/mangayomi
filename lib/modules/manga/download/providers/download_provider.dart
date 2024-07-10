import 'dart:io';
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
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'download_provider.g.dart';

FileDownloader _mangaFileDownloader = FileDownloader(isAnime: false);
FileDownloader _animeFileDownloader = FileDownloader(isAnime: true);
@riverpod
Future<List<String>> downloadChapter(
  DownloadChapterRef ref, {
  required Chapter chapter,
  bool? useWifi,
}) async {
  List<String> pageUrls = [];
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
  final regExp = RegExp(r'[^a-zA-Z0-9 .()\-\s]');
  String scanlator = chapter.scanlator!.isNotEmpty
      ? "${chapter.scanlator!.replaceAll(regExp, '_')}_"
      : "";

  final isManga = chapter.manga.value!.isManga!;
  final finalPath =
      "downloads/${isManga ? "Manga" : "Anime"}/${manga.source} (${manga.lang!.toUpperCase()})/${manga.name!.replaceAll(regExp, '_')}${isManga ? "/$scanlator${chapter.name!.replaceAll(regExp, '_')}" : ""}";
  path = Directory("${path1!.path}$finalPath/");
  Map<String, String> videoHeader = {};

  void savePageUrls() {
    final settings = isar.settings.getSync(227)!;
    List<ChapterPageurls>? chapterPageUrls = [];
    for (var chapterPageUrl in settings.chapterPageUrlsList ?? []) {
      if (chapterPageUrl.chapterId != chapter.id) {
        chapterPageUrls.add(chapterPageUrl);
      }
    }
    chapterPageUrls.add(ChapterPageurls()
      ..chapterId = chapter.id
      ..urls = pageUrls);
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
    ref
        .read(getVideoListProvider(
      episode: chapter,
    ).future)
        .then((value) {
      final videosUrls = value.$1
          .where((element) => element.originalUrl.isMediaVideo())
          .toList();
      if (videosUrls.isNotEmpty) {
        pageUrls = [videosUrls.first.url];
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
        await File("${mangaDir!.path}${chapter.name}.cbz").exists() &&
            ref.watch(saveAsCBZArchiveStateProvider);
    bool mp4FileExist =
        await File("${mangaDir.path}${chapter.name}.mp4").exists();
    if (!cbzFileExist && isManga || !mp4FileExist && !isManga) {
      for (var index = 0; index < pageUrls.length; index++) {
        final path2 = Directory("${path1.path}downloads/");
        final path5 =
            Directory("${path1.path}downloads/${isManga ? "Manga" : "Anime"}/");
        final path4 = Directory(
            "${path5.path}${manga.source} (${manga.lang!.toUpperCase()})/");
        final path3 =
            Directory("${path4.path}${manga.name!.replaceAll(regExp, '_')}/");

        if (!(await path1.exists())) {
          await path1.create();
        }
        if (Platform.isAndroid) {
          if (!(await File("${path1.path}" ".nomedia").exists())) {
            await File("${path1.path}" ".nomedia").create();
          }
        }
        if (!(await path2.exists())) {
          await path2.create();
        }
        if (!(await path5.exists())) {
          await path5.create();
        }
        if (!(await path4.exists())) {
          await path4.create();
        }
        if (!(await path3.exists())) {
          await path3.create();
        }

        final cookie = MClient.getCookiesPref(pageUrls[index]);
        final headers = isManga
            ? ref.watch(
                headersProvider(source: manga.source!, lang: manga.lang!))
            : videoHeader;
        if (cookie.isNotEmpty) {
          final userAgent = isar.settings.getSync(227)!.userAgent!;
          headers.addAll(cookie);
          headers[HttpHeaders.userAgentHeader] = userAgent;
        }
        if (isManga) {
          if ((await path.exists())) {
            if (await File("${path.path}" "${padIndex(index + 1)}.jpg")
                .exists()) {
            } else {
              tasks.add(DownloadTask(
                  taskId: pageUrls[index],
                  headers: headers,
                  url: pageUrls[index].trim().trimLeft().trimRight(),
                  filename: "${padIndex(index + 1)}.jpg",
                  baseDirectory: BaseDirectory.temporary,
                  directory: 'Mangayomi/$finalPath',
                  updates: Updates.statusAndProgress,
                  retries: 3,
                  allowPause: true,
                  requiresWiFi: onlyOnWifi));
            }
          } else {
            await path.create();
            if (await File("${path.path}" "${padIndex(index + 1)}.jpg")
                .exists()) {
            } else {
              tasks.add(DownloadTask(
                  taskId: pageUrls[index],
                  headers: headers,
                  url: pageUrls[index].trim().trimLeft().trimRight(),
                  filename: "${padIndex(index + 1)}.jpg",
                  baseDirectory: BaseDirectory.temporary,
                  directory: 'Mangayomi/$finalPath',
                  updates: Updates.statusAndProgress,
                  allowPause: true,
                  retries: 3,
                  requiresWiFi: onlyOnWifi));
            }
          }
        } else {
          if ((await path.exists())) {
            if (await File("${path.path}${chapter.name}.mp4").exists()) {
            } else {
              tasks.add(DownloadTask(
                  taskId: pageUrls[index],
                  headers: headers,
                  url: pageUrls[index].trim().trimLeft().trimRight(),
                  filename: "${chapter.name}.mp4",
                  baseDirectory: BaseDirectory.temporary,
                  directory: 'Mangayomi/$finalPath',
                  updates: Updates.statusAndProgress,
                  allowPause: true,
                  retries: 3,
                  requiresWiFi: onlyOnWifi));
            }
          } else {
            await path.create();
            if (await File("${path.path}${chapter.name}.mp4").exists()) {
            } else {
              tasks.add(DownloadTask(
                  taskId: pageUrls[index],
                  headers: headers,
                  url: pageUrls[index].trim().trimLeft().trimRight(),
                  filename: "${chapter.name}.mp4",
                  baseDirectory: BaseDirectory.temporary,
                  directory: 'Mangayomi/$finalPath',
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
      savePageUrls();
      final download = Download(
          succeeded: 0,
          failed: 0,
          total: 0,
          isDownload: true,
          taskIds: pageUrls,
          isStartDownload: false,
          chapterId: chapter.id,
          mangaId: manga.id);

      isar.writeTxnSync(() {
        isar.downloads.putSync(download..chapter.value = chapter);
      });
    } else {
      if (isManga) {
        await _mangaFileDownloader.downloadBatch(
          tasks,
          batchProgressCallback: (succeeded, failed) async {
            if (succeeded == tasks.length) {
              if (isManga) {
                savePageUrls();
                if (ref.watch(saveAsCBZArchiveStateProvider)) {
                  await ref.watch(convertToCBZProvider(
                          path!.path, mangaDir.path, chapter.name!, pageUrls)
                      .future);
                }
              }
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
                  taskIds: pageUrls,
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
          },
          taskProgressCallback: (taskProgress) async {
            if (taskProgress.progress == 1.0) {
              final file = File(
                  "${tempDir.path}/${taskProgress.task.directory}/${taskProgress.task.filename}");
              await file.copy("${path!.path}/${taskProgress.task.filename}");
              await file.delete();
            }
          },
        );
      } else {
        await _animeFileDownloader.download(
          tasks.first,
          onProgress: (progress) async {
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
                  taskIds: pageUrls,
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
          },
          onStatus: (status) async {
            if (status == TaskStatus.complete) {
              final file = File(
                  "${tempDir.path}/${tasks.first.directory}/${tasks.first.filename}");
              await file.copy("${path!.path}/${tasks.first.filename}");
              await file.delete();
            }
          },
        );
      }
    }
  }
  return pageUrls;
}
