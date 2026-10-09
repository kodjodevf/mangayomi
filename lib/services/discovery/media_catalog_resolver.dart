import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/discovery/title_match.dart';
import 'package:mangayomi/services/discovery/trakt_discovery.dart';

typedef AnimeCatalogSearch = Future<List<DiscoveryMedia>> Function({
  required ItemType itemType,
  List<String>? sort,
  String? search,
  required int page,
  required int perPage,
});

final class ResolvedDiscoveryCatalog {
  const ResolvedDiscoveryCatalog({
    required this.catalog,
    this.anilistId,
    this.traktRoot,
  });

  final DiscoveryCatalog catalog;
  final int? anilistId;
  final TraktRootMedia? traktRoot;
}

/// Resolves mixed video catalogs without treating their URL shape as proof
/// that a title is western media.
///
/// Automatic entries need an exact AniList title, year, and compatible format.
/// A clean miss selects Trakt. AniList failures propagate so an outage cannot
/// silently reclassify anime as western content.
final class MediaCatalogResolver {
  MediaCatalogResolver({TraktDiscovery? trakt, AnimeCatalogSearch? animeSearch})
    : _trakt = trakt ?? TraktDiscovery(),
      _animeSearch = animeSearch ?? fetchDiscoveryPage;

  final TraktDiscovery _trakt;
  final AnimeCatalogSearch _animeSearch;
  final Map<String, Future<ResolvedDiscoveryCatalog>> _cache = {};

  Future<ResolvedDiscoveryCatalog> resolve(MediaLookupContext media) {
    if (media.catalog != DiscoveryCatalog.automatic) {
      return Future.value(
        ResolvedDiscoveryCatalog(
          catalog: media.catalog,
          anilistId: media.anilistId,
        ),
      );
    }

    final key = [
      media.kind.name,
      media.tmdbId,
      media.traktId,
      media.year,
      media.title,
    ].join(':');
    final cached = _cache[key];
    if (cached != null) return cached;

    final request = () async {
      try {
        return await _resolveAutomatic(media);
      } catch (_) {
        _cache.remove(key);
        rethrow;
      }
    }();
    _cache[key] = request;
    return request;
  }

  Future<ResolvedDiscoveryCatalog> _resolveAutomatic(
    MediaLookupContext media,
  ) async {
    final type = switch (media.kind) {
      MediaKind.movie => TraktMediaType.movie,
      MediaKind.show => TraktMediaType.show,
      MediaKind.unknown || MediaKind.anime => null,
    };
    if (type == null) {
      return const ResolvedDiscoveryCatalog(catalog: DiscoveryCatalog.anilist);
    }

    TraktRootMedia? traktRoot;
    var exactYear = media.year;
    if (exactYear == null) {
      traktRoot = await _resolveTraktRoot(media, type);
      exactYear = traktRoot?.year;
    }
    final resolvedYear = exactYear;
    if (resolvedYear != null) {
      final candidates = await _animeSearch(
        itemType: ItemType.anime,
        search: media.title,
        sort: const ['SEARCH_MATCH'],
        perPage: 5,
        page: 1,
      );
      final compatible = candidates
          .where(
            (candidate) => _isCompatible(candidate, media.kind, resolvedYear),
          )
          .toList(growable: false);
      final normalizedTitle = normalizeTitle(media.title);
      final best = compatible.indexWhere(
        (candidate) =>
            _titles(candidate)
                .any((title) => normalizeTitle(title) == normalizedTitle),
      );
      if (best != -1) {
        return ResolvedDiscoveryCatalog(
          catalog: DiscoveryCatalog.anilist,
          anilistId: compatible[best].id,
          traktRoot: traktRoot,
        );
      }
    }

    traktRoot ??= await _resolveTraktRoot(media, type);
    return ResolvedDiscoveryCatalog(
      catalog: DiscoveryCatalog.trakt,
      traktRoot: traktRoot,
    );
  }

  Future<TraktRootMedia?> _resolveTraktRoot(
    MediaLookupContext media,
    TraktMediaType type,
  ) async {
    if (media.tmdbId case final int tmdbId when tmdbId > 0) {
      final exact = await _trakt.resolveByTmdbId(tmdbId: tmdbId, type: type);
      if (exact != null) return exact;
    }
    if (media.traktId case final int traktId when traktId > 0) {
      final exact = await _trakt.resolveByTraktId(traktId: traktId, type: type);
      if (exact != null) return exact;
    }
    if (media.title.trim().isEmpty) return null;
    return _trakt.resolveByTitle(
      title: media.title,
      year: media.year,
      type: type,
    );
  }
}

bool _isCompatible(DiscoveryMedia media, MediaKind kind, int year) {
  if ((media.seasonYear ?? media.startYear) != year) return false;
  final format = media.format?.toUpperCase();
  return switch (kind) {
    MediaKind.movie => format == 'MOVIE',
    MediaKind.show => format != null && format != 'MOVIE' && format != 'MUSIC',
    MediaKind.unknown || MediaKind.anime => false,
  };
}

List<String> _titles(DiscoveryMedia media) => [
  if (media.english case final String title) title,
  if (media.romaji case final String title) title,
  if (media.native case final String title) title,
];
