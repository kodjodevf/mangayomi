import 'package:http_interceptor/http_interceptor.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'dart:convert';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'kitsu.g.dart';

@riverpod
class Kitsu extends _$Kitsu {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final String _clientId =
      'dd031b32d2f56c990b1425efe6c42ad847e7fe3ab46bf1299f05ecd856bdb7dd';
  final String _clientSecret =
      '54d7307928f63414defd96399fc31ba847961ceaecef3a5fd93144e960c0e151';
  final String _baseUrl = 'https://kitsu.app/api/edge/';
  final String _loginUrl = 'https://kitsu.app/api/oauth/token';
  final String _algoliaKeyUrl =
      'https://kitsu.app/api/edge/algolia-keys/media/';
  final String _algoliaUrl =
      'https://AWQO5J657S-dsn.algolia.net/1/indexes/production_media/query/';
  final String _algoliaAppId = 'AWQO5J657S';
  String _algoliaFilter(bool isManga) =>
      '&facetFilters=%5B%22kind%3A${isManga ? 'manga' : 'anime'}%22%5D'
      '&attributesToRetrieve=%5B%22synopsis%22%2C%22canonicalTitle%22%2C%22'
      '${isManga ? 'chapter' : 'episode'}Count%22%2C%22posterImage%22%2C%22'
      'startDate%22%2C%22subtype%22%2C%22endDate%22%2C%20%22id%22%5D';

  String _mediaUrl(String type, int id) => 'https://kitsu.app/$type/$id';

  @override
  void build({required int syncId, ItemType? itemType}) {}

  Future<(bool, String)> login(String username, String password) async {
    try {
      final request = MultipartRequest('POST', Uri.parse(_loginUrl));
      request.fields.addAll({
        'username': username,
        'password': password,
        'grant_type': 'password',
        'client_id': _clientId,
        'client_secret': _clientSecret,
      });
      final response = await request.send();
      if (response.statusCode != 200) {
        return (false, "${response.reasonPhrase!} ${response.statusCode}");
      }
      final res =
          jsonDecode(await response.stream.bytesToString())
              as Map<String, dynamic>;
      final aKOAuth = OAuth.fromJson(res)
        ..expiresIn = DateTime.now()
            .add(Duration(seconds: res['expires_in']))
            .millisecondsSinceEpoch;
      final currentUser = await _getCurrentUser(aKOAuth.accessToken!);
      ref
          .read(tracksProvider(syncId: syncId).notifier)
          .login(
            TrackPreference(
              username: currentUser.$1,
              syncId: syncId,
              prefs: jsonEncode({"ratingSystem": currentUser.$2}),
              oAuth: jsonEncode(aKOAuth.toJson()),
            ),
          );

      return (true, "");
    } catch (e) {
      return (false, e.toString());
    }
  }

  Future<Track> update(Track track, bool isManga) async {
    final isNew = track.libraryId == null;
    final String? userId = isNew ? _getUserId() : null;
    final type = isManga ? 'manga' : 'anime';
    final url = Uri.parse(
      '${_baseUrl}library-entries${isNew ? "" : "/${track.libraryId}"}',
    );
    final headers = {
      "Content-Type": "application/vnd.api+json",
      'Authorization': 'Bearer ${_getAccessToken()}',
    };
    final payload = jsonEncode({
      "data": {
        "type": "libraryEntries",
        if (!isNew) "id": track.libraryId,
        "attributes": {
          "status": toKitsuStatus(track.status, isManga),
          "progress": track.lastChapterRead,
          if (!isNew) "ratingTwenty": _toKitsuScore(track.score!),
          if (!isNew) "startedAt": _convertDate(track.startedReadingDate!),
          if (!isNew) "finishedAt": _convertDate(track.finishedReadingDate!),
        },
        if (isNew)
          "relationships": {
            'user': {
              'data': {'id': userId, 'type': 'users'},
            },
            'media': {
              'data': {'id': track.mediaId, 'type': type},
            },
          },
      },
    });
    if (isNew) {
      final response = await http.post(url, headers: headers, body: payload);
      if (response.statusCode != 200) {
        final found = await findLibItem(track, isManga);
        if (found == null) {
          throw Exception('Could not add $type entry for ${track.mediaId}');
        }
        track.libraryId = found.libraryId;
        return track;
      }
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      track.libraryId = int.parse(jsonData['data']['id']);
    } else {
      await http.patch(url, headers: headers, body: payload);
    }
    return track;
  }

