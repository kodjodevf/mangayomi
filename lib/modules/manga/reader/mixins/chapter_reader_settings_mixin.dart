import 'package:flutter/foundation.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/mixins/chapter_controller_mixin.dart';

/// Shared reader-specific settings and actions for a [Chapter].
///
/// This mixin builds on top of [ChapterControllerMixin] and provides:
/// - bookmark toggling
/// - auto-scroll preferences
///
/// It is intended for reader-like controllers (manga/novel), not anime.
///
/// Classes using this mixin may override [onSettingsMutated] to react to
/// settings changes (e.g. invalidate caches).
mixin ChapterReaderSettingsMixin on ChapterControllerMixin {
  // ---------------------------------------------------------------------------
  // Hooks
  // ---------------------------------------------------------------------------

  /// Called after any settings mutation (e.g. [setAutoScroll], [setReaderMode],
  /// [setPageMode], [setShowPageNumber], [setPageIndex]).
  ///
  /// Default is a no-op. Controllers can override this to invalidate caches
  /// or trigger updates when settings change.
  @protected
  void onSettingsMutated() {}

  // ---------------------------------------------------------------------------
  // Bookmarks
  // ---------------------------------------------------------------------------

  /// Toggles the bookmark state of the current [chapter].
  ///
  /// Updates the persisted chapter and bumps its [updatedAt] timestamp.
  /// No-op in incognito mode.
  void setChapterBookmarked() {
    if (incognitoMode) return;
    final isBookmarked = getChapterBookmarked();
    final chap = chapter;
    isar.writeTxnSync(() {
      chap.isBookmarked = !isBookmarked;
      chap.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.chapters.putSync(chap);
    });
  }

  /// Returns whether the current [chapter] is bookmarked.
  ///
  /// Reads directly from the database to ensure consistency.
  bool getChapterBookmarked() {
    return isar.chapters.getSync(chapter.id!)!.isBookmarked!;
  }

  // ---------------------------------------------------------------------------
  // Auto-scroll
  // ---------------------------------------------------------------------------

  /// Returns the auto-scroll configuration for the current manga.
  ///
  /// The tuple contains:
  /// - whether auto-scroll is enabled
  /// - the page offset (scroll speed / distance)
  ///
  /// Falls back to `(false, 10)` if no custom setting exists.
  (bool, double) autoScrollValues() {
    final autoScrollPagesList = getIsarSetting().autoScrollPages ?? [];
    final autoScrollPages = autoScrollPagesList.where(
      (element) => element.mangaId == getManga().id,
    );
    if (autoScrollPages.isNotEmpty) {
      return (
        autoScrollPages.first.autoScroll ?? false,
        autoScrollPages.first.pageOffset ?? 10,
      );
    }
    return (false, 10);
  }

  /// Persists auto-scroll settings for the current manga.
  ///
  /// Replaces any existing entry for this manga with the new values and updates
  /// the global settings object. Calls [onSettingsMutated] afterwards so
  /// controllers can react (e.g. invalidate cached settings).
  void setAutoScroll(bool value, double offset) {
    List<AutoScrollPages>? autoScrollPagesList = [];
    for (var autoScrollPages in getIsarSetting().autoScrollPages ?? []) {
      if (autoScrollPages.mangaId != getManga().id) {
        autoScrollPagesList.add(autoScrollPages);
      }
    }
    autoScrollPagesList.add(
      AutoScrollPages()
        ..mangaId = getManga().id
        ..pageOffset = offset
        ..autoScroll = value,
    );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        getIsarSetting()
          ..autoScrollPages = autoScrollPagesList
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
    onSettingsMutated();
  }
}
