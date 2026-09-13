// Client for the sync-server's `/api/sync/v1` protocol. See
// docs/sync_api.md in the sync-server repo for the wire contract this
// implements: one combined endpoint, incremental (only what changed since
// `since`), newest-write-wins per row by `updatedAt`, deletions sent as an
// explicit list rather than inferred from what's missing from a response.
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_progress_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/client_id.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
part 'sync_server.g.dart';

/// The highest protocol version this build speaks. Sent nowhere - the server
/// advertises what it supports via GET /api/version and this is just checked
/// against that list.
const _supportedProtocolVersion = '1';

/// Matches the server's SYNC.maxRowsPerEntity. A changed-row batch larger
/// than this for one entity is split across more than one request rather
/// than sent in one oversized body.
const _maxRowsPerEntity = 5000;

/// Local reader-only settings that make no sense on another device (paths,
/// device-specific proxy/JRE locations). Stripped before upload, and
/// preserved (not overwritten) when applying a pulled settings blob.
const _deviceLocalSettingsKeys = {
  'localFolders',
  'namedLocalFolders',
  'downloadLocalFolderName',
  'askDownloadDestination',
  'androidProxyServer',
  'jrePath',
  'extensionServerPath',
};

// Loopback port for the desktop OAuth callback. Only the protocol+hostname of
// a redirect_uri are checked server-side (see isAllowedRedirectUri in the
// sync-server repo), not the port, so this can be anything not already in use.
const _desktopOAuthCallbackPort = 48765;