  Future<List<TrackSearch>> search(String search, bool isManga) async {
    final accessToken = _getAccessToken();

    final url = Uri.parse(_algoliaKeyUrl);
    final algoliaKeyResponse = await _makeGetRequest(url, accessToken);
    final key = json.decode(algoliaKeyResponse.body)["media"]["key"];
    final response = await http.post(
      Uri.parse(_algoliaUrl),
      headers: {
        "Content-Type": "application/json",
        "X-Algolia-Application-Id": _algoliaAppId,
        "X-Algolia-API-Key": key,
      },
      body: json.encode({
        'params':
            'query=${Uri.encodeComponent(search)}${_algoliaFilter(isManga)}',
      }),
    );
    final data = json.decode(response.body);

    final entries = List<Map<String, dynamic>>.from(
      data['hits'],
    ).where((element) => element["subtype"] != "novel").toList();
    final totalChapter = isManga ? "chapterCount" : "episodeCount";
    return entries
        .map(
          (jsonRes) => TrackSearch(
            libraryId: jsonRes['id'],
            syncId: syncId,
            trackingUrl: _mediaUrl(isManga ? 'manga' : 'anime', jsonRes['id']),
            mediaId: jsonRes['id'],
            summary: jsonRes['synopsis'] ?? "",
            totalChapter: (jsonRes[totalChapter] ?? 0),
            coverUrl: jsonRes['posterImage']['original'] ?? "",
            title: jsonRes['canonicalTitle'],
            startDate: "",
            publishingType: (jsonRes["subtype"] ?? ""),
            publishingStatus: jsonRes['endDate'] == null
                ? "Publishing"
                : "Finished",
            score: jsonRes['averageRating'] is String
                ? double.parse(jsonRes['averageRating'])
                : jsonRes['averageRating'],
          ),
        )
        .toList();
  }

  Future<List<TrackSearch>> fetchGeneralData({
    bool isManga = true,
    String rankingType = "popularityRank",
  }) async {
    final response = await http.get(
      Uri.parse("$_baseUrl${isManga ? "manga" : "anime"}?sort=$rankingType"),
    );
    final data = json.decode(response.body);

    final entries = List<Map<String, dynamic>>.from(
      data['data'],
    ).where((element) => element["subtype"] != "novel").toList();
    final totalChapter = isManga ? "chapterCount" : "episodeCount";
    return entries.map((jsonRes) {
      final mediaId = jsonRes['id'] is String
          ? int.parse(jsonRes['id'])
          : jsonRes['id'];
      final score = jsonRes['attributes']['averageRating'] is String
          ? double.parse(jsonRes['attributes']['averageRating'])
          : jsonRes['attributes']['averageRating'];
      return TrackSearch(
        libraryId: mediaId,
        syncId: syncId,
        trackingUrl: _mediaUrl(isManga ? 'manga' : 'anime', mediaId),
        mediaId: mediaId,
        summary: jsonRes['attributes']['synopsis'] ?? "",
        totalChapter: (jsonRes['attributes'][totalChapter] ?? 0),
        coverUrl: jsonRes['attributes']['posterImage']['original'] ?? "",
        title: jsonRes['attributes']['canonicalTitle'],
        startDate: "",
        score: score,
        publishingType: (jsonRes['attributes']['subtype'] ?? ""),
        publishingStatus: jsonRes['attributes']['endDate'] == null
            ? "Publishing"
            : "Finished",
      );
    }).toList();
  }

  Future<List<TrackSearch>> fetchUserData({bool isManga = true}) async {
    final type = isManga ? "manga" : "anime";
    final userId = _getUserId();
    final accessToken = _getAccessToken();
    final response = await _makeGetRequest(
      Uri.parse("${_baseUrl}library-entries").replace(
        queryParameters: {
          'filter[user_id]': userId,
          'filter[kind]': type,
          'page[limit]': "100",
          'sort': "status,-progressed_at",
          'include': type,
        },
      ),
      accessToken,
    );
    final data = json.decode(response.body);

    final totalChapter = type == 'manga' ? "chapterCount" : "episodeCount";

    final List<TrackSearch> result = [];
    final List<dynamic> dataList = data['data'];
    final List<dynamic> includedList = data['included'];
    for (int i = 0; i < dataList.length; i++) {
      final obj = dataList[i];
      final attributes = obj["attributes"];
      final included = includedList[i]["attributes"];
      final id = int.parse(obj["id"]);
      result.add(
        TrackSearch(
          libraryId: id,
          mediaId: id,
          syncId: syncId,
          trackingUrl: _mediaUrl(type, id),
          summary: included['synopsis'] ?? "",
          totalChapter: included[totalChapter] ?? 0,
          coverUrl: included['posterImage']['original'] ?? "",
          title: included['canonicalTitle'],
          startDate: "",
          publishingType: (included["subtype"] ?? ""),
          publishingStatus: included['endDate'] == null
              ? "Publishing"
              : "Finished",
          score: included['averageRating'] is String
              ? double.parse(included['averageRating'])
              : included['averageRating'],
          status: getKitsuTrackStatus(attributes["status"], type).name,
          lastChapterRead: attributes["progress"],
          startedReadingDate: _parseDate(attributes["startedAt"]),
          finishedReadingDate: _parseDate(attributes["finishedAt"]),
        ),
      );
    }
    return result;
  }

