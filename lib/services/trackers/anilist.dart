import 'dart:io';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'dart:convert';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/more/settings/track/myanimelist/model.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'anilist.g.dart';

@riverpod
class Anilist extends _$Anilist {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  final String _clientId =
      (Platform.isWindows || Platform.isLinux) ? '13587' : '13588';
  static const String _baseApiUrl = "https://graphql.anilist.co/";
  final String _redirectUri = (Platform.isWindows || Platform.isLinux)
      ? 'http://localhost:43824/success?code=1337'
      : 'mangayomi://success?code=1337';
  final String _clientSecret = (Platform.isWindows || Platform.isLinux)
      ? 'tJA13cAR2tCCXrJCwwvmwEDbWRoIaahFiJTXToHd'
      : 'G2fFUiGtgFd60D0lCkhgGKvMmrCfDmZXADQIzWXr';

  @override
  void build({required int syncId, ItemType? itemType}) {}

  Future<bool?> login() async {
    final callbackUrlScheme = (Platform.isWindows || Platform.isLinux)
        ? 'http://localhost:43824'
        : 'mangayomi';
    final loginUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$_clientId&redirect_uri=$_redirectUri&response_type=code';

    try {
      final uri = await FlutterWebAuth2.authenticate(
          url: loginUrl, callbackUrlScheme: callbackUrlScheme);

      final code = Uri.parse(uri).queryParameters['code'];
      final response = await http.post(
        Uri.parse('https://anilist.co/api/v2/oauth/token'),
        body: {
          'grant_type': 'authorization_code',
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'redirect_uri': _redirectUri,
          'code': code
        },
      );
      final res = jsonDecode(response.body) as Map<String, dynamic>;
      final aLOAuth = OAuth.fromJson(res);
      final currenUser = await _getCurrentUser(aLOAuth.accessToken!);
      ref.read(tracksProvider(syncId: syncId).notifier).login(TrackPreference(
          syncId: syncId,
          username: currenUser.$1,
          prefs: jsonEncode({"scoreFormat": currenUser.$2}),
          oAuth: jsonEncode(aLOAuth.toJson())));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Track> addLibManga(Track track) async {
    final accessToken = await _getAccesToken();

    const query = '''
    mutation AddManga(\$mangaId: Int, \$progress: Int, \$status: MediaListStatus) {
      SaveMediaListEntry(mediaId: \$mangaId, progress: \$progress, status: \$status) {
        id
        status
      }
    }
    ''';

    final body = {
      "query": query,
      "variables": {
        "mangaId": track.mediaId,
        "progress": track.lastChapterRead,
        "status": toAniListStatusManga(track.status),
      }
    };

    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );
    final data = json.decode(response.body);
    track.libraryId = data['data']['SaveMediaListEntry']['id'];
    return track;
  }

  Future<Track> addLibAnime(Track track) async {
    final accessToken = await _getAccesToken();

    const query = '''
    mutation AddAnime(\$animeId: Int, \$progress: Int, \$status: MediaListStatus) {
      SaveMediaListEntry(mediaId: \$animeId, progress: \$progress, status: \$status) {
        id
        status
      }
    }
    ''';
    final body = {
      "query": query,
      "variables": {
        "animeId": track.mediaId,
        "progress": track.lastChapterRead,
        "status": toAniListStatusAnime(track.status),
      }
    };

    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );
    final data = json.decode(response.body);
    track.libraryId = data['data']['SaveMediaListEntry']['id'];
    return track;
  }

