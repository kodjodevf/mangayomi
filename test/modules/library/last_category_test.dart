import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/utils/last_category.dart';

void main() {
  group('libraryTabIndexFor', () {
    // Default, then the categories 7 (DOPE), 3 and 9.
    const withDefault = <int?>[null, 7, 3, 9];
    const withoutDefault = <int?>[7, 3, 9];

    test('finds the saved category wherever its tab sits', () {
      expect(libraryTabIndexFor(withDefault, 7), 1);
      expect(libraryTabIndexFor(withoutDefault, 7), 0);
      expect(libraryTabIndexFor(withDefault, 9), 3);
    });

    test('nothing saved, or Default saved, opens the first tab', () {
      expect(libraryTabIndexFor(withDefault, null), 0);
      expect(libraryTabIndexFor(withoutDefault, null), 0);
    });

    test('a deleted or hidden category falls back to the given tab', () {
      expect(libraryTabIndexFor(withDefault, 42), 0);
      expect(libraryTabIndexFor(withDefault, 42, fallback: 2), 2);
      // Clamped to the tabs that are left.
      expect(libraryTabIndexFor(withoutDefault, 42, fallback: 5), 2);
    });

    test('no tabs at all is the first tab', () {
      expect(libraryTabIndexFor(const [], 7), 0);
    });
  });

  test('each library remembers its own category', () {
    final settings = Settings();
    setLastLibraryCategoryId(settings, ItemType.manga, 7);
    setLastLibraryCategoryId(settings, ItemType.anime, 3);

    expect(lastLibraryCategoryId(settings, ItemType.manga), 7);
    expect(lastLibraryCategoryId(settings, ItemType.anime), 3);
    expect(lastLibraryCategoryId(settings, ItemType.novel), isNull);

    setLastLibraryCategoryId(settings, ItemType.manga, null);
    expect(lastLibraryCategoryId(settings, ItemType.manga), isNull);
  });

  test('the saved categories survive settings JSON', () {
    final defaults = Settings();
    for (final type in ItemType.values) {
      expect(lastLibraryCategoryId(defaults, type), isNull);
    }

    final restored = Settings.fromJson({
      ...defaults.toJson(),
      'libraryLastCategoryIdMangas': 7,
      'libraryLastCategoryIdAnime': 3,
      'libraryLastCategoryIdNovel': 9,
    });
    expect(lastLibraryCategoryId(restored, ItemType.manga), 7);
    expect(lastLibraryCategoryId(restored, ItemType.anime), 3);
    expect(lastLibraryCategoryId(restored, ItemType.novel), 9);

    // Settings saved before this existed open on the first tab.
    final old = Settings().toJson()
      ..remove('libraryLastCategoryIdMangas')
      ..remove('libraryLastCategoryIdAnime')
      ..remove('libraryLastCategoryIdNovel');
    expect(
      lastLibraryCategoryId(Settings.fromJson(old), ItemType.manga),
      isNull,
    );
  });
}
