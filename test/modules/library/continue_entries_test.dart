import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/continue_shelf.dart';

Manga _manga(int id, {bool favorite = true}) => Manga(
  source: 's',
  sourceId: null,
  author: '',
  artist: '',
  genre: const [],
  imageUrl: '',
  lang: 'en',
  link: '',
  name: 'Series $id',
  status: Status.ongoing,
  description: '',
  itemType: ItemType.manga,
  favorite: favorite,
)..id = id;

Chapter _chapter(int id, int mangaId) =>
    Chapter(mangaId: mangaId, name: 'Chapter $id')..id = id;

History _history(int chapterId, int mangaId, int at) => History(
  mangaId: mangaId,
  chapterId: chapterId,
  date: '$at',
  itemType: ItemType.manga,
);

void main() {
  final mangas = {1: _manga(1), 2: _manga(2), 3: _manga(3, favorite: false)};
  final chapters = {
    10: _chapter(10, 1),
    11: _chapter(11, 1),
    20: _chapter(20, 2),
    30: _chapter(30, 3),
  };

  test('most recent first, each series once, at its latest chapter', () {
    final out = continueEntries(
      [_history(10, 1, 100), _history(20, 2, 200), _history(11, 1, 300)],
      chapterById: chapters,
      mangaById: mangas,
    );
    expect(out.map((e) => e.manga.id), [1, 2]);
    expect(out.first.chapter.id, 11);
  });

  test('a series no longer in the library is left out', () {
    final out = continueEntries(
      [_history(30, 3, 500), _history(20, 2, 100)],
      chapterById: chapters,
      mangaById: mangas,
    );
    expect(out.map((e) => e.manga.id), [2]);
  });

  test('a history row whose chapter is gone is skipped', () {
    final out = continueEntries(
      [_history(99, 1, 500)],
      chapterById: chapters,
      mangaById: mangas,
    );
    expect(out, isEmpty);
  });

  test('stops at the limit', () {
    final out = continueEntries(
      [_history(10, 1, 1), _history(20, 2, 2)],
      chapterById: chapters,
      mangaById: mangas,
      limit: 1,
    );
    expect(out, hasLength(1));
  });
}
