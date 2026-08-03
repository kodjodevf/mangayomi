import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_font_family.g.dart';

@riverpod
class AppFontFamily extends _$AppFontFamily {
  static String? _resolveFontFamily(String? fontFamily) {
    if (fontFamily == null || fontFamily.isEmpty) return null;
    if (GoogleFonts.asMap().containsKey(fontFamily)) {
      try {
        return GoogleFonts.getFont(fontFamily).fontFamily;
      } catch (_) {
        return fontFamily;
      }
    }
    return fontFamily;
  }

  @override
  String? build() {
    final fontFamily = isar.settings.getSync(227)?.appFontFamily;
    return _resolveFontFamily(fontFamily);
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
    state = _resolveFontFamily(fontFamily);
  }
}
