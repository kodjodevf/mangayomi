import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'myanimelist.g.dart';

@riverpod
class MyAnimeList extends _$MyAnimeList {
  String baseOAuthUrl = 'https://myanimelist.net/v1/oauth2';
  String baseApiUrl = 'https://api.myanimelist.net/v2';
  String codeVerifier = "";
  String clientId = (Platform.isWindows || Platform.isLinux)
      ? '39e9be346b4e7dbcc59a98357e2f8472'
      : '0c9100ccd443ddb441a319a881180f7f';
  int listPaginationAmount = 250;

  @override
  build({required int syncId, required bool? isManga}) {}

  Future<bool?> login() async {
    final callbackUrlScheme = (Platform.isWindows || Platform.isLinux)
        ? 'http://localhost:43824'
        : 'mangayomi';
    final loginUrl = _authUrl();

    try {
      final uri = await FlutterWebAuth2.authenticate(
          url: loginUrl, callbackUrlScheme: callbackUrlScheme);
      final queryParams = Uri.parse(uri).queryParameters;
      if (queryParams['code'] == null) return null;

      final oAuth = await _getOAuth(queryParams['code']!);
      final mALOAuth = OAuth.fromJson(oAuth as Map<String, dynamic>);
      final username = await _getUserName(mALOAuth.accessToken!);
      ref.read(tracksProvider(syncId: syncId).notifier).login(TrackPreference(
          syncId: syncId,
          username: username,
          oAuth: jsonEncode(mALOAuth.toJson())));

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> _getAccesToken() async {
    final track = ref.watch(tracksProvider(syncId: syncId));
    final mALOAuth =
        OAuth.fromJson(jsonDecode(track!.oAuth!) as Map<String, dynamic>);
    final expiresIn = DateTime.fromMillisecondsSinceEpoch(mALOAuth.expiresIn!);
    if (DateTime.now().isAfter(expiresIn)) {
      final params = {
        'client_id': clientId,
        'grant_type': 'refresh_token',
        'refresh_token': mALOAuth.refreshToken,
      };
      final response =
          await http.post(Uri.parse('$baseOAuthUrl/token'), body: params);
      final oAuth =
          OAuth.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      final username = await _getUserName(oAuth.accessToken!);
      ref.read(tracksProvider(syncId: syncId).notifier).login(TrackPreference(
          syncId: syncId,
          username: username,
          prefs: "",
          oAuth: jsonEncode(oAuth.toJson())));
      return oAuth.accessToken!;
    }
    return mALOAuth.accessToken!;
  }

  Future<List<TrackSearch>> search(String query) async {
    final accessToken = await _getAccesToken();
    final url = Uri.parse(isManga! ? '$baseApiUrl/manga' : '$baseApiUrl/anime')
        .replace(queryParameters: {
      'q': query.trim(),
      'nsfw': 'true',
    });
    final result =
        await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    List<int> mangaIds =
        (res['data'] as List).map((e) => e['node']["id"] as int).toList();
    List<TrackSearch> trackSearchResult = [];
    for (var mangaId in mangaIds) {
      final trackSearch = isManga!
          ? await getMangaDetails(mangaId, accessToken)
          : await getAnimeDetails(mangaId, accessToken);
      trackSearchResult.add(trackSearch);
    }

    return trackSearchResult
        .where((element) => !element.publishingType!.contains("novel"))
        .toList();
  }

  Future<TrackSearch> getMangaDetails(int id, String accessToken) async {
    final url = Uri.parse('$baseApiUrl/manga/$id').replace(queryParameters: {
      'fields':
          'id,title,synopsis,num_chapters,main_picture,status,media_type,start_date',
    });

    final result =
        await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    return TrackSearch(
        mediaId: res["id"],
        summary: res["synopsis"] ?? "",
        totalChapter: res["num_chapters"],
        coverUrl: res["main_picture"]["large"] ?? "",
        title: res["title"],
        startDate: res["start_date"] ?? "",
        publishingType: res["media_type"].toString().replaceAll("_", " "),
        publishingStatus: res["status"].toString().replaceAll("_", " "),
        trackingUrl: "https://myanimelist.net/manga/${res["id"]}");
  }

  Future<TrackSearch> getAnimeDetails(int id, String accessToken) async {
    final url = Uri.parse('$baseApiUrl/anime/$id').replace(queryParameters: {
      'fields':
          'id,title,synopsis,num_episodes,main_picture,status,media_type,start_date',
    });

    final result =
        await http.get(url, headers: {'Authorization': 'Bearer $accessToken'});
    final res = jsonDecode(result.body) as Map<String, dynamic>;

    return TrackSearch(
        mediaId: res["id"],
        summary: res["synopsis"] ?? "",
        totalChapter: res["num_episodes"],
        coverUrl: res["main_picture"]["large"] ?? "",
        title: res["title"],
        startDate: res["start_date"] ?? "",
        publishingType: res["media_type"].toString().replaceAll("_", " "),
        publishingStatus: res["status"].toString().replaceAll("_", " "),
        trackingUrl: "https://myanimelist.net/anime/${res["id"]}");
  }

  String _convertToIsoDate(int? epochTime) {
    String date = "";
    try {
      date = DateFormat("yyyy-MM-dd", "en_US")
          .format(DateTime.fromMillisecondsSinceEpoch(epochTime!));
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

  TrackStatus _getMALTrackStatusManga(String status) {
    return switch (status) {
      "reading" => TrackStatus.reading,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      "plan_to_read" => TrackStatus.planToRead,
      _ => TrackStatus.rereading,
    };
  }

  TrackStatus _getMALTrackStatusAnime(String status) {
    return switch (status) {
      "watching" => TrackStatus.watching,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      _ => TrackStatus.planToWatch,
    };
  }

  List<TrackStatus> myAnimeListStatusListManga = [
    TrackStatus.reading,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToRead,
    TrackStatus.rereading
  ];
  List<TrackStatus> myAnimeListStatusListAnime = [
    TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToWatch
  ];

  String? toMyAnimeListStatusManga(TrackStatus status) {
    return switch (status) {
      TrackStatus.reading => "reading",
      TrackStatus.completed => "completed",
      TrackStatus.onHold => "on_hold",
      TrackStatus.dropped => "dropped",
      TrackStatus.planToRead => "plan_to_read",
      _ => "reading",
    };
  }

  String? toMyAnimeListStatusAnime(TrackStatus status) {
    return switch (status) {
      TrackStatus.watching => "watching",
      TrackStatus.completed => "completed",
      TrackStatus.onHold => "on_hold",
      TrackStatus.dropped => "dropped",
      _ => "plan_to_watch",
    };
  }

  Future<dynamic> _getOAuth(String code) async {
    final params = {
      'client_id': clientId,
      'code': code,
      'code_verifier': codeVerifier,
      'grant_type': 'authorization_code',
    };
    final response =
        await http.post(Uri.parse('$baseOAuthUrl/token'), body: params);
    return jsonDecode(response.body);
  }

  Future<String> _getUserName(String accessToken) async {
    final response = await http.get(Uri.parse('$baseApiUrl/users/@me'),
        headers: {'Authorization': 'Bearer $accessToken'});
    return jsonDecode(response.body)['name'];
  }

  Future<Track> findManga(Track track) async {
    final accessToken = await _getAccesToken();
    final uri = Uri.parse(isManga!
            ? '$baseApiUrl/manga/${track.mediaId}'
            : '$baseApiUrl/anime/${track.mediaId}')
        .replace(queryParameters: {
      'fields': isManga!
          ? 'num_chapters,my_list_status{start_date,finish_date}'
          : 'num_episodes,my_list_status{start_date,finish_date}',
    });
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $accessToken'});
    final mJson = jsonDecode(response.body);
    track.totalChapter =
        isManga! ? mJson['num_chapters'] ?? 0 : mJson['num_episodes'] ?? 0;
    if (mJson['my_list_status'] != null) {
      track = isManga!
          ? _parseMangaItem(mJson["my_list_status"], track)
          : _parseAnimeItem(mJson["my_list_status"], track);
    } else {
      track = isManga! ? await updateManga(track) : await updateAnime(track);
    }
    return track;
  }

  Track _parseMangaItem(Map<String, dynamic> mJson, Track track) {
    bool isRereading = mJson["is_rereading"] ?? false;
    track.status = isRereading
        ? TrackStatus.rereading
        : _getMALTrackStatusManga(mJson["status"]);
    track.lastChapterRead = int.parse(mJson["num_chapters_read"].toString());
    track.score = int.parse(mJson["score"].toString());
    track.startedReadingDate = _parseDate(mJson["start_date"]);
    track.finishedReadingDate = _parseDate(mJson["finish_date"]);
    return track;
  }

  Track _parseAnimeItem(Map<String, dynamic> mJson, Track track) {
    bool isReWatching = mJson["is_rewatching"] ?? false;
    track.status = isReWatching
        ? TrackStatus.reWatching
        : _getMALTrackStatusAnime(mJson["status"]);
    track.lastChapterRead = int.parse(mJson["num_episodes_watched"].toString());
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

  Future<Track> updateAnime(Track track) async {
    final accessToken = await _getAccesToken();
    final formBody = {
      'status':
          (toMyAnimeListStatusAnime(track.status) ?? 'watching').toString(),
      'is_rewatching': (track.status == TrackStatus.reWatching).toString(),
      'score': track.score.toString(),
      'num_watched_episodes': track.lastChapterRead.toString(),
      if (track.startedReadingDate != null)
        'start_date': _convertToIsoDate(track.startedReadingDate),
      if (track.finishedReadingDate != null)
        'finish_date': _convertToIsoDate(track.finishedReadingDate)
    };
    final request = http.Request(
        'PUT', Uri.parse('$baseApiUrl/anime/${track.mediaId}/my_list_status'));
    request.bodyFields = formBody;
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});
    final response = await http.Client().send(request);
    final mJson = jsonDecode(await response.stream.bytesToString());
    return _parseAnimeItem(mJson, track);
  }

  Future<Track> updateManga(Track track) async {
    final accessToken = await _getAccesToken();
    final formBody = {
      'status':
          (toMyAnimeListStatusManga(track.status) ?? 'reading').toString(),
      'is_rereading': (track.status == TrackStatus.rereading).toString(),
      'score': track.score.toString(),
      'num_chapters_read': track.lastChapterRead.toString(),
      if (track.startedReadingDate != null)
        'start_date': _convertToIsoDate(track.startedReadingDate),
      if (track.finishedReadingDate != null)
        'finish_date': _convertToIsoDate(track.finishedReadingDate)
    };
    final request = http.Request(
        'PUT', Uri.parse('$baseApiUrl/manga/${track.mediaId}/my_list_status'));
    request.bodyFields = formBody;
    request.headers.addAll({'Authorization': 'Bearer $accessToken'});
    final response = await http.Client().send(request);
    final mJson = jsonDecode(await response.stream.bytesToString());
    return _parseMangaItem(mJson, track);
  }
}
