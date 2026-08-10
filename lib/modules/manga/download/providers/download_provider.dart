import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/manga/download/providers/convert_to_cbz.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/modules/more/settings/general/providers/general_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/download_manager/download_queue_order.dart';
import 'package:mangayomi/services/download_manager/m_downloader.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/download_manager/m3u8/m3u8_downloader.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
  final keepAlive = ref.keepAlive();

  // Show the chapter as queued straight away, before it waits for a slot, so
  // the download icon reacts to the tap immediately even while it sits in the
  // gate behind other downloads.
  if (isar.downloads.getSync(chapter.id!) == null) {
    isar.writeTxnSync(() {
      isar.downloads.putSync(
        Download(
          id: chapter.id,
          succeeded: 0,
          failed: 0,
          total: 100,
          isDownload: false,
          isStartDownload: true,
        )..chapter.value = chapter,
      );
    });
  }

  // Every download path funnels through here, so acquiring the shared gate is
  // what makes the concurrency limit, per-source serialization (#645) and the
  // start delay/jitter (#621) apply no matter how the download was started.
  final sourceKey = _chapterSourceKey(chapter);
  final maxConcurrent = ref.read(allowConcurrentDownloadsStateProvider)
      ? ref.read(concurrentDownloadsStateProvider)
      : 1;
  final delaySeconds = ref.read(downloadDelaySecondsStateProvider);
  await _DownloadGate.instance.acquire(
    id: chapter.id!,
    sourceKey: sourceKey,
    maxConcurrent: maxConcurrent,
    delaySeconds: delaySeconds,
  );

  try {
    // Cancelled while it waited for a slot in the gate? Its record was deleted,
    // so don't resurrect it.
    if (_downloadCancelled(chapter)) {
      keepAlive.close();
      return;
    }
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
    PageUrl? novelPage;
    List<PageUrl> pages = [];
    final StorageProvider storageProvider = StorageProvider();
    await storageProvider.requestPermission();
    final mangaMainDirectory = await storageProvider.getMangaMainDirectory(
      chapter,
    );
    List<Track>? subtitles;
    bool isOk = false;
    // Reason the download couldn't be prepared, if any — used to fail loudly
    // instead of hanging in the wait-loop below.
    String? startFailure;
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
      "User-Agent": ref.read(userAgentStateProvider),
    };
    bool hasM3U8File = false;
    bool nonM3U8File = false;
    M3u8Downloader? m3u8Downloader;

    Future<void> processConvert() async {
      if (!ref.read(saveAsCBZArchiveStateProvider)) return;
      try {
        // Extract chapter number from name (e.g., "Chapter 5" → "5")
        final chapterNumber = ChapterRecognition().parseChapterNumber(
          chapter.manga.value!.name!,
          chapter.name!,
        );

        final comicInfo = ComicInfoData(
          title: chapter.name,
          series: manga.name,
          number: chapterNumber.toString(),
          writer: manga.author,
          penciller: manga.artist,
          summary: manga.description,
          genre: manga.genre?.join(', '),
          translator: chapter.scanlator,
          publishingStatusStr: manga.status.name,
        );

        await ref.read(
          convertToCBZProvider(
            chapterDirectory.path,
            mangaMainDirectory!.path,
            chapterName,
            pages.map((e) => e.fileName!).toList(),
            comicInfo: comicInfo,
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
      ref
          .read(getChapterPagesProvider(chapter: chapter).future)
          .then((value) {
            if (value.pageUrls.isNotEmpty) {
              pageUrls = value.pageUrls;
              isOk = true;
            } else {
              startFailure = "No pages returned by the source";
            }
          })
          .catchError((Object e) {
            startFailure = "Failed to load chapter pages: $e";
          });
    } else if (itemType == ItemType.anime) {
      ref
          .read(getVideoListProvider(episode: chapter).future)
          .then((value) async {
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
                  fileName: p.join(
                    mangaMainDirectory!.path,
                    "$chapterName.mp4",
                  ),
                  chapter: chapter,
                );
              } else {
                pageUrls = [PageUrl(videosUrls.first.url)];
              }
              videoHeader.addAll(videosUrls.first.headers ?? {});
              isOk = true;
            } else {
              // Got a video list but nothing matched .m3u8/.m3u or a known video
              // extension — record why instead of spinning forever below.
              startFailure = value.$1.isEmpty
                  ? "No videos returned by the source"
                  : "No downloadable URL among ${value.$1.length} video(s) "
                        "(none matched .m3u8/.m3u or a known extension)";
            }
          })
          .catchError((Object e) {
            startFailure = "Failed to load the video list: $e";
          });
    } else if (itemType == ItemType.novel && chapter.url != null) {
      final manga = chapter.manga.value!;
      final source = getSource(manga.lang!, manga.source!, manga.sourceId)!;
      final chapterUrl = "${source.baseUrl}${chapter.url!.getUrlWithoutDomain}";
      final cookie = MClient.getCookiesPref(chapterUrl);
      final headers = htmlHeader;
      if (cookie.isNotEmpty) {
        final userAgent = ref.read(userAgentStateProvider);
        headers.addAll(cookie);
        headers[HttpHeaders.userAgentHeader] = userAgent;
      }
      final res = await http.get(Uri.parse(chapterUrl), headers: headers);
      if (res.headers.containsKey("Location")) {
        novelPage = PageUrl(res.headers["Location"]!);
      } else {
        novelPage = PageUrl(chapterUrl);
      }
      isOk = true;
    }

    // Wait for the source to resolve pages/video — but never forever. Bail on
    // a recorded failure or after a timeout so a bad/unmatched URL surfaces an
    // error instead of a silent, endless stall.
    final startDeadline = DateTime.now().add(const Duration(seconds: 45));
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (isOk == true || startFailure != null) {
        return false;
      }
      if (DateTime.now().isAfter(startDeadline)) {
        startFailure = "Timed out preparing the download";
        return false;
      }
      return true;
    });

    if (!isOk) {
      botToast(startFailure ?? "Couldn't start the download");
      _markDownloadFailed(chapter);
      if (callback != null) callback();
      keepAlive.close();
      return;
    }

    // Cancelled during the (up to 45s) prep wait? Bail before writing files.
    if (_downloadCancelled(chapter)) {
      keepAlive.close();
      return;
    }

    if (pageUrls.isNotEmpty) {
      // A stalled or failed attempt can leave a partial single-file download
      // (anime .mp4, novel .html) on disk. The existence check below would then
      // treat it as already downloaded and mark it complete — a truncated but
      // "finished" file. If this chapter's download record is not actually
      // complete, delete any such leftover first so it re-downloads fresh.
      final downloadRecord = isar.downloads.getSync(chapter.id!);
      if (!(downloadRecord?.isDownload ?? false)) {
        for (final leftover in [
          File(p.join(mangaMainDirectory!.path, "$chapterName.mp4")),
          File(p.join(mangaMainDirectory.path, "$chapterName.html")),
        ]) {
          if (leftover.existsSync()) {
            try {
              leftover.deleteSync();
            } catch (_) {}
          }
        }
      }
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
            if (!(await File(
              p.join(mainDirectory.path, ".nomedia"),
            ).exists())) {
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
            final userAgent = ref.read(userAgentStateProvider);
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
                  page.url.trim(),
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
                  page.url.trim(),
                  headers: pageHeaders,
                  fileName: p.join(mangaMainDirectory.path, "$chapterName.mp4"),
                ),
              );
            }
          }
        }
      }

      if (pages.isEmpty && pageUrls.isNotEmpty) {
        await processConvert();
        savePageUrls();
        await setProgress(DownloadProgress(1, 1, itemType, isCompleted: true));
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
    } else if (itemType == ItemType.novel) {
      final file = File(p.join(chapterDirectory.path, "$chapterName.html"));
      if (!file.existsSync() && novelPage != null) {
        final source = getSource(manga.lang!, manga.source!, manga.sourceId)!;
        p.join(chapterDirectory.path, "$chapterName.html");
        final html = await withExtensionService(
          source,
          ref.read(androidProxyServerStateProvider),
          (service) =>
              service.getHtmlContent(chapter.manga.value!.name!, chapter.url!),
        );
        if (html.isNotEmpty) {
          await file.writeAsString(html);
          await setProgress(
            DownloadProgress(1, 1, itemType, isCompleted: true),
          );
        }
      } else {
        await setProgress(DownloadProgress(1, 1, itemType, isCompleted: true));
      }
    } else if (hasM3U8File) {
      await m3u8Downloader?.download((progress) {
        setProgress(progress);
      });
    }
    if (callback != null) {
      callback();
    }
    keepAlive.close();
  } catch (e) {
    // Surface the failure instead of swallowing it — a silent catch here is
    // exactly how "downloads just don't start" stays invisible.
    botToast("Download failed: $e");
    _markDownloadFailed(chapter);
    if (callback != null) callback();
    keepAlive.close();
  } finally {
    _DownloadGate.instance.release(sourceKey);
  }
}