@riverpod
class SyncServer extends _$SyncServer {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});

  @override
  void build({required int syncId}) {
    ref.keepAlive();
  }

  // ------------------------------------------------------------------
  // Login. OAuth (PKCE) only - the server's own authorize/token endpoints,
  // opened in the system browser. There is no password form: this app talks
  // to exactly one server it's paired with, not a third-party OAuth
  // provider, so the browser round trip is purely local - it's whichever
  // session is already logged into that server's website.
  // ------------------------------------------------------------------

  Future<(bool, String)> login(AppLocalizations l10n, String server) async {
    server = _normalizeServer(server);
    try {
      final verifier = _generatePkceVerifier();
      final challenge = _codeChallengeFromVerifier(verifier);
      final state = _generatePkceVerifier();
      final redirectUri = isDesktop
          ? 'http://localhost:$_desktopOAuthCallbackPort/callback'
          : 'mangayomi://oauth-callback';
      final callbackUrlScheme = isDesktop
          ? 'http://localhost:$_desktopOAuthCallbackPort'
          : 'mangayomi';

      final authorizeUrl = Uri.parse('$server/api/oauth/authorize').replace(
        queryParameters: {
          'redirect_uri': redirectUri,
          'code_challenge': challenge,
          'code_challenge_method': 'S256',
          'state': state,
        },
      );

      final resultUrl = await FlutterWebAuth2.authenticate(
        url: authorizeUrl.toString(),
        callbackUrlScheme: callbackUrlScheme,
      );
      final resultParams = Uri.parse(resultUrl).queryParameters;
      final code = resultParams['code'];
      // Confirms this callback answers the authorize call this same login()
      // just made, not a stray/replayed one.
      if (code == null || resultParams['state'] != state) {
        return (false, "Auth failed");
      }

      final tokenResponse = await http.post(
        Uri.parse('$server/api/oauth/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'codeVerifier': verifier,
          'redirectUri': redirectUri,
        }),
      );
      if (tokenResponse.statusCode != 200) {
        return (false, "Auth failed");
      }
      final body = jsonDecode(tokenResponse.body) as Map<String, dynamic>;
      final accessToken = body['access_token'] as String?;
      final username = body['username'] as String?;
      if (accessToken == null || username == null) {
        return (false, "Auth failed");
      }

      ref
          .read(synchingProvider(syncId: syncId).notifier)
          .login(server, username, accessToken);
      botToast(l10n.sync_logged);
      return (true, "");
    } catch (e) {
      return (false, e.toString());
    }
  }

  String _normalizePkceSegment(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');

  String _generatePkceVerifier() {
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    return _normalizePkceSegment(bytes);
  }

  // Must match the server's challengeFromVerifier (lib/auth/oauth.ts):
  // SHA-256 of the verifier, base64url, unpadded.
  String _codeChallengeFromVerifier(String verifier) =>
      _normalizePkceSegment(sha256.convert(utf8.encode(verifier)).bytes);

  String _normalizeServer(String server) =>
      server.isNotEmpty && server[server.length - 1] == '/'
      ? server.substring(0, server.length - 1)
      : server;

  // ------------------------------------------------------------------
  // Public entry point
  // ------------------------------------------------------------------

  Future<bool> startSync(
    AppLocalizations l10n,
    bool silent, {
    bool upload = false,
    bool download = false,
    bool bypassRestoreGuard = false,
  }) async {
    // A restore in progress owns the sync server state until its own
    // post-restore upload runs (that call passes bypassRestoreGuard: true).
    // Anything else - the periodic timer or a manual trigger - must wait,
    // otherwise it could race the restore and pull stale data back down.
    if (!bypassRestoreGuard && ref.read(restoreSyncGuardProvider)) {
      if (!silent) {
        botToast(l10n.sync_restore_in_progress, second: 3);
      }
      return false;
    }
    if (!silent) {
      botToast(l10n.sync_starting, second: 500);
    }
    final progress = ref.read(syncProgressProvider(syncId: syncId).notifier);
    progress.begin();
    try {
      if (!await _checkVersion()) {
        botToast(l10n.sync_failed, second: 5);
        return false;
      }
      // Cheap safety net: covers a row created earlier in this same running
      // session, which the once-at-launch sweep in main.dart couldn't have
      // seen yet. See lib/utils/client_id.dart.
      await backfillMissingClientIds();

      final notifier = ref.read(synchingProvider(syncId: syncId).notifier);
      final ok = upload
          ? await _forceUpload(notifier)
          : download
          ? await _fullDownload(notifier)
          : await _incrementalSync(notifier);

      if (!ok) {
        botToast(l10n.sync_failed, second: 5);
        return false;
      }
      ref.invalidate(synchingProvider(syncId: syncId));
      if (!silent) {
        botToast(l10n.sync_finished, second: 2);
      }
      return true;
    } catch (error) {
      botToast(error.toString(), second: 5);
      return false;
    } finally {
      progress.finish();
    }
  }

  Future<bool> _checkVersion() async {
    try {
      final response = await http
          .get(Uri.parse('${_getServer()}/api/version'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return false;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final supported = (body['supported'] as List?)?.cast<String>() ?? [];
      return supported.contains(_supportedProtocolVersion);
    } catch (_) {
      return false;
    }
  }

  // ------------------------------------------------------------------
  // Incremental sync: the normal path. One request handles every entity at
  // once; a request pages on its own (via cursors/sessionToken/hasMore)
  // until every entity has fully caught up, then saves the new `since`.
  // ------------------------------------------------------------------

  Future<bool> _incrementalSync(Synching notifier) async {
    final prefs = ref.read(synchingProvider(syncId: syncId));
    final since = prefs.since ?? 0;
    final changed = _ChangedRows.collect(prefs, notifier);
    final chunks = changed.chunked(_maxRowsPerEntity);
    final progress = ref.read(syncProgressProvider(syncId: syncId).notifier);
    progress.addTotal(chunks.length);

    Map<String, String?>? cursors;
    String? sessionToken;
    var chunkIndex = 0;

    while (true) {
      final hasChunk = chunkIndex < chunks.length;
      final body = <String, dynamic>{
        'since': since,
        'sessionToken': ?sessionToken,
        'cursors': ?cursors,
        if (hasChunk) ...chunks[chunkIndex],
      };
      if (hasChunk) chunkIndex += 1;

      final response = await _postSync(body);
      if (response == null) return false;
      if (hasChunk) progress.addDone(1);
      _trackDownloadProgress(progress, response);

      await _applyPulledEntities(response);
      sessionToken = response['sessionToken'] as String?;
      cursors = _decodeCursors(response['cursors']);
      final hasMore = response['hasMore'] == true;

      if (chunkIndex >= chunks.length && !hasMore) {
        final syncedAt = response['syncedAt'] as int?;
        if (syncedAt != null) {
          notifier.setSince(syncedAt);
          notifier.setLastSync(DateTime.now().millisecondsSinceEpoch);
          await changed.clearUploaded(notifier);
        }
        return true;
      }
    }
  }

  // Adds this response's contribution to the progress bar using docs/sync_api.md's totalCounts and per-page row counts.
  void _trackDownloadProgress(
    SyncProgress progress,
    Map<String, dynamic> response,
  ) {
    final totalCounts = response['totalCounts'] as Map?;
    if (totalCounts != null) {
      final sum = totalCounts.values.fold<int>(
        0,
        (a, b) => a + (b as int),
      );
      progress.addTotal(sum);
    }
    const pagedKeys = [
      'categories',
      'manga',
      'chapters',
      'tracks',
      'histories',
      'updates',
    ];
    final pageRows = pagedKeys.fold<int>(
      0,
      (a, key) => a + ((response[key] as List?)?.length ?? 0),
    );
    progress.addDone(pageRows);
  }

  // ------------------------------------------------------------------
  // "Upload only": local data should win. Every local row is sent, with its
  // wire `updatedAt` forced to now so it beats whatever the server holds,
  // batched like a normal upload. Deliberately does NOT delete anything on
  // the server that only exists there - diffing local against remote and
  // auto-deleting the difference would turn a client-side bug (or a fresh,
  // still-empty install) into a silent wipe of another device's data. This
  // narrows what the button promises versus the old server's full replace,
  // traded for not being a one-click way to destroy real data by accident.
  // ------------------------------------------------------------------

  Future<bool> _forceUpload(Synching notifier) async {
    final prefs = ref.read(synchingProvider(syncId: syncId));
    final since = prefs.since ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final changed = _ChangedRows.collectAll(forcedUpdatedAt: now);
    final chunks = changed.chunked(_maxRowsPerEntity);
    final progress = ref.read(syncProgressProvider(syncId: syncId).notifier);
    progress.addTotal(chunks.length);

    Map<String, String?>? cursors;
    String? sessionToken;
    var chunkIndex = 0;

    while (true) {
      final hasChunk = chunkIndex < chunks.length;
      final body = <String, dynamic>{
        'since': since,
        'sessionToken': ?sessionToken,
        'cursors': ?cursors,
        if (hasChunk) ...chunks[chunkIndex],
      };
      if (hasChunk) chunkIndex += 1;

      final response = await _postSync(body);
      if (response == null) return false;
      if (hasChunk) progress.addDone(1);
      _trackDownloadProgress(progress, response);

      await _applyPulledEntities(response);
      sessionToken = response['sessionToken'] as String?;
      cursors = _decodeCursors(response['cursors']);
      final hasMore = response['hasMore'] == true;

      if (chunkIndex >= chunks.length && !hasMore) {
        final syncedAt = response['syncedAt'] as int?;
        if (syncedAt != null) {
          notifier.setSince(syncedAt);
          notifier.setLastSync(DateTime.now().millisecondsSinceEpoch);
          await changed.clearUploaded(notifier);
        }
        return true;
      }
    }
  }

  // ------------------------------------------------------------------
  // "Download only": pull everything the server has, merged in via the
  // normal newest-wins upsert rule (purely additive, never deletes). Same
  // reasoning as _forceUpload for why this isn't a literal mirror: wiping
  // local rows the server doesn't happen to know about is a real way to
  // lose data over one dropped page or a server-side gap, for no upside
  // over just leaving them alone.
  // ------------------------------------------------------------------

  Future<bool> _fullDownload(Synching notifier) async {
    const since = 0;
    Map<String, String?>? cursors;
    String? sessionToken;
    final progress = ref.read(syncProgressProvider(syncId: syncId).notifier);

    while (true) {
      final body = <String, dynamic>{
        'since': since,
        'sessionToken': ?sessionToken,
        'cursors': ?cursors,
      };
      final response = await _postSync(body);
      if (response == null) return false;
      _trackDownloadProgress(progress, response);

      await _applyPulledEntities(response);
      sessionToken = response['sessionToken'] as String?;
      cursors = _decodeCursors(response['cursors']);
      final hasMore = response['hasMore'] == true;

      if (!hasMore) {
        final syncedAt = response['syncedAt'] as int?;
        if (syncedAt != null) {
          notifier.setSince(syncedAt);
          notifier.setLastSync(DateTime.now().millisecondsSinceEpoch);
        }
        return true;
      }
    }
  }

  // ------------------------------------------------------------------
  // Wire transport
  // ------------------------------------------------------------------

  Future<Map<String, dynamic>?> _postSync(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('${_getServer()}/api/sync/v1'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'id=${_getAccessToken()}',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) return null;
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Map<String, String?>? _decodeCursors(Object? raw) {
    if (raw is! Map) return null;
    return raw.map((key, value) => MapEntry(key as String, value as String?));
  }

  String _getAccessToken() {
    final syncPrefs = ref.watch(synchingProvider(syncId: syncId));
    return syncPrefs.authToken ?? "";
  }

  String _getServer() {
    final syncPrefs = ref.watch(synchingProvider(syncId: syncId));
    return syncPrefs.server ?? "";
  }

  // ------------------------------------------------------------------
  // Applying a response's pulled entities to local storage. Additive only:
  // a row absent from a page never means "delete this", only `tombstones`
  // does. Order matters - categories before manga (manga's category links
  // reference them), manga before chapters/tracks/histories/updates
  // (they all reference a manga by clientId).
  // ------------------------------------------------------------------

  // Isar requires every write - even a single put() - to run inside an
  // explicit transaction; it does not open one on its own the way some other
  // embedded databases do. Kept fully synchronous (writeTxnSync + putSync/
  // deleteSync throughout, no await anywhere in the callback) rather than
  // async writeTxn: a sync transaction is one uninterrupted call with no
  // event-loop turn in the middle, so there's no window for it to overlap
  // with anything else. One page's whole apply is one transaction, not one
  // per row, so a page of a few thousand rows doesn't cost a few thousand
  // separate commits. Routed through dbWriteQueue like every other write
  // path in the app, so it still queues behind other writes instead of
  // colliding with them.
  Future<void> _applyPulledEntities(Map<String, dynamic> response) async {
    await dbWriteQueue.run(() {
      isar.writeTxnSync(() {
        final remaps = _MangaChapterRemaps(
          manga: (response['mangaClientIdRemap'] as Map?)?.map(
            (k, v) => MapEntry(int.parse(k as String), v as int),
          ),
          chapter: (response['chapterClientIdRemap'] as Map?)?.map(
            (k, v) => MapEntry(int.parse(k as String), v as int),
          ),
        );
        if (remaps.manga != null) _applyMangaRemap(remaps.manga!);
        if (remaps.chapter != null) _applyChapterRemap(remaps.chapter!);

        for (final row in (response['categories'] as List? ?? [])) {
          _applyCategory(row as Map<String, dynamic>);
        }
        for (final row in (response['manga'] as List? ?? [])) {
          _applyManga(row as Map<String, dynamic>);
        }
        for (final row in (response['chapters'] as List? ?? [])) {
          _applyChapter(row as Map<String, dynamic>);
        }
        for (final row in (response['tracks'] as List? ?? [])) {
          _applyTrack(row as Map<String, dynamic>);
        }
        for (final row in (response['histories'] as List? ?? [])) {
          _applyHistory(row as Map<String, dynamic>);
        }
        for (final row in (response['updates'] as List? ?? [])) {
          _applyUpdate(row as Map<String, dynamic>);
        }
        if (response['settings'] != null) {
          _applySettings(response['settings'] as Map<String, dynamic>);
        }

        final tombstones = response['tombstones'] as Map<String, dynamic>?;
        if (tombstones != null) _applyTombstones(tombstones);
      });
    });
  }

  // A manga upload matched a title another device already established under
  // a different clientId. Adopt the server's canonical id locally so this
  // device stops uploading it as a new duplicate every sync from now on.
  void _applyMangaRemap(Map<int, int> remap) {
    for (final entry in remap.entries) {
      final manga = mangaRepository.getByClientId(entry.key);
      if (manga != null) {
        manga.clientId = entry.value;
        mangaRepository.putSync(manga);
      }
    }
  }

  void _applyChapterRemap(Map<int, int> remap) {
    for (final entry in remap.entries) {
      final chapter = chapterRepository.getByClientId(entry.key);
      if (chapter != null) {
        chapter.clientId = entry.value;
        chapterRepository.putSync(chapter);
      }
    }
  }

  void _applyCategory(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final existing = categoryRepository.getByClientId(wire['clientId'] as int);
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;
    final category =
        existing ?? Category(name: '', forItemType: ItemType.manga);
    category
      ..clientId = wire['clientId'] as int
      ..name = wire['name'] as String
      ..forItemType = _itemTypeFromWire(wire['forItemType'] as String)
      ..pos = wire['pos'] as int?
      ..hide = wire['hide'] as bool?
      ..shouldUpdate = wire['shouldUpdate'] as bool?
      ..updatedAt = incoming;
    categoryRepository.putSync(category);
  }

  void _applyManga(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    var existing = mangaRepository.getByClientId(clientId);
    // Not known by clientId yet: this device may have added the same title
    // on its own before ever syncing. Fall back to a natural-key match so it
    // adopts that row instead of creating a duplicate.
    existing ??= mangaRepository.findByLinkAndItemType(
      (wire['link'] as String?) ?? '',
      _itemTypeFromWire(wire['itemType'] as String),
    );
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final categoryClientIds = (wire['categoryClientIds'] as List?)?.cast<int>();
    final localCategoryIds = categoryClientIds
        ?.map((id) => categoryRepository.getByClientId(id)?.id)
        .nonNulls
        .toList();

    final manga =
        existing ??
        Manga(
          source: null,
          author: null,
          artist: null,
          genre: null,
          imageUrl: null,
          lang: null,
          link: null,
          name: null,
          status: Status.unknown,
          description: null,
          sourceId: null,
        );
    manga
      ..clientId = clientId
      ..source = wire['source'] as String?
      ..sourceId = wire['sourceId'] as int?
      ..link = wire['link'] as String?
      ..itemType = _itemTypeFromWire(wire['itemType'] as String)
      ..name = wire['name'] as String?
      ..imageUrl = wire['imageUrl'] as String?
      ..description = wire['description'] as String?
      ..author = wire['author'] as String?
      ..artist = wire['artist'] as String?
      ..status = _statusFromWire(wire['status'] as String?)
      ..genre = (wire['genre'] as List?)?.cast<String>()
      ..lang = wire['lang'] as String?
      ..lastUpdate = wire['lastUpdate'] as int?
      ..favorite = wire['favorite'] as bool?
      ..dateAdded = wire['dateAdded'] as int?
      ..lastRead = wire['lastRead'] as int?
      ..isLocalArchive = wire['isLocalArchive'] as bool?
      ..customCoverFromTracker = wire['customCoverFromTracker'] as String?
      ..smartUpdateDays = wire['smartUpdateDays'] as int?
      ..updatedAt = incoming;
    if (localCategoryIds != null) manga.categories = localCategoryIds;
    mangaRepository.putSync(manga);
  }

  void _applyChapter(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    final mangaLocal = mangaRepository.getByClientId(
      wire['mangaClientId'] as int,
    );
    if (mangaLocal == null) return; // orphaned reference, nothing to attach to

    var existing = chapterRepository.getByClientId(clientId);
    existing ??= chapterRepository.findByUrlAndMangaId(
      (wire['url'] as String?) ?? '',
      mangaLocal.id!,
    );
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final chapter =
        existing ??
        Chapter(mangaId: mangaLocal.id, name: wire['name'] as String?);
    chapter
      ..clientId = clientId
      ..mangaId = mangaLocal.id
      ..name = wire['name'] as String?
      ..url = wire['url'] as String?
      ..scanlator = wire['scanlator'] as String?
      ..dateUpload = (wire['dateUpload'] as int?)?.toString() ?? ''
      ..isFiller = wire['isFiller'] as bool?
      ..thumbnailUrl = wire['thumbnailUrl'] as String?
      ..description = wire['description'] as String?
      ..downloadSize = (wire['downloadSize'] as int?)?.toString()
      ..duration = (wire['duration'] as int?)?.toString()
      ..isRead = wire['isRead'] as bool?
      ..isBookmarked = wire['isBookmarked'] as bool?
      ..lastPageRead = wire['lastPageRead'] as String?
      ..manga.value = mangaLocal
      ..updatedAt = incoming;
    chapterRepository.putSync(chapter);
    chapter.manga.saveSync();
  }

  void _applyTrack(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    final mangaLocal = mangaRepository.getByClientId(
      wire['mangaClientId'] as int,
    );
    if (mangaLocal == null) return;

    var existing = trackRepository.getByClientId(clientId);
    existing ??= trackRepository.findBySyncIdAndMangaId(
      wire['syncId'] as int?,
      mangaLocal.id,
    );
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final track =
        existing ??
        Track(status: _trackStatusFromWire(wire['status'] as String?));
    track
      ..clientId = clientId
      ..mangaId = mangaLocal.id
      ..syncId = wire['syncId'] as int?
      ..mediaId = wire['mediaId'] as int?
      ..libraryId = wire['libraryId'] as int?
      ..title = wire['title'] as String?
      ..lastChapterRead = wire['lastChapterRead'] as int?
      ..totalChapter = wire['totalChapter'] as int?
      ..score = wire['score'] as int?
      ..status = _trackStatusFromWire(wire['status'] as String?)
      ..startedReadingDate = wire['startedReadingDate'] as int?
      ..finishedReadingDate = wire['finishedReadingDate'] as int?
      ..trackingUrl = wire['trackingUrl'] as String?
      ..itemType = _itemTypeFromWire(wire['itemType'] as String)
      ..updatedAt = incoming;
    isar.tracks.putSync(track);
  }

  void _applyHistory(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    final mangaLocal = mangaRepository.getByClientId(
      wire['mangaClientId'] as int,
    );
    final chapterLocal = chapterRepository.getByClientId(
      wire['chapterClientId'] as int,
    );
    if (mangaLocal == null || chapterLocal == null) return;

    var existing = historyRepository.getByClientId(clientId);
    existing ??= historyRepository.findByChapterId(chapterLocal.id);
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final history =
        existing ??
        History(
          itemType: _itemTypeFromWire(wire['itemType'] as String),
          chapterId: chapterLocal.id,
          mangaId: mangaLocal.id,
          date: null,
        );
    history
      ..clientId = clientId
      ..mangaId = mangaLocal.id
      ..chapterId = chapterLocal.id
      ..itemType = _itemTypeFromWire(wire['itemType'] as String)
      ..date = (wire['date'] as int?)?.toString() ?? ''
      ..readingTimeSeconds = wire['readingTimeSeconds'] as int?
      ..chapter.value = chapterLocal
      ..updatedAt = incoming;
    historyRepository.putSync(history);
    history.chapter.saveSync();
  }

  void _applyUpdate(Map<String, dynamic> wire) {
    final incoming = wire['updatedAt'] as int;
    final clientId = wire['clientId'] as int;
    final mangaLocal = mangaRepository.getByClientId(
      wire['mangaClientId'] as int,
    );
    if (mangaLocal == null) return;

    var existing = updateRepository.getByClientId(clientId);
    existing ??= updateRepository.findByMangaIdAndChapterName(
      mangaLocal.id,
      wire['chapterName'] as String?,
    );
    if (existing != null && (existing.updatedAt ?? 0) >= incoming) return;

    final update =
        existing ??
        Update(
          mangaId: mangaLocal.id,
          chapterName: wire['chapterName'] as String?,
          date: null,
        );
    update
      ..clientId = clientId
      ..mangaId = mangaLocal.id
      ..chapterName = wire['chapterName'] as String?
      ..date = (wire['date'] as int?)?.toString() ?? ''
      ..updatedAt = incoming;
    final chapterLocal = chapterRepository.findByUrlAndMangaId(
      '',
      mangaLocal.id!,
    );
    if (chapterLocal == null) {
      updateRepository.putSync(update);
    } else {
      updateRepository.putSync(update..chapter.value = chapterLocal);
      update.chapter.saveSync();
    }
  }

  void _applySettings(Map<String, dynamic> wire) {
    final incomingUpdatedAt = wire['updatedAt'] as int;
    final oldSettings = settingsRepository.current;
    if ((oldSettings.updatedAt ?? 0) >= incomingUpdatedAt) return;
    final data = Map<String, dynamic>.from(wire['data'] as Map);
    data['updatedAt'] = incomingUpdatedAt;
    final settings = Settings.fromJson(data);
    settingsRepository.putSync(
      _preserveDeviceLocalSettings(settings, oldSettings)
        ..cookiesList = oldSettings.cookiesList,
    );
    ref.invalidate(followSystemThemeStateProvider);
    ref.invalidate(themeModeStateProvider);
    ref.invalidate(blendLevelStateProvider);
    ref.invalidate(flexSchemeColorStateProvider);
    ref.invalidate(pureBlackDarkModeStateProvider);
    ref.invalidate(l10nLocaleStateProvider);
    ref.invalidate(extensionsRepoStateProvider(ItemType.manga));
    ref.invalidate(extensionsRepoStateProvider(ItemType.anime));
    ref.invalidate(extensionsRepoStateProvider(ItemType.novel));
  }

  // Deleted on the server by another device (or an admin). Deletes the same
  // row locally too, straight through the collection - no need to record
  // this back into ChangedPart, it's not this device's outgoing change.
  void _applyTombstones(Map<String, dynamic> tombstones) {
    for (final clientId in (tombstones['categories'] as List? ?? [])) {
      final row = categoryRepository.getByClientId(clientId as int);
      if (row != null) isar.categorys.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['manga'] as List? ?? [])) {
      final row = mangaRepository.getByClientId(clientId as int);
      if (row != null) isar.mangas.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['chapters'] as List? ?? [])) {
      final row = chapterRepository.getByClientId(clientId as int);
      if (row != null) isar.chapters.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['tracks'] as List? ?? [])) {
      final row = trackRepository.getByClientId(clientId as int);
      if (row != null) isar.tracks.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['histories'] as List? ?? [])) {
      final row = historyRepository.getByClientId(clientId as int);
      if (row != null) isar.historys.deleteSync(row.id!);
    }
    for (final clientId in (tombstones['updates'] as List? ?? [])) {
      final row = updateRepository.getByClientId(clientId as int);
      if (row != null) isar.updates.deleteSync(row.id!);
    }
  }
}

