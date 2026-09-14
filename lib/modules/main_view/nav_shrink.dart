/// Decides when the floating bar should step back, from the scroll deltas of
/// the page underneath it.
///
/// Kept apart from the widget so the thresholds can be exercised directly:
/// getting them wrong is the difference between a bar that breathes with the
/// list and one that flickers on every stray pixel.
class NavShrink {
  /// Downward run needed before the bar gives way. Long enough that nudging a
  /// list, or the overscroll settling after a fling, leaves it alone.
  static const downTrigger = 90.0;

  /// Upward run that brings it back. Shorter than the trigger on purpose:
  /// reaching for the bar should feel immediate, hiding it should not.
  static const upRelease = 40.0;

  double _run = 0;
  bool _shrunk = false;

  bool get shrunk => _shrunk;

  /// Feeds one scroll delta in. Positive means the content moved up, which is
  /// the reader scrolling down. Returns true when the state changed.
  bool update(double delta) {
    if (delta == 0) return false;
    // A change of direction starts the run over, so a scroll only counts once
    // it has been sustained one way.
    if (_run != 0 && (delta < 0) != (_run < 0)) _run = 0;
    _run += delta;

    if (!_shrunk && _run >= downTrigger) {
      _shrunk = true;
      _run = 0;
      return true;
    }
    if (_shrunk && _run <= -upRelease) {
      _shrunk = false;
      _run = 0;
      return true;
    }
    return false;
  }

  /// Back to rest, whatever the run so far. Used when a list reaches its top
  /// and when the tab changes, where a bar left shrunk would look stuck.
  bool reset() {
    _run = 0;
    if (!_shrunk) return false;
    _shrunk = false;
    return true;
  }
}
