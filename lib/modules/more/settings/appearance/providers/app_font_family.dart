import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_font_family.g.dart';

@riverpod
class AppFontFamily extends _$AppFontFamily {
  @override
  String? build() {
    return isar.settings.getSync(227)!.appFontFamily;
  }

  void set(String? fontFamily) {
    final settings = isar.settings.getSync(227);
    state = fontFamily;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..appFontFamily = fontFamily));
  }
}
