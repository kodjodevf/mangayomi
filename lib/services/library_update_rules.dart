import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';

/// Which library entries a library update leaves alone.
///
/// The skip-updates flag of a category only applies when the whole library is
/// refreshed (the Updates tab, the scheduled update): refreshing a category
/// from the library itself is asking for that category.
class LibraryUpdateRules {
  const LibraryUpdateRules({
    this.skippedCategoryIds = const {},
    this.skipCompleted = false,
    this.skipUnread = false,
    this.skipNotStarted = false,
  });

  factory LibraryUpdateRules.fromSettings(
    Settings settings, {
    Set<int> skippedCategoryIds = const {},
  }) => LibraryUpdateRules(
    skippedCategoryIds: skippedCategoryIds,
    skipCompleted: settings.libraryUpdateSkipCompleted ?? false,
    skipUnread: settings.libraryUpdateSkipUnread ?? false,
    skipNotStarted: settings.libraryUpdateSkipNotStarted ?? false,
  );

  /// Categories marked to skip updates; an entry in any of them is skipped.
  final Set<int> skippedCategoryIds;

  /// Entries whose status is completed.
  final bool skipCompleted;

  /// Entries with at least one unread chapter.
  final bool skipUnread;

  /// Entries with chapters, none of them read yet.
  final bool skipNotStarted;

  bool get isEmpty =>
      skippedCategoryIds.isEmpty &&
      !skipCompleted &&
      !skipUnread &&
      !skipNotStarted;

  /// Whether [manga], whose chapters are [chapters], is updated.
  bool allows(Manga manga, List<Chapter> chapters) {
    if (manga.categories?.any(skippedCategoryIds.contains) ?? false) {
      return false;
    }
    if (skipCompleted && manga.status == Status.completed) return false;
    if (skipUnread && chapters.any((c) => c.isRead != true)) return false;
    if (skipNotStarted &&
        chapters.isNotEmpty &&
        !chapters.any((c) => c.isRead == true)) {
      return false;
    }
    return true;
  }
}

/// Whether the new chapters a library update finds for [manga] are
/// downloaded, given the categories [included] (none meaning every one) and
/// [excluded]. An excluded category wins over an included one.
bool downloadsNewChaptersOf(
  Manga manga, {
  required Iterable<int> included,
  required Iterable<int> excluded,
}) {
  final categories = manga.categories ?? const <int>[];
  if (categories.any(excluded.contains)) return false;
  return included.isEmpty || categories.any(included.contains);
}