  Future<Track?> findLibItem(Track track, bool isManga) async {
    final type = isManga ? "manga" : "anime";
    final userId = _getUserId();
    final accessToken = _getAccessToken();

    final url = Uri.parse(
      '${_baseUrl}library-entries?filter[${type}_id]=${track.mediaId}&filter[user_id]=$userId&include=$type',
    );
    Response response = await _makeGetRequest(url, accessToken);
    if (response.statusCode == 200) {
      final parsed = parseTrackResponse(response, track, type);
      if (parsed != null) return parsed;
    }
    return await getItem(track, type);
  }

  Future<Response> _makeGetRequest(Uri url, String accessToken) async {
    return await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
    );
  }

  Future<Track?> getItem(Track track, String type) async {
    final accessToken = _getAccessToken();
    final url = Uri.parse(
      '${_baseUrl}library-entries?filter[id]=${track.mediaId}&include=$type',
    );
    Response response = await _makeGetRequest(url, accessToken);
    if (response.statusCode == 200) {
      return parseTrackResponse(response, track, type);
    }
    return null;
  }

  Track? parseTrackResponse(Response response, Track track, String type) {
    final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

    final List<dynamic> data = jsonResponse['data'];

    if (data.isEmpty) return null;

    final obj = data[0];
    final attributes = obj["attributes"];
    final included = jsonResponse['included'][0]["attributes"];
    final id = int.parse(obj["id"]);
    final totalChapter = type == 'manga' ? "chapterCount" : "episodeCount";
    return track
      ..mediaId = id
      ..libraryId = id
      ..syncId = syncId
      ..trackingUrl = _mediaUrl(type, id)
      ..totalChapter = included[totalChapter] ?? 0
      ..status = getKitsuTrackStatus(attributes["status"], type)
      ..score = ((attributes["ratingTwenty"] ?? 0) / 2).toInt()
      ..title = included["canonicalTitle"]
      ..lastChapterRead = attributes["progress"]
      ..startedReadingDate = _parseDate(attributes["startedAt"])
      ..finishedReadingDate = _parseDate(attributes["finishedAt"]);
  }

  Future<(String, String)> _getCurrentUser(String accessToken) async {
    final url = Uri.parse('${_baseUrl}users?filter[self]=true');
    Response response = await _makeGetRequest(url, accessToken);
    final data = json.decode(response.body)['data'][0];
    return (
      data['id'].toString(),
      data['attributes']['ratingSystem'].toString(),
    );
  }

  String _getAccessToken() {
    final track = ref.watch(tracksProvider(syncId: syncId));
    final mAKOAuth = OAuth.fromJson(
      jsonDecode(track!.oAuth!) as Map<String, dynamic>,
    );
    final expiresIn = DateTime.fromMillisecondsSinceEpoch(mAKOAuth.expiresIn!);
    if (DateTime.now().isAfter(expiresIn)) {
      ref.read(tracksProvider(syncId: syncId).notifier).logout();
      botToast("Kitsu Token expired");
      throw Exception("Token expired");
    }
    return mAKOAuth.accessToken!;
  }

  String _getUserId() {
    final track = ref.watch(tracksProvider(syncId: syncId));
    return track!.username!;
  }

  TrackStatus getKitsuTrackStatus(String status, String type) {
    return switch (status) {
      "current" => type == "manga" ? TrackStatus.reading : TrackStatus.watching,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      _ => type == "manga" ? TrackStatus.planToRead : TrackStatus.planToWatch,
    };
  }

  List<TrackStatus> statusList(bool isManga) => [
    isManga ? TrackStatus.reading : TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    isManga ? TrackStatus.planToRead : TrackStatus.planToWatch,
  ];

  String? toKitsuStatus(TrackStatus status, bool isManga) {
    return switch (status) {
      TrackStatus.reading when isManga => "current",
      TrackStatus.watching when !isManga => "current",
      TrackStatus.completed => "completed",
      TrackStatus.onHold => "on_hold",
      TrackStatus.dropped => "dropped",
      _ => "planned",
    };
  }

  var formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "en");
  String? _convertDate(int dateValue) {
    if (dateValue == 0) return null;

    return formatter.format(DateTime.fromMillisecondsSinceEpoch(dateValue));
  }

  int _parseDate(String? date) {
    if (date == null) return 0;

    var dateValue = formatter.parse(date);

    return dateValue.millisecondsSinceEpoch;
  }

  String? _toKitsuScore(int score) {
    return score > 0 ? (score * 2).toString() : null;
  }
}
