import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_reader_settings_mixin.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_controller_mixin.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'novel_reader_controller_provider.g.dart';

@riverpod
class NovelReaderController extends _$NovelReaderController
    with ChapterControllerMixin, ChapterReaderSettingsMixin {
  @override
  void build({required Chapter chapter}) {}

  // Keep incognitoMode as a final field (read once, not on every access).
  @override
  final bool incognitoMode = settingsRepository.current.incognitoMode!;

  // ---------------------------------------------------------------------------
  // Scroll-position tracking
  // ---------------------------------------------------------------------------

  void setChapterOffset(double newOffset, double maxOffset, bool save) {
    if (incognitoMode) return;
    final isRead = (newOffset / (maxOffset != 0 ? maxOffset : 1)) >= 0.9;
    if (isRead || save) {
      final ch = chapter;
      ch.isRead = isRead;
      ch.lastPageRead = (maxOffset != 0 ? newOffset / maxOffset : 0).toString();
      chapterRepository.save(ch);
    }
  }
}
