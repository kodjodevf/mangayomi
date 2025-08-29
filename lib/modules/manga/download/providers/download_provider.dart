import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/manga/download/providers/convert_to_cbz.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/download_manager/m_downloader.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/download_manager/m3u8/m3u8_downloader.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'download_provider.g.dart';

@riverpod
Future<void> addDownloadToQueue(Ref ref, {required Chapter chapter}) async {
  final download = isar.downloads.getSync(chapter.id!);
  if (download == null) {
    final download = Download(
      id: chapter.id,
      succeeded: 0,
      failed: 0,
      total: 100,
      isDownload: false,
      isStartDownload: true,
    );
    isar.writeTxnSync(() {
      isar.downloads.putSync(download..chapter.value = chapter);
    });
  }
}

@riverpod
Future<void> downloadChapter(
  Ref ref, {
  required Chapter chapter,
  bool? useWifi,
  VoidCallback? callback,
}) async {
  bool onlyOnWifi = useWifi ?? ref.read(onlyOnWifiStateProvider);
  final connectivity = await Connectivity().checkConnectivity();
  final isOnWifi =
      connectivity.contains(ConnectivityResult.wifi) ||
      connectivity.contains(ConnectivityResult.ethernet);
  if (onlyOnWifi && !isOnWifi) {
    botToast(navigatorKey.currentContext!.l10n.downloads_are_limited_to_wifi);
    return;
  }
  final http = MClient.init(
    reqcopyWith: {'useDartHttpClient': true, 'followRedirects': false},
  );

  List<PageUrl> pageUrls = [];
  List<PageUrl> pages = [];
  final StorageProvider storageProvider = StorageProvider();
  await storageProvider.requestPermission();
  final mangaMainDirectory = await storageProvider.getMangaMainDirectory(
    chapter,
  );
  List<Track>? subtitles;
  bool isOk = false;
  final manga = chapter.manga.value!;
  final chapterName = chapter.name!.replaceForbiddenCharacters(' ');
  final itemType = chapter.manga.value!.itemType;
  final chapterDirectory = (await storageProvider.getMangaChapterDirectory(
    chapter,
    mangaMainDirectory: mangaMainDirectory,
  ))!;
  await storageProvider.createDirectorySafely(chapterDirectory.path);
  Map<String, String> videoHeader = {};
  Map<String, String> htmlHeader = {
    "Priority": "u=0, i",
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36",
  };
  bool hasM3U8File = false;
  bool nonM3U8File = false;
  M3u8Downloader? m3u8Downloader;

  Future<void> processConvert() async {
    if (!ref.read(saveAsCBZArchiveStateProvider)) return;
    try {
      await ref.read(
        convertToCBZProvider(
          chapterDirectory.path,
          mangaMainDirectory!.path,
          chapter.name!,
          pages.map((e) => e.fileName!).toList(),
        ).future,
      );
    } catch (error) {
      botToast("Failed to create CBZ: $error");
    }
  }

  Future<void> setProgress(DownloadProgress progress) async {
    if (progress.isCompleted && itemType == ItemType.manga) {
      await processConvert();
    }
    final download = isar.downloads.getSync(chapter.id!);
    if (download == null) {
      final download = Download(
        id: chapter.id,
        succeeded: progress.completed == 0
            ? 0
            : (progress.completed / progress.total * 100).toInt(),
        failed: 0,
        total: 100,
        isDownload: progress.isCompleted,
        isStartDownload: true,
      );
      isar.writeTxnSync(() {
        isar.downloads.putSync(download..chapter.value = chapter);
      });
    } else {
      final download = isar.downloads.getSync(chapter.id!);
      if (download != null && progress.total != 0) {
        isar.writeTxnSync(() {
          isar.downloads.putSync(
            download
              ..succeeded = progress.completed == 0
                  ? 0
                  : (progress.completed / progress.total * 100).toInt()
              ..total = 100
              ..failed = 0
              ..isDownload = progress.isCompleted,
          );
        });
      }
    }
  }

  setProgress(DownloadProgress(0, 0, itemType));
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
    chapterPageUrls.add(
      ChapterPageurls()
        ..chapterId = chapter.id
        ..urls = pageUrls.map((e) => e.url).toList()
        ..chapterUrl = chapter.url
        ..headers = chapterPageHeaders.first != null
            ? chapterPageHeaders.map((e) => e.toString()).toList()
            : null,
    );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..chapterPageUrlsList = chapterPageUrls
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  if (itemType == ItemType.manga) {
    ref.read(getChapterPagesProvider(chapter: chapter).future).then((value) {
      if (value.pageUrls.isNotEmpty) {
        pageUrls = value.pageUrls;
        isOk = true;
      }
    });
  } else if (itemType == ItemType.anime) {
    ref.read(getVideoListProvider(episode: chapter).future).then((value) async {
      final m3u8Urls = value.$1
          .where(
            (element) =>
                element.originalUrl.endsWith(".m3u8") ||
                element.originalUrl.endsWith(".m3u"),
          )
          .toList();
      final nonM3u8Urls = value.$1
          .where((element) => element.originalUrl.isMediaVideo())
          .toList();
      nonM3U8File = nonM3u8Urls.isNotEmpty;
      hasM3U8File = nonM3U8File ? false : m3u8Urls.isNotEmpty;
      final videosUrls = nonM3U8File ? nonM3u8Urls : m3u8Urls;
      if (videosUrls.isNotEmpty) {
        subtitles = videosUrls.first.subtitles;
        if (hasM3U8File) {
          m3u8Downloader = M3u8Downloader(
            m3u8Url: videosUrls.first.url,
            downloadDir: chapterDirectory.path,
            headers: videosUrls.first.headers ?? {},
            subtitles: subtitles,
            fileName: p.join(mangaMainDirectory!.path, "$chapterName.mp4"),
            chapter: chapter,
          );
        } else {
          pageUrls = [PageUrl(videosUrls.first.url)];
        }
        videoHeader.addAll(videosUrls.first.headers ?? {});
        isOk = true;
      }
    });
  } else if (itemType == ItemType.novel && chapter.url != null) {
    final cookie = MClient.getCookiesPref(chapter.url!);
    final headers = htmlHeader;
    if (cookie.isNotEmpty) {
      final userAgent = isar.settings.getSync(227)!.userAgent!;
      headers.addAll(cookie);
      headers[HttpHeaders.userAgentHeader] = userAgent;
    }
    final res = await http.get(Uri.parse(chapter.url!), headers: headers);
    if (res.headers.containsKey("Location")) {
      pageUrls = [PageUrl(res.headers["Location"]!)];
    } else {
      pageUrls = [PageUrl(chapter.url!)];
    }
    isOk = true;
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
        await File(
          p.join(mangaMainDirectory!.path, "${chapter.name}.cbz"),
        ).exists() &&
        ref.read(saveAsCBZArchiveStateProvider);
    bool mp4FileExist = await File(
      p.join(mangaMainDirectory.path, "$chapterName.mp4"),
    ).exists();
    bool htmlFileExist = await File(
      p.join(mangaMainDirectory.path, "$chapterName.html"),
    ).exists();
    if (!cbzFileExist && itemType == ItemType.manga ||
        !mp4FileExist && itemType == ItemType.anime ||
        !htmlFileExist && itemType == ItemType.novel) {
      final mainDirectory = (await storageProvider.getDirectory())!;
      storageProvider.createDirectorySafely(mainDirectory.path);
      for (var index = 0; index < pageUrls.length; index++) {
        if (Platform.isAndroid) {
          if (!(await File(p.join(mainDirectory.path, ".nomedia")).exists())) {
            await File(p.join(mainDirectory.path, ".nomedia")).create();
          }
        }
        final page = pageUrls[index];
        final cookie = MClient.getCookiesPref(page.url);
        final headers = itemType == ItemType.manga
            ? ref.read(
                headersProvider(
                  source: manga.source!,
                  lang: manga.lang!,
                  sourceId: manga.sourceId,
                ),
              )
            : itemType == ItemType.anime
            ? videoHeader
            : htmlHeader;
        if (cookie.isNotEmpty) {
          final userAgent = isar.settings.getSync(227)!.userAgent!;
          headers.addAll(cookie);
          headers[HttpHeaders.userAgentHeader] = userAgent;
        }
        Map<String, String> pageHeaders = headers;
        pageHeaders.addAll(page.headers ?? {});

        if (itemType == ItemType.manga) {
          final file = File(
            p.join(chapterDirectory.path, "${padIndex(index)}.jpg"),
          );
          if (!file.existsSync()) {
            pages.add(
              PageUrl(
                page.url.trim().trimLeft().trimRight(),
                headers: pageHeaders,
                fileName: p.join(
                  chapterDirectory.path,
                  "${padIndex(index)}.jpg",
                ),
              ),
            );
          }
        } else if (itemType == ItemType.anime) {
          final file = File(
            p.join(mangaMainDirectory.path, "$chapterName.mp4"),
          );
          if (!file.existsSync()) {
            pages.add(
              PageUrl(
                page.url.trim().trimLeft().trimRight(),
                headers: pageHeaders,
                fileName: p.join(mangaMainDirectory.path, "$chapterName.mp4"),
              ),
            );
          }
        } else {
          final file = File(p.join(chapterDirectory.path, "$chapterName.html"));
          if (!file.existsSync()) {
            pages.add(
              PageUrl(
                page.url.trim().trimLeft().trimRight(),
                headers: pageHeaders,
                fileName: p.join(chapterDirectory.path, "$chapterName.html"),
              ),
            );
          }
        }
      }
    }

    if (pages.isEmpty && pageUrls.isNotEmpty) {
      await processConvert();
      savePageUrls();
      final download = Download(
        id: chapter.id,
        succeeded: 0,
        failed: 0,
        total: 0,
        isDownload: true,
        isStartDownload: false,
      );

      isar.writeTxnSync(() {
        isar.downloads.putSync(download..chapter.value = chapter);
      });
    } else {
      savePageUrls();
      await MDownloader(
        chapter: chapter,
        pageUrls: pages,
        subtitles: subtitles,
        subDownloadDir: chapterDirectory.path,
      ).download((progress) {
        setProgress(progress);
      });
    }
  } else if (hasM3U8File) {
    await m3u8Downloader?.download((progress) {
      setProgress(progress);
    });
  }
  if (callback != null) {
    callback();
  }
}

@riverpod
Future<void> processDownloads(Ref ref, {bool? useWifi}) async {
  final ongoingDownloads = await isar.downloads
      .filter()
      .idIsNotNull()
      .isDownloadEqualTo(false)
      .isStartDownloadEqualTo(true)
      .findAll();
  final maxConcurrentDownloads = ref.read(concurrentDownloadsStateProvider);
  int index = 0;
  int downloaded = 0;
  int current = 0;
  await Future.doWhile(() async {
    await Future.delayed(const Duration(seconds: 1));
    if (ongoingDownloads.length == downloaded) {
      return false;
    }
    if (current < maxConcurrentDownloads) {
      current++;
      final downloadItem = ongoingDownloads[index++];
      final chapter = downloadItem.chapter.value!;
      chapter.cancelDownloads(downloadItem.id);
      ref.read(
        downloadChapterProvider(
          chapter: chapter,
          useWifi: useWifi,
          callback: () {
            downloaded++;
            current--;
          },
        ),
      );
    }
    return true;
  });
}
