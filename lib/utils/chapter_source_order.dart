import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

class IndexedSourceChapter {
  final MChapter chapter;
  final int sourceOrder;

  const IndexedSourceChapter({
    required this.chapter,
    required this.sourceOrder,
  });
}

class ChapterSourceOrder {
  const ChapterSourceOrder._();

  static List<IndexedSourceChapter> indexSourceChapters(
    Iterable<MChapter> chapters,
  ) {
    final unique = <MChapter>[];
    final seenUrls = <String>{};

    for (final chapter in chapters) {
      final url = chapter.url?.trim();
      if (url == null || url.isEmpty || !seenUrls.add(url)) continue;
      chapter.url = url;
      unique.add(chapter);
    }

    return List.generate(
      unique.length,
      (index) => IndexedSourceChapter(
        chapter: unique[index],
        sourceOrder: unique.length - index - 1,
      ),
    );
  }

  static int compare(Chapter a, Chapter b, String mangaTitle) {
    final recognition = ChapterRecognition();
    final aOrder = value(a, mangaTitle, recognition: recognition);
    final bOrder = value(b, mangaTitle, recognition: recognition);
    final order = aOrder.compareTo(bOrder);
    if (order != 0) return order;

    final name = (a.name ?? '').compareTo(b.name ?? '');
    if (name != 0) return name;

    return (a.url ?? '').compareTo(b.url ?? '');
  }

  static int value(
    Chapter chapter,
    String mangaTitle, {
    ChapterRecognition? recognition,
  }) {
    return chapter.sourceOrder ??
        (recognition ?? ChapterRecognition()).parseChapterNumber(
          mangaTitle,
          chapter.name ?? '',
        );
  }
}
