import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/kotatsu_backup.dart';

void main() {
  Archive backupArchive({
    required List<Map<String, dynamic>> categories,
    required List<Map<String, dynamic>> favourites,
    bool favouritesFirst = false,
  }) {
    final categoryFile = ArchiveFile.string(
      'categories',
      jsonEncode(categories),
    );
    final favouriteFile = ArchiveFile.string(
      'favourites',
      jsonEncode(favourites),
    );
    return Archive()
      ..add(favouritesFirst ? favouriteFile : categoryFile)
      ..add(favouritesFirst ? categoryFile : favouriteFile);
  }

  test(
    'reads current Kotatsu category_id fields and preserves their order',
    () {
      final backup = parseKotatsuBackup(
        backupArchive(
          categories: [
            {
              'category_id': 42,
              'title': 'Reading',
              'sort_key': 7,
              'show_in_lib': false,
            },
          ],
          favourites: const [],
        ),
      );

      expect(backup.categories, hasLength(1));
      expect(backup.categories.single.sourceId, 42);
      expect(backup.categories.single.name, 'Reading');
      expect(backup.categories.single.position, 7);
      expect(backup.categories.single.hidden, isTrue);
    },
  );

  test('groups repeated favourites and remaps every category assignment', () {
    Map<String, dynamic> manga(int id, String title) => {
      'id': id,
      'title': title,
      'url': '/$title',
      'source': 'TEST',
    };

    final backup = parseKotatsuBackup(
      backupArchive(
        categories: [
          {'category_id': 42, 'title': 'Reading'},
          {'category_id': 77, 'title': 'Favorites'},
        ],
        favourites: [
          {'manga_id': 9001, 'category_id': 42, 'manga': manga(9001, 'Alpha')},
          {'manga_id': 9001, 'category_id': 77, 'manga': manga(9001, 'Alpha')},
          {'manga_id': 9002, 'category_id': 77, 'manga': manga(9002, 'Beta')},
        ],
        favouritesFirst: true,
      ),
    );

    expect(backup.mangas, hasLength(2));
    final alpha = backup.mangas.firstWhere(
      (record) => record.manga['title'] == 'Alpha',
    );
    expect(alpha.categoryIds, {42, 77});
    expect(remapKotatsuCategoryIds(alpha, {42: 3, 77: 8}), [3, 8]);
  });

  test('accepts the legacy category id field', () {
    final backup = parseKotatsuBackup(
      backupArchive(
        categories: [
          {'id': '12', 'title': 'Legacy'},
        ],
        favourites: const [],
      ),
    );

    expect(backup.categories.single.sourceId, 12);
  });
}