class _MangaChapterRemaps {
  final Map<int, int>? manga;
  final Map<int, int>? chapter;
  _MangaChapterRemaps({this.manga, this.chapter});
}

// Positionally aligned with the server's zod enums (see lib/validation/sync.ts),
// so the index each Dart enum already carries doubles as the lookup key.
const _wireItemTypes = ['MANGA', 'ANIME', 'NOVEL'];
const _wireStatuses = [
  'ONGOING',
  'COMPLETED',
  'CANCELED',
  'UNKNOWN',
  'ON_HIATUS',
  'PUBLISHING_FINISHED',
];
const _wireTrackStatuses = [
  'READING',
  'COMPLETED',
  'ON_HOLD',
  'DROPPED',
  'PLAN_TO_READ',
  'RE_READING',
  'WATCHING',
  'PLAN_TO_WATCH',
  'RE_WATCHING',
];

ItemType _itemTypeFromWire(String value) =>
    ItemType.values[_wireItemTypes.indexOf(value)];
Status _statusFromWire(String? value) => value == null
    ? Status.unknown
    : Status.values[_wireStatuses.indexOf(value)];
TrackStatus _trackStatusFromWire(String? value) => value == null
    ? TrackStatus.reading
    : TrackStatus.values[_wireTrackStatuses.indexOf(value)];

