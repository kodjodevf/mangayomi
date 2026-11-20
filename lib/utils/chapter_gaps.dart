import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

/// A run of whole chapter numbers with none of them in the series:
/// [first] to [last], both included.
typedef ChapterNumberRange = ({int first, int last});

extension ChapterNumberRangeCount on List<ChapterNumberRange> {
  /// How many chapter numbers the ranges cover.
  int get numberCount =>
      fold(0, (count, range) => count + range.last - range.first + 1);
}

/// The whole numbers absent between the lowest and the highest of
/// [numbers], as runs: 1, 2, 4, 7 gives 3 and 5–6.
///
/// A decimal extra (12.5) counts for its whole chapter, as it is not part
/// of the main numbering, and negative numbers are left out.
List<ChapterNumberRange> missingNumberRanges(Iterable<double> numbers) {
  final present =
      numbers.where((n) => n >= 0).map((n) => n.floor()).toSet().toList()
        ..sort();
  final ranges = <ChapterNumberRange>[];
  for (var i = 1; i < present.length; i++) {
    if (present[i] - present[i - 1] > 1) {
      ranges.add((first: present[i - 1] + 1, last: present[i] - 1));
    }
  }
  return ranges;
}

/// The chapter numbers of [chapters] that [ChapterRecognition] can read,
/// season set aside.
Iterable<double> recognizedChapterNumbers(
  String mangaTitle,
  Iterable<Chapter> chapters,
) {
  final recognition = ChapterRecognition();
  return chapters
      .map((c) => recognition.rawSeasonAndNumber(mangaTitle, c.name ?? '').$2)
      .whereType<double>();
}

/// The chapter numbers skipped going from [from] to [to] that no chapter of
/// [chapters] carries: none when [to] does not come after [from], when
/// either has no number, or when they are in different seasons, whose
/// numbering starts over.
///
/// A number some chapter does carry is not missing, only left out by the
/// reader's filters, so it is not counted.
List<ChapterNumberRange> missingNumbersBetween(
  String mangaTitle,
  Chapter from,
  Chapter to,
  Iterable<Chapter> chapters,
) {
  final recognition = ChapterRecognition();
  final (fromSeason, a) = recognition.rawSeasonAndNumber(
    mangaTitle,
    from.name ?? '',
  );
  final (toSeason, b) = recognition.rawSeasonAndNumber(
    mangaTitle,
    to.name ?? '',
  );
  if (a == null || b == null || a < 0 || b < 0) return const [];
  if (fromSeason != toSeason) return const [];
  final low = a.floor();
  final high = b.floor();
  if (high - low <= 1) return const [];
  final present = recognizedChapterNumbers(
    mangaTitle,
    chapters,
  ).map((n) => n.floor()).where((n) => n > low && n < high).toSet();
  return missingNumberRanges([
    low.toDouble(),
    ...present.map((n) => n.toDouble()),
    high.toDouble(),
  ]);
}

/// [ranges] as a reader would write them: "3, 7–9, 100".
String formatChapterNumberRanges(List<ChapterNumberRange> ranges) => ranges
    .map(
      (r) => r.first == r.last
          ? '${r.first}'
          : r.last == r.first + 1
          ? '${r.first}, ${r.last}'
          : '${r.first}–${r.last}',
    )
    .join(', ');
