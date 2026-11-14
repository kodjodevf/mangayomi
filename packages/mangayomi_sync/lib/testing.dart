// The suite every SyncStore runs: the engine's rules end to end on that
// store, then what the engine relies on the store for. Test functions come
// from the caller, so a Flutter test and a plain Dart test can both run it.
import 'dart:async';

import 'package:matcher/expect.dart';

import 'mangayomi_sync.dart';

typedef TestBody = FutureOr<void> Function();

/// Registers the suite with the caller's test functions. [openStore] gives
/// a new, empty store before each test; [closeStore] disposes of it after.
void syncStoreSuite({
  required void Function(String description, TestBody body) test,
  required void Function(TestBody body) setUp,
  required void Function(TestBody body) tearDown,
  required FutureOr<SyncStore> Function() openStore,
  FutureOr<void> Function(SyncStore store)? closeStore,
}) {
  late SyncStore store;
  late int now;
  late SyncEngine engine;

  setUp(() async {
    store = await openStore();
    now = 1000000;
    engine = SyncEngine(store, clock: () => now);
  });

  tearDown(() async {
    await closeStore?.call(store);
  });

  Map<String, dynamic> manga(
    int clientId, {
    String link = '/title',
    int updatedAt = 10,
    String name = 'Title',
  }) => {
    'clientId': clientId,
    'source': 'Demo',
    'link': link,
    'itemType': 'MANGA',
    'name': name,
    'updatedAt': updatedAt,
  };

  Map<String, dynamic> chapter(
    int clientId,
    int mangaClientId, {
    String url = '/c1',
    int updatedAt = 10,
    bool isRead = false,
  }) => {
    'clientId': clientId,
    'mangaClientId': mangaClientId,
    'name': 'Chapter',
    'url': url,
    'isRead': isRead,
    'updatedAt': updatedAt,
  };

  List<int> ids(Map<String, dynamic> response, String entity) => [
    for (final row in response[entity] as List) row['clientId'] as int,
  ];

  test('what one device uploads reaches the other, not itself', () {
    final fromA = engine.handle({
      'since': 0,
      'manga': [manga(1)],
      'chapters': [chapter(11, 1)],
    });
    expect(ids(fromA, 'manga'), isEmpty);
    expect(fromA['syncedAt'], isA<int>());
    expect(fromA['hasMore'], isFalse);

    now += 10;
    final toB = engine.handle({'since': 0});
    expect(ids(toB, 'manga'), [1]);
    expect(ids(toB, 'chapters'), [11]);
    expect((toB['manga'] as List).single['name'], 'Title');
    expect(toB['totalCounts'], containsPair('manga', 1));

    // Nothing new since.
    final again = engine.handle({'since': toB['syncedAt']});
    expect(ids(again, 'manga'), isEmpty);
  });

  test('an edit made offline still reaches a device that synced since', () {
    engine.handle({
      'since': 0,
      'manga': [manga(1)],
    });
    now = 2000000;
    final b = engine.handle({'since': 0});

    // A read the title offline before B synced, and uploads it only now.
    now = 3000000;
    engine.handle({
      'since': 0,
      'manga': [manga(1, updatedAt: 1500000, name: 'Read offline')],
    });

    final toB = engine.handle({'since': b['syncedAt']});
    expect((toB['manga'] as List).single['name'], 'Read offline');
  });

  test('the newest version wins, by the uploading device clock', () {
    engine.handle({
      'manga': [manga(1, updatedAt: 50, name: 'New')],
    });
    engine.handle({
      'manga': [manga(1, updatedAt: 40, name: 'Old')],
    });
    expect((engine.handle({})['manga'] as List).single['name'], 'New');
  });

  test('a date far ahead counts as now, so later edits still win', () {
    engine.handle({
      'manga': [manga(1, updatedAt: now + 10 * 365 * 86400000, name: 'Ahead')],
    });
    now += 1000;
    engine.handle({
      'manga': [manga(1, updatedAt: now, name: 'Later')],
    });
    expect((engine.handle({})['manga'] as List).single['name'], 'Later');
  });

  test('a title two devices added apart becomes one', () {
    engine.handle({
      'manga': [manga(1)],
    });

    final fromB = engine.handle({
      'manga': [manga(2)],
      'chapters': [chapter(22, 2)],
    });
    expect(fromB['mangaClientIdRemap'], {'2': 1});

    // A later upload under the old id still lands on the one title.
    engine.handle({
      'chapters': [chapter(23, 2, url: '/c2')],
    });
    final all = engine.handle({});
    expect(ids(all, 'manga'), [1]);
    expect(
      [for (final c in all['chapters'] as List) c['mangaClientId']],
      [1, 1],
    );
  });

  test('a chapter two devices tracked apart becomes one', () {
    engine.handle({
      'manga': [manga(1)],
      'chapters': [chapter(11, 1)],
    });
    final fromB = engine.handle({
      'chapters': [chapter(12, 1, updatedAt: 20, isRead: true)],
      'histories': [
        {
          'clientId': 31,
          'mangaClientId': 1,
          'chapterClientId': 12,
          'itemType': 'MANGA',
          'updatedAt': 20,
        },
      ],
    });
    expect(fromB['chapterClientIdRemap'], {'12': 11});

    final all = engine.handle({});
    expect(ids(all, 'chapters'), [11]);
    expect((all['chapters'] as List).single['isRead'], isTrue);
    expect((all['histories'] as List).single['chapterClientId'], 11);
  });

  test('rows whose title the host does not have are left out', () {
    final response = engine.handle({
      'chapters': [chapter(11, 99)],
    });
    expect(response['chapters'], isEmpty);
    expect(engine.handle({})['chapters'], isEmpty);
  });

  test('deleting a title deletes what belongs to it, for every device', () {
    engine.handle({
      'manga': [manga(1)],
      'chapters': [chapter(11, 1)],
      'tracks': [
        {
          'clientId': 41,
          'mangaClientId': 1,
          'itemType': 'MANGA',
          'updatedAt': 10,
        },
      ],
    });
    final before = engine.handle({});

    now += 10;
    engine.handle({
      'deleted': {
        'manga': [1],
      },
    });

    final after = engine.handle({'since': before['syncedAt']});
    final tombstones = after['tombstones'] as Map<String, dynamic>;
    expect(tombstones['manga'], [1]);
    expect(tombstones['chapters'], [11]);
    expect(tombstones['tracks'], [41]);
    expect(engine.handle({})['manga'], isEmpty);
  });

  test('a newer upload brings a deleted title back', () {
    engine.handle({
      'manga': [manga(1)],
      'deleted': {
        'manga': [1],
      },
    });
    now += 10;
    engine.handle({
      'manga': [manga(1, updatedAt: now)],
    });
    expect(ids(engine.handle({}), 'manga'), [1]);
  });

  test('a large library comes in pages, then the watermark', () {
    engine = SyncEngine(store, clock: () => now, pageSize: 2);
    engine.handle({
      'manga': [for (var i = 1; i <= 5; i++) manga(i, link: '/t$i')],
    });

    final seen = <int>[];
    Map<String, dynamic>? cursors;
    for (var page = 0; ; page++) {
      final response = engine.handle({'since': 0, 'cursors': ?cursors});
      seen.addAll(ids(response, 'manga'));
      if (page == 0) expect(response['totalCounts'], containsPair('manga', 5));
      if (response['hasMore'] != true) {
        expect(response['syncedAt'], isA<int>());
        break;
      }
      expect(response['syncedAt'], isNull);
      cursors = Map<String, dynamic>.from(response['cursors'] as Map);
    }
    expect(seen, [1, 2, 3, 4, 5]);
  });

  test('settings: the newest wins and reaches the other devices', () {
    final fromA = engine.handle({
      'settings': {
        'data': {'theme': 'dark'},
        'updatedAt': 10,
      },
    });
    expect(fromA['settings'], isNull);

    engine.handle({
      'settings': {
        'data': {'theme': 'light'},
        'updatedAt': 5,
      },
    });
    final toB = engine.handle({'since': 0});
    expect(toB['settings'], {
      'data': {'theme': 'dark'},
      'updatedAt': 10,
    });
  });

  test('the host clock going back never reuses a stamp', () {
    final first = engine.handle({
      'manga': [manga(1)],
    });
    now -= 500000;
    engine.handle({
      'manga': [manga(2, link: '/other')],
    });
    // Still after the first sync, so the device that made it gets it.
    final next = engine.handle({'since': first['syncedAt']});
    expect(ids(next, 'manga'), [2]);
  });

  {
    for (final (name, request) in [
      ('not an object', <Object?>[]),
      (
        'a clientId of 0',
        {
          'manga': [manga(0)],
        },
      ),
      (
        'an unknown item type',
        {
          'manga': [
            {...manga(1), 'itemType': 'COMIC'},
          ],
        },
      ),
      (
        'a text too long',
        {
          'manga': [
            {...manga(1), 'name': 'x' * 501},
          ],
        },
      ),
      (
        'a tracking URL that is not web',
        {
          'tracks': [
            {
              'clientId': 1,
              'mangaClientId': 1,
              'itemType': 'MANGA',
              'trackingUrl': 'javascript:alert(1)',
              'updatedAt': 1,
            },
          ],
        },
      ),
      (
        'too many rows',
        {
          'categories': [
            for (var i = 1; i <= maxRowsPerEntity + 1; i++)
              {
                'clientId': i,
                'name': 'c',
                'forItemType': 'MANGA',
                'updatedAt': 1,
              },
          ],
        },
      ),
    ]) {
      test('a request is refused whole, before anything is stored: $name', () {
        final valid = manga(7, link: '/valid');
        expect(
          () => engine.handle(
            request is Map<String, dynamic>
                ? {
                    ...request,
                    'manga': [...?request['manga'] as List?, valid],
                  }
                : request,
          ),
          throwsA(isA<SyncRequestInvalid>()),
        );
        expect(engine.handle({})['manga'], isEmpty);
      });
    }
  }

  test('fields a device has no business sending are not kept', () {
    engine.handle({
      'manga': [
        {...manga(1), 'injected': 'x'},
      ],
    });
    final row = (engine.handle({})['manga'] as List).single as Map;
    expect(row.containsKey('injected'), isFalse);
  });

  // -----------------------------------------------------------------------
  // The store itself
  // -----------------------------------------------------------------------

  StoredRow row(
    String entity,
    int clientId, {
    int receivedAt = 1,
    bool deleted = false,
    String? key,
    int? parent,
  }) => StoredRow(
    entity: entity,
    clientId: clientId,
    receivedAt: receivedAt,
    updatedAt: 1,
    deleted: deleted,
    naturalKey: key,
    parentClientId: parent,
    data: deleted ? null : '{}',
  );

  test('store: a row is replaced under its entity and clientId', () {
    store.transaction(() {
      store.put(row('manga', 1, receivedAt: 5));
      store.put(row('manga', 1, receivedAt: 6, key: 'k'));
      store.put(row('chapters', 1, receivedAt: 7));
    });
    expect(store.get('manga', 1)!.receivedAt, 6);
    expect(store.get('manga', 1)!.naturalKey, 'k');
    expect(store.get('chapters', 1)!.receivedAt, 7);
    expect(store.get('manga', 2), isNull);
  });

  test('store: a failed transaction keeps nothing it wrote', () {
    store.transaction(() => store.put(row('manga', 1)));
    expect(
      () => store.transaction(() {
        store.put(row('manga', 2));
        store.put(row('manga', 1, receivedAt: 9));
        throw StateError('stop');
      }),
      throwsA(isA<StateError>()),
    );
    expect(store.get('manga', 2), isNull);
    expect(store.get('manga', 1)!.receivedAt, 1);
  });

  test('store: changes come oldest first, after the cursor, limited', () {
    store.transaction(() {
      for (final (id, at) in [(1, 30), (2, 10), (3, 20), (4, 40)]) {
        store.put(row('manga', id, receivedAt: at));
      }
      store.put(row('manga', 5, receivedAt: 25, deleted: true));
      store.put(row('chapters', 6, receivedAt: 15, deleted: true));
    });
    final page = store.changes(
      entity: 'manga',
      deleted: false,
      after: 10,
      limit: 2,
    );
    expect([for (final r in page) r.clientId], [3, 1]);
    expect(store.countChanges(entity: 'manga', deleted: false, after: 10), 3);
    final tombstones = store.changes(deleted: true, after: 0, limit: 10);
    expect([for (final r in tombstones) r.clientId], [6, 5]);
    expect(store.countChanges(deleted: true, after: 20), 1);
  });

  test('store: natural keys and children only find live rows', () {
    store.transaction(() {
      store.put(row('manga', 1, key: 'a', deleted: true));
      store.put(row('manga', 2, key: 'a'));
      store.put(row('chapters', 3, parent: 2));
      store.put(row('chapters', 4, parent: 2, deleted: true));
      store.put(row('tracks', 5, parent: 2));
    });
    expect(store.liveByNaturalKey('manga', 'a')!.clientId, 2);
    expect(store.liveByNaturalKey('manga', 'b'), isNull);
    expect(store.liveByNaturalKey('chapters', 'a'), isNull);
    expect(
      [for (final r in store.liveChildren('chapters', 2)) r.clientId],
      [3],
    );
  });

  test('store: text survives as stored, separators and all', () {
    const text = 'a\u001fb\u0000c é 漫画 🙂';
    store.transaction(
      () => store.put(
        StoredRow(
          entity: 'manga',
          clientId: 1,
          receivedAt: 1,
          updatedAt: 1,
          naturalKey: 'MANGA\u001fsrc\u001f/x',
          data: '{"name":"$text"}',
        ),
      ),
    );
    expect(store.get('manga', 1)!.data, '{"name":"$text"}');
    expect(
      store.liveByNaturalKey('manga', 'MANGA\u001fsrc\u001f/x')!.clientId,
      1,
    );
  });
}
