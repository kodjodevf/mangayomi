// Riverpod-facing orchestration for the sync-server's `/api/sync/v1`
// protocol. The wire transport lives in SyncApiClient, applying a pulled
// response to local storage lives in SyncEntityApplier, and collecting local
// changes to upload lives in ChangedRows (services/sync/*) - this class only
// sequences those three pieces and turns their results into UI-facing state
// (toasts, progress, invalidated providers).
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/blend_level_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/theme_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_progress_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/sync/sync_api_client.dart';
import 'package:mangayomi/services/sync/sync_change_collector.dart';
import 'package:mangayomi/services/sync/sync_entity_applier.dart';
import 'package:mangayomi/utils/client_id.dart';
import 'package:mangayomi/utils/platform_utils.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
part 'sync_server.g.dart';

/// Matches the server's SYNC.maxRowsPerEntity. A changed-row batch larger
/// than this for one entity is split across more than one request rather
/// than sent in one oversized body.
const _maxRowsPerEntity = 5000;

// Loopback port for the desktop OAuth callback. Only the protocol+hostname of
// a redirect_uri are checked server-side (see isAllowedRedirectUri in the
// sync-server repo), not the port, so this can be anything not already in use.
const _desktopOAuthCallbackPort = 48765;

@riverpod
class SyncServer extends _$SyncServer {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final _entityApplier = const SyncEntityApplier();
  late final _apiClient = SyncApiClient(http);

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
      if (!await _apiClient.checkVersion(_getServer())) {
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

  // ------------------------------------------------------------------
  // Incremental sync: the normal path. One request handles every entity at
  // once; a request pages on its own (via cursors/sessionToken/hasMore)
  // until every entity has fully caught up, then saves the new `since`.
  // ------------------------------------------------------------------

  Future<bool> _incrementalSync(Synching notifier) async {
    final prefs = ref.read(synchingProvider(syncId: syncId));
    final since = prefs.since ?? 0;
    final changed = ChangedRows.collect(prefs, notifier);
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
      cursors = _apiClient.decodeCursors(response['cursors']);
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
    final changed = ChangedRows.collectAll(forcedUpdatedAt: now);
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
      cursors = _apiClient.decodeCursors(response['cursors']);
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
      cursors = _apiClient.decodeCursors(response['cursors']);
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

  Future<Map<String, dynamic>?> _postSync(Map<String, dynamic> body) =>
      _apiClient.postSync(_getServer(), _getAccessToken(), body);

  String _getAccessToken() {
    final syncPrefs = ref.watch(synchingProvider(syncId: syncId));
    return syncPrefs.authToken ?? "";
  }

  String _getServer() {
    final syncPrefs = ref.watch(synchingProvider(syncId: syncId));
    return syncPrefs.server ?? "";
  }

  // ------------------------------------------------------------------
  // Applying a response's pulled entities to local storage, then
  // invalidating whatever app state depends on settings if they changed.
  // ------------------------------------------------------------------

  Future<void> _applyPulledEntities(Map<String, dynamic> response) async {
    final settingsChanged = await _entityApplier.apply(response);
    if (settingsChanged) _invalidateSettingsDerivedProviders();
  }

  void _invalidateSettingsDerivedProviders() {
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
}
