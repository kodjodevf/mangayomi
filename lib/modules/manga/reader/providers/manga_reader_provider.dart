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

  if (!ref.mounted) throw Exception('Reader provider disposed');

  final pagesProvider = getChapterPagesProvider(chapter: chap);
  // Keeps the auto-dispose sub-provider alive while we await it.
  ref.listen(pagesProvider, (_, _) {}, onError: (_, _) {});
  final pages = await ref.read(pagesProvider.future);

  return ChapterWithPages(chapter: chap, pages: pages);
}
