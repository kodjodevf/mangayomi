import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Hive box + key for the user's explicit anime-only-layout override.
/// A stored `bool` forces it on/off; absent means "auto" (follow [isTv]).
const _boxName = 'tv_prefs';
const _overrideKey = 'anime_only_override';
const _tvHomeStyleKey = 'tv_home_style';
const _genreRowsKey = 'tv_home_genre_rows';

/// Opens the backing box. Called once at startup.
Future<void> openTvPrefsBox() async {
  if (!Hive.isBoxOpen(_boxName)) {
    await Hive.openBox(_boxName);
  }
}

/// Whether to show the anime-only TV layout (manga + novel libraries hidden,
/// anime-first). Defaults to [isTv] — i.e. on for Android TV, off everywhere
/// else — and can be explicitly overridden by the user as an escape hatch, so
/// a wrong detection can never strand someone with manga hidden.
final animeOnlyTvModeProvider = NotifierProvider<AnimeOnlyTvMode, bool>(
  AnimeOnlyTvMode.new,
);

class AnimeOnlyTvMode extends Notifier<bool> {
  @override
  bool build() {
    if (Hive.isBoxOpen(_boxName)) {
      final override = Hive.box(_boxName).get(_overrideKey);
      if (override is bool) return override;
    }
    return isTv;
  }

  /// Explicitly turns the anime-only layout on/off and persists the choice.
  void set(bool value) {
    state = value;
    if (Hive.isBoxOpen(_boxName)) {
      Hive.box(_boxName).put(_overrideKey, value);
    }
  }
}

/// Whether the anime library uses the TV home (hero + rows) instead of the flat
/// grid. Defaults to [isTv], and is togglable in Appearance so a TV user can
/// always fall back to the grid.
final tvHomeStyleProvider = NotifierProvider<TvHomeStyle, bool>(
  TvHomeStyle.new,
);

class TvHomeStyle extends Notifier<bool> {
  @override
  bool build() {
    if (Hive.isBoxOpen(_boxName)) {
      final v = Hive.box(_boxName).get(_tvHomeStyleKey);
      if (v is bool) return v;
    }
    return isTv;
  }

  void set(bool value) {
    state = value;
    if (Hive.isBoxOpen(_boxName)) {
      Hive.box(_boxName).put(_tvHomeStyleKey, value);
    }
  }
}

/// Whether the TV home shows its genre rows. They're the one place a title can
/// appear in more than one row, so anyone who finds that repetitive can switch
/// them off from the filter/sort/display sheet. On by default.
final tvHomeGenreRowsProvider = NotifierProvider<TvHomeGenreRows, bool>(
  TvHomeGenreRows.new,
);

class TvHomeGenreRows extends Notifier<bool> {
  @override
  bool build() {
    if (Hive.isBoxOpen(_boxName)) {
      final v = Hive.box(_boxName).get(_genreRowsKey);
      if (v is bool) return v;
    }
    return true;
  }

  void set(bool value) {
    state = value;
    if (Hive.isBoxOpen(_boxName)) {
      Hive.box(_boxName).put(_genreRowsKey, value);
    }
  }
}