/// Delay before releasing the next queued download from the gate. With rate
/// limiting off ([baseSeconds] 0) there is no artificial delay — the gate's
/// concurrency limit and per-source serialization already prevent hammering, so
/// downloads should start as soon as a slot is free. Otherwise it is the chosen
/// base plus 25% to 100% random jitter, spacing requests out and varying them so
/// a source is less likely to IP-block or wear a plugin out. See #621.
Duration _downloadStartDelay(int baseSeconds) {
  if (baseSeconds <= 0) return Duration.zero;
  final base = baseSeconds * 1000;
  final jitter = (base * (0.25 + Random().nextDouble() * 0.75)).round();
  return Duration(milliseconds: base + jitter);
}

/// Reset a failed/aborted download to a plain, tappable "not downloaded" state
/// so it shows a retry-able icon instead of a progress bar frozen at its last
/// value. Any partial file is cleaned up on the next attempt.
void _markDownloadFailed(Chapter chapter) {
  final record = isar.downloads.getSync(chapter.id!);
  if (record == null || (record.isDownload ?? false)) return;
  isar.writeTxnSync(() {
    isar.downloads.putSync(
      record
        ..isStartDownload = false
        ..succeeded = 0
        ..failed = 1,
    );
  });
}

/// True when a download was cancelled while it was queued. cancelDownloads
/// deletes the record, so a missing record for a chapter we were about to
/// download means "cancelled" — bail instead of resurrecting it. This matters
/// because every download is fired up front and then waits in the gate; a
/// cancel that lands while it waits must actually stop it.
bool _downloadCancelled(Chapter chapter) =>
    isar.downloads.getSync(chapter.id!) == null;

