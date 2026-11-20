import 'package:material_ui/material_ui.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/reader_common/mixins/chapter_controller_mixin.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/utils/chapter_gaps.dart';
import 'package:shiori/shiori.dart';

/// Before [reader] goes on to [next]: when that skips chapter numbers no
/// chapter of the series carries, says which, and whether to go on anyway.
///
/// Next chapter used to jump over the gap without a word, which in
/// fullscreen left the reader a chapter further on than they thought. True
/// to go on: right away when nothing is skipped, or when the warning was
/// turned off in the reader's settings.
Future<bool> confirmSkippingMissingChapters(
  BuildContext context,
  ChapterControllerMixin reader,
  Chapter next,
) async {
  final settings = settingsRepository.current;
  if (!(settings.warnMissingChapters ?? true)) return true;
  final manga = reader.getManga();
  final missing = missingNumbersBetween(
    manga.name ?? '',
    reader.chapter,
    next,
    manga.chapters,
  );
  if (missing.isEmpty) return true;
  final l10n = context.l10n;
  final nextName = chapterDisplayName(
    next,
    manga,
    l10n,
    byNumber: {...?settings.chapterNumberDisplayMangaIds}.contains(manga.id),
  );
  return showShioriConfirm(
    context,
    title: l10n.missing_chapters_skipped(
      missing.numberCount,
      formatChapterNumberRanges(missing),
    ),
    message: l10n.missing_chapters_skipped_message(nextName),
    confirmLabel: l10n.continue_reading,
  );
}
