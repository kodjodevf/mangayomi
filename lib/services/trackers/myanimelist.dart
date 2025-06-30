import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'myanimelist.g.dart';

@riverpod
class MyAnimeList extends _$MyAnimeList {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  String baseOAuthUrl = 'https://myanimelist.net/v1/oauth2';
  String baseApiUrl = 'https://api.myanimelist.net/v2';
  String codeVerifier = "";
  static final isDesktop = (Platform.isWindows || Platform.isLinux);
  String clientId = isDesktop
      ? '39e9be346b4e7dbcc59a98357e2f8472'
      : '0c9100ccd443ddb441a319a881180f7f';

  @override
  void build({required int syncId, required ItemType? itemType}) {}

  Future<bool?> login() async {
    final callbackUrlScheme = isDesktop
        ? 'http://localhost:43824'
        : 'mangayomi';
    final loginUrl = _authUrl();

    try {
      final uri = await FlutterWebAuth2.authenticate(
        url: loginUrl,
        callbackUrlScheme: callbackUrlScheme,
      );
      final queryParams = Uri.parse(uri).queryParameters;
      if (queryParams['code'] == null) return null;

      final oAuth = await _getOAuth(queryParams['code']!);
      final mALOAuth = OAuth.fromJson(oAuth as Map<String, dynamic>)
        ..expiresIn = DateTime.now()
            .add(Duration(seconds: oAuth['expires_in']))
            .millisecondsSinceEpoch;
      final username = await _getUserName(mALOAuth.accessToken!);
      ref
          .read(tracksProvider(syncId: syncId).notifier)
          .login(
            TrackPreference(
              syncId: syncId,
              username: username,
              oAuth: jsonEncode(mALOAuth.toJson()),
            ),
          );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> _getAccessToken() async {
    final track = ref.watch(tracksProvider(syncId: syncId));
    final mALOAuth = OAuth.fromJson(
      jsonDecode(track!.oAuth!) as Map<String, dynamic>,
    );
    final expiresIn = DateTime.fromMillisecondsSinceEpoch(mALOAuth.expiresIn!);
    if (DateTime.now().isAfter(expiresIn)) {
      final params = {
        'client_id': clientId,
        'grant_type': 'refresh_token',
        'refresh_token': mALOAuth.refreshToken,
      };
      final response = await http.post(
        Uri.parse('$baseOAuthUrl/token'),
        body: params,
      );
      final oAuth = OAuth.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      final username = await _getUserName(oAuth.accessToken!);
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
      return oAuth.accessToken!;
    }
    return mALOAuth.accessToken!;
  }

  Future<List<TrackSearch>> search(String query, isManga) async {
    final accessToken = await _getAccessToken();
    final url = Uri.parse(
      '$baseApiUrl/${isManga ? "manga" : "anime"}',
    ).replace(queryParameters: {'q': query.trim(), 'nsfw': 'true'});
    final result = await _makeGetRequest(url, accessToken);
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    List<int> mangaIds = res['data'] == null
        ? []
        : (res['data'] as List).map((e) => e['node']["id"] as int).toList();
    final trackSearchResult = await Future.wait(
      mangaIds.map((id) => getDetails(id, accessToken, isManga)),
    );

    return trackSearchResult
        .where((element) => !element.publishingType!.contains("novel"))
        .toList();
  }

  Future<TrackSearch> getDetails(
    int id,
    String accessToken,
    bool isManga,
  ) async {
    final item = isManga ? "manga" : "anime";
    final contentUnit = isManga ? "num_chapters" : "num_episodes";
    final url = Uri.parse('$baseApiUrl/$item/$id').replace(
      queryParameters: {
        'fields':
            'id,title,synopsis,$contentUnit,main_picture,status,media_type,start_date,mean',
      },
    );

    final result = await _makeGetRequest(url, accessToken);
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    return TrackSearch(
      mediaId: res["id"],
      summary: res["synopsis"] ?? "",
      totalChapter: res[contentUnit],
      coverUrl: res["main_picture"]["large"] ?? "",
      title: res["title"],
      startDate: res["start_date"] ?? "",
      publishingType: res["media_type"].toString().replaceAll("_", " "),
      publishingStatus: res["status"].toString().replaceAll("_", " "),
      trackingUrl: "https://myanimelist.net/$item/${res["id"]}",
      score: res["mean"],
      syncId: syncId,
    );
  }

  Future<List<TrackSearch>> fetchGeneralData({
    bool isManga = true,
    String rankingType = "airing",
  }) async {
    final accessToken = await _getAccessToken();
    final item = isManga ? "manga" : "anime";
    final contentUnit = isManga ? "num_chapters" : "num_episodes";
    final url = Uri.parse('$baseApiUrl/$item/ranking').replace(
      queryParameters: {
        'ranking_type': rankingType,
        'limit': '15',
        'fields':
            'id,title,synopsis,$contentUnit,main_picture,status,media_type,start_date,mean',
      },
    );
    final result = await _makeGetRequest(url, accessToken);
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    return res['data'] == null
        ? []
        : (res['data'] as List)
              .map(
                (e) => TrackSearch(
                  mediaId: e["node"]["id"],
                  summary: e["node"]["synopsis"] ?? "",
                  totalChapter: e["node"][contentUnit],
                  coverUrl: e["node"]["main_picture"]["large"] ?? "",
                  title: e["node"]["title"],
                  score: e["node"]["mean"] is double
                      ? e["node"]["mean"]
                      : ((e["node"]["mean"] ?? 0) as int).toDouble(),
                  startDate: e["node"]["start_date"] ?? "",
                  publishingType: e["node"]["media_type"].toString().replaceAll(
                    "_",
                    " ",
                  ),
                  publishingStatus: e["node"]["status"].toString().replaceAll(
                    "_",
                    " ",
                  ),
                  trackingUrl:
                      "https://myanimelist.net/$item/${e["node"]["id"]}",
                  syncId: syncId,
                ),
              )
              .toList();
  }

  Future<List<TrackSearch>> fetchUserData({bool isManga = true}) async {
    final accessToken = await _getAccessToken();
    final item = isManga ? "mangalist" : "animelist";
    final contentUnit = isManga ? "num_chapters" : "num_episodes";
    final currentStatus = isManga ? "reading" : "watching";
    final url = Uri.parse('$baseApiUrl/users/@me/$item').replace(
      queryParameters: {
        'status': currentStatus,
        utf8.decode([110, 115, 102, 119]): 'true',
        'sort': 'list_updated_at',
        'limit': '1000',
        'fields':
            'id,title,synopsis,$contentUnit,main_picture,status,media_type,start_date,mean,list_status',
      },
    );
    final result = await _makeGetRequest(url, accessToken);
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    return res['data'] == null
        ? []
        : (res['data'] as List)
              .map(
                (e) => TrackSearch(
                  mediaId: e["node"]["id"],
                  summary: e["node"]["synopsis"] ?? "",
                  totalChapter: e["node"][contentUnit],
                  coverUrl: e["node"]["main_picture"]["large"] ?? "",
                  title: e["node"]["title"],
                  score: e["node"]["mean"] is double
                      ? e["node"]["mean"]
                      : ((e["node"]["mean"] ?? 0) as int).toDouble(),
                  startDate: e["node"]["start_date"] ?? "",
                  publishingType: e["node"]["media_type"].toString().replaceAll(
                    "_",
                    " ",
                  ),
                  publishingStatus: e["node"]["status"].toString().replaceAll(
                    "_",
                    " ",
                  ),
                  trackingUrl:
                      "https://myanimelist.net/$item/${e["node"]["id"]}",
                  startedReadingDate: _parseDate(
                    e["list_status"]["start_date"],
                  ),
                  finishedReadingDate: _parseDate(
                    e["list_status"]["finish_date"],
                  ),
                  lastChapterRead:
                      e["list_status"][isManga
                          ? "num_chapters_read"
                          : "num_episodes_watched"],
                  status: fromMyAnimeListStatus(
                    e["list_status"]["status"],
                    isManga,
                  ).name,
                  syncId: syncId,
                ),
              )
              .toList();
  }

  String _convertToIsoDate(int? epochTime) {
    String date = "";
    try {
      date = DateFormat(
        "yyyy-MM-dd",
        "en_US",
      ).format(DateTime.fromMillisecondsSinceEpoch(epochTime!));
    } catch (_) {}
    return date;
  }

  String _codeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(200, (i) => random.nextInt(256));
    codeVerifier = base64UrlEncode(values).substring(0, 128);
    return codeVerifier;
  }

  String _authUrl() {
    _codeVerifier();
    return '$baseOAuthUrl/authorize?client_id=$clientId&code_challenge=$codeVerifier&response_type=code';
  }

  TrackStatus _getMALTrackStatus(String status, bool isManga) {
    return switch (status) {
      "reading" when isManga => TrackStatus.reading,
      "watching" when !isManga => TrackStatus.watching,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      "plan_to_read" when isManga => TrackStatus.planToRead,
      "plan_to_watch" when !isManga => TrackStatus.planToWatch,
      _ => isManga ? TrackStatus.reReading : TrackStatus.planToWatch,
    };
  }

  List<TrackStatus> statusList(bool isManga) => [
    isManga ? TrackStatus.reading : TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    isManga ? TrackStatus.planToRead : TrackStatus.planToWatch,
    if (isManga) TrackStatus.reReading,
  ];

  String? toMyAnimeListStatus(TrackStatus status, bool isManga) {
    return switch (status) {
      TrackStatus.reading when isManga => "reading",
      TrackStatus.watching when !isManga => "watching",
      TrackStatus.completed => "completed",
      TrackStatus.onHold => "on_hold",
      TrackStatus.dropped => "dropped",
      TrackStatus.planToRead when isManga => "plan_to_read",
      TrackStatus.planToWatch when !isManga => "plan_to_watch",
      _ => isManga ? "reading" : "plan_to_watch",
    };
  }

  TrackStatus fromMyAnimeListStatus(String status, bool isManga) {
    return switch (status) {
      "reading" when isManga => TrackStatus.reading,
      "watching" when !isManga => TrackStatus.watching,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      "plan_to_read" when isManga => TrackStatus.planToRead,
      "plan_to_watch" when !isManga => TrackStatus.planToWatch,
      _ => isManga ? TrackStatus.reading : TrackStatus.planToWatch,
    };
  }

  Future<dynamic> _getOAuth(String code) async {
    final params = {
      'client_id': clientId,
      'code': code,
      'code_verifier': codeVerifier,
      'grant_type': 'authorization_code',
    };
    final response = await http.post(
      Uri.parse('$baseOAuthUrl/token'),
      body: params,
    );
    return jsonDecode(response.body);
  }

  Future<String> _getUserName(String accessToken) async {
    final response = await _makeGetRequest(
      Uri.parse('$baseApiUrl/users/@me'),
      accessToken,
    );
    return jsonDecode(response.body)['name'];
  }

  Future<Track> findLibItem(Track track, bool isManga) async {
    final type = isManga ? "manga" : "anime";
    final contentUnit = isManga ? 'num_chapters' : 'num_episodes';
    final accessToken = await _getAccessToken();
    final uri = Uri.parse('$baseApiUrl/$type/${track.mediaId}').replace(
      queryParameters: {
        'fields': '$contentUnit,my_list_status{start_date,finish_date}',
      },
    );
    final response = await _makeGetRequest(uri, accessToken);
    final mJson = jsonDecode(response.body);
    track.totalChapter = mJson[contentUnit] ?? 0;
    if (mJson['my_list_status'] != null) {
      track = _parseItem(mJson["my_list_status"], track, isManga);
    } else {
      track = await update(track, isManga);
    }
    return track;
  }

  Track _parseItem(Map<String, dynamic> mJson, Track track, bool isManga) {
    bool isRepeating =
        mJson[isManga ? "is_rereading" : "is_rewatching"] ?? false;
    track.status = isRepeating
        ? (isManga ? TrackStatus.reReading : TrackStatus.reWatching)
        : _getMALTrackStatus(mJson["status"], isManga);
    track.lastChapterRead = int.parse(
      mJson[isManga ? "num_chapters_read" : "num_episodes_watched"].toString(),
    );
    track.score = int.parse(mJson["score"].toString());
    track.startedReadingDate = _parseDate(mJson["start_date"]);
    track.finishedReadingDate = _parseDate(mJson["finish_date"]);
    return track;
  }

  int? _parseDate(String? isoDate) {
    if (isoDate == null) return null;

    final date = DateFormat('yyyy-MM-dd', 'en_US').parse(isoDate);
    return date.millisecondsSinceEpoch;
  }

  Future<Track> update(Track track, bool isManga) async {
    final accessToken = await _getAccessToken();
    final formBody = {
      'status':
          (toMyAnimeListStatus(track.status, isManga) ??
                  (isManga ? 'reading' : 'watching'))
              .toString(),
      isManga ? 'is_rereading' : 'is_rewatching':
          (track.status ==
                  (isManga ? TrackStatus.reReading : TrackStatus.reWatching))
              .toString(),
      'score': track.score.toString(),
      isManga ? 'num_chapters_read' : 'num_watched_episodes': track
          .lastChapterRead
          .toString(),
      if (track.startedReadingDate != null)
        'start_date': _convertToIsoDate(track.startedReadingDate),
      if (track.finishedReadingDate != null)
        'finish_date': _convertToIsoDate(track.finishedReadingDate),
    };
    final request = Request(
      'PUT',
      Uri.parse(
        '$baseApiUrl/${isManga ? "manga" : "anime"}'
        '/${track.mediaId}/my_list_status',
      ),
    );
    request.bodyFields = formBody;
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});
    final response = await Client().send(request);
    final mJson = jsonDecode(await response.stream.bytesToString());
    return _parseItem(mJson, track, isManga);
  }

  Future<Response> _makeGetRequest(Uri url, String accessToken) async {
    return await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
  }
}
