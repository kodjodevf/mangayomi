import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';

void main() {
  const all = [
    '/MangaLibrary',
    '/AnimeLibrary',
    '/NovelLibrary',
    '/updates',
    '/history',
    '/browse',
    '/more',
  ];

  group('groupDestinations', () {
    test('folds seven destinations into four, in the user order', () {
      expect(groupDestinations(all), [
        NavGroup.library,
        NavGroup.activity,
        '/browse',
        '/more',
      ]);
    });

    test('a group takes the place of its first member', () {
      expect(
        groupDestinations([
          '/browse',
          '/history',
          '/AnimeLibrary',
          '/more',
          '/updates',
          '/MangaLibrary',
        ]),
        ['/browse', NavGroup.activity, NavGroup.library, '/more'],
      );
    });

    test('a group with one visible member keeps its own name', () {
      expect(groupDestinations(['/AnimeLibrary', '/updates', '/more']), [
        '/AnimeLibrary',
        '/updates',
        '/more',
      ]);
    });

    test('destinations outside any group are untouched', () {
      expect(groupDestinations(['/trackerLibrary', '/browse']), [
        '/trackerLibrary',
        '/browse',
      ]);
    });
  });

  group('resolveNavDestination', () {
    test('a plain route opens itself', () {
      expect(resolveNavDestination('/browse', visible: all), '/browse');
    });

    test('a group opens the member last visited', () {
      expect(
        resolveNavDestination(
          NavGroup.library,
          visible: all,
          lastVisited: '/NovelLibrary',
        ),
        '/NovelLibrary',
      );
    });

    test('with no visit yet, the first member in the user order', () {
      expect(
        resolveNavDestination(
          NavGroup.library,
          visible: const ['/more', '/AnimeLibrary', '/MangaLibrary'],
        ),
        '/AnimeLibrary',
      );
    });

    test('a member hidden since the last visit is not reopened', () {
      expect(
        resolveNavDestination(
          NavGroup.activity,
          visible: const ['/history', '/more'],
          lastVisited: '/updates',
        ),
        '/history',
      );
    });
  });

  test('every library route belongs to the library group', () {
    for (final route in NavGroup.members[NavGroup.library]!) {
      expect(NavGroup.of(route), NavGroup.library);
    }
    expect(NavGroup.of('/browse'), isNull);
  });
}
