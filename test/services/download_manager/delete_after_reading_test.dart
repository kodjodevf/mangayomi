import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/download_manager/delete_after_reading.dart';

void main() {
  // Chapters 1 to 6, the first [read] read, [bookmarked] bookmarked.
  List<Chapter> chapters({int read = 0, Set<int> bookmarked = const {}}) =>
      List.generate(
        6,
        (i) => Chapter(
          id: i + 1,
          mangaId: 1,
          name: 'Chapter ${i + 1}',
          isRead: i < read,
          isBookmarked: bookmarked.contains(i + 1),
        ),
      );

  test('slot 0 is the chapter just read', () {
    final list = chapters(read: 4);
    expect(
      chapterToDeleteAfterReading(
        list,
        list[3],
        slot: 0,
        deleteBookmarked: false,
      )?.id,
      4,
    );
  });

  test('a later slot keeps the chapters in between', () {
    final list = chapters(read: 4);
    expect(
      chapterToDeleteAfterReading(
        list,
        list[3],
        slot: 2,
        deleteBookmarked: false,
      )?.id,
      2,
    );
  });

  test('nothing before the first chapter, or an unread one', () {
    final list = chapters(read: 2);
    expect(
      chapterToDeleteAfterReading(
        list,
        list[1],
        slot: 3,
        deleteBookmarked: false,
      ),
      isNull,
    );
    final skipped = chapters(read: 1)..[4].isRead = true;
    expect(
      chapterToDeleteAfterReading(
        skipped,
        skipped[4],
        slot: 2,
        deleteBookmarked: false,
      ),
      isNull,
    );
  });

  test('bookmarked chapters stay unless asked', () {
    final list = chapters(read: 4, bookmarked: {4});
    expect(
      chapterToDeleteAfterReading(
        list,
        list[3],
        slot: 0,
        deleteBookmarked: false,
      ),
      isNull,
    );
    expect(
      chapterToDeleteAfterReading(
        list,
        list[3],
        slot: 0,
        deleteBookmarked: true,
      )?.id,
      4,
    );
  });
}
