import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/anilist_discovery.dart';

/// Recommendations ("more like this"), backed by AniList's `recommendations`.
///
/// This previously hit anibrain.ai, which permanently shut down in 2026 (its API
/// now redirects to a farewell page), so recommendations silently returned
/// nothing for every title. It now resolves the name to an AniList media id and
/// asks AniList for related titles. Errors propagate on purpose so the screen
/// shows a real message instead of a blank "No result".
///
/// [algorithmWeights] is retained for call-site compatibility; AniList has no
/// tunable weighting, so it is unused.
Future<List<RecommendationResult>?> getRecommendations(
  String name,
  ItemType itemType,
  AlgorithmWeights algorithmWeights,
) async {
  final mediaId = await searchMediaId(itemType, name);
  if (mediaId == null) return const [];
  final recommendations = await fetchRecommendations(mediaId);
  return recommendations.map(RecommendationResult.fromDiscovery).toList();
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

  factory RecommendationResult.fromDiscovery(DiscoveryMedia media) =>
      RecommendationResult(
        id: media.id.toString(),
        anilistId: media.id,
        myanimelistId: media.idMal,
        // AniList has no similarity metric, so surface the title's own score.
        score: media.averageScore ?? 0,
        titleRomaji: media.romaji,
        titleEnglish: media.english,
        titleNative: media.native,
        description: media.description,
        imgURLs: media.coverImage != null ? [media.coverImage!] : const [],
        genres: media.genres,
      );
}
