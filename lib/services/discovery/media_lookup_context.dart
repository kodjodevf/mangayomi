import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';

enum MediaKind { unknown, anime, movie, show }

enum DiscoveryCatalog { anilist, trakt, automatic }

/// The stable metadata needed to look up recommendations and watch order.
///
/// This deliberately copies values out of [Manga] and [Track]. It does not
/// retain either Isar object, so it remains safe to pass between screens and
/// asynchronous discovery requests.
final class MediaLookupContext {
  const MediaLookupContext({
    required this.title,
    required this.itemType,
    this.sourceLink,
    this.sourceName,
    this.year,
    this.kind = MediaKind.unknown,
    this.catalog = DiscoveryCatalog.anilist,
    this.anilistId,
    this.tmdbId,
    this.traktId,
  });

  factory MediaLookupContext.fromManga(
    Manga manga, {
    Track? track,
    Iterable<Track> tracks = const [],
    int? year,
    MediaKind? kind,
    String? chapterName,
  }) {
    final sourceLink = _nonEmpty(manga.link);
    final sourceName = _nonEmpty(manga.source);
    final sourceIdentity = _tmdbIdentity(sourceLink, sourceName);
    final allTracks = <Track>[?track, ...tracks];
    final traktTrack = allTracks.where(_isTraktTrack).firstOrNull;
    final anilistTrack = allTracks.where(_isAniListTrack).firstOrNull;
    final traktIdentity = _traktIdentity(traktTrack);
    final hasAnimeTracker = allTracks.any(_isAnimeTrack);
    final catalog = manga.itemType != ItemType.anime
        ? DiscoveryCatalog.anilist
        : hasAnimeTracker
        ? DiscoveryCatalog.anilist
        : sourceIdentity != null || traktIdentity != null
        ? DiscoveryCatalog.automatic
        : DiscoveryCatalog.anilist;
    final rawTitle =
        _nonEmpty(manga.name) ?? _nonEmpty(allTracks.firstOrNull?.title) ?? '';
    final titleAndYear = _titleAndYear(rawTitle);

    return MediaLookupContext(
      title: titleAndYear.title,
      itemType: manga.itemType,
      sourceLink: sourceLink,
      sourceName: sourceName,
      year: year ?? titleAndYear.year ?? _linkYear(sourceLink),
      kind:
          kind ??
          (catalog == DiscoveryCatalog.anilist
              ? manga.itemType == ItemType.anime
                    ? MediaKind.anime
                    : MediaKind.unknown
              : sourceIdentity?.kind ??
                    traktIdentity?.kind ??
                    _chapterKind(sourceName, chapterName) ??
                    MediaKind.unknown),
      catalog: catalog,
      anilistId: anilistTrack?.mediaId,
      tmdbId: sourceIdentity?.id,
      traktId: traktIdentity?.id,
    );
  }

  final String title;
  final ItemType itemType;
  final String? sourceLink;
  final String? sourceName;
  final int? year;
  final MediaKind kind;
  final DiscoveryCatalog catalog;
  final int? anilistId;
  final int? tmdbId;
  final int? traktId;
}

bool _isAnimeTrack(Track track) {
  if (track.syncId == 1 || track.syncId == 2 || track.syncId == 3) return true;
  final host = Uri.tryParse(track.trackingUrl ?? '')?.host.toLowerCase();
  return host == 'anilist.co' ||
      host == 'myanimelist.net' ||
      host == 'www.myanimelist.net' ||
      host == 'kitsu.app';
}

bool _isAniListTrack(Track track) {
  if (track.syncId == 2) return true;
  return Uri.tryParse(track.trackingUrl ?? '')?.host.toLowerCase() ==
      'anilist.co';
}

bool _isTraktTrack(Track track) {
  if (track.syncId == 5) return true;
  final host = Uri.tryParse(track.trackingUrl ?? '')?.host.toLowerCase();
  return host == 'trakt.tv' || host == 'www.trakt.tv';
}

