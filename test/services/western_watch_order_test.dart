import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/discovery/media_lookup_context.dart';
import 'package:mangayomi/services/discovery/trakt_discovery.dart';
import 'package:mangayomi/services/discovery/western_watch_order.dart';

const _breakingBad = TraktRootMedia(
  type: TraktMediaType.show,
  title: 'Breaking Bad',
  year: 2008,
  ids: TraktIds(trakt: 1388, tmdb: 1396, slug: 'breaking-bad'),
);
const _betterCallSaul = TraktRootMedia(
  type: TraktMediaType.show,
  title: 'Better Call Saul',
  year: 2015,
  ids: TraktIds(trakt: 922, tmdb: 60059, slug: 'better-call-saul'),
);
const _elCamino = TraktRootMedia(
  type: TraktMediaType.movie,
  title: 'El Camino',
  year: 2019,
  ids: TraktIds(trakt: 100, tmdb: 559969, slug: 'el-camino'),
);
const _toyStoryOne = TraktRootMedia(
  type: TraktMediaType.movie,
  title: 'Toy Story',
  year: 1995,
  ids: TraktIds(trakt: 705, tmdb: 862, slug: 'toy-story'),
);
const _toyStoryTwo = TraktRootMedia(
  type: TraktMediaType.movie,
  title: 'Toy Story 2',
  year: 1999,
  ids: TraktIds(trakt: 706, tmdb: 863, slug: 'toy-story-2'),
);
const _toyStoryThree = TraktRootMedia(
  type: TraktMediaType.movie,
  title: 'Toy Story 3',
  year: 2010,
  ids: TraktIds(trakt: 5407, tmdb: 10193, slug: 'toy-story-3'),
);
const _toyStoryFour = TraktRootMedia(
  type: TraktMediaType.movie,
  title: 'Toy Story 4',
  year: 2019,
  ids: TraktIds(trakt: 193972, tmdb: 301528, slug: 'toy-story-4'),
);
const _toyStoryFive = TraktRootMedia(
  type: TraktMediaType.movie,
  title: 'Toy Story 5',
  year: 2026,
  ids: TraktIds(trakt: 871500, tmdb: 1084242, slug: 'toy-story-5'),
);

MediaLookupContext _context({
  String title = 'Breaking Bad',
  int? year = 2008,
  MediaKind kind = MediaKind.show,
  int? tmdbId = 1396,
  int? traktId,
}) {
  return MediaLookupContext(
    title: title,
    itemType: ItemType.anime,
    year: year,
    kind: kind,
    tmdbId: tmdbId,
    traktId: traktId,
  );
}

TraktSeason _season(TraktRootMedia show, int number, {int? episodeCount}) {
  return TraktSeason(
    number: number,
    ids: TraktIds(trakt: 5000 + number),
    show: show,
    title: number == 0 ? 'Specials' : 'Season $number',
    episodeCount: episodeCount,
  );
}

TraktListItem _showItem(TraktRootMedia show, int rank) {
  return TraktListItem(
    rank: rank,
    type: TraktMediaType.show,
    title: show.title,
    year: show.year,
    ids: show.ids,
    media: show,
  );
}

TraktListItem _movieItem(TraktRootMedia movie, int rank) {
  return TraktListItem(
    rank: rank,
    type: TraktMediaType.movie,
    title: movie.title,
    year: movie.year,
    ids: movie.ids,
    media: movie,
  );
}

TraktListItem _seasonItem(TraktRootMedia show, int number, int rank) {
  return TraktListItem(
    rank: rank,
    type: TraktMediaType.season,
    title: number == 0 ? 'Specials' : 'Season $number',
    ids: TraktIds(trakt: 7000 + number),
    parentShow: show,
    seasonNumber: number,
  );
}

TraktListItem _episodeItem(
  TraktRootMedia show, {
  required int season,
  required int episode,
  required int rank,
}) {
  return TraktListItem(
    rank: rank,
    type: TraktMediaType.episode,
    title: 'Episode $episode',
    ids: TraktIds(trakt: 9000 + episode),
    parentShow: show,
    seasonNumber: season,
    episodeNumber: episode,
  );
}

