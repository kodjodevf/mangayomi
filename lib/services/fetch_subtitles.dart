import 'dart:convert';
import 'package:mangayomi/services/http/m_client.dart';

Future<List<ImdbTitle>> fetchImdbTitles(String query) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final url = "https://api.imdbapi.dev/search/titles?query=$query";
    final res = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
      },
    );
    final data = json.decode(res.body) as Map<String, dynamic>;
    return (data["titles"] as List?)
            ?.map((e) => ImdbTitle.fromJson(e))
            .toList() ??
        [];
  } catch (_) {
    return [];
  }
}

Future<List<ImdbEpisode>?> fetchImdbEpisodes(String imdbId) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final url = "https://api.imdbapi.dev/titles/$imdbId/episodes";
    final res = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
      },
    );
    final data = json.decode(res.body) as Map<String, dynamic>;
    return (data["episodes"] as List?)
        ?.map((e) => ImdbEpisode.fromJson(e))
        .toList();
  } catch (_) {
    return null;
  }
}

Future<List<ImdbSubtitle>?> fetchImdbSubtitles(String imdbId) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final url = "https://sub.wyzie.ru/search?id=$imdbId";
    final res = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
      },
    );
    final data = json.decode(res.body) as List?;
    return data
        ?.map((e) => ImdbSubtitle.fromJson(e))
        .where((e) => e.url != null)
        .toList();
  } catch (_) {
    return null;
  }
}

class ImdbTitle {
  final String id;
  final String? type;
  final String primaryTitle;
  final String? originalTitle;
  final String? primaryImage;
  final int? startYear;
  final int? endYear;
  final double? aggregateRating;
  final int? voteCount;

  ImdbTitle({
    required this.id,
    this.type,
    required this.primaryTitle,
    this.originalTitle,
    this.primaryImage,
    this.startYear,
    this.endYear,
    this.aggregateRating,
    this.voteCount,
  });

  factory ImdbTitle.fromJson(Map<String, dynamic> json) {
    return ImdbTitle(
      id: json["id"],
      type: json["type"],
      primaryTitle: json["primaryTitle"] ?? "???",
      originalTitle: json["originalTitle"],
      primaryImage: json["primaryImage"]?["url"],
      startYear: json["startYear"],
      endYear: json["endYear"],
      aggregateRating: json["rating"]?["aggregateRating"] is int
          ? (json["rating"]?["aggregateRating"] as int).toDouble()
          : json["rating"]?["aggregateRating"],
      voteCount: json["rating"]?["voteCount"],
    );
  }
}

class ImdbEpisode {
  final String id;
  final String title;
  final String? primaryImage;
  final String season;
  final String episode;

  ImdbEpisode({
    required this.id,
    required this.title,
    this.primaryImage,
    required this.season,
    required this.episode,
  });

  factory ImdbEpisode.fromJson(Map<String, dynamic> json) {
    return ImdbEpisode(
      id: json["id"],
      title: json["title"] ?? "???",
      primaryImage: json["primaryImage"]?["url"],
      season: json["season"] ?? "?",
      episode: (json["episodeNumber"] as int?)?.toString() ?? "?",
    );
  }
}

class ImdbSubtitle {
  final String id;
  final String? url;
  final String? flagUrl;
  final String? format;
  final String? encoding;
  final String? displayLang;
  final String? language;
  final String? name;
  final bool isHearingImpaired;

  ImdbSubtitle({
    required this.id,
    this.url,
    this.flagUrl,
    this.format,
    this.encoding,
    this.displayLang,
    this.language,
    this.name,
    required this.isHearingImpaired,
  });

  factory ImdbSubtitle.fromJson(Map<String, dynamic> json) {
    return ImdbSubtitle(
      id: json["id"],
      url: json["url"],
      flagUrl: json["flagUrl"],
      format: json["format"],
      encoding: json["encoding"],
      displayLang: json["display"],
      language: json["language"],
      name: json["media"],
      isHearingImpaired: json["isHearingImpaired"] ?? false,
    );
  }
}
