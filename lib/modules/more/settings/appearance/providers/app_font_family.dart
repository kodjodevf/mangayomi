import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_font_family.g.dart';

/// Provides both the raw and resolved font family.
///
/// Returns a tuple `(raw, resolved)`:
/// - `raw`      -> the original font name stored in Isar (e.g. "Roboto")
/// - `resolved` -> the actual font family used by Flutter/GoogleFonts (e.g. "Roboto-Regular")
@riverpod
class AppFontFamily extends _$AppFontFamily {
  static String? _resolveFontFamily(String? fontFamily) {
    if (fontFamily == null || fontFamily.isEmpty) return null;
    try {
      return GoogleFonts.getFont(fontFamily).fontFamily;
    } catch (_) {
      return fontFamily;
    }
  }

  @override
  (String? raw, String? resolved) build() {
    final fontFamily = settingsRepository.current.appFontFamily;
    return (fontFamily, _resolveFontFamily(fontFamily));
  }

  void set(String? fontFamily) {
    settingsRepository.update((s) => s.appFontFamily = fontFamily);
    state = (fontFamily, _resolveFontFamily(fontFamily));
  }
}