TraktListCandidate _candidate({
  required String id,
  required String name,
  required double score,
  required List<TraktListItem> items,
  bool official = false,
  String? owner = 'alice',
}) {
  return TraktListCandidate(
    listId: id,
    name: name,
    ownerSlug: official ? null : owner,
    author: official ? 'Trakt' : 'Alice',
    sourceUrl: official
        ? 'https://trakt.tv/lists/$id'
        : 'https://trakt.tv/users/$owner/lists/$id',
    isOfficial: official,
    score: score,
    items: items,
  );
}

final class _FakeDiscovery extends TraktDiscovery {
  _FakeDiscovery();

  TraktRootMedia? tmdbResult;
  TraktRootMedia? traktResult;
  TraktRootMedia? titleResult;
  List<TraktListCandidate> candidates = const [];
  final Map<int, List<TraktSeason>> seasons = {};
  final List<String> calls = [];
  Completer<void>? listGate;
  int failListRequests = 0;
  int failSeasonRequests = 0;

  @override
  Future<TraktRootMedia?> resolveByTmdbId({
    required int tmdbId,
    required TraktMediaType type,
  }) async {
    calls.add('tmdb:$tmdbId:${type.apiName}');
    return tmdbResult;
  }

  @override
  Future<TraktRootMedia?> resolveByTraktId({
    required int traktId,
    required TraktMediaType type,
  }) async {
    calls.add('trakt:$traktId:${type.apiName}');
    return traktResult;
  }

  @override
  Future<TraktRootMedia?> resolveByTitle({
    required String title,
    required TraktMediaType type,
    int? year,
  }) async {
    calls.add('title:$title:$year:${type.apiName}');
    return titleResult;
  }

  @override
  Future<List<TraktListCandidate>> findWatchOrderLists(
    TraktRootMedia root, {
    int limit = 5,
  }) async {
    calls.add('lists:${root.ids.trakt}:$limit');
    await listGate?.future;
    if (failListRequests > 0) {
      failListRequests--;
      throw const TraktDiscoveryException('Temporary list failure');
    }
    return candidates;
  }

  @override
  Future<List<TraktSeason>> fetchSeasons(
    TraktRootMedia show, {
    int? limit,
  }) async {
    calls.add('seasons:${show.ids.trakt}');
    if (failSeasonRequests > 0) {
      failSeasonRequests--;
      throw const TraktDiscoveryException('Temporary season failure');
    }
    return seasons[show.ids.trakt] ?? const [];
  }
}

