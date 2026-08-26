import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'manga_reader_provider.g.dart';

class ChapterWithPages {
  final Chapter chapter;
  final GetChapterPagesModel pages;

  ChapterWithPages({required this.chapter, required this.pages});
}

@riverpod
Future<ChapterWithPages> mangaReader(Ref ref, int chapterId) async {
  final chap = await chapterRepository.findById(chapterId);
  if (chap == null) {
    throw Exception('Chapter #$chapterId not found');
  }

  final pages = await ref.read(getChapterPagesProvider(chapter: chap).future);

  return ChapterWithPages(chapter: chap, pages: pages);
}
