import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/detail/chapter_bulk_actions.dart';

void main() {
  Chapter chapter(bool isRead) =>
      Chapter(mangaId: 1, name: 'Chapter', isRead: isRead);

  test('multiple read chapters are uniformly marked unread', () {
    expect(bulkChapterTargetReadState([chapter(true), chapter(true)]), isFalse);
  });

  test('mixed selection is uniformly marked read', () {
    expect(bulkChapterTargetReadState([chapter(true), chapter(false)]), isTrue);
  });
}