/// Key identifying the source a chapter belongs to, used to serialize
/// downloads from the same source. Falls back to a per-chapter unique key when
/// the source can't be resolved, so an unknown source never over-serializes.
String _chapterSourceKey(Chapter chapter) {
  if (!chapter.manga.isLoaded) {
    try {
      chapter.manga.loadSync();
    } catch (_) {}
  }
  final m = chapter.manga.value;
  if (m?.source == null) return 'chapter-${chapter.id}';
  return '${m!.source}|${m.lang}|${m.sourceId}';
}

/// A download waiting for a slot in [_DownloadGate]. [id] is the download's id
/// (== chapter id), used to honor the manual queue order.
class _GateWaiter {
  _GateWaiter(this.id, this.sourceKey, this.completer);
  final int id;
  final String sourceKey;
  final Completer<void> completer;
}

/// App-wide gate every download passes through before doing network work.
/// It bounds how many downloads run at once, keeps a single source strictly
/// serial (#645), spaces launches apart with a jittered delay (#621), and hands
/// out slots in the user's manual queue order (#514) — all independent of how
/// the download was triggered (per-chapter icon, "download all", or the queue
/// processor).
class _DownloadGate {
  _DownloadGate._();
  static final _DownloadGate instance = _DownloadGate._();

  int _active = 0;
  int _maxConcurrent = 1;
  int _delaySeconds = 0;
  final Set<String> _activeSources = <String>{};
  final List<_GateWaiter> _waiters = <_GateWaiter>[];

