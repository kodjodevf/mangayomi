/// Process-wide signal that the active reader is being replaced by another
/// chapter's reader (via `pushReplacement`), rather than closed.
///
/// The old reader's `dispose()` runs after the new reader is created, so
/// without this flag it would clobber the new reader's fullscreen / system UI
/// state. Any widget that switches chapters from inside a reader (chapter
/// list dialog, transition page, next/previous buttons) marks it; the
/// disposing reader consumes it.
///
/// Lives in `reader_common` so shared reader widgets don't have to import a
/// concrete reader view (which used to create an import cycle).
abstract final class ReaderChapterNavigation {
  static bool _isNavigatingToChapter = false;

  /// Whether a chapter switch is in progress.
  static bool get isNavigatingToChapter => _isNavigatingToChapter;

  /// Marks that the current reader is about to be replaced by another chapter.
  static void markNavigatingToChapter() => _isNavigatingToChapter = true;

  /// Clears the flag, e.g. when the replacement failed.
  static void reset() => _isNavigatingToChapter = false;

  /// Returns whether a chapter switch was in progress and clears the flag.
  static bool consume() {
    final value = _isNavigatingToChapter;
    _isNavigatingToChapter = false;
    return value;
  }
}
