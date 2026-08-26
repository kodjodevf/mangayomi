import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'color_filter_provider.g.dart';

@riverpod
class CustomColorFilterState extends _$CustomColorFilterState {
  @override
  CustomColorFilter? build() {
    if (!ref.watch(enableCustomColorFilterStateProvider)) return null;
    return settingsRepository.current.customColorFilter;
  }

  void set(int a, int r, int g, int b, bool end) {
    var value = CustomColorFilter()
      ..a = a
      ..r = r
      ..g = g
      ..b = b;
    if (end) {
      settingsRepository.update((s) => s.customColorFilter = value);
    }
    state = value;
  }
}

@riverpod
class EnableCustomColorFilterState extends _$EnableCustomColorFilterState {
  @override
  bool build() {
    return settingsRepository.current.enableCustomColorFilter ?? false;
  }

  void set(bool value) {
    settingsRepository.update((s) => s.enableCustomColorFilter = value);
    state = value;
  }
}

@riverpod
class ColorFilterBlendModeState extends _$ColorFilterBlendModeState {
  @override
  ColorFilterBlendMode build() {
    return settingsRepository.current.colorFilterBlendMode;
  }

  void set(ColorFilterBlendMode value) {
    settingsRepository.update((s) => s.colorFilterBlendMode = value);
    state = value;
  }
}
