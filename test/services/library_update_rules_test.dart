import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/library_update_rules.dart';

Manga _manga({Status status = Status.ongoing, List<int>? categories}) => Manga(
  source: 'source',
  author: '',
  artist: '',
  genre: const [],
  imageUrl: '',
  lang: 'en',
  link: '/manga',
  name: 'Manga',
  status: status,
  description: '',
  sourceId: null,
  categories: categories,
);

Chapter _chapter({bool read = false}) =>
    Chapter(name: 'Chapter', url: '/c', mangaId: 1)..isRead = read;

void main() {
  test('no rule updates everything', () {
    const rules = LibraryUpdateRules();
    expect(rules.isEmpty, isTrue);
    expect(rules.allows(_manga(status: Status.completed), []), isTrue);
  });

  test('a category set to skip updates leaves its entries out', () {
    const rules = LibraryUpdateRules(skippedCategoryIds: {2});
    expect(rules.allows(_manga(categories: [1, 2]), []), isFalse);
    expect(rules.allows(_manga(categories: [1]), []), isTrue);
    expect(rules.allows(_manga(), []), isTrue);
  });

  test('completed series are skipped', () {
    const rules = LibraryUpdateRules(skipCompleted: true);
    expect(rules.allows(_manga(status: Status.completed), []), isFalse);
    expect(rules.allows(_manga(), []), isTrue);
  });

  test('series with an unread chapter are skipped', () {
    const rules = LibraryUpdateRules(skipUnread: true);
    expect(rules.allows(_manga(), [_chapter(read: true), _chapter()]), isFalse);
    expect(rules.allows(_manga(), [_chapter(read: true)]), isTrue);
  });

  test('series not started are skipped, but not those with no chapters', () {
    const rules = LibraryUpdateRules(skipNotStarted: true);
    expect(rules.allows(_manga(), [_chapter(), _chapter()]), isFalse);
    expect(rules.allows(_manga(), [_chapter(read: true), _chapter()]), isTrue);
    expect(rules.allows(_manga(), []), isTrue);
  });
}
