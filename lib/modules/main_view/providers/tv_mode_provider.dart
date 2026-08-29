import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/utils/platform_utils.dart';

// Android TV preferences, stored on the Settings collection. A null field means
// "auto" (follow the default below); a stored bool is an explicit override.

/// Whether to show the anime-only TV layout (manga + novel libraries hidden,
/// anime-first). Defaults to [isTv] - i.e. on for Android TV, off everywhere
/// else - and can be explicitly overridden by the user as an escape hatch, so
/// a wrong detection can never strand someone with manga hidden.
final animeOnlyTvModeProvider = NotifierProvider<AnimeOnlyTvMode, bool>(
  AnimeOnlyTvMode.new,
);

class AnimeOnlyTvMode extends Notifier<bool> {
  @override
  bool build() => settingsRepository.current.tvAnimeOnlyOverride ?? isTv;

  /// Explicitly turns the anime-only layout on/off and persists the choice.
  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.tvAnimeOnlyOverride = value);
  }
}

/// Which controls to use for the anime player on TV: `true` = the dedicated TV
/// player (default), `false` = the original desktop player. Only consulted when
/// [isTv]; phones/desktops are unaffected.
final tvPlayerStyleProvider = NotifierProvider<TvPlayerStyle, bool>(
  TvPlayerStyle.new,
);

class TvPlayerStyle extends Notifier<bool> {
  @override
  bool build() => settingsRepository.current.tvPlayerStyle ?? true;

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.tvPlayerStyle = value);
  }
}

/// Which anime library "home" to show on TV: `true` = the dedicated rows-based
/// TV home (hero + Continue / New Episodes / Recently Added / category rows),
/// `false` = the classic cover grid. Only consulted when [isTv]; phones and
/// desktops always get the grid.
final tvHomeStyleProvider = NotifierProvider<TvHomeStyle, bool>(
  TvHomeStyle.new,
);

class TvHomeStyle extends Notifier<bool> {
  @override
  bool build() => settingsRepository.current.tvHomeStyle ?? isTv;

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.tvHomeStyle = value);
  }
}

/// Whether the TV home shows its genre rows. They're the one place a title can
/// appear more than once, so anyone who finds that repetitive can switch them
/// off from the filter/sort/display sheet. On by default.
final tvHomeGenreRowsProvider = NotifierProvider<TvHomeGenreRows, bool>(
  TvHomeGenreRows.new,
);

class TvHomeGenreRows extends Notifier<bool> {
  @override
  bool build() => settingsRepository.current.tvHomeGenreRows ?? true;

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.tvHomeGenreRows = value);
  }
}
