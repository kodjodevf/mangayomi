import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/anilist_discovery.dart';
import 'package:mangayomi/services/discovery/service_availability.dart';
import 'package:mangayomi/services/related_titles.dart';

DiscoveryRelation _relation(
  String relationType, {
  required String title,
  String type = 'MANGA',
  String? format,
}) => DiscoveryRelation(
  relationType: relationType,
  media: DiscoveryMedia(
    id: title.hashCode,
    source: DiscoveryService.kitsu,
    english: title,
    type: type,
    format: format,
    genres: const [],
  ),
);

void main() {
  group('ordering', () {
    test('an adaptation in the other medium leads', () {
      // The reason this feature exists: from inside a manga there is no other
      // way to find out an anime of it exists.
      final ordered = orderRelations([
        _relation('SIDE_STORY', title: 'Buddy Stories'),
        _relation('SEQUEL', title: 'Part 2'),
        _relation('ADAPTATION', title: 'Chainsaw Man', type: 'ANIME'),
      ], ItemType.manga);

      expect(ordered.first.title, 'Chainsaw Man');
      expect(ordered.first.itemType, ItemType.anime);
      expect(ordered.map((e) => e.relation), [
        'ADAPTATION',
        'SEQUEL',
        'SIDE_STORY',
      ]);
    });

    test('an adaptation within the same medium does not', () {
      // A manga adaptation of a novel, read from the manga, is not the jump
      // this is for, so the story order outranks it.
      final ordered = orderRelations([
        _relation('ADAPTATION', title: 'Same medium'),
        _relation('SEQUEL', title: 'Part 2'),
        _relation('ADAPTATION', title: 'The anime', type: 'ANIME'),
      ], ItemType.manga);

      expect(ordered.map((e) => e.title), [
        'The anime',
        'Same medium',
        'Part 2',
      ]);
    });

    test('keeps the whole story order in order', () {
      final ordered = orderRelations([
        _relation('SPIN_OFF', title: 'f'),
        _relation('ALTERNATIVE', title: 'g'),
        _relation('SIDE_STORY', title: 'e'),
        _relation('PARENT', title: 'd'),
        _relation('PREQUEL', title: 'c'),
        _relation('SEQUEL', title: 'b'),
        _relation('CHARACTER', title: 'h'),
      ], ItemType.manga);

      expect(ordered.map((e) => e.title), ['b', 'c', 'd', 'e', 'f', 'g', 'h']);
    });

    test('drops a repeat of the same title in the same medium', () {
      // Both services list one work under more than one relation.
      final ordered = orderRelations([
        _relation('ADAPTATION', title: 'Chainsaw Man', type: 'ANIME'),
        _relation('ALTERNATIVE', title: 'chainsaw man', type: 'ANIME'),
      ], ItemType.manga);

      expect(ordered, hasLength(1));
      expect(ordered.single.relation, 'ADAPTATION');
    });

    test('keeps the same title when it is the other medium', () {
      // A manga and its anime share a name, and both are worth showing.
      final ordered = orderRelations([
        _relation('ADAPTATION', title: 'Chainsaw Man', type: 'ANIME'),
        _relation('SEQUEL', title: 'Chainsaw Man'),
      ], ItemType.manga);

      expect(ordered, hasLength(2));
    });

    test('drops an entry with no title rather than drawing a blank card', () {
      final relations = [
        DiscoveryRelation(
          relationType: 'SEQUEL',
          media: DiscoveryMedia(
            id: 1,
            source: DiscoveryService.kitsu,
            genres: const [],
          ),
        ),
        _relation('SEQUEL', title: 'real'),
      ];

      expect(orderRelations(relations, ItemType.manga).map((e) => e.title), [
        'real',
      ]);
    });
  });

  group('which library an entry belongs to', () {
    test('anime is anime', () {
      final media = DiscoveryMedia(
        id: 1,
        source: DiscoveryService.kitsu,
        type: 'ANIME',
        format: 'TV',
        genres: const [],
      );
      expect(relatedItemType(media), ItemType.anime);
    });

    test('a novel is a novel, not a manga', () {
      // Kitsu has no novel type; it is a manga whose subtype says novel. Sent
      // to the manga library it would search the wrong sources.
      final media = DiscoveryMedia(
        id: 1,
        source: DiscoveryService.kitsu,
        type: 'MANGA',
        format: 'NOVEL',
        genres: const [],
      );
      expect(relatedItemType(media), ItemType.novel);
    });

    test('anything else is a manga', () {
      final media = DiscoveryMedia(
        id: 1,
        source: DiscoveryService.kitsu,
        type: 'MANGA',
        format: 'MANHWA',
        genres: const [],
      );
      expect(relatedItemType(media), ItemType.manga);
    });
  });

  test('crossesMedium is about video, not about the exact library', () {
    const novel = RelatedTitle(
      title: 'a',
      relation: 'ADAPTATION',
      itemType: ItemType.novel,
    );
    // A novel read from a manga is still reading, so it is not the jump.
    expect(novel.crossesMedium(ItemType.manga), isFalse);
    expect(novel.crossesMedium(ItemType.anime), isTrue);
  });
}
