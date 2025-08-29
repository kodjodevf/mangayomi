import 'dart:convert';
import 'dart:io';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'base_tracker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'simkl.g.dart';

@riverpod
class Simkl extends _$Simkl implements BaseTracker {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  static const _baseOAuthUrl = 'https://simkl.com/oauth';
  static const _baseApiUrl = 'https://api.simkl.com';
  static final _isDesktop = (Platform.isWindows || Platform.isLinux);
  static final _redirectUri = _isDesktop
      ? 'http://localhost:43824'
      : 'mangayomi://';
  static const _clientId =
      '1e0a52930b1bdface4e30c1a94a44641475f3c80b69a5ea939562153fccffb68';
  static const _clientSecret =
      'aed1dc0fa8b9906c493b87c513b430fde75ea5cdad0087e8d129fbc5d36f9be0';

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
    final type = isManga ? "movies" : "tv";
    final accessToken = await _getAccessToken();
    final url = Uri.parse('$_baseApiUrl/$type/$rankingType').replace(
      queryParameters: {
        'extended': 'overview',
        if (rankingType == "airing") 'date': 'today',
        if (rankingType == "airing") 'sort': 'rank',
        if (rankingType == "best") 'filter': 'all',
        if (rankingType == "best") 'type': 'series',
        'clientId': _clientId,
        'limit': '15',
      },
    );
    final result = await _makeGetRequest(url, accessToken);
    final data = jsonDecode(result.body) as List?;
    return data?.map((e) {
          return TrackSearch(
            mediaId: e['ids']?['simkl_id'] ?? e['ids']?['simkl'],
            summary: e['overview'] ?? 'No summary available.',
            totalChapter: 0,
            coverUrl: e['fanart'] != null
                ? 'https://wsrv.nl/?url=https://simkl.in/fanart/${e['fanart']}_medium.jpg'
                : e['poster'] != null
                ? 'https://wsrv.nl/?url=https://simkl.in/posters/${e['poster']}_m.webp'
                : '',
            title: e['title'] ?? 'Unknown Title',
            score: (e["ratings"]?["simkl"]?["rating"] as num?)?.toDouble(),
            startDate: e["release_date"] ?? "",
            publishingType: isManga ? "movie" : "tv",
            publishingStatus: e["status"],
            trackingUrl:
                "https://simkl.com/$type/${e['ids']?['simkl_id'] ?? e['ids']?['simkl']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
  }

  @override
  Future<List<TrackSearch>> fetchUserData({bool isManga = true}) async {
    final type = isManga ? "movies" : "shows";
    final nodeType = isManga ? "movie" : "show";
    final accessToken = await _getAccessToken();
    final url = Uri.parse('$_baseApiUrl/sync/all-items/$type');
    final result = await _makeGetRequest(url, accessToken);
    final data = jsonDecode(result.body) as Map<String, dynamic>?;
    return (data?[type] as List?)?.map((e) {
          final node = e[nodeType];
          return TrackSearch(
            mediaId: node['ids']?['simkl'],
            summary: 'No summary available.',
            totalChapter: isManga ? 1 : e['total_episodes_count'],
            coverUrl: node['poster'] != null
                ? "https://wsrv.nl/?url=https://simkl.in/posters/${node['poster']}_m.jpg"
                : "",
            title: node['title'] ?? 'Unknown Title',
            score: 0,
            startDate: "",
            publishingType: isManga ? "movie" : "tv",
            publishingStatus: e["status"],
            trackingUrl: "https://simkl.com/$type/${node['ids']?['simkl']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
  }

  @override
  Future<Track?> findLibItem(Track track, bool isManga) async {
    final accessToken = await _getAccessToken();
    final url = Uri.parse(
      '$_baseApiUrl/sync/watched/',
    ).replace(queryParameters: {"extended": "episodes,specials,counters"});
    final result = await _makePostRequest(url, accessToken, [
      {"simkl": track.mediaId},
    ]);
    final data = jsonDecode(result.body) as List?;
    if ((data?.isNotEmpty ?? false) &&
        data!.firstOrNull?["result"] != "not_found") {
      final node = data.firstOrNull;
      if (node?["list"] is String) {
        track.status = _trackFromSimklStatus(node!["list"]);
        if (track.status == TrackStatus.completed &&
            node?["last_watched_at"] is String) {
          track.finishedReadingDate = DateTime.tryParse(
            node!["last_watched_at"],
          )?.millisecondsSinceEpoch;
        }
      }
      if (node?["episodes_watched"] is num) {
        track.lastChapterRead = (node!["episodes_watched"] as num).toInt();
      }
      if (node?["episodes_total"] is num) {
        track.totalChapter = (node!["episodes_total"] as num).toInt();
      }
      track.libraryId = 1;
      if (node?["result"] == false) {
        track.libraryId = 0;
        return await update(track, isManga);
      }
    }
    return track;
  }

  @override
  Future<List<TrackSearch>> search(String query, bool isManga) async {
    final accessToken = await _getAccessToken();
    final urlMovies = Uri.parse('$_baseApiUrl/search/movies').replace(
      queryParameters: {
        'q': query,
        'extended': 'full',
        'clientId': _clientId,
        'limit': '15',
      },
    );
    final resultMovies = await _makeGetRequest(urlMovies, accessToken);
    final dataMovies = jsonDecode(resultMovies.body) as List?;
    final movies =
        dataMovies?.map((e) {
          return TrackSearch(
            mediaId: e['ids']?['simkl_id'] ?? e['ids']?['simkl'],
            summary: e['overview'] ?? 'No summary available.',
            totalChapter: 0,
            coverUrl: e['poster'] != null
                ? 'https://wsrv.nl/?url=https://simkl.in/posters/${e['poster']}_m.webp'
                : '',
            title: e['title'] ?? 'Unknown Title',
            score: (e["ratings"]?["simkl"]?["rating"] as num?)?.toDouble(),
            startDate: e["release_date"] ?? "",
            publishingType: "movie",
            publishingStatus: e["status"],
            trackingUrl:
                "https://simkl.com/movie/${e['ids']?['simkl_id'] ?? e['ids']?['simkl']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
    final urlSeries = Uri.parse('$_baseApiUrl/search/tv').replace(
      queryParameters: {
        'q': query,
        'extended': 'full',
        'clientId': _clientId,
        'limit': '15',
      },
    );
    final resultSeries = await _makeGetRequest(urlSeries, accessToken);
    final dataSeries = jsonDecode(resultSeries.body) as List?;
    final series =
        dataSeries?.map((e) {
          return TrackSearch(
            mediaId: e['ids']?['simkl_id'] ?? e['ids']?['simkl'],
            summary: e['overview'] ?? 'No summary available.',
            totalChapter: 0,
            coverUrl: e['poster'] != null
                ? 'https://wsrv.nl/?url=https://simkl.in/posters/${e['poster']}_m.webp'
                : '',
            title: e['title'] ?? 'Unknown Title',
            score: (e["ratings"]?["simkl"]?["rating"] as num?)?.toDouble(),
            startDate: e["release_date"] ?? "",
            publishingType: "tv",
            publishingStatus: e["status"],
            trackingUrl:
                "https://simkl.com/tv/${e['ids']?['simkl_id'] ?? e['ids']?['simkl']}",
            syncId: syncId,
          );
        }).toList() ??
        [];
    return movies + series;
  }

  @override
  List<TrackStatus> statusList(bool isManga) => [
    TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToWatch,
  ];

  @override
  Future<Track> update(Track track, bool isManga) async {
    final accessToken = await _getAccessToken();
    final existRemote = track.libraryId == 1;
    final isMovie =
        track.trackingUrl?.replaceAll("https://simkl.com/", "").split("/")[0] ==
        "movie";
    final url =
        Uri.parse(
          existRemote
              ? "$_baseApiUrl/sync/history"
              : "$_baseApiUrl/sync/add-to-list",
        ).replace(
          queryParameters: {
            'extended': 'full',
            'clientId': _clientId,
            'limit': '15',
          },
        );
    final body = isMovie
        ? {
            'movies': [
              {
                if (!existRemote) 'to': _trackToSimklStatus(track),
                if (existRemote) 'status': _trackToSimklStatus(track),
                'ids': {'simkl': track.mediaId},
              },
            ],
          }
        : {
            'shows': [
              {
                if (!existRemote) 'to': _trackToSimklStatus(track),
                if (existRemote) 'status': _trackToSimklStatus(track),
                'ids': {'simkl': track.mediaId},
                'episodes': [
                  for (int i = 1; i <= (track.lastChapterRead ?? 1); i++)
                    {'number': i},
                ],
              },
            ],
          };
    final result = await _makePostRequest(url, accessToken, body);
    if (result.statusCode >= 200 && result.statusCode < 300) {
      track.libraryId = 1;
    }
    if (result.statusCode == 201) {
      return track;
    }
    final temp = (jsonDecode(result.body) as Map<String, dynamic>?)?["added"];
    final data = _extractTrackData(
      temp?[isMovie ? "movies" : "shows"] as List?,
      track.mediaId,
    );
    return _parseTrack(track, data);
  }

  Map<String, dynamic>? _extractTrackData(List? data, int? mediaId) {
    return data?.firstWhereOrNull((e) => e["ids"]?["simkl"] == mediaId);
  }

  Track _parseTrack(Track track, Map<String, dynamic>? data) {
    if (data?["to"] is String) {
      track.status = _trackFromSimklStatus(data!["to"]);
    }
    return track;
  }

  String _trackToSimklStatus(Track track) => switch (track.status) {
    TrackStatus.completed => "completed",
    TrackStatus.watching => "watching",
    TrackStatus.onHold => "hold",
    TrackStatus.dropped => "dropped",
    _ => "plantowatch",
  };

  TrackStatus _trackFromSimklStatus(String status) => switch (status) {
    "completed" => TrackStatus.completed,
    "watching" => TrackStatus.watching,
    "hold" => TrackStatus.onHold,
    "dropped" => TrackStatus.dropped,
    _ => TrackStatus.planToWatch,
  };

  Future<String> _getAccessToken() async {
    final track = ref.read(tracksProvider(syncId: syncId));
    final mALOAuth = OAuth.fromJson(
      jsonDecode(track!.oAuth!) as Map<String, dynamic>,
    );
    return mALOAuth.accessToken!;
  }

  OAuth _buildOAuth(Map<String, dynamic> json, String clientId) {
    return OAuth.fromJson(json)..clientId = clientId;
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
    return "${jsonDecode(response.body)['account']['id']}";
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
      Uri.parse('$_baseApiUrl/oauth/token'),
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
        'simkl-api-key': _clientId,
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
        'simkl-api-key': _clientId,
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
    ref.read(tracksProvider(syncId: syncId).notifier).setRefreshing(false);
    return true;
  }
}
