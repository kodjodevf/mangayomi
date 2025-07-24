import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'color_filter_provider.g.dart';

@riverpod
class CustomColorFilterState extends _$CustomColorFilterState {
  @override
  CustomColorFilter? build() {
    if (!ref.watch(enableCustomColorFilterStateProvider)) return null;
    return isar.settings.getSync(227)!.customColorFilter;
  }

  void set(int a, int r, int g, int b, bool end) {
    final settings = isar.settings.getSync(227);
    var value = CustomColorFilter()
      ..a = a
      ..r = r
      ..g = g
      ..b = b;
    if (end) {
      isar.writeTxnSync(
        () => isar.settings.putSync(
          settings!
            ..customColorFilter = value
            ..updatedAt = DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
    state = value;
  }
}

@riverpod
class EnableCustomColorFilterState extends _$EnableCustomColorFilterState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.enableCustomColorFilter ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);

    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..enableCustomColorFilter = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
    state = value;
  }
}

@riverpod
class ColorFilterBlendModeState extends _$ColorFilterBlendModeState {
  @override
  ColorFilterBlendMode build() {
    return isar.settings.getSync(227)!.colorFilterBlendMode;
  }

  void set(ColorFilterBlendMode value) {
    final settings = isar.settings.getSync(227);

    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..colorFilterBlendMode = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
    state = value;
  }
}
