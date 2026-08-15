/// Which side a shell tab page should come in from.
///
/// `1` when the tab being opened sits to the right of the one being left, `-1`
/// when it sits to the left, and `0` for no slide at all.
///
/// Held here rather than passed through the route because go_router builds
/// these pages itself and has no idea how the tabs are arranged. The shell
/// does: it knows the user's own navigation order, so it works the direction
/// out and leaves it here immediately before it navigates.
int _slide = 0;

/// The direction the next tab page should arrive from.
int get tabSlide => _slide;

/// Records which way the tab about to be opened lies.
///
/// Pass 0 for a switch that is already animating on its own. A swipe carries
/// the pages across under the finger, and sliding them again on arrival plays
/// the same movement twice.
void setTabSlide(int direction) => _slide = direction;

/// The direction between two positions in the navigation order.
int slideBetween(int from, int to) {
  if (from == to) return 0;
  return to > from ? 1 : -1;
}