Settings _preserveDeviceLocalSettings(Settings incoming, Settings current) {
  return incoming
    ..id = current.id
    ..localFolders = current.localFolders
    ..namedLocalFolders = current.namedLocalFolders
    ..downloadLocalFolderName = current.downloadLocalFolderName
    ..askDownloadDestination = current.askDownloadDestination
    ..androidProxyServer = current.androidProxyServer
    ..jrePath = current.jrePath
    ..extensionServerPath = current.extensionServerPath;
}

// ------------------------------------------------------------------
// Local -> wire. The mirror of the SyncServer._applyX methods above.
// ------------------------------------------------------------------

Map<String, dynamic> _categoryToWire(Category c) => {
  'clientId': c.clientId,
  'name': c.name,
  'forItemType': _wireItemTypes[c.forItemType.index],
  'pos': c.pos,
  'hide': c.hide ?? false,
  'shouldUpdate': c.shouldUpdate ?? true,
  'updatedAt': c.updatedAt ?? 0,
};

// Returns null when the row can't be represented on the wire (no clientId
// yet - shouldn't happen once backfill has run, but skip rather than crash
// if it somehow does).
Map<String, dynamic>? _mangaToWire(Manga m, {int? forcedUpdatedAt}) {
  if (m.clientId == null) return null;
  return {
    'clientId': m.clientId,
    'source': m.source,
    'sourceId': m.sourceId,
    'link': m.link,
    'itemType': _wireItemTypes[m.itemType.index],
    'name': m.name,
    'imageUrl': m.imageUrl,
    'description': m.description,
    'author': m.author,
    'artist': m.artist,
    'status': _wireStatuses[m.status.index],
    'genre': m.genre ?? [],
    'lang': m.lang,
    'lastUpdate': m.lastUpdate,
    'favorite': m.favorite ?? false,
    'dateAdded': m.dateAdded,
    'lastRead': m.lastRead,
    'isLocalArchive': m.isLocalArchive ?? false,
    'customCoverFromTracker': m.customCoverFromTracker,
    'smartUpdateDays': m.smartUpdateDays,
    'categoryClientIds': (m.categories ?? [])
        .map((id) => isar.categorys.getSync(id)?.clientId)
        .nonNulls
        .toList(),
    'updatedAt': forcedUpdatedAt ?? m.updatedAt ?? 0,
  };
}