void main() {
  test(
    'builds a ranked mixed franchise with provenance and one exact current row',
    () async {
      final discovery = _FakeDiscovery()
        ..tmdbResult = _breakingBad
        ..seasons[_betterCallSaul.ids.trakt!] = [
          _season(_betterCallSaul, 1, episodeCount: 10),
          _season(_betterCallSaul, 2, episodeCount: 10),
        ]
        ..seasons[_breakingBad.ids.trakt!] = [
          _season(_breakingBad, 1),
          _season(_breakingBad, 2),
        ]
        ..candidates = [
          _candidate(
            id: '90',
            name: 'Breaking Bad Universe Watch Order',
            score: 200,
            official: true,
            items: [
              _showItem(_betterCallSaul, 10),
              _showItem(_breakingBad, 20),
              _seasonItem(_breakingBad, 0, 21),
              _seasonItem(_breakingBad, 1, 22),
              _movieItem(_elCamino, 30),
            ],
          ),
        ];
      final planner = WesternWatchOrderPlanner(discovery: discovery);

      final plan = await planner.build(_context());

      expect(plan, isNotNull);
      expect(plan!.source.kind, WesternWatchOrderSourceKind.publicList);
      expect(plan.source.name, 'Breaking Bad Universe Watch Order');
      expect(plan.source.author, 'Trakt');
      expect(plan.source.isOfficial, isTrue);
      expect(plan.source.url, 'https://trakt.tv/lists/90');
      expect(plan.selectedCandidateKey, 'trakt:list:official:90');

      final topLevel = plan.items.where((item) => item.depth == 0).toList();
      expect(topLevel.map((item) => item.title), [
        'Better Call Saul',
        'Breaking Bad',
        'El Camino',
      ]);
      expect(topLevel.map((item) => item.sourceRank), [10, 20, 30]);
      expect(topLevel.map((item) => item.role), [
        WesternWatchOrderItemRole.previous,
        WesternWatchOrderItemRole.current,
        WesternWatchOrderItemRole.next,
      ]);
      expect(
        plan.items.where(
          (item) => item.role == WesternWatchOrderItemRole.current,
        ),
        hasLength(1),
      );
      expect(
        plan.items
            .where((item) => item.depth > 0)
            .every((item) => item.role == WesternWatchOrderItemRole.neutral),
        isTrue,
      );

      final explicitSpecial = plan.items.singleWhere(
        (item) =>
            item.title == 'Specials' &&
            item.searchTarget.query == 'Breaking Bad',
      );
      expect(explicitSpecial.kind, WesternWatchOrderItemKind.season);
      expect(explicitSpecial.seasonNumber, 0);
      expect(explicitSpecial.depth, 1);

      expect(discovery.calls, contains('seasons:922'));
      expect(discovery.calls, isNot(contains('seasons:1388')));
      expect(
        plan.items
            .where((item) => item.searchTarget.query == 'Better Call Saul')
            .map((item) => item.episodeCount),
        [null, 10, 10],
      );
    },
  );

  test(
    'groups explicit season and episode rows under synthetic parents',
    () async {
      final discovery = _FakeDiscovery()
        ..tmdbResult = _breakingBad
        ..candidates = [
          _candidate(
            id: '12',
            name: 'Breaking Bad Chronology',
            score: 80,
            items: [
              _seasonItem(_breakingBad, 0, 1),
              _episodeItem(_breakingBad, season: 1, episode: 1, rank: 2),
              _episodeItem(_breakingBad, season: 1, episode: 2, rank: 3),
              _movieItem(_elCamino, 4),
            ],
          ),
        ];
      final planner = WesternWatchOrderPlanner(discovery: discovery);

      final plan = await planner.build(_context());

      expect(plan, isNotNull);
      expect(plan!.items.map((item) => (item.title, item.depth)), [
        ('Breaking Bad', 0),
        ('Specials', 1),
        ('Season 1', 1),
        ('Episode 1', 2),
        ('Episode 2', 2),
        ('El Camino', 0),
      ]);
      expect(plan.items.first.role, WesternWatchOrderItemRole.current);
      expect(plan.items[1].seasonNumber, 0);
      expect(
        plan.items
            .skip(1)
            .take(4)
            .every(
              (item) =>
                  item.role == WesternWatchOrderItemRole.neutral &&
                  item.searchTarget.query == 'Breaking Bad',
            ),
        isTrue,
      );
      expect(
        discovery.calls.where((call) => call.startsWith('seasons:')),
        isEmpty,
      );
    },
  );

  test(
    'selected alternative controls the plan and exposes other choices',
    () async {
      final first = _candidate(
        id: '1',
        name: 'Official Collection',
        score: 100,
        official: true,
        items: [_showItem(_breakingBad, 1), _movieItem(_elCamino, 2)],
      );
      final second = _candidate(
        id: '2',
        name: 'Community Chronology',
        score: 80,
        items: [_movieItem(_elCamino, 1), _showItem(_breakingBad, 2)],
      );
      final discovery = _FakeDiscovery()
        ..tmdbResult = _breakingBad
        ..candidates = [second, first];
      final planner = WesternWatchOrderPlanner(discovery: discovery);

      final defaultPlan = await planner.build(_context());

      final plan = await planner.build(
        _context(),
        selectedCandidateKey: second.stableKey,
      );

      expect(defaultPlan?.selectedCandidateKey, first.stableKey);
      expect(plan, isNotNull);
      expect(plan!.source.name, 'Community Chronology');
      expect(plan.selectedCandidateKey, second.stableKey);
      expect(plan.options.map((option) => option.key), [
        first.stableKey,
        second.stableKey,
      ]);
      expect(plan.alternatives.single.key, first.stableKey);
      expect(
        plan.items.where((item) => item.depth == 0).map((item) => item.title),
        ['El Camino', 'Breaking Bad'],
      );
      expect(
        discovery.calls.where((call) => call.startsWith('lists:')),
        hasLength(1),
      );
    },
  );

  test(
    'Toy Story uses the official movie collection in ranked order',
    () async {
      final discovery = _FakeDiscovery()
        ..tmdbResult = _toyStoryThree
        ..candidates = [
          _candidate(
            id: '117',
            name: 'Toy Story Collection',
            score: 300,
            official: true,
            items: [
              _movieItem(_toyStoryOne, 1),
              _movieItem(_toyStoryTwo, 2),
              _movieItem(_toyStoryThree, 3),
              _movieItem(_toyStoryFour, 4),
              _movieItem(_toyStoryFive, 5),
            ],
          ),
        ];
      final planner = WesternWatchOrderPlanner(discovery: discovery);

      final plan = await planner.build(
        _context(
          title: 'Toy Story 3',
          year: 2010,
          kind: MediaKind.movie,
          tmdbId: 10193,
        ),
      );

      expect(plan?.source.name, 'Toy Story Collection');
      expect(plan?.source.isOfficial, isTrue);
      expect(plan?.items.map((item) => item.title), [
        'Toy Story',
        'Toy Story 2',
        'Toy Story 3',
        'Toy Story 4',
        'Toy Story 5',
      ]);
      expect(plan?.items.map((item) => item.role), [
        WesternWatchOrderItemRole.previous,
        WesternWatchOrderItemRole.previous,
        WesternWatchOrderItemRole.current,
        WesternWatchOrderItemRole.next,
        WesternWatchOrderItemRole.next,
      ]);
    },
  );

  test(
    'standalone show resolves by title and falls back to non-special seasons',
    () async {
      final discovery = _FakeDiscovery()
        ..titleResult = _breakingBad
        ..seasons[_breakingBad.ids.trakt!] = [
          _season(_breakingBad, 0, episodeCount: 3),
          _season(_breakingBad, 2, episodeCount: 13),
          _season(_breakingBad, 1, episodeCount: 7),
        ];
      final planner = WesternWatchOrderPlanner(discovery: discovery);

      final plan = await planner.build(
        _context(tmdbId: null, title: 'Breaking Bad', year: 2008),
      );

      expect(plan, isNotNull);
      expect(plan!.source.kind, WesternWatchOrderSourceKind.showSeasons);
      expect(plan.options, isEmpty);
      expect(plan.items.map((item) => item.title), [
        'Breaking Bad',
        'Season 1',
        'Season 2',
      ]);
      expect(plan.items.first.role, WesternWatchOrderItemRole.current);
      expect(plan.items.skip(1).every((item) => item.depth == 1), isTrue);
      expect(discovery.calls.first, 'title:Breaking Bad:2008:show');
      expect(discovery.calls, contains('lists:1388:5'));
    },
  );

  test('resolution tries TMDB, Trakt, then title and year', () async {
    final discovery = _FakeDiscovery()
      ..traktResult = _breakingBad
      ..candidates = const []
      ..seasons[_breakingBad.ids.trakt!] = [];
    final planner = WesternWatchOrderPlanner(discovery: discovery);

    await planner.build(_context(tmdbId: 1396, traktId: 1388));

    expect(discovery.calls.take(2), ['tmdb:1396:show', 'trakt:1388:show']);
    expect(discovery.calls.where((call) => call.startsWith('title:')), isEmpty);
  });

  test('standalone movie never fabricates order from related titles', () async {
    final discovery = _FakeDiscovery()
      ..tmdbResult = _elCamino
      ..candidates = const [];
    final planner = WesternWatchOrderPlanner(discovery: discovery);

    final plan = await planner.build(
      _context(
        title: 'El Camino',
        year: 2019,
        kind: MediaKind.movie,
        tmdbId: 559969,
      ),
    );

    expect(plan, isNull);
    expect(discovery.calls, isNot(contains('seasons:100')));
    expect(
      discovery.calls.where((call) => call.contains('recommend')),
      isEmpty,
    );
  });

  test('a failed season request is evicted so retry can recover', () async {
    final discovery = _FakeDiscovery()
      ..tmdbResult = _breakingBad
      ..failSeasonRequests = 1
      ..seasons[_breakingBad.ids.trakt!] = [_season(_breakingBad, 1)];
    final planner = WesternWatchOrderPlanner(discovery: discovery);

    await expectLater(planner.build(_context()), throwsA(isA<Exception>()));
    final plan = await planner.build(_context());

    expect(plan?.items.map((item) => item.title), ['Breaking Bad', 'Season 1']);
    expect(
      discovery.calls.where((call) => call == 'seasons:1388'),
      hasLength(2),
    );
  });

  test('concurrent builds share one in-flight list lookup', () async {
    final gate = Completer<void>();
    final discovery = _FakeDiscovery()
      ..tmdbResult = _breakingBad
      ..listGate = gate
      ..candidates = const []
      ..seasons[_breakingBad.ids.trakt!] = [_season(_breakingBad, 1)];
    final planner = WesternWatchOrderPlanner(discovery: discovery);

    final first = planner.build(_context());
    await Future<void>.delayed(Duration.zero);
    final second = planner.build(_context());
    await Future<void>.delayed(Duration.zero);

    expect(
      discovery.calls.where((call) => call.startsWith('lists:')),
      hasLength(1),
    );
    gate.complete();
    await Future.wait([first, second]);
  });

  test('a failed list lookup is evicted so retry can recover', () async {
    final discovery = _FakeDiscovery()
      ..tmdbResult = _breakingBad
      ..failListRequests = 1
      ..candidates = const []
      ..seasons[_breakingBad.ids.trakt!] = [_season(_breakingBad, 1)];
    final planner = WesternWatchOrderPlanner(discovery: discovery);

    await expectLater(planner.build(_context()), throwsA(isA<Exception>()));
    final plan = await planner.build(_context());

    expect(plan?.items.map((item) => item.title), ['Breaking Bad', 'Season 1']);
    expect(
      discovery.calls.where((call) => call.startsWith('lists:')),
      hasLength(2),
    );
  });

  test(
    'season expansion cannot push the exact root outside the row cap',
    () async {
      final discovery = _FakeDiscovery()
        ..tmdbResult = _breakingBad
        ..seasons[_betterCallSaul.ids.trakt!] = [
          for (var number = 1; number <= 20; number++)
            _season(_betterCallSaul, number),
        ]
        ..seasons[_breakingBad.ids.trakt!] = [
          _season(_breakingBad, 1),
          _season(_breakingBad, 2),
        ]
        ..candidates = [
          _candidate(
            id: 'cap',
            name: 'Breaking Bad Universe Watch Order',
            score: 100,
            items: [
              _showItem(_betterCallSaul, 1),
              _showItem(_breakingBad, 2),
              _movieItem(_elCamino, 3),
            ],
          ),
        ];
      final planner = WesternWatchOrderPlanner(
        discovery: discovery,
        maxRenderedItems: 5,
      );

      final plan = await planner.build(_context());

      expect(plan?.items, hasLength(5));
      expect(
        plan?.items.where(
          (item) => item.role == WesternWatchOrderItemRole.current,
        ),
        hasLength(1),
      );
      expect(
        plan?.items
            .singleWhere(
              (item) => item.role == WesternWatchOrderItemRole.current,
            )
            .title,
        'Breaking Bad',
      );
    },
  );

  test(
    'interleaved child groups use unique neutral duplicate headers',
    () async {
      final discovery = _FakeDiscovery()
        ..tmdbResult = _breakingBad
        ..candidates = [
          _candidate(
            id: 'interleaved',
            name: 'Breaking Bad Chronology',
            score: 100,
            items: [
              _seasonItem(_breakingBad, 1, 1),
              _movieItem(_elCamino, 2),
              _episodeItem(_breakingBad, season: 2, episode: 1, rank: 3),
            ],
          ),
        ];
      final planner = WesternWatchOrderPlanner(discovery: discovery);

      final plan = await planner.build(_context());
      final headers = plan!.items.where((item) => item.depth == 0).toList();
      final breakingBadHeaders = headers
          .where((item) => item.title == 'Breaking Bad')
          .toList();

      expect(headers.map((item) => item.title), [
        'Breaking Bad',
        'El Camino',
        'Breaking Bad',
      ]);
      expect(breakingBadHeaders.map((item) => item.role), [
        WesternWatchOrderItemRole.current,
        WesternWatchOrderItemRole.neutral,
      ]);
      expect(breakingBadHeaders.map((item) => item.key).toSet(), hasLength(2));
    },
  );
}
