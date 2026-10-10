import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';

Manga _manga({
  required String name,
  required String source,
  required String link,
}) => Manga(
  name: name,
  source: source,
  link: link,
  author: null,
  artist: null,
  genre: const [],
  imageUrl: null,
  lang: 'en',
  status: Status.unknown,
  description: null,
  sourceId: 1,
  itemType: ItemType.anime,
);

void main() {
  group('SFlix TMDB identity', () {
    test('Friends is an exact 1994 TV lookup', () {
      final context = MediaLookupContext.fromManga(
        _manga(
          name: 'Friends (1994)',
          source: 'SFlix',
          link: '/serie/friends-1668',
        ),
      );

      expect(context.title, 'Friends');
      expect(context.year, 1994);
      expect(context.kind, MediaKind.show);
      expect(context.catalog, DiscoveryCatalog.automatic);
      expect(context.tmdbId, 1668);
    });

    test('Breaking Bad episode links keep the series TMDB ID', () {
      final context = MediaLookupContext.fromManga(
        _manga(
          name: 'Breaking Bad',
          source: 'SFlix',
          link: 'https://ssflix.pro/watch/serie/breaking-bad-1396/season-1/episode-1',
        ),
      );

      expect(context.kind, MediaKind.show);
      expect(context.tmdbId, 1396);
    });

    test('Toy Story is identified as a movie', () {
      final context = MediaLookupContext.fromManga(
        _manga(
          name: 'Toy Story',
          source: 'SFlix',
          link: '/watch/movie/toy-story-862',
        ),
      );

      expect(context.kind, MediaKind.movie);
      expect(context.tmdbId, 862);
    });
  });

  test('MoviesFlix decodes its wrapped movie and series IDs', () {
    final movie = MediaLookupContext.fromManga(
      _manga(
        name: 'Toy Story',
        source: 'MoviesFlix',
        link: '/movies/toy-story-2862A3/',
      ),
    );
    final show = MediaLookupContext.fromManga(
      _manga(
        name: 'Breaking Bad',
        source: 'MoviesFlix',
        link: '/serie/1396-1-1/breaking-bad/',
      ),
    );

    expect(movie.kind, MediaKind.movie);
    expect(movie.catalog, DiscoveryCatalog.automatic);
    expect(movie.tmdbId, 862);
    expect(show.kind, MediaKind.show);
    expect(show.tmdbId, 1396);
  });

  test('CineJoy contributes its exact TMDB kind, ID, and year', () {
    final movie = MediaLookupContext.fromManga(
      _manga(
        name: 'Toy Story',
        source: 'CineJoy',
        link: '/movie/862?title=Toy%20Story&year=1995',
      ),
    );
    final show = MediaLookupContext.fromManga(
      _manga(
        name: 'Breaking Bad',
        source: 'CineJoy',
        link: '/tv/1396?title=Breaking%20Bad&year=2008',
      ),
    );

    expect(movie.kind, MediaKind.movie);
    expect(movie.catalog, DiscoveryCatalog.automatic);
    expect(movie.tmdbId, 862);
    expect(movie.year, 1995);
    expect(show.kind, MediaKind.show);
    expect(show.tmdbId, 1396);
    expect(show.year, 2008);
  });

  test('a Trakt track contributes its exact kind and media ID', () {
    final manga = _manga(
      name: 'Friends',
      source: 'Other video source',
      link: '/friends',
    );
    final track = Track(
      mediaId: 42,
      title: 'Friends',
      trackingUrl: 'https://trakt.tv/shows/friends',
      status: TrackStatus.watching,
      itemType: ItemType.anime,
    );

    final context = MediaLookupContext.fromManga(manga, track: track);
    manga.name = 'Changed after lookup';
    track.mediaId = 99;

    expect(context.title, 'Friends');
    expect(context.kind, MediaKind.show);
    expect(context.catalog, DiscoveryCatalog.automatic);
    expect(context.traktId, 42);
  });

  test(
    'an anime title with a numeric link is not guessed as western media',
    () {
      final context = MediaLookupContext.fromManga(
        _manga(
          name: 'Monster',
          source: 'HiAnime',
          link: '/watch/monster-19?ep=1',
        ),
        chapterName: 'Season 1 Episode 1',
      );

      expect(context.itemType, ItemType.anime);
      expect(context.kind, MediaKind.anime);
      expect(context.catalog, DiscoveryCatalog.anilist);
      expect(context.tmdbId, isNull);
      expect(context.traktId, isNull);
    },
  );

  test('an anime tracker wins over mixed-source and Trakt identities', () {
    final manga = _manga(
      name: 'Naruto',
      source: 'SFlix',
      link: '/serie/naruto-46260',
    );
    final anilist = Track(
      mediaId: 20,
      syncId: 2,
      title: 'Naruto',
      trackingUrl: 'https://anilist.co/anime/20/Naruto/',
      status: TrackStatus.watching,
      itemType: ItemType.anime,
    );
    final trakt = Track(
      mediaId: 123,
      syncId: 5,
      title: 'Naruto',
      trackingUrl: 'https://trakt.tv/shows/naruto',
      status: TrackStatus.watching,
      itemType: ItemType.anime,
    );

    final context = MediaLookupContext.fromManga(
      manga,
      tracks: [trakt, anilist],
    );

    expect(context.catalog, DiscoveryCatalog.anilist);
    expect(context.kind, MediaKind.anime);
    expect(context.anilistId, 20);
    expect(context.tmdbId, 46260);
    expect(context.traktId, 123);
  });
}
