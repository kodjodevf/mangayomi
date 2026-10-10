import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/media_catalog_resolver.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/discovery/search_target.dart';
import 'package:mangayomi/services/discovery/trakt_discovery.dart';

/// Recommendations for the title represented by [media].
///
/// Anime, manga and novels keep the existing AniList behavior. Mixed video
/// catalogs require an exact AniList title, year, and format match before they
/// use anime discovery; a clean miss uses Trakt. Provider failures still
/// surface instead of silently reclassifying the title.
///
/// Errors propagate so the screen can show the provider's real failure instead
/// of pretending that an unavailable service found no matches.
///
/// [algorithmWeights] is retained for call-site compatibility. Neither AniList
/// nor Trakt exposes compatible weighting controls, so it is unused.
Future<List<RecommendationResult>> getRecommendations(
  MediaLookupContext media,
  AlgorithmWeights algorithmWeights, {
  TraktDiscovery? trakt,
  MediaCatalogResolver? catalogResolver,
}) async {
  final discovery = trakt ?? TraktDiscovery();
  final resolved =
      await (catalogResolver ?? MediaCatalogResolver(trakt: discovery)).resolve(
        media,
      );
  if (resolved.catalog == DiscoveryCatalog.trakt) {
    final traktType = _traktType(media.kind);
    if (traktType == null) return const [];
    final root =
        resolved.traktRoot ??
        await _resolveTraktRoot(media, discovery, traktType);
    if (root == null) return const [];
    final recommendations = await discovery.fetchRecommendations(root);
    return recommendations
        .map(RecommendationResult.fromTrakt)
        .toList(growable: false);
  }

  final mediaId =
      resolved.anilistId ?? await searchMediaId(media.itemType, media.title);
  if (mediaId == null) return const [];
  final recommendations = await fetchRecommendations(mediaId);
  return recommendations
      .map(
        (recommendation) => RecommendationResult.fromDiscovery(
          recommendation,
          itemType: media.itemType,
        ),
      )
      .toList(growable: false);
}

Future<TraktRootMedia?> _resolveTraktRoot(
  MediaLookupContext media,
  TraktDiscovery discovery,
  TraktMediaType type,
) async {
  if (media.tmdbId case final int tmdbId) {
    final exact = await discovery.resolveByTmdbId(tmdbId: tmdbId, type: type);
    if (exact != null) return exact;
  }
  if (media.traktId case final int traktId) {
    final exact = await discovery.resolveByTraktId(
      traktId: traktId,
      type: type,
    );
    if (exact != null) return exact;
  }
  if (media.title.trim().isEmpty) return null;
  return discovery.resolveByTitle(
    title: media.title,
    year: media.year,
    type: type,
  );
}

TraktMediaType? _traktType(MediaKind kind) => switch (kind) {
  MediaKind.movie => TraktMediaType.movie,
  MediaKind.show => TraktMediaType.show,
  MediaKind.unknown || MediaKind.anime => null,
};

enum RecommendationProvider { anilist, trakt }

/// A catalog rating and its scale.
///
/// Neither AniList nor Trakt returns a similarity percentage. Keeping the
/// provider scale prevents a Trakt 8.7/10 rating from being rendered as 8%.
class CatalogRating {
  const CatalogRating({
    required this.value,
    required this.maximum,
    required this.provider,
  });

  final double value;
  final double maximum;
  final RecommendationProvider provider;

  String get valueLabel {
    if (maximum == 10) return '${value.toStringAsFixed(1)}/10';
    if (maximum == 100) return '${value.round()}%';
    return '${value.toStringAsFixed(1)}/${maximum.toStringAsFixed(0)}';
  }
}

class RecommendationResult {
  const RecommendationResult({
    required this.id,
    required this.provider,
    required this.kind,
    required this.searchTarget,
    required this.imgURLs,
    required this.genres,
    this.anilistId,
    this.myanimelistId,
    this.traktId,
    this.tmdbId,
    this.year,
    this.rating,
    this.titleRomaji,
    this.titleEnglish,
    this.titleNative,
    this.description,
  });

  final String id;
  final RecommendationProvider provider;
  final MediaKind kind;
  final SearchTarget searchTarget;
  final int? anilistId;
  final int? myanimelistId;
  final int? traktId;
  final int? tmdbId;
  final int? year;
  final CatalogRating? rating;
  final String? titleRomaji;
  final String? titleEnglish;
  final String? titleNative;
  final String? description;
  final List<String> imgURLs;
  final List<String> genres;

  String get title =>
      titleEnglish ?? titleRomaji ?? titleNative ?? searchTarget.query;

  factory RecommendationResult.fromDiscovery(
    DiscoveryMedia media, {
    required ItemType itemType,
  }) => RecommendationResult(
    id: 'anilist:${media.id}',
    provider: RecommendationProvider.anilist,
    kind: media.isAnime ? MediaKind.anime : MediaKind.unknown,
    searchTarget: SearchTarget(query: media.title, itemType: itemType),
    anilistId: media.id,
    myanimelistId: media.idMal,
    year: media.seasonYear,
    rating: media.averageScore == null
        ? null
        : CatalogRating(
            value: media.averageScore!.toDouble(),
            maximum: 100,
            provider: RecommendationProvider.anilist,
          ),
    titleRomaji: media.romaji,
    titleEnglish: media.english,
    titleNative: media.native,
    description: media.description,
    imgURLs: media.coverImage != null ? [media.coverImage!] : const [],
    genres: media.genres,
  );

  factory RecommendationResult.fromTrakt(TraktRecommendation result) {
    final media = result.media;
    final kind = media.type == TraktMediaType.movie
        ? MediaKind.movie
        : MediaKind.show;
    return RecommendationResult(
      id: media.stableKey,
      provider: RecommendationProvider.trakt,
      kind: kind,
      searchTarget: SearchTarget(query: media.title, itemType: ItemType.anime),
      traktId: media.ids.trakt,
      tmdbId: media.ids.tmdb,
      year: media.year,
      rating: media.rating == null
          ? null
          : CatalogRating(
              value: media.rating!,
              maximum: 10,
              provider: RecommendationProvider.trakt,
            ),
      titleEnglish: media.title,
      titleNative: media.originalTitle,
      description: media.overview,
      imgURLs: media.posterUrl == null ? const [] : [media.posterUrl!],
      genres: media.genres,
    );
  }
}
