/// Which section each tab was left on.
///
/// The shell builds one tab at a time, so leaving a tab disposes its screen
/// and its TabController along with it. Coming back rebuilt it at section
/// zero, which meant swiping out of the last section and straight back landed
/// somewhere you had never been.
///
/// Deliberately in memory only: this is where you were this session, not a
/// preference, and it should not outlive the app.
final Map<String, int> _sections = {};

int rememberedSection(String tab, {int fallback = 0}) =>
    _sections[tab] ?? fallback;

void rememberSection(String tab, int index) => _sections[tab] = index;

/// Used by tests; the app has no reason to clear this.
void clearRememberedSections() => _sections.clear();