  Future<Track> updateLibManga(Track track) async {
    final accessToken = await _getAccesToken();
    const query = '''
    mutation UpdateManga(\$listId: Int, \$progress: Int, \$status: MediaListStatus, \$score: Int, \$startedAt: FuzzyDateInput, \$completedAt: FuzzyDateInput) {
      SaveMediaListEntry(
        id: \$listId,
        progress: \$progress,
        status: \$status,
        scoreRaw: \$score,
        startedAt: \$startedAt,
        completedAt: \$completedAt,
      ) {
        id
        status
        progress
      }
    }
    ''';

    final body = {
      "query": query,
      "variables": {
        "listId": track.libraryId,
        "progress": track.lastChapterRead,
        "status": toAniListStatusManga(track.status),
        "score": track.score!,
        "startedAt": createDate(track.startedReadingDate!),
        "completedAt": createDate(track.finishedReadingDate!),
      }
    };

    await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );
    return track;
  }

  Future<Track> updateLibAnime(Track track) async {
    final accessToken = await _getAccesToken();
    const query = '''
    mutation UpdateAnime(\$listId: Int, \$progress: Int, \$status: MediaListStatus, \$score: Int, \$startedAt: FuzzyDateInput, \$completedAt: FuzzyDateInput) {
      SaveMediaListEntry(
        id: \$listId,
        progress: \$progress,
        status: \$status,
        scoreRaw: \$score,
        startedAt: \$startedAt,
        completedAt: \$completedAt,
      ) {
        id
        status
        progress
      }
    }
    ''';

    final body = {
      "query": query,
      "variables": {
        "listId": track.libraryId,
        "progress": track.lastChapterRead,
        "status": toAniListStatusAnime(track.status),
        "score": track.score!,
        "startedAt": createDate(track.startedReadingDate!),
        "completedAt": createDate(track.finishedReadingDate!),
      }
    };
    await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );
    return track;
  }

  Future<List<TrackSearch>> search(String search) async {
    final accessToken = await _getAccesToken();
    const query = '''
    query Search(\$query: String) {
      Page(perPage: 50) {
        media(search: \$query, type: MANGA, format_not_in: [NOVEL]) {
          id
          title {
            userPreferred
          }
          coverImage {
            large
          }
          format
          status
          chapters
          description
          startDate {
            year
            month
            day
          }
        }
      }
    }
    ''';

    final body = {
      "query": query,
      "variables": {
        "query": search,
      }
    };

    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );

    final data = json.decode(response.body);

    final entries =
        List<Map<String, dynamic>>.from(data['data']['Page']['media']);
    return entries
        .map((jsonRes) => TrackSearch(
            libraryId: jsonRes['id'],
            syncId: syncId,
            trackingUrl: "",
            mediaId: jsonRes['id'],
            summary: jsonRes['description'] ?? "",
            totalChapter: jsonRes['chapters'] ?? 0,
            coverUrl: jsonRes['coverImage']['large'] ?? "",
            title: jsonRes['title']['userPreferred'],
            startDate: jsonRes["start_date"] ??
                DateTime.fromMillisecondsSinceEpoch(
                        parseDate(jsonRes, 'startDate'))
                    .toString(),
            publishingType: "",
            publishingStatus: jsonRes['status']))
        .toList();
  }

  Future<List<TrackSearch>> searchAnime(String search) async {
    final accessToken = await _getAccesToken();
    const query = '''
    query Search(\$query: String) {
      Page(perPage: 50) {
        media(search: \$query, type: ANIME) {
          id
          title {
            userPreferred
          }
          coverImage {
            large
          }
          format
          status
          episodes
          description
          startDate {
            year
            month
            day
          }
        }
      }
    }
    ''';

    final body = {
      "query": query,
      "variables": {
        "query": search,
      }
    };

    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );

    final data = json.decode(response.body);

    final entries =
        List<Map<String, dynamic>>.from(data['data']['Page']['media']);
    return entries
        .map((jsonRes) => TrackSearch(
            libraryId: jsonRes['id'],
            syncId: syncId,
            trackingUrl: "",
            mediaId: jsonRes['id'],
            summary: jsonRes['description'] ?? "",
            totalChapter: jsonRes['episodes'] ?? 0,
            coverUrl: jsonRes['coverImage']['large'] ?? "",
            title: jsonRes['title']['userPreferred'],
            startDate: jsonRes["start_date"] ??
                DateTime.fromMillisecondsSinceEpoch(
                        parseDate(jsonRes, 'startDate'))
                    .toString(),
            publishingType: "",
            publishingStatus: jsonRes['status']))
        .toList();
  }

  Future<Track?> findLibManga(
    Track track,
  ) async {
    final userId = ref.watch(tracksProvider(syncId: syncId))!.username;

    final accessToken = await _getAccesToken();
    const query = '''
    query(\$id: Int!, \$manga_id: Int!) {
      Page {
        mediaList(userId: \$id, type: MANGA, mediaId: \$manga_id) {
          id
          status
          scoreRaw: score(format: POINT_100)
          progress
          startedAt {
            year
            month
            day
          }
          completedAt {
            year
            month
            day
          }
          media {
            id
            title {
              userPreferred
            }
            coverImage {
              large
            }
            format
            status
            chapters
            description
            startDate {
              year
              month
              day
            }
          }
        }
      }
    }
    ''';

    final body = {
      "query": query,
      "variables": {
        "id": int.parse(userId!),
        "manga_id": track.mediaId,
      }
    };

    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );
    final data = json.decode(response.body);
    final entries =
        List<Map<String, dynamic>>.from(data['data']['Page']['mediaList']);
    if (entries.isNotEmpty) {
      final jsonRes = entries.first;
      track.libraryId = jsonRes['id'];
      track.syncId = syncId;
      track.mediaId = jsonRes['media']['id'];
      track.status = _getALTrackStatusManga(jsonRes['status']);
      track.title = jsonRes['media']['title']['userPreferred'] ?? '';
      track.score = jsonRes['scoreRaw'] ?? 0;
      track.lastChapterRead = jsonRes['progress'] ?? 0;
      track.startedReadingDate = parseDate(jsonRes, 'startedAt');
      track.finishedReadingDate = parseDate(jsonRes, 'completedAt');
      track.totalChapter = jsonRes['media']["chapters"] ?? 0;
    }
    return entries.isNotEmpty ? track : null;
  }

  Future<Track?> findLibAnime(
    Track track,
  ) async {
    final userId = ref.watch(tracksProvider(syncId: syncId))!.username;

    final accessToken = await _getAccesToken();
    const query = '''
    query(\$id: Int!, \$anime_id: Int!) {
      Page {
        mediaList(userId: \$id, type: ANIME, mediaId: \$anime_id) {
          id
          status
          scoreRaw: score(format: POINT_100)
          progress
          startedAt {
            year
            month
            day
          }
          completedAt {
            year
            month
            day
          }
          media {
            id
            title {
              userPreferred
            }
            coverImage {
              large
            }
            format
            status
            episodes
            description
            startDate {
              year
              month
              day
            }
          }
        }
      }
    }
    ''';

    final body = {
      "query": query,
      "variables": {
        "id": int.parse(userId!),
        "anime_id": track.mediaId,
      }
    };

    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );
    final data = json.decode(response.body);
    final entries =
        List<Map<String, dynamic>>.from(data['data']['Page']['mediaList']);
    if (entries.isNotEmpty) {
      final jsonRes = entries.first;
      track.libraryId = jsonRes['id'];
      track.syncId = syncId;
      track.mediaId = jsonRes['media']['id'];
      track.status = _getALTrackStatusAnime(jsonRes['status']);
      track.title = jsonRes['media']['title']['userPreferred'] ?? '';
      track.score = jsonRes['scoreRaw'] ?? 0;
      track.lastChapterRead = jsonRes['progress'] ?? 0;
      track.startedReadingDate = parseDate(jsonRes, 'startedAt');
      track.finishedReadingDate = parseDate(jsonRes, 'completedAt');
      track.totalChapter = jsonRes['media']["episodes"] ?? 0;
    }
    return entries.isNotEmpty ? track : null;
  }

  Future<(String, String)> _getCurrentUser(String accessToken) async {
    const query = '''
    query User {
      Viewer {
        id
        mediaListOptions {
          scoreFormat
        }
      }
    }
    ''';

    final body = {
      "query": query,
    };

    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(body),
    );
    final data = json.decode(response.body);

    final viewer = data['data']['Viewer'];
    return (
      viewer['id'].toString(),
      viewer['mediaListOptions']['scoreFormat'].toString()
    );
  }

  Future<String> _getAccesToken() async {
    final track = ref.watch(tracksProvider(syncId: syncId));
    final mALOAuth =
        OAuth.fromJson(jsonDecode(track!.oAuth!) as Map<String, dynamic>);
    final expiresIn = DateTime.fromMillisecondsSinceEpoch(mALOAuth.expiresIn!);
    if (DateTime.now().isAfter(expiresIn)) {
      ref.read(tracksProvider(syncId: syncId).notifier).logout();
      botToast("Anilist Token expired");
      throw Exception("Token expired");
    }
    return mALOAuth.accessToken!;
  }

  String _toAnilistScore(int score) {
    final prefs = isar.trackPreferences.getSync(syncId)!.prefs;
    final scoreFormat = jsonDecode(prefs!)['scoreFormat'];
    return switch (scoreFormat) {
      "POINT_10" => (score / 10).toString(),
      "POINT_100" => score.toString(),
      "POINT_5" => switch (score) {
          0 => "0",
          < 30 => "1",
          < 50 => "2",
          < 70 => "3",
          < 90 => "4",
          _ => "5"
        },
      "POINT_3" => switch (score) {
          0 => "0",
          <= 35 => ":(",
          <= 60 => ":|",
          _ => ":)"
        },
      "POINT_10_DECIMAL" => (score / 10).toString(),
      _ => throw ("Unknown score type")
    };
  }

  TrackStatus _getALTrackStatusManga(String status) {
    return switch (status) {
      "CURRENT" => TrackStatus.reading,
      "COMPLETED" => TrackStatus.completed,
      "PAUSED" => TrackStatus.onHold,
      "DROPPED" => TrackStatus.dropped,
      "PLANNING" => TrackStatus.planToRead,
      _ => TrackStatus.rereading,
    };
  }

  TrackStatus _getALTrackStatusAnime(String status) {
    return switch (status) {
      "CURRENT" => TrackStatus.watching,
      "COMPLETED" => TrackStatus.completed,
      "PAUSED" => TrackStatus.onHold,
      "DROPPED" => TrackStatus.dropped,
      "PLANNING" => TrackStatus.planToWatch,
      _ => TrackStatus.reWatching,
    };
  }

  List<TrackStatus> aniListStatusListManga = [
    TrackStatus.reading,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToRead,
    TrackStatus.rereading
  ];
  List<TrackStatus> aniListStatusListAnime = [
    TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    TrackStatus.planToWatch,
    TrackStatus.reWatching
  ];

  String? toAniListStatusManga(TrackStatus status) {
    return switch (status) {
      TrackStatus.reading => "CURRENT",
      TrackStatus.completed => "COMPLETED",
      TrackStatus.onHold => "PAUSED",
      TrackStatus.dropped => "DROPPED",
      TrackStatus.planToRead => "PLANNING",
      _ => "REPEATING",
    };
  }

  String? toAniListStatusAnime(TrackStatus status) {
    return switch (status) {
      TrackStatus.watching => "CURRENT",
      TrackStatus.completed => "COMPLETED",
      TrackStatus.onHold => "PAUSED",
      TrackStatus.dropped => "DROPPED",
      TrackStatus.planToWatch => "PLANNING",
      _ => "REPEATING",
    };
  }

  int parseDate(Map<String, dynamic> json, String dateKey) {
    try {
      final year = json[dateKey]['year'];
      final month = json[dateKey]['month'];
      final day = json[dateKey]['day'];
      final date = DateTime(year, month, day);
      return date.millisecondsSinceEpoch;
    } catch (_) {
      return DateTime(1970, 01, 01).millisecondsSinceEpoch;
    }
  }

  Map<String, dynamic> createDate(int dateValue) {
    if (dateValue == 0) {
      return {
        "year": null,
        "month": null,
        "day": null,
      };
    }

    final date = DateTime.fromMillisecondsSinceEpoch(dateValue);
    return {
      "year": date.year,
      "month": date.month,
      "day": date.day,
    };
  }

  String displayScore(int score) {
    final prefs = isar.trackPreferences.getSync(syncId)!.prefs;
    final scoreFormat = jsonDecode(prefs!)['scoreFormat'];
    return switch (scoreFormat) {
      'POINT_5' => switch (score) {
          0 => "0 ★",
          _ => "${(score + 10) ~/ 20} ★"
        },
      'POINT_3' => switch (score) {
          0 => "-",
          <= 35 => "😦",
          <= 60 => "😐",
          _ => "😊"
        },
      _ => _toAnilistScore(score),
    };
  }

  (int, int) getScoreValue() {
    final prefs = isar.trackPreferences.getSync(syncId)!.prefs;
    String scoreFormat = jsonDecode(prefs!)['scoreFormat'];
    return switch (scoreFormat) {
      'POINT_10' => (100, 10),
      'POINT_100' => (100, 1),
      'POINT_5' => (100, 20),
      'POINT_3' => (100, 30),
      _ => (100, 1),
    };
  }
}
