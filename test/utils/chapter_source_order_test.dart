import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/chapter_source_order.dart';

void main() {
  test('source order survives Chapter JSON serialization', () {
    final chapter = Chapter(
      mangaId: 1,
      name: 'Season 1 afterword',
      sourceOrder: 7,
    );

    expect(Chapter.fromJson(chapter.toJson()).sourceOrder, 7);
  });

  test('indexes valid unique URLs in returned order', () {
    final indexed = ChapterSourceOrder.indexSourceChapters([
      MChapter(name: 'new', url: '/new'),
      MChapter(name: 'duplicate', url: '/new'),
      MChapter(name: 'invalid', url: '  '),
      MChapter(name: 'old', url: '/old'),
    ]);

    expect(indexed.map((entry) => entry.chapter.url), ['/new', '/old']);
    expect(indexed.map((entry) => entry.sourceOrder), [1, 0]);
  });

  test('source order overrides the recognized title number', () {
    final chapter = Chapter(
      mangaId: 1,
      name: 'Episode 1',
      sourceOrder: 97,
    );

    expect(ChapterSourceOrder.value(chapter, 'Series title'), 97);
  });

  test('legacy rows fall back to the recognized title number', () {
    final chapter = Chapter(mangaId: 1, name: 'Episode 12');

    expect(ChapterSourceOrder.value(chapter, 'Series title'), 12);
  });
}