  Future<void> acquire({
    required int id,
    required String sourceKey,
    required int maxConcurrent,
    required int delaySeconds,
  }) {
    _maxConcurrent = maxConcurrent < 1 ? 1 : maxConcurrent;
    _delaySeconds = delaySeconds;
    final completer = Completer<void>();
    _waiters.add(_GateWaiter(id, sourceKey, completer));
    _dispatch();
    return completer.future;
  }

  void release(String sourceKey) {
    if (_active > 0) _active--;
    _activeSources.remove(sourceKey);
    _dispatch();
  }

  /// Reorder the waiting list by the user's saved manual order (#514), re-read
  /// each dispatch so dragging a chapter up takes effect on what's still
  /// waiting. Ids not in the saved order keep their current relative order,
  /// after the ranked ones, so a plain queue behaves exactly as before.
  void _reorderWaiters() {
    final order = DownloadQueueOrder.order;
    if (order.isEmpty || _waiters.length < 2) return;
    final rank = <int, int>{};
    for (var j = 0; j < order.length; j++) {
      rank[order[j]] = j;
    }
    final decorated = [
      for (var j = 0; j < _waiters.length; j++) (pos: j, w: _waiters[j]),
    ];
    decorated.sort((a, b) {
      final ra = rank[a.w.id] ?? (order.length + a.pos);
      final rb = rank[b.w.id] ?? (order.length + b.pos);
      return ra.compareTo(rb);
    });
    _waiters
      ..clear()
      ..addAll(decorated.map((e) => e.w));
  }

  void _dispatch() {
    // Only worth reordering when a slot is actually free to grant; skipping it
    // when full keeps a big "download all" burst from doing O(n^2) sorting.
    if (_active < _maxConcurrent) _reorderWaiters();
    var i = 0;
    while (i < _waiters.length && _active < _maxConcurrent) {
      final waiter = _waiters[i];
      // Source already downloading — leave this one queued, try the next.
      if (_activeSources.contains(waiter.sourceKey)) {
        i++;
        continue;
      }
      _waiters.removeAt(i);
      _active++;
      _activeSources.add(waiter.sourceKey);
      // Reserve the slot now but only release the waiter after the start delay,
      // so launches stay spaced out instead of bursting.
      Future.delayed(_downloadStartDelay(_delaySeconds), () {
        if (!waiter.completer.isCompleted) waiter.completer.complete();
      });
    }
  }
}

@riverpod
Future<void> processDownloads(Ref ref, {bool? useWifi}) async {
  final keepAlive = ref.keepAlive();
  try {
    // Fire in the user's manual queue order (#514) so the initial slots go to
    // the highest-priority chapters; the gate then keeps honoring live reorders
    // as later slots free.
    final ongoingDownloads = DownloadQueueOrder.sorted(
      await isar.downloads
          .filter()
          .idIsNotNull()
          .isDownloadEqualTo(false)
          .isStartDownloadEqualTo(true)
          .findAll(),
    );
    // Kick off every pending download. The shared _DownloadGate enforces the
    // concurrency limit, per-source serialization (#645), the start delay
    // (#621) and the manual order (#514), so they can all be fired at once and
    // will queue themselves instead of being paced here (which used to block on
    // the main isolate).
    for (final downloadItem in ongoingDownloads) {
      if (!downloadItem.chapter.isLoaded) {
        try {
          downloadItem.chapter.loadSync();
        } catch (_) {}
      }
      final chapter = downloadItem.chapter.value;
      if (chapter == null) continue;
      chapter.cancelDownloads(downloadItem.id);
      ref.read(downloadChapterProvider(chapter: chapter, useWifi: useWifi));
    }
  } catch (_) {
  } finally {
    keepAlive.close();
  }
}
