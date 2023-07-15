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
  build({required int syncId}) {}

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
      final myAnimeListoAuth =
          MyAnimeListOAuth.fromJson(oAuth as Map<String, dynamic>);
      final username = await _getUserName(myAnimeListoAuth.accessToken!);
      ref.read(tracksProvider(syncId: syncId).notifier).login(TrackPreference(
          syncId: syncId,
          username: username,
          oAuth: jsonEncode(myAnimeListoAuth.toJson())));

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> _getAccesToken() async {
    final track = ref.watch(tracksProvider(syncId: syncId));
    final myAnimeListoAuth = MyAnimeListOAuth.fromJson(
        jsonDecode(track!.oAuth!) as Map<String, dynamic>);
    final expiresIn =
        DateTime.fromMillisecondsSinceEpoch(myAnimeListoAuth.expiresIn!);
    if (DateTime.now().isAfter(expiresIn)) {
      final params = {
        'client_id': clientId,
        'grant_type': 'refresh_token',
        'refresh_token': myAnimeListoAuth.refreshToken,
      };
      final response =
          await http.post(Uri.parse('$baseOAuthUrl/token'), body: params);
      final oAuth = MyAnimeListOAuth.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      final username = await _getUserName(oAuth.accessToken!);
      ref.read(tracksProvider(syncId: syncId).notifier).login(TrackPreference(
          syncId: syncId,
          username: username,
          oAuth: jsonEncode(oAuth.toJson())));
      return oAuth.accessToken!;
    }
    return myAnimeListoAuth.accessToken!;
  }

  Future<List<TrackSearch>> search(String query) async {
    final accessToken = await _getAccesToken();
    final url = Uri.parse('$baseApiUrl/manga').replace(queryParameters: {
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
      final trackSearch = await getMangaDetails(mangaId, accessToken);
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

  TrackStatus _getMALTrackStatus(String status) {
    return switch (status) {
      "reading" => TrackStatus.reading,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      "plan_to_read" => TrackStatus.planToRead,
      _ => TrackStatus.rereading,
    };
  }

  List<TrackStatus> myAnimeListStatusList = [
    TrackStatus.reading,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToRead,
    TrackStatus.rereading
  ];

  String? toMyAnimeListStatus(TrackStatus status) {
    return switch (status) {
      TrackStatus.reading => "reading",
      TrackStatus.completed => "completed",
      TrackStatus.onHold => "on_hold",
      TrackStatus.dropped => "dropped",
      TrackStatus.planToRead => "plan_to_read",
      TrackStatus.rereading => "reading",
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

  Future<Track> findListItem(Track track) async {
    final accessToken = await _getAccesToken();
    final uri = Uri.parse('$baseApiUrl/manga/${track.mediaId}')
        .replace(queryParameters: {
      'fields': 'num_chapters,my_list_status{start_date,finish_date}',
    });
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $accessToken'});
    final mJson = jsonDecode(response.body);
    track.totalChapter = mJson['num_chapters'] ?? 0;
    if (mJson['my_list_status'] != null) {
      track = parseMangaItem(mJson["my_list_status"], track);
    } else {
      track = await updateItem(track);
    }
    return track;
  }

  Future<List<TrackSearch>> findListItems(String query,
      {int offset = 0}) async {
    final accessToken = await _getAccesToken();
    final json = await getListPage(offset);
    final obj = json['data'] as List<dynamic>;
    List<int> mangaIds = obj
        .where((data) => data['node']['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .map((data) => data['node']['id'] as int)
        .toList();
    List<TrackSearch> trackSearchResult = [];
    for (var mangaId in mangaIds) {
      final trackSearch = await getMangaDetails(mangaId, accessToken);
      trackSearchResult.add(trackSearch);
    }

    if (json['paging']['next'] != null) {
      final newV =
          await findListItems(query, offset: offset + listPaginationAmount);
      trackSearchResult.addAll(newV);
    }
    return trackSearchResult;
  }

  Future<Map<String, dynamic>> getListPage(int offset) async {
    final urlBuilder =
        Uri.parse('$baseApiUrl/users/@me/mangalist').replace(queryParameters: {
      'fields': 'list_status{start_date,finish_date}',
      'limit': listPaginationAmount.toString(),
    });
    if (offset > 0) {
      urlBuilder.queryParameters['offset'] = offset.toString();
    }
    final url = urlBuilder.toString();
    final response =
        await http.get(Uri.parse(url), headers: {'X-MAL-CLIENT-ID': clientId});
    return jsonDecode(response.body);
  }

  Track parseMangaItem(Map<String, dynamic> mJson, Track track) {
    bool isRereading = mJson["is_rereading"] ?? false;
    track.status = isRereading
        ? TrackStatus.rereading
        : _getMALTrackStatus(mJson["status"]);
    track.lastChapterRead = int.parse(mJson["num_chapters_read"].toString());
    track.score = int.parse(mJson["score"].toString());
    track.startedReadingDate = parseDate(mJson["start_date"]);
    track.finishedReadingDate = parseDate(mJson["finish_date"]);
    return track;
  }

  int? parseDate(String? isoDate) {
    if (isoDate == null) return null;

    final date = DateFormat('yyyy-MM-dd', 'en_US').parse(isoDate);
    return date.millisecondsSinceEpoch;
  }

  Future<Track> updateItem(Track track) async {
    final accessToken = await _getAccesToken();
    final formBody = {
      'status': (toMyAnimeListStatus(track.status) ?? 'reading').toString(),
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
    return parseMangaItem(mJson, track);
  }
}
