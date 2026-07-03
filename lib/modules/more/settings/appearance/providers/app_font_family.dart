import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
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
    final fontFamily = isar.settings.getSync(227)?.appFontFamily;
    return (fontFamily, _resolveFontFamily(fontFamily));
  }

  void set(String? fontFamily) {
    final settings = isar.settings.getSync(227);
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..appFontFamily = fontFamily
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
    state = (fontFamily, _resolveFontFamily(fontFamily));
  }
}
