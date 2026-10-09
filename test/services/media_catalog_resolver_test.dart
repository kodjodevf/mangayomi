import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/media_catalog_resolver.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/discovery/trakt_discovery.dart';

final class _FakeTrakt extends TraktDiscovery {
  TraktRootMedia? root;
  final List<String> calls = [];

  @override
  Future<TraktRootMedia?> resolveByTmdbId({
    required int tmdbId,
    required TraktMediaType type,
  }) async {
    calls.add('tmdb:$tmdbId:${type.apiName}');
    return root;
  }
}

MediaLookupContext _automatic({
  required String title,
  required MediaKind kind,
  required int tmdbId,
  int? year,
}) => MediaLookupContext(
  title: title,
  itemType: ItemType.anime,
  kind: kind,
  catalog: DiscoveryCatalog.automatic,
  tmdbId: tmdbId,
  year: year,
);

void main() {
  test('an exact anime alias, year, and format selects AniList', () async {
    final trakt = _FakeTrakt()
      ..root = const TraktRootMedia(
        type: TraktMediaType.show,
        title: 'Attack on Titan',
        year: 2013,
        ids: TraktIds(trakt: 353, tmdb: 1429),
      );
    final searches = <String?>[];
    final resolver = MediaCatalogResolver(
      trakt: trakt,
      animeSearch:
          ({
            required itemType,
            sort,
            search,
            required page,
            required perPage,
          }) async {
            searches.add(search);
            return [
              DiscoveryMedia(
                id: 16498,
                english: 'Attack on Titan',
                romaji: 'Shingeki no Kyojin',
                seasonYear: 2013,
                format: 'TV',
              ),
            ];
          },
    );

    final result = await resolver.resolve(
      _automatic(title: 'Attack on Titan', kind: MediaKind.show, tmdbId: 1429),
    );

    expect(result.catalog, DiscoveryCatalog.anilist);
    expect(result.anilistId, 16498);
    expect(result.traktRoot?.ids.trakt, 353);
    expect(trakt.calls, ['tmdb:1429:show']);
    expect(searches, ['Attack on Titan']);
  });

  test('a partial anime title match does not capture a western show', () async {
    final trakt = _FakeTrakt()
      ..root = const TraktRootMedia(
        type: TraktMediaType.show,
        title: 'Friends',
        year: 1994,
        ids: TraktIds(trakt: 1657, tmdb: 1668),
      );
    final resolver = MediaCatalogResolver(
      trakt: trakt,
      animeSearch:
          ({
            required itemType,
            sort,
            search,
            required page,
            required perPage,
          }) async => [
            DiscoveryMedia(
              id: 1,
              english: 'Friends: Mononoke Shima no Naki',
              seasonYear: 1994,
              format: 'TV',
            ),
          ],
    );

    final result = await resolver.resolve(
      _automatic(
        title: 'Friends',
        kind: MediaKind.show,
        tmdbId: 1668,
        year: 1994,
      ),
    );

    expect(result.catalog, DiscoveryCatalog.trakt);
    expect(result.traktRoot?.title, 'Friends');
  });

  test('year and format collisions remain on Trakt', () async {
    final trakt = _FakeTrakt()
      ..root = const TraktRootMedia(
        type: TraktMediaType.show,
        title: 'Monster',
        year: 2003,
        ids: TraktIds(trakt: 1, tmdb: 2),
      );
    final resolver = MediaCatalogResolver(
      trakt: trakt,
      animeSearch:
          ({
            required itemType,
            sort,
            search,
            required page,
            required perPage,
          }) async => [
            DiscoveryMedia(
              id: 19,
              english: 'Monster',
              seasonYear: 2004,
              format: 'TV',
            ),
            DiscoveryMedia(
              id: 20,
              english: 'Monster',
              seasonYear: 2003,
              format: 'MOVIE',
            ),
          ],
    );

    final result = await resolver.resolve(
      _automatic(title: 'Monster', kind: MediaKind.show, tmdbId: 2, year: 2003),
    );

    expect(result.catalog, DiscoveryCatalog.trakt);
  });

  test('an AniList failure is not reclassified as western media', () async {
    final trakt = _FakeTrakt()
      ..root = const TraktRootMedia(
        type: TraktMediaType.show,
        title: 'Naruto',
        year: 2002,
        ids: TraktIds(trakt: 1, tmdb: 46260),
      );
    final resolver = MediaCatalogResolver(
      trakt: trakt,
      animeSearch: ({
        required itemType,
        sort,
        search,
        required page,
        required perPage,
      }) async => throw StateError('AniList unavailable'),
    );

    await expectLater(
      resolver.resolve(
        _automatic(title: 'Naruto', kind: MediaKind.show, tmdbId: 46260),
      ),
      throwsStateError,
    );
  });

  test('a known anime catalog bypasses automatic network lookup', () async {
    var searched = false;
    final resolver = MediaCatalogResolver(
      trakt: _FakeTrakt(),
      animeSearch:
          ({
            required itemType,
            sort,
            search,
            required page,
            required perPage,
          }) async {
            searched = true;
            return const [];
          },
    );

    final result = await resolver.resolve(
      const MediaLookupContext(
        title: 'Naruto',
        itemType: ItemType.anime,
        kind: MediaKind.anime,
        catalog: DiscoveryCatalog.anilist,
      ),
    );

    expect(result.catalog, DiscoveryCatalog.anilist);
    expect(searched, isFalse);
  });
}
