import 'dart:developer';
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
  final String _baseUrl = 'https://kitsu.io/api/edge/';
  final String _loginUrl = 'https://kitsu.io/api/oauth/token';
  final String _algoliaKeyUrl = 'https://kitsu.io/api/edge/algolia-keys/media/';
  final String _algoliaUrl =
      'https://AWQO5J657S-dsn.algolia.net/1/indexes/production_media/query/';
  final String _algoliaAppId = 'AWQO5J657S';
  final String _algoliaFilter =
      '&facetFilters=%5B%22kind%3Amanga%22%5D&attributesToRetrieve=%5B%22synopsis%22%2C%22canonicalTitle%22%2C%22chapterCount%22%2C%22posterImage%22%2C%22startDate%22%2C%22subtype%22%2C%22endDate%22%2C%20%22id%22%5D';
  final String _algoliaFilterAnime =
      '&facetFilters=%5B%22kind%3Aanime%22%5D&attributesToRetrieve=%5B%22synopsis%22%2C%22canonicalTitle%22%2C%22episodeCount%22%2C%22posterImage%22%2C%22startDate%22%2C%22subtype%22%2C%22endDate%22%2C%20%22id%22%5D';

  String _mangaUrl(int id) {
    return 'https://kitsu.io/manga/$id';
  }

  String _animeUrl(int id) {
    return 'https://kitsu.io/anime/$id';
  }

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
      final res = jsonDecode(await response.stream.bytesToString())
          as Map<String, dynamic>;
      final aKOAuth = OAuth.fromJson(res);
      final currenUser = await _getCurrentUser(aKOAuth.accessToken!);
      ref.read(tracksProvider(syncId: syncId).notifier).login(TrackPreference(
          username: currenUser.$1,
          syncId: syncId,
          prefs: jsonEncode({"ratingSystem": currenUser.$2}),
          oAuth: jsonEncode(aKOAuth.toJson())));

      return (true, "");
    } catch (e) {
      return (false, e.toString());
    }
  }

  Future<Track?> addLibManga(Track track) async {
    final userId = _getUserId();
    final accessToken = _getAccesToken();
    var data = jsonEncode({
      'data': {
        'type': 'libraryEntries',
        'attributes': {
          'status': toKitsuStatusManga(track.status),
          'progress': track.lastChapterRead
        },
        'relationships': {
          'user': {
            'data': {'id': userId, 'type': 'users'},
          },
          'media': {
            'data': {'id': track.mediaId, 'type': 'manga'},
          },
        },
      },
    });

    var response = await http.post(
      Uri.parse('${_baseUrl}library-entries'),
      headers: {
        'Content-Type': 'application/vnd.api+json',
        'Authorization': 'Bearer $accessToken'
      },
      body: data,
    );
    if (response.statusCode != 200) {
      return await findLibManga(track);
    }

    var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    track.libraryId = int.parse(jsonData['data']['id']);
    return track;
  }

  Future<Track?> addLibAnime(Track track) async {
    final userId = _getUserId();
    log(track.mediaId.toString());
    final accessToken = _getAccesToken();
    var data = jsonEncode({
      'data': {
        'type': 'libraryEntries',
        'attributes': {
          'status': tokitsuStatusAnime(track.status),
          'progress': track.lastChapterRead,
        },
        'relationships': {
          'user': {
            'data': {'id': userId, 'type': 'users'},
          },
          'media': {
            'data': {'id': track.mediaId, 'type': 'anime'},
          },
        },
      },
    });

    var response = await http.post(
      Uri.parse('${_baseUrl}library-entries'),
      headers: {
        'Content-Type': 'application/vnd.api+json',
        'Authorization': 'Bearer $accessToken'
      },
      body: data,
    );
    if (response.statusCode != 200) {
      return await findLibAnime(track);
    }
    var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
    track.libraryId = int.parse(jsonData['data']['id']);
    return track;
  }

  Future<Track> updateLibManga(Track track) async {
    final accessToken = _getAccesToken();
    final data = jsonEncode({
      "data": {
        "type": "libraryEntries",
        "id": track.mediaId,
        "attributes": {
          "status": toKitsuStatusManga(track.status),
          "progress": track.lastChapterRead,
          "ratingTwenty": _toKitsuScore(track.score!),
          "startedAt": _convertDate(track.startedReadingDate!),
          "finishedAt": _convertDate(track.finishedReadingDate!),
        }
      }
    });

    await http.patch(
      Uri.parse('$_baseUrl/library-entries/${track.mediaId}'),
      headers: {
        "Content-Type": "application/vnd.api+json",
        'Authorization': 'Bearer $accessToken'
      },
      body: data,
    );
    return track;
  }

  Future<Track> updateLibAnime(Track track) async {
    final accessToken = _getAccesToken();
    final data = jsonEncode({
      "data": {
        "type": "libraryEntries",
        "id": track.mediaId,
        "attributes": {
          "status": tokitsuStatusAnime(track.status),
          "progress": track.lastChapterRead,
          "ratingTwenty": _toKitsuScore(track.score!),
          "startedAt": _convertDate(track.startedReadingDate!),
          "finishedAt": _convertDate(track.finishedReadingDate!),
        }
      }
    });

    await http.patch(
      Uri.parse('$_baseUrl/library-entries/${track.mediaId}'),
      headers: {
        "Content-Type": "application/vnd.api+json",
        'Authorization': 'Bearer $accessToken'
      },
      body: data,
    );
    return track;
  }

  Future<List<TrackSearch>> search(String search) async {
    final accessToken = _getAccesToken();

    final algoliaKeyResponse = await http.get(
      Uri.parse(_algoliaKeyUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
    );
    final key = json.decode(algoliaKeyResponse.body)["media"]["key"];
    final response = await http.post(
      Uri.parse(_algoliaUrl),
      headers: {
        "Content-Type": "application/json",
        "X-Algolia-Application-Id": _algoliaAppId,
        "X-Algolia-API-Key": key,
      },
      body: json.encode(
          {'params': 'query=${Uri.encodeComponent(search)}$_algoliaFilter'}),
    );
    final data = json.decode(response.body);

    final entries = List<Map<String, dynamic>>.from(data['hits'])
        .where((element) => element["subtype"] != "novel")
        .toList();
    return entries
        .map((jsonRes) => TrackSearch(
            libraryId: jsonRes['id'],
            syncId: syncId,
            trackingUrl: _mangaUrl(jsonRes['id']),
            mediaId: jsonRes['id'],
            summary: jsonRes['synopsis'] ?? "",
            totalChapter: jsonRes['chapterCount'] ?? 0,
            coverUrl: jsonRes['posterImage']['original'] ?? "",
            title: jsonRes['canonicalTitle'],
            startDate: "",
            publishingType: jsonRes["subtype"] ?? "s",
            publishingStatus:
                jsonRes['endDate'] == null ? "Publishing" : "Finished"))
        .toList();
  }

  Future<List<TrackSearch>> searchAnime(String search) async {
    final accessToken = _getAccesToken();

    final algoliaKeyResponse = await http.get(
      Uri.parse(_algoliaKeyUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
    );
    final key = json.decode(algoliaKeyResponse.body)["media"]["key"];
    final response = await http.post(
      Uri.parse(_algoliaUrl),
      headers: {
        "Content-Type": "application/json",
        "X-Algolia-Application-Id": _algoliaAppId,
        "X-Algolia-API-Key": key,
      },
      body: json.encode({
        'params': 'query=${Uri.encodeComponent(search)}$_algoliaFilterAnime'
      }),
    );
    final data = json.decode(response.body);

    final entries = List<Map<String, dynamic>>.from(data['hits'])
        .where((element) => element["subtype"] != "novel")
        .toList();
    return entries
        .map((jsonRes) => TrackSearch(
            libraryId: jsonRes['id'],
            syncId: syncId,
            trackingUrl: _animeUrl(jsonRes['id']),
            mediaId: jsonRes['id'],
            summary: jsonRes['synopsis'] ?? "",
            totalChapter: jsonRes['episodeCount'] ?? 0,
            coverUrl: jsonRes['posterImage']['original'] ?? "",
            title: jsonRes['canonicalTitle'],
            startDate: "",
            publishingType: jsonRes["subtype"] ?? "",
            publishingStatus:
                jsonRes['endDate'] == null ? "Publishing" : "Finished"))
        .toList();
  }

  Future<Track?> getManga(Track track) async {
    final accessToken = _getAccesToken();
    final url = Uri.parse(
        '${_baseUrl}library-entries?filter[id]=${track.mediaId}&include=manga');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final List<dynamic> data = jsonResponse['data'];

      if (data.isNotEmpty) {
        final obj = data[0];
        track.mediaId = int.parse(obj["id"]);
        track.libraryId = int.parse(obj["id"]);
        track.syncId = syncId;
        track.trackingUrl = _mangaUrl(int.parse(obj["id"]));
        track.status = _getKitsuTrackStatusManga(obj["attributes"]["status"]);
        track.title =
            jsonResponse['included'][0]["attributes"]["canonicalTitle"];
        track.totalChapter =
            jsonResponse['included'][0]["attributes"]["chapterCount"] ?? 0;
        track.score = ((obj["attributes"]["ratingTwenty"] ?? 0) / 2).toInt();
        track.lastChapterRead = obj["attributes"]["progress"];
        track.startedReadingDate = _parseDate(obj["attributes"]["startedAt"]);
        track.finishedReadingDate = _parseDate(obj["attributes"]["finishedAt"]);
        return track;
      }
    }
    return null;
  }

  Future<Track?> findLibManga(Track track) async {
    final userId = _getUserId();
    final accessToken = _getAccesToken();
    final url = Uri.parse(
        '${_baseUrl}library-entries?filter[manga_id]=${track.mediaId}&filter[user_id]=$userId&include=manga');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final List<dynamic> data = jsonResponse['data'];

      if (data.isNotEmpty) {
        final obj = data[0];
        track.mediaId = int.parse(obj["id"]);
        track.libraryId = int.parse(obj["id"]);
        track.syncId = syncId;
        track.trackingUrl = _mangaUrl(int.parse(obj["id"]));
        track.title =
            jsonResponse['included'][0]["attributes"]["canonicalTitle"];
        track.totalChapter =
            jsonResponse['included'][0]["attributes"]["chapterCount"] ?? 0;
        track.status = _getKitsuTrackStatusManga(obj["attributes"]["status"]);
        track.score = ((obj["attributes"]["ratingTwenty"] ?? 0) / 2).toInt();
        track.lastChapterRead = obj["attributes"]["progress"];
        track.startedReadingDate = _parseDate(obj["attributes"]["startedAt"]);
        track.finishedReadingDate = _parseDate(obj["attributes"]["finishedAt"]);
        return track;
      }
    }
    return await getManga(track);
  }

  Future<Track?> findLibAnime(Track track) async {
    final userId = _getUserId();
    final accessToken = _getAccesToken();
    final url = Uri.parse(
        '${_baseUrl}library-entries?filter[anime_id]=${track.mediaId}&filter[user_id]=$userId&include=anime');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $accessToken'
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final List<dynamic> data = jsonResponse['data'];
      if (data.isNotEmpty) {
        track.mediaId = int.parse(data[0]["id"]);
        track.libraryId = int.parse(data[0]["id"]);
        track.syncId = syncId;
        track.trackingUrl = _animeUrl(int.parse(data[0]["id"]));
        track.status =
            _getKitsuTrsackStatusAnime(data[0]["attributes"]["status"]);
        track.title =
            jsonResponse['included'][0]["attributes"]["canonicalTitle"];
        track.totalChapter =
            jsonResponse['included'][0]["attributes"]["episodeCount"] ?? 0;
        track.score =
            ((data[0]["attributes"]["ratingTwenty"] ?? 0) / 2).toInt();
        track.lastChapterRead = data[0]["attributes"]["progress"];
        track.startedReadingDate =
            _parseDate(data[0]["attributes"]["startedAt"]);
        track.finishedReadingDate =
            _parseDate(data[0]["attributes"]["finishedAt"]);
        return track;
      }
    }
    return await getAnime(track);
  }

  Future<Track?> getAnime(Track track) async {
    final accessToken = _getAccesToken();
    final url = Uri.parse(
        '${_baseUrl}library-entries?filter[id]=${track.mediaId}&include=anime');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $accessToken'
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final List<dynamic> data = jsonResponse['data'];
      if (data.isNotEmpty) {
        track.mediaId = int.parse(data[0]["id"]);
        track.libraryId = int.parse(data[0]["id"]);
        track.syncId = syncId;
        track.trackingUrl = _animeUrl(int.parse(data[0]["id"]));
        track.status =
            _getKitsuTrsackStatusAnime(data[0]["attributes"]["status"]);
        track.score =
            ((data[0]["attributes"]["ratingTwenty"] ?? 0) / 2).toInt();
        track.title =
            jsonResponse['included'][0]["attributes"]["canonicalTitle"];
        track.totalChapter =
            jsonResponse['included'][0]["attributes"]["episodeCount"] ?? 0;
        track.lastChapterRead = data[0]["attributes"]["progress"];
        track.startedReadingDate =
            _parseDate(data[0]["attributes"]["startedAt"]);
        track.finishedReadingDate =
            _parseDate(data[0]["attributes"]["finishedAt"]);
        return track;
      }
    }
    return null;
  }

  Future<(String, String)> _getCurrentUser(String accessToken) async {
    final response = await http.get(
      Uri.parse("${_baseUrl}users?filter[self]=true"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
    );
    final data = json.decode(response.body)['data'][0];
    return (
      data['id'].toString(),
      data['attributes']['ratingSystem'].toString(),
    );
  }

  String _getAccesToken() {
    final track = ref.watch(tracksProvider(syncId: syncId));
    final mAKOAuth =
        OAuth.fromJson(jsonDecode(track!.oAuth!) as Map<String, dynamic>);
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

  TrackStatus _getKitsuTrsackStatusAnime(String status) {
    return switch (status) {
      "current" => TrackStatus.watching,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      _ => TrackStatus.planToWatch,
    };
  }

  TrackStatus _getKitsuTrackStatusManga(String status) {
    return switch (status) {
      "current" => TrackStatus.reading,
      "completed" => TrackStatus.completed,
      "on_hold" => TrackStatus.onHold,
      "dropped" => TrackStatus.dropped,
      _ => TrackStatus.planToRead,
    };
  }

  List<TrackStatus> kitsuStatusListManga = [
    TrackStatus.reading,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToRead
  ];
  List<TrackStatus> kitsuStatusListAnime = [
    TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToWatch
  ];

  String? toKitsuStatusManga(TrackStatus status) {
    return switch (status) {
      TrackStatus.reading => "current",
      TrackStatus.completed => "completed",
      TrackStatus.onHold => "on_hold",
      TrackStatus.dropped => "dropped",
      _ => "planned",
    };
  }

  String? tokitsuStatusAnime(TrackStatus status) {
    return switch (status) {
      TrackStatus.watching => "current",
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
