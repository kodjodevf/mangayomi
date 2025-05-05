import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

class ChapterWithPages {
  final Chapter chapter;
  final GetChapterPagesModel pages;

  ChapterWithPages({required this.chapter, required this.pages});
}

class MangaReaderController extends FamilyAsyncNotifier<ChapterWithPages, int> {
  @override
  Future<ChapterWithPages> build(int chapterId) async {
    final chap = await isar.chapters.get(chapterId);
    if (chap == null) {
      throw Exception('Chapter #$chapterId not found');
    }

    final pages = await ref.read(getChapterPagesProvider(chapter: chap).future);

    return ChapterWithPages(chapter: chap, pages: pages);
  }
}

final mangaReaderProvider =
    AsyncNotifierProvider.family<MangaReaderController, ChapterWithPages, int>(
      MangaReaderController.new,
    );
