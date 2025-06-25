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
  static final _isDesktop = Platform.isWindows || Platform.isLinux;
  final String _clientId = _isDesktop ? '13587' : '13588';
  static const String _baseApiUrl = "https://graphql.anilist.co/";
  final String _redirectUri = _isDesktop
      ? 'http://localhost:43824/success?code=1337'
      : 'mangayomi://success?code=1337';
  final String _clientSecret = _isDesktop
      ? 'tJA13cAR2tCCXrJCwwvmwEDbWRoIaahFiJTXToHd'
      : 'G2fFUiGtgFd60D0lCkhgGKvMmrCfDmZXADQIzWXr';

  @override
  void build({required int syncId, ItemType? itemType}) {}

  Future<bool?> login() async {
    final callbackUrlScheme = _isDesktop
        ? 'http://localhost:43824'
        : 'mangayomi';
    final loginUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$_clientId'
        '&redirect_uri=$_redirectUri&response_type=code';

    try {
      final uri = await FlutterWebAuth2.authenticate(
        url: loginUrl,
        callbackUrlScheme: callbackUrlScheme,
      );

      final code = Uri.parse(uri).queryParameters['code'];
      final response = await http.post(
        Uri.parse('https://anilist.co/api/v2/oauth/token'),
        body: {
          'grant_type': 'authorization_code',
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'redirect_uri': _redirectUri,
          'code': code,
        },
      );
      final res = jsonDecode(response.body) as Map<String, dynamic>;
      final aLOAuth = OAuth.fromJson(res)
        ..expiresIn = DateTime.now()
            .add(Duration(seconds: res['expires_in']))
            .millisecondsSinceEpoch;
      final currenUser = await _getCurrentUser(aLOAuth.accessToken!);
      ref
          .read(tracksProvider(syncId: syncId).notifier)
          .login(
            TrackPreference(
              syncId: syncId,
              username: currenUser.$1,
              prefs: jsonEncode({"scoreFormat": currenUser.$2}),
              oAuth: jsonEncode(aLOAuth.toJson()),
            ),
          );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Track> update(Track track, bool isManga) async {
    final isNew = track.libraryId == null;
    final opName = isNew ? 'AddEntry' : 'UpdateEntry';
    final idVarName = isNew ? 'mediaId' : 'id';
    final idVarValue = isNew ? track.mediaId : track.libraryId!;

    final document =
        '''
    mutation $opName(\$$idVarName: Int!, \$progress: Int!, \$status: MediaListStatus${isNew ? '' : ', \$score: Int, \$startedAt: FuzzyDateInput, \$completedAt: FuzzyDateInput'} ) {
      SaveMediaListEntry(
        ${isNew ? 'mediaId' : 'id'}: \$$idVarName,
        progress: \$progress,
        status: \$status,
        ${!isNew ? 'scoreRaw: \$score, startedAt: \$startedAt, completedAt: \$completedAt,' : ''}
      ) {
        id
        status
        progress
      }
    }
    ''';

    final vars = {
      idVarName: idVarValue,
      'progress': track.lastChapterRead,
      'status': toAniListStatus(track.status, isManga),
      if (!isNew) 'score': track.score!,
      if (!isNew) 'startedAt': createDate(track.startedReadingDate!),
      if (!isNew) 'completedAt': createDate(track.finishedReadingDate!),
    };

    final data = await _executeGraphQL(document, vars);
    final entry = data['SaveMediaListEntry'] as Map<String, dynamic>;
    track.libraryId = entry['id'] as int;
    return track;
  }

  Future<List<TrackSearch>> search(String search, bool isManga) async {
    final type = isManga ? "MANGA" : "ANIME";
    final contentUnit = isManga ? "chapters" : "episodes";
    final query =
        '''
    query Search(\$query: String) {
      Page(perPage: 50) {
        media(search: \$query, type: $type, format_not_in: [NOVEL]) {
          id
          title { userPreferred }
          coverImage { large }
          format
          status
          $contentUnit
          description
          startDate { year month day }
          averageScore
        }
      }
    }
    ''';

    final vars = {"query": search};

    final data = await _executeGraphQL(query, vars);

    final entries = List<Map<String, dynamic>>.from(
      data['Page']['media'] as List,
    );
    return entries
        .map(
          (jsonRes) => TrackSearch(
            libraryId: jsonRes['id'],
            syncId: syncId,
            trackingUrl: "",
            mediaId: jsonRes['id'],
            summary: jsonRes['description'] ?? "",
            totalChapter: jsonRes[contentUnit] ?? 0,
            coverUrl: jsonRes['coverImage']['large'] ?? "",
            title: jsonRes['title']['userPreferred'],
            startDate:
                jsonRes["start_date"] ??
                DateTime.fromMillisecondsSinceEpoch(
                  parseDate(jsonRes, 'startDate'),
                ).toString(),
            publishingType: "",
            publishingStatus: jsonRes['status'],
            score: jsonRes["averageScore"] != null
                ? jsonRes["averageScore"] * 1.0
                : 0,
          ),
        )
        .toList();
  }

  Future<Track?> findLibItem(Track track, bool isManga) async {
    final userId = int.parse(
      ref.watch(tracksProvider(syncId: syncId))!.username!,
    );
    final type = isManga ? "MANGA" : "ANIME";
    final typeVar = isManga ? "manga_id" : "anime_id";
    final contentUnit = isManga ? "chapters" : "episodes";

    final query =
        '''
    query(\$id: Int!, \$$typeVar: Int!) {
      Page {
        mediaList(userId: \$id, type: $type, mediaId: \$$typeVar) {
          id
          status
          scoreRaw: score(format: POINT_100)
          progress
          startedAt { year month day }
          completedAt { year month day }
          media {
            id
            title { userPreferred }
            coverImage { large }
            format
            status
            $contentUnit
            description
            startDate { year month day }
          }
        }
      }
    }
    ''';

    final vars = {"id": userId, typeVar: track.mediaId};

    final data = await _executeGraphQL(query, vars);
    final entries = List<Map<String, dynamic>>.from(
      data['Page']['mediaList'] as List,
    );
    if (entries.isEmpty) return null;

    final jsonRes = entries.first;
    return track
      ..libraryId = jsonRes['id'] as int
      ..syncId = syncId
      ..mediaId = jsonRes['media']['id'] as int
      ..status = _getALTrackStatus(jsonRes['status'], isManga)
      ..title = jsonRes['media']['title']['userPreferred'] ?? ''
      ..score = jsonRes['scoreRaw'] as int?
      ..lastChapterRead = jsonRes['progress'] as int? ?? 0
      ..startedReadingDate = parseDate(jsonRes, 'startedAt')
      ..finishedReadingDate = parseDate(jsonRes, 'completedAt')
      ..totalChapter = jsonRes['media'][contentUnit] as int? ?? 0;
  }

  Future<List<TrackSearch>> fetchGeneralData({
    bool isManga = true,
    String rankingType =
        "status: NOT_YET_RELEASED, sort: [POPULARITY_DESC, TRENDING_DESC]",
  }) async {
    final type = isManga ? "MANGA" : "ANIME";
    final contentUnit = isManga ? "chapters" : "episodes";
    final query =
        '''
    query {
      Page(perPage: 50) {
        media(type: $type, format_not_in: [NOVEL], $rankingType) {
          id
          title { userPreferred }
          coverImage { large }
          format
          status
          $contentUnit
          description
          startDate { year month day }
          averageScore
        }
      }
    }
    ''';

    final Map<String, dynamic> vars = {};

    final data = await _executeGraphQL(query, vars);

    final entries = List<Map<String, dynamic>>.from(
      data['Page']['media'] as List,
    );
    return entries
        .map(
          (jsonRes) => TrackSearch(
            libraryId: jsonRes['id'],
            syncId: syncId,
            trackingUrl: "",
            mediaId: jsonRes['id'],
            summary: jsonRes['description'] ?? "",
            totalChapter: jsonRes[contentUnit] ?? 0,
            coverUrl: jsonRes['coverImage']['large'] ?? "",
            title: jsonRes['title']['userPreferred'],
            startDate:
                jsonRes["start_date"] ??
                DateTime.fromMillisecondsSinceEpoch(
                  parseDate(jsonRes, 'startDate'),
                ).toString(),
            publishingType: "",
            publishingStatus: jsonRes['status'],
            score: jsonRes["averageScore"] != null
                ? jsonRes["averageScore"] * 1.0
                : 0,
          ),
        )
        .toList();
  }

  Future<List<TrackSearch>> fetchUserData({bool isManga = true}) async {
    final userId = int.parse(
      ref.watch(tracksProvider(syncId: syncId))!.username!,
    );
    final type = isManga ? "MANGA" : "ANIME";
    final contentUnit = isManga ? "chapters" : "episodes";

    final query =
        '''
    query(\$id: Int!) {
      Page {
        mediaList(userId: \$id, type: $type, status: CURRENT) {
          id
          status
          scoreRaw: score(format: POINT_100)
          progress
          startedAt { year month day }
          completedAt { year month day }
          media {
            id
            title { userPreferred }
            coverImage { large }
            format
            status
            $contentUnit
            description
            startDate { year month day }
            averageScore
          }
        }
      }
    }
    ''';

    final vars = {"id": userId};

    final data = await _executeGraphQL(query, vars);

    final entries = List<Map<String, dynamic>>.from(
      data['Page']['mediaList'] as List,
    );
    return entries
        .map(
          (jsonRes) => TrackSearch(
            libraryId: jsonRes['id'],
            syncId: syncId,
            trackingUrl: "",
            mediaId: jsonRes['media']['id'],
            summary: jsonRes['media']['description'] ?? "",
            totalChapter: jsonRes['media'][contentUnit] ?? 0,
            coverUrl: jsonRes['media']['coverImage']['large'] ?? "",
            title: jsonRes['media']['title']['userPreferred'],
            startDate:
                jsonRes['media']["start_date"] ??
                DateTime.fromMillisecondsSinceEpoch(
                  parseDate(jsonRes['media'], 'startDate'),
                ).toString(),
            publishingType: "",
            publishingStatus: jsonRes['media']['status'],
            score: jsonRes['media']['averageScore'] != null
                ? jsonRes['media']['averageScore'] * 1.0
                : 0,
            status: _getALTrackStatus(jsonRes['status'], isManga).name,
            lastChapterRead: jsonRes['progress'] as int? ?? 0,
            startedReadingDate: parseDate(jsonRes, 'startedAt'),
            finishedReadingDate: parseDate(jsonRes, 'completedAt'),
          ),
        )
        .toList();
  }

  Future<Map<String, dynamic>> _executeGraphQL(
    String document,
    Map<String, dynamic> variables,
  ) async {
    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await _getAccessToken()}',
      },
      body: jsonEncode({'query': document, 'variables': variables}),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return decoded['data'] as Map<String, dynamic>;
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

    final body = {"query": query};

    final response = await http.post(
      Uri.parse(_baseApiUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(body),
    );
    final data = json.decode(response.body);

    final viewer = data['data']['Viewer'];
    return (
      viewer['id'].toString(),
      viewer['mediaListOptions']['scoreFormat'].toString(),
    );
  }

  Future<String> _getAccessToken() async {
    final track = ref.watch(tracksProvider(syncId: syncId));
    final mALOAuth = OAuth.fromJson(
      jsonDecode(track!.oAuth!) as Map<String, dynamic>,
    );
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
        _ => "5",
      },
      "POINT_3" => switch (score) {
        0 => "0",
        <= 35 => ":(",
        <= 60 => ":|",
        _ => ":)",
      },
      "POINT_10_DECIMAL" => (score / 10).toString(),
      _ => throw ("Unknown score type"),
    };
  }

  TrackStatus _getALTrackStatus(String status, bool isManga) {
    return switch (status) {
      "CURRENT" => isManga ? TrackStatus.reading : TrackStatus.watching,
      "COMPLETED" => TrackStatus.completed,
      "PAUSED" => TrackStatus.onHold,
      "DROPPED" => TrackStatus.dropped,
      "PLANNING" => isManga ? TrackStatus.planToRead : TrackStatus.planToWatch,
      _ => isManga ? TrackStatus.reReading : TrackStatus.reWatching,
    };
  }

  List<TrackStatus> statusList(bool isManga) => [
    isManga ? TrackStatus.reading : TrackStatus.watching,
    TrackStatus.completed,
    TrackStatus.onHold,
    TrackStatus.dropped,
    isManga ? TrackStatus.planToRead : TrackStatus.planToWatch,
    isManga ? TrackStatus.reReading : TrackStatus.reWatching,
  ];

  String? toAniListStatus(TrackStatus status, bool isManga) {
    return switch (status) {
      TrackStatus.reading when isManga => "CURRENT",
      TrackStatus.watching when !isManga => "CURRENT",
      TrackStatus.completed => "COMPLETED",
      TrackStatus.onHold => "PAUSED",
      TrackStatus.dropped => "DROPPED",
      TrackStatus.planToRead when isManga => "PLANNING",
      TrackStatus.planToWatch when !isManga => "PLANNING",
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
      return {"year": null, "month": null, "day": null};
    }

    final date = DateTime.fromMillisecondsSinceEpoch(dateValue);
    return {"year": date.year, "month": date.month, "day": date.day};
  }

  String displayScore(int score) {
    final prefs = isar.trackPreferences.getSync(syncId)!.prefs;
    final scoreFormat = jsonDecode(prefs!)['scoreFormat'];
    return switch (scoreFormat) {
      'POINT_5' => switch (score) {
        0 => "0 ★",
        _ => "${(score + 10) ~/ 20} ★",
      },
      'POINT_3' => switch (score) {
        0 => "-",
        <= 35 => "😦",
        <= 60 => "😐",
        _ => "😊",
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
