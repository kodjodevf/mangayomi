import 'dart:convert';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'aniskip.g.dart';

// credits: https://github.com/aniyomiorg/aniyomi/blob/master/app/src/main/java/eu/kanade/tachiyomi/util/AniSkipApi.kt
@riverpod
class AniSkip extends _$AniSkip {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  @override
  void build() {}

  Future<List<Results>?> getResult((int, int) id, int episodeNumber, double episodeLength) async {
    try {
      final malId = await _getMalId(id);

      final url =
          "https://api.aniskip.com/v2/skip-times/$malId/$episodeNumber?types[]=ed&types[]=mixed-ed&types[]=mixed-op&types[]=op&types[]=recap&episodeLength=$episodeLength";
      final response = await http.get(Uri.parse(url));
      final res = AniSkipResponse.fromJson(json.decode(response.body));

      return (res.found ?? false) ? res.results : null;
    } catch (_) {
      return null;
    }
  }

  Future<int> _getMalId((int, int) id) async {
    if (id.$2 == 1) return id.$1;
    if (id.$2 != 2) throw "";

    final query = """
      query{
        Media(id:${id.$1}){idMal}
      }
    """;
    final response = await http.post(
      Uri.parse("https://graphql.anilist.co"),
      body: json.encode({"query": query}),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body)["data"]["Media"]["idMal"] ?? 0;
  }
}

class AniSkipResponse {
  bool? found;
  List<Results>? results;
  String? message;
  int? statusCode;

  AniSkipResponse({this.found, this.results, this.message, this.statusCode});

  factory AniSkipResponse.fromJson(Map<String, dynamic> json) {
    return AniSkipResponse(
      found: json['found'],
      results: (json['results'] as List?)?.map((e) => Results.fromJson(e)).toList(),
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }
}

class Results {
  Interval? interval;
  String? skipType;
  String? skipId;
  double? episodeLength;

  Results({this.interval, this.skipType, this.skipId, this.episodeLength});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      interval: Interval.fromJson(json['interval']),
      skipType: json['skipType'],
      skipId: json['skipId'],
      episodeLength: json['episodeLength'],
    );
  }
}

class Interval {
  double? startTime;
  double? endTime;

  Interval({this.startTime, this.endTime});

  factory Interval.fromJson(Map<String, dynamic> json) {
    return Interval(
      startTime: double.parse(json['startTime'].toString()),
      endTime: double.parse(json['endTime'].toString()),
    );
  }
}