Map<String, dynamic>? _chapterToWire(Chapter c, {int? forcedUpdatedAt}) {
  final mangaClientId = c.mangaId == null
      ? null
      : mangaRepository.findById(c.mangaId!)?.clientId;
  if (c.clientId == null || mangaClientId == null) return null;
  return {
    'clientId': c.clientId,
    'mangaClientId': mangaClientId,
    'name': c.name,
    'url': c.url,
    'scanlator': c.scanlator,
    'dateUpload': int.tryParse(c.dateUpload ?? ''),
    'isFiller': c.isFiller ?? false,
    'thumbnailUrl': c.thumbnailUrl,
    'description': c.description,
    'downloadSize': int.tryParse(c.downloadSize ?? ''),
    'duration': int.tryParse(c.duration ?? ''),
    'isRead': c.isRead ?? false,
    'isBookmarked': c.isBookmarked ?? false,
    'lastPageRead': c.lastPageRead,
    'updatedAt': forcedUpdatedAt ?? c.updatedAt ?? 0,
  };
}

Map<String, dynamic>? _trackToWire(Track t, {int? forcedUpdatedAt}) {
  final mangaClientId = t.mangaId == null
      ? null
      : mangaRepository.findById(t.mangaId!)?.clientId;
  if (t.clientId == null || mangaClientId == null) return null;
  return {
    'clientId': t.clientId,
    'mangaClientId': mangaClientId,
    'syncId': t.syncId,
    'mediaId': t.mediaId,
    'libraryId': t.libraryId,
    'title': t.title,
    'lastChapterRead': t.lastChapterRead,
    'totalChapter': t.totalChapter,
    'score': t.score,
    'status': _wireTrackStatuses[t.status.index],
    'startedReadingDate': t.startedReadingDate,
    'finishedReadingDate': t.finishedReadingDate,
    'trackingUrl': t.trackingUrl,
    'itemType': _wireItemTypes[t.itemType.index],
    'updatedAt': forcedUpdatedAt ?? t.updatedAt ?? 0,
  };
}

