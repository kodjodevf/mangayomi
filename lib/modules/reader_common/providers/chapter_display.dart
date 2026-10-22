import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';

/// The series whose chapters are listed by number ("Chapter 12") rather
/// than by the title their source gives them, which can be long, carry the
/// series name again, or change format halfway through a run.
class ChapterNumberDisplay extends Notifier<Set<int>> {
  @override
  Set<int> build() => {
    ...?settingsRepository.current.chapterNumberDisplayMangaIds,
  };

  void set(int mangaId, {required bool byNumber}) {
    final next = {...state};
    byNumber ? next.add(mangaId) : next.remove(mangaId);
    if (next.length == state.length) return;
    state = next;
    settingsRepository.update(
      (s) => s.chapterNumberDisplayMangaIds = next.toList(),
    );
  }
}

final chapterNumberDisplayProvider =
    NotifierProvider<ChapterNumberDisplay, Set<int>>(ChapterNumberDisplay.new);

/// How [chapter] of [manga] is named in its list: the source's title, or
/// "Chapter 12" / "Episode 3" when [byNumber]. A chapter whose name holds
/// no number keeps its title.
String chapterDisplayName(
  Chapter chapter,
  Manga manga,
  AppLocalizations l10n, {
  required bool byNumber,
}) {
  final title = chapter.name ?? '';
  if (!byNumber) return title;
  final (_, number) = ChapterRecognition().rawSeasonAndNumber(
    manga.name ?? '',
    title,
  );
  if (number == null || number < 0) return title;
  final shown = number == number.roundToDouble()
      ? number.toInt().toString()
      : number.toString();
  final word = manga.itemType == ItemType.anime ? l10n.episode : l10n.chapter;
  // The word is stored in lower case, for use inside sentences.
  final label = word.isEmpty ? word : word[0].toUpperCase() + word.substring(1);
  return '$label $shown';
}
