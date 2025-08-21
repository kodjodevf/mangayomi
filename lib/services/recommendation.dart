import 'dart:convert';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/http/m_client.dart';

Future<List<RecommendationResult>?> getRecommendations(
  String name,
  ItemType itemType,
  AlgorithmWeights algorithmWeights,
) async {
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true});
  try {
    final mediaId = await _getSuggest(http, name, itemType);
    return _getRecommendation(
      http,
      mediaId ?? name,
      itemType,
      algorithmWeights,
    );
  } catch (_) {
    return null;
  }
}

Future<List<RecommendationResult>?> _getRecommendation(
  InterceptedClient http,
  String mediaId,
  ItemType itemType,
  AlgorithmWeights algorithmWeights,
) async {
  final url =
      "https://anibrain.ai/api/-/recommender/recs/${itemType != ItemType.anime ? "manga" : "anime"}";
  final res = await http.get(
    Uri.parse(url),
    headers: {
      "priority": "u=1, i",
      "Referer": "https://anibrain.ai/",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
    },
    params: {
      "filterCountry": '[]',
      "filterFormat": '${_fillerType(itemType).map((e) => '"$e"').toList()}',
      "filterGenre": '{}',
      "filterTag": '{"max":{},"min":{}}',
      "filterRelease": '[1930,${DateTime.now().year}]',
      "filterScore": 0,
      "algorithmWeights": _algorithmWeights(algorithmWeights),
      "mediaId": mediaId,
      "mediaType": _mediaType(itemType),
      "adult": false,
      "page": 1,
    },
  );
  final data = json.decode(res.body) as Map<String, dynamic>;
  return (data["data"] as List?)
      ?.map((e) => RecommendationResult.fromJson(e))
      .toList();
}

Future<String?> _getSuggest(
  InterceptedClient http,
  String name,
  ItemType itemType,
) async {
  final url =
      "https://anibrain.ai/api/-/recommender/autosuggest?searchValue=$name&mediaType=${_mediaType(itemType)}&adult=false";
  final res = await http.get(
    Uri.parse(url),
    headers: {
      "priority": "u=1, i",
      "Referer": "https://anibrain.ai/recommender/manga",
      "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36",
    },
  );
  final data = json.decode(res.body) as Map<String, dynamic>;
  final list = (data["data"] as List?)?.map((e) => e["id"]);
  return list?.firstOrNull;
}

String _algorithmWeights(AlgorithmWeights algorithmWeights) {
  final genre = ((algorithmWeights.genre ?? 30) / 100).toStringAsFixed(2);
  final setting = ((algorithmWeights.setting ?? 15) / 100).toStringAsFixed(2);
  final synopsis = ((algorithmWeights.synopsis ?? 40) / 100).toStringAsFixed(2);
  final theme = ((algorithmWeights.theme ?? 20) / 100).toStringAsFixed(2);
  return '{"genre":$genre,"setting":$setting,"synopsis":$synopsis,"theme":$theme}';
}

String _mediaType(ItemType itemType) {
  return switch (itemType) {
    ItemType.manga => "MANGA",
    ItemType.anime => "ANIME",
    ItemType.novel => "NOVEL",
  };
}

List<String> _fillerType(ItemType itemType) {
  return switch (itemType) {
    ItemType.manga => ["MANGA"],
    ItemType.anime => ["movie", "ona", "tv"],
    ItemType.novel => ["NOVEL"],
  };
}

class RecommendationResult {
  final String id;
  final int? anilistId;
  final int? myanimelistId;
  final int score;
  final String? titleRomaji;
  final String? titleEnglish;
  final String? titleNative;
  final String? description;
  final List<String> imgURLs;
  final List<String> genres;

  RecommendationResult({
    required this.id,
    this.anilistId,
    this.myanimelistId,
    required this.score,
    this.titleRomaji,
    this.titleEnglish,
    this.titleNative,
    this.description,
    required this.imgURLs,
    required this.genres,
  });

  factory RecommendationResult.fromJson(Map<String, dynamic> json) {
    return RecommendationResult(
      id: json["id"],
      anilistId: json["anilistId"],
      myanimelistId: json["myanimelistId"],
      score: json["score"],
      titleRomaji: json["titleRomaji"],
      titleEnglish: json["titleEnglish"],
      titleNative: json["titleNative"],
      description: json["description"],
      imgURLs: json["imgURLs"]?.cast<String>() ?? [],
      genres: json["genres"]?.cast<String>() ?? [],
    );
  }
}