Map<String, dynamic>? _historyToWire(History h, {int? forcedUpdatedAt}) {
  final mangaClientId = h.mangaId == null
      ? null
      : mangaRepository.findById(h.mangaId!)?.clientId;
  final chapterClientId = h.chapterId == null
      ? null
      : chapterRepository.getByClientId(h.chapterId!)?.clientId ??
            _chapterClientIdByLocalId(h.chapterId!);
  if (h.clientId == null || mangaClientId == null || chapterClientId == null) {
    return null;
  }
  return {
    'clientId': h.clientId,
    'mangaClientId': mangaClientId,
    'chapterClientId': chapterClientId,
    'itemType': _wireItemTypes[h.itemType.index],
    'date': int.tryParse(h.date ?? ''),
    'readingTimeSeconds': h.readingTimeSeconds ?? 0,
    'updatedAt': forcedUpdatedAt ?? h.updatedAt ?? 0,
  };
}

Map<String, dynamic>? _updateToWire(Update u, {int? forcedUpdatedAt}) {
  final mangaClientId = u.mangaId == null
      ? null
      : mangaRepository.findById(u.mangaId!)?.clientId;
  if (u.clientId == null || mangaClientId == null) return null;
  return {
    'clientId': u.clientId,
    'mangaClientId': mangaClientId,
    'chapterName': u.chapterName,
    'date': int.tryParse(u.date ?? ''),
    'updatedAt': forcedUpdatedAt ?? u.updatedAt ?? 0,
  };
}

