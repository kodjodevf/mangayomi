import 'dart:convert';
import 'dart:io';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'base_tracker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'trakt_tv.g.dart';

@riverpod
class TraktTv extends _$TraktTv implements BaseTracker {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  static const _baseOAuthUrl = 'https://api.trakt.tv/oauth';
  static const _baseApiUrl = 'https://api.trakt.tv';
  static final _isDesktop = (Platform.isWindows || Platform.isLinux);
  static final _redirectUri = _isDesktop
      ? 'http://localhost:43824'
      : 'mangayomi://';
  static const _clientId =
      '5520c7e24da0d8d73ec80315b61b9849483583b013cb7f296c6db723eb9886a1';
  static const _clientSecret =
      'b512565ad92d4179290de257b6e435d03ee47b2e4371b3bd918081beb6121734';

  String getFallbackClientId(String usedId) {
    return _clientId;
  }

  @override
  void build({required int syncId, required ItemType? itemType}) {}

  Future<bool?> login() async {
    final callbackUrlScheme = _isDesktop
        ? 'http://localhost:43824'
        : 'mangayomi';
    final loginUrl = _authUrl();

    try {
      final uri = await FlutterWebAuth2.authenticate(
        url: "$loginUrl&redirect_uri=$_redirectUri",
        callbackUrlScheme: callbackUrlScheme,
      );
      final code = Uri.parse(uri).queryParameters['code'];
      if (code == null) return null;

      final oAuthData = await _getOAuth(code);
      final oAuth = _buildOAuth(oAuthData, _clientId);
      final username = await _getUserName(oAuth.accessToken!);
      _saveOAuth(username, oAuth);

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<TrackSearch>> fetchGeneralData({
    bool isManga = true,
    String rankingType = "trending",
  }) async {
    /// isManga <> isMovie
    final type = isManga ? "movies" : "shows";
    final accessToken = await _getAccessToken();
    final url = Uri.parse('$_baseApiUrl/$type/$rankingType').replace(
      queryParameters: {
        'extended': 'full,images',
        'clientId': _clientId,
        'limit': '15',
      },
    );
    final result = await _makeGetRequest(url, accessToken);
    final data = jsonDecode(result.body) as List?;
    return data?.map((e) {
          final type = isManga ? "movie" : "show";
          final typeName = type == 'movie' ? 'movies' : 'shows';
          return TrackSearch(
            mediaId: e['ids']?['trakt'] ?? e[type]?['ids']?['trakt'],
            summary:
                e['overview'] ??
                e[type]?['overview'] ??
                'No summary available.',
            totalChapter:
                e['aired_episodes'] ?? e[type]?['aired_episodes'] ?? 1,
            coverUrl: (e['images']?['fanart'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e['images']?['fanart'][0]}'
                : (e[type]?['images']?['fanart'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e[type]?['images']?['fanart'][0]}'
                : (e['images']?['poster'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e['images']?['poster'][0]}'
                : (e[type]?['images']?['poster'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e[type]?['images']?['poster'][0]}'
                : '',
            title: e['title'] ?? e[type]?['title'] ?? 'Unknown Title',
            score: double.tryParse(
              (e["rating"] ?? e[type]?["rating"] as num?)
                      ?.toDouble()
                      .toStringAsFixed(2) ??
                  "",
            ),
            startDate: e["first_aired"] ?? e[type]?["first_aired"] ?? "",
            publishingType: type,
            publishingStatus: e["status"] ?? e[type]["status"],
            trackingUrl:
                "https://trakt.tv/$typeName/${e['ids']?['slug'] ?? e[type]?['ids']?['slug']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
  }

  @override
  Future<List<TrackSearch>> fetchUserData({bool isManga = true}) async {
    final type = isManga ? "movies" : "shows";
    final accessToken = await _getAccessToken();
    final url = Uri.parse(
      '$_baseApiUrl/sync/watched/$type',
    ).replace(queryParameters: {"extended": "full,images"});
    final result = await _makeGetRequest(url, accessToken);
    final data = jsonDecode(result.body) as List?;
    return data?.map((e) {
          final type = e['movie'] != null ? "movie" : "show";
          final typeName = type == 'movie' ? 'movies' : 'shows';
          return TrackSearch(
            mediaId: e[type]?['ids']?['trakt'],
            summary: e[type]?['overview'] ?? 'No summary available.',
            totalChapter: e[type]?['aired_episodes'] ?? 1,
            coverUrl: (e['images']?['fanart'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e['images']?['fanart'][0]}'
                : (e[type]?['images']?['fanart'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e[type]?['images']?['fanart'][0]}'
                : (e['images']?['poster'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e['images']?['poster'][0]}'
                : (e[type]?['images']?['poster'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e[type]?['images']?['poster'][0]}'
                : '',
            title: e[type]['title'] ?? 'Unknown Title',
            score: double.tryParse(
              (e[type]?["rating"] as num?)?.toDouble().toStringAsFixed(2) ?? "",
            ),
            startDate: e[type]?["first_aired"] ?? "",
            publishingType: type,
            publishingStatus: e[type]["status"],
            trackingUrl:
                "https://trakt.tv/$typeName/${e[type]?['ids']?['slug']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
  }

  @override
  Future<Track?> findLibItem(Track track, bool isManga) async {
    final accessToken = await _getAccessToken();
    final isMovie =
        track.trackingUrl?.replaceAll("https://trakt.tv/", "").split("/")[0] ==
        "movies";
    final url = Uri.parse(
      '$_baseApiUrl/sync/history/${isMovie ? "movies" : "shows"}/${track.mediaId}',
    ).replace(queryParameters: {"extended": "full"});
    final result = await _makeGetRequest(url, accessToken);
    final data = jsonDecode(result.body) as List?;
    if (data?.isNotEmpty ?? false) {
      if (!isMovie) {
        track.lastChapterRead = data!
            .where((e) => e["type"] == "episode")
            .length;
      }
      if ((track.lastChapterRead ?? 0) >= (track.totalChapter ?? 0)) {
        track.finishedReadingDate = DateTime.tryParse(
          data!.firstOrNull?["watched_at"],
        )?.millisecondsSinceEpoch;
      }
      return track;
    }
    return await update(track, isManga);
  }

  @override
  Future<List<TrackSearch>> search(String query, bool isManga) async {
    final accessToken = await _getAccessToken();
    final url = Uri.parse('$_baseApiUrl/search/movie,show').replace(
      queryParameters: {
        'query': query,
        'extended': 'full,images',
        'clientId': _clientId,
        'limit': '15',
      },
    );
    final result = await _makeGetRequest(url, accessToken);
    final data = jsonDecode(result.body) as List?;
    return data?.map((e) {
          final type = e['type'];
          final typeName = e['type'] == 'movie' ? 'movies' : 'shows';
          return TrackSearch(
            mediaId: e[type]?['ids']?['trakt'],
            summary: e[type]?['overview'] ?? 'No summary available.',
            totalChapter: e[type]?['aired_episodes'] ?? 1,
            coverUrl: (e['images']?['fanart'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e['images']?['fanart'][0]}'
                : (e[type]?['images']?['fanart'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e[type]?['images']?['fanart'][0]}'
                : (e['images']?['poster'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e['images']?['poster'][0]}'
                : (e[type]?['images']?['poster'] as List?)?.isNotEmpty ?? false
                ? 'https://wsrv.nl/?url=${e[type]?['images']?['poster'][0]}'
                : '',
            title: e[type]['title'] ?? 'Unknown Title',
            score: double.tryParse(
              (e["rating"] ?? e[type]?["rating"] as num?)
                      ?.toDouble()
                      .toStringAsFixed(2) ??
                  "",
            ),
            startDate: e[type]?["first_aired"] ?? "",
            publishingType: type,
            publishingStatus: e[type]["status"],
            trackingUrl:
                "https://trakt.tv/$typeName/${e[type]?['ids']?['slug']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
  }

  @override
  List<TrackStatus> statusList(bool isManga) => [];

  @override
  Future<Track> update(Track track, bool isManga) async {
    final accessToken = await _getAccessToken();
    final isMovie =
        track.trackingUrl?.replaceAll("https://trakt.tv/", "").split("/")[0] ==
        "movies";
    final urlRemove = Uri.parse(
      "$_baseApiUrl/sync/history/remove",
    ).replace(queryParameters: {'clientId': _clientId});
    final bodyRemove = isMovie
        ? {
            'movies': [
              {
                'ids': {'trakt': track.mediaId},
              },
            ],
          }
        : {
            'shows': [
              {
                'ids': {'trakt': track.mediaId},
              },
            ],
          };
    await _makePostRequest(urlRemove, accessToken, bodyRemove);
    final url = Uri.parse(
      "$_baseApiUrl/sync/history",
    ).replace(queryParameters: {'extended': 'full', 'clientId': _clientId});
    final body = isMovie
        ? {
            'movies': [
              {
                'watched_at': DateTime.now().toIso8601String(),
                'ids': {'trakt': track.mediaId},
              },
            ],
          }
        : {
            'shows': [
              {
                'watched_at': DateTime.now().toIso8601String(),
                'ids': {'trakt': track.mediaId},
                'seasons': [
                  {
                    'number': 1,
                    'episodes': [
                      for (int i = 1; i <= (track.lastChapterRead ?? 1); i++)
                        {
                          'watched_at': DateTime.now().toIso8601String(),
                          'number': i,
                        },
                    ],
                  },
                ],
              },
            ],
          };
    await _makePostRequest(url, accessToken, body);
    return track;
  }

  Future<String> _getAccessToken({bool bypass = false}) async {
    final track = ref.read(tracksProvider(syncId: syncId));
    final mALOAuth = OAuth.fromJson(
      jsonDecode(track!.oAuth!) as Map<String, dynamic>,
    );
    final expiresIn = DateTime.fromMillisecondsSinceEpoch(mALOAuth.expiresIn!);
    if (DateTime.now().isBefore(expiresIn)) return mALOAuth.accessToken!;
    if (!bypass &&
        (ref.read(tracksProvider(syncId: syncId))?.refreshing ?? false)) {
      return mALOAuth.accessToken!;
    }
    ref.read(tracksProvider(syncId: syncId).notifier).setRefreshing(true);
    final refreshed = await _tryRefreshToken(mALOAuth);
    if (refreshed == null) {
      ref.read(tracksProvider(syncId: syncId).notifier).logout();
      botToast("Trakt.tv Token expired");
      throw Exception("Token expired");
    }
    final username = await _getUserName(refreshed.accessToken!);
    _saveOAuth(username, refreshed);
    await Future.delayed(Duration(seconds: 3));
    ref.read(tracksProvider(syncId: syncId).notifier).setRefreshing(false);
    return refreshed.accessToken!;
  }

  Future<OAuth?> _tryRefreshToken(OAuth oldOAuth) async {
    String primaryClientId = oldOAuth.clientId ?? _clientId;

    Future<OAuth?> tryRefresh(String cid) async {
      final params = {
        'refresh_token': oldOAuth.refreshToken,
        'client_id': cid,
        'client_secret': _clientSecret,
        'redirect_uri': _redirectUri,
        'grant_type': 'refresh_token',
      };
      final response = await http.post(
        Uri.parse('$_baseOAuthUrl/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(params),
      );
      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return _buildOAuth(body, cid);
    }

    return await tryRefresh(primaryClientId) ??
        await tryRefresh(getFallbackClientId(primaryClientId));
  }

  OAuth _buildOAuth(Map<String, dynamic> json, String clientId) {
    return OAuth.fromJson(json)
      ..expiresIn = DateTime.now()
          .add(Duration(seconds: json['expires_in']))
          .millisecondsSinceEpoch
      ..clientId = clientId;
  }

  void _saveOAuth(String username, OAuth oAuth) {
    ref
        .read(tracksProvider(syncId: syncId).notifier)
        .login(
          TrackPreference(
            syncId: syncId,
            username: username,
            prefs: "",
            oAuth: jsonEncode(oAuth.toJson()),
          ),
        );
  }

  Future<String> _getUserName(String accessToken) async {
    final response = await _makeGetRequest(
      Uri.parse('$_baseApiUrl/users/settings'),
      accessToken,
    );
    return "${jsonDecode(response.body)['user']['username']}";
  }

  String _authUrl() {
    return '$_baseOAuthUrl/authorize?client_id=$_clientId&response_type=code';
  }

  Future<dynamic> _getOAuth(String code) async {
    final params = {
      'code': code,
      'client_id': _clientId,
      'client_secret': _clientSecret,
      'redirect_uri': _redirectUri,
      'grant_type': 'authorization_code',
    };
    final response = await http.post(
      Uri.parse('$_baseOAuthUrl/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(params),
    );
    return jsonDecode(response.body);
  }

  Future<Response> _makeGetRequest(Uri url, String accessToken) async {
    return await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'trakt-api-key': _clientId,
        'trakt-api-version': "2",
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Response> _makePostRequest(
    Uri url,
    String accessToken,
    Object? body,
  ) async {
    return await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'trakt-api-key': _clientId,
        'trakt-api-version': "2",
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  @override
  String displayScore(int score) {
    throw UnimplementedError();
  }

  @override
  (int, int) getScoreValue() {
    throw UnimplementedError();
  }

  @override
  Future<bool> checkRefresh() async {
    try {
      await _getAccessToken(bypass: true);
      AppLogger.log("Refreshed Trakt.tv token!");
      return true;
    } catch (e) {
      AppLogger.log(
        "Failed to refresh Trakt.tv token:",
        logLevel: LogLevel.error,
      );
      AppLogger.log(e.toString(), logLevel: LogLevel.error);
      return false;
    } finally {
      ref.read(tracksProvider(syncId: syncId).notifier).setRefreshing(false);
    }
  }
}