({MediaKind kind, int id})? _tmdbIdentity(
  String? sourceLink,
  String? sourceName,
) {
  if (sourceLink == null) return null;

  final uri = Uri.tryParse(sourceLink);
  final path = uri?.path ?? sourceLink.split(RegExp(r'[?#]')).first;
  final host = (uri?.host ?? '').toLowerCase();
  final normalizedSource = sourceName?.trim().toLowerCase();

  final isCineJoy =
      normalizedSource == 'cinejoy' ||
      host == 'cinejoy.pk' ||
      host == 'www.cinejoy.pk' ||
      host == 'cinejoy.to' ||
      host == 'www.cinejoy.to';
  if (isCineJoy) {
    final movie = RegExp(
      r'/movie/(\d+)(?:/|$)',
      caseSensitive: false,
    ).firstMatch(path);
    final show = RegExp(
      r'/tv/(\d+)(?:/|$)',
      caseSensitive: false,
    ).firstMatch(path);
    return _identity(movie, MediaKind.movie) ?? _identity(show, MediaKind.show);
  }

  final isSflix =
      normalizedSource == 'sflix' ||
      host == 'ssflix.pro' ||
      host == 'www.ssflix.pro';
  if (isSflix) {
    final movie = RegExp(
      r'/(?:watch/)?movie/[^/]*-(\d+)(?:/|$)',
      caseSensitive: false,
    ).firstMatch(path);
    final show = RegExp(
      r'/(?:watch/)?serie/[^/]*-(\d+)(?:/|$)',
      caseSensitive: false,
    ).firstMatch(path);
    return _identity(movie, MediaKind.movie) ?? _identity(show, MediaKind.show);
  }

  final isMoviesFlix =
      normalizedSource == 'moviesflix' ||
      host == 'moviesflix.uk' ||
      host == 'www.moviesflix.uk';
  if (isMoviesFlix) {
    final movie = RegExp(
      r'/movies/[^/]*-2(\d+)A3(?:/|$)',
      caseSensitive: false,
    ).firstMatch(path);
    final show = RegExp(
      r'/serie/(\d+)(?:-\d+){0,2}(?:/|$)',
      caseSensitive: false,
    ).firstMatch(path);
    return _identity(movie, MediaKind.movie) ?? _identity(show, MediaKind.show);
  }

  return null;
}

int? _linkYear(String? sourceLink) {
  final value = Uri.tryParse(sourceLink ?? '')?.queryParameters['year'];
  if (value == null || !RegExp(r'^(?:18|19|20)\d{2}$').hasMatch(value)) {
    return null;
  }
  return int.tryParse(value);
}

({MediaKind kind, int id})? _traktIdentity(Track? track) {
  final mediaId = track?.mediaId;
  final rawUrl = _nonEmpty(track?.trackingUrl);
  if (mediaId == null || mediaId <= 0 || rawUrl == null) return null;

  final uri = Uri.tryParse(rawUrl);
  if (uri == null ||
      (uri.host.toLowerCase() != 'trakt.tv' &&
          uri.host.toLowerCase() != 'www.trakt.tv')) {
    return null;
  }

  final segments = uri.pathSegments.where((segment) => segment.isNotEmpty);
  if (segments.isEmpty) return null;
  return switch (segments.first.toLowerCase()) {
    'movies' => (kind: MediaKind.movie, id: mediaId),
    'shows' => (kind: MediaKind.show, id: mediaId),
    _ => null,
  };
}

({MediaKind kind, int id})? _identity(RegExpMatch? match, MediaKind kind) {
  final id = int.tryParse(match?.group(1) ?? '');
  return id == null || id <= 0 ? null : (kind: kind, id: id);
}

MediaKind? _chapterKind(String? sourceName, String? chapterName) {
  final source = sourceName?.trim().toLowerCase();
  if (source != 'sflix' && source != 'moviesflix') return null;

  final chapter = chapterName?.trim() ?? '';
  if (RegExp(
    r'^season\s+\d+\s+episode\s+\d+$',
    caseSensitive: false,
  ).hasMatch(chapter)) {
    return MediaKind.show;
  }
  if (chapter.toLowerCase() == 'movie') return MediaKind.movie;
  return null;
}

({String title, int? year}) _titleAndYear(String rawTitle) {
  final match = RegExp(r'^(.*?\S)\s*[\(\[]((?:18|19|20)\d{2})[\)\]]$')
      .firstMatch(rawTitle);
  if (match == null) return (title: rawTitle, year: null);

  return (
    title: match.group(1)?.trim() ?? rawTitle,
    year: int.tryParse(match.group(2) ?? ''),
  );
}

String? _nonEmpty(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