// getByClientId also falls back to matching on the local id (see the
// repositories), so a plain local-id lookup is the same query by another
// name - kept as its own function just for a clearer call site above.
int? _chapterClientIdByLocalId(int localId) =>
    chapterRepository.getByClientId(localId)?.clientId;

// ------------------------------------------------------------------
// Gathering local changes for an upload, and clearing them once a sync
// confirms they were applied.
// ------------------------------------------------------------------

class _ChangedRows {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> manga;
  final List<Map<String, dynamic>> chapters;
  final List<Map<String, dynamic>> tracks;
  final List<Map<String, dynamic>> histories;
  final List<Map<String, dynamic>> updates;
  final Map<String, dynamic>? deleted;
  final Map<String, dynamic>? settings;
  final List<ActionType> _deletionActionsToClear;

  _ChangedRows._({
    required this.categories,
    required this.manga,
    required this.chapters,
    required this.tracks,
    required this.histories,
    required this.updates,
    required this.deleted,
    required this.settings,
    required this._deletionActionsToClear,
  });

  /// Normal incremental sync: rows changed since `since`, every entity,
  /// plus pending local deletions.
  factory _ChangedRows.collect(SyncPreference prefs, Synching notifier) {
    final since = prefs.since ?? 0;

    final deleted = <String, List<int>>{};
    final deletionActions = <ActionType>[];
    void collectDeleted(String key, ActionType action) {
      final parts = notifier.getChangedParts([action]);
      final ids = parts.map((p) => p.clientId).nonNulls.toSet().toList();
      if (ids.isNotEmpty) deleted[key] = ids;
      deletionActions.add(action);
    }

    collectDeleted('categories', ActionType.removeCategory);
    collectDeleted('manga', ActionType.removeItem);
    collectDeleted('chapters', ActionType.removeChapter);
    collectDeleted('tracks', ActionType.removeTrack);
    collectDeleted('histories', ActionType.removeHistory);
    collectDeleted('updates', ActionType.removeUpdate);

    Map<String, dynamic>? settingsWire;
    final current = settingsRepository.current;
    if ((current.updatedAt ?? 0) >= since) {
      settingsWire = _settingsToWire(current);
    }

    return _ChangedRows._(
      categories: categoryRepository
          .getChangedSince(since)
          .map(_categoryToWire)
          .toList(),
      manga: mangaRepository
          .getChangedSince(since)
          .map((m) => _mangaToWire(m))
          .nonNulls
          .toList(),
      chapters: chapterRepository
          .getChangedSince(since)
          .map((c) => _chapterToWire(c))
          .nonNulls
          .toList(),
      tracks: trackRepository
          .getChangedSince(since)
          .map((t) => _trackToWire(t))
          .nonNulls
          .toList(),
      histories: historyRepository
          .getChangedSince(since)
          .map((h) => _historyToWire(h))
          .nonNulls
          .toList(),
      updates: updateRepository
          .getChangedSince(since)
          .map((u) => _updateToWire(u))
          .nonNulls
          .toList(),
      deleted: deleted.isEmpty ? null : deleted,
      settings: settingsWire,
      deletionActionsToClear: deletionActions,
    );
  }

  /// "Upload only": every local row, every entity, with `updatedAt` forced
  /// so it wins regardless of what the server holds. No deletions - see the
  /// comment on SyncServer._forceUpload for why.
  factory _ChangedRows.collectAll({required int forcedUpdatedAt}) {
    final settingsWire = _settingsToWire(
      settingsRepository.current,
      forcedUpdatedAt: forcedUpdatedAt,
    );
    return _ChangedRows._(
      categories: categoryRepository.getAll().map(_categoryToWire).toList(),
      manga: mangaRepository
          .getAll()
          .map((m) => _mangaToWire(m, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      chapters: chapterRepository
          .getAll()
          .map((c) => _chapterToWire(c, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      tracks: trackRepository
          .getAll()
          .map((t) => _trackToWire(t, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      histories: historyRepository
          .getAll()
          .map((h) => _historyToWire(h, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      updates: updateRepository
          .getAll()
          .map((u) => _updateToWire(u, forcedUpdatedAt: forcedUpdatedAt))
          .nonNulls
          .toList(),
      deleted: null,
      settings: settingsWire,
      deletionActionsToClear: const [],
    );
  }

  /// Splits into requests of at most [maxRows] rows per entity. `deleted`
  /// and `settings` ride along on the first request only - real-world
  /// deletion counts and the settings blob are nowhere near large enough to
  /// need batching of their own.
  List<Map<String, dynamic>> chunked(int maxRows) {
    int chunkCountFor(List list) =>
        list.isEmpty ? 0 : (list.length / maxRows).ceil();
    final chunkCount = [
      chunkCountFor(categories),
      chunkCountFor(manga),
      chunkCountFor(chapters),
      chunkCountFor(tracks),
      chunkCountFor(histories),
      chunkCountFor(updates),
    ].reduce(max);
    if (chunkCount == 0) {
      return [
        {
          if (deleted != null) 'deleted': deleted,
          if (settings != null) 'settings': settings,
        },
      ];
    }

    List<Map<String, dynamic>> slice(List<Map<String, dynamic>> list, int i) {
      final start = i * maxRows;
      if (start >= list.length) return const [];
      return list.sublist(start, min(start + maxRows, list.length));
    }

    return List.generate(chunkCount, (i) {
      final fields = <String, dynamic>{
        'categories': slice(categories, i),
        'manga': slice(manga, i),
        'chapters': slice(chapters, i),
        'tracks': slice(tracks, i),
        'histories': slice(histories, i),
        'updates': slice(updates, i),
      };
      if (i == 0) {
        if (deleted != null) fields['deleted'] = deleted;
        if (settings != null) fields['settings'] = settings;
      }
      return fields;
    });
  }

  Future<void> clearUploaded(Synching notifier) async {
    if (_deletionActionsToClear.isEmpty) return;
    await notifier.clearChangedParts(_deletionActionsToClear, true);
  }
}

Map<String, dynamic> _settingsToWire(
  Settings settings, {
  int? forcedUpdatedAt,
}) {
  final json = settings.toJson();
  json['updatedAt'] = forcedUpdatedAt ?? json['updatedAt'] ?? 0;
  // Session cookies are device/login-specific, never worth syncing.
  json['cookiesList'] = [];
  for (final key in _deviceLocalSettingsKeys) {
    json.remove(key);
  }
  return {'data': json, 'updatedAt': json['updatedAt']};
}
