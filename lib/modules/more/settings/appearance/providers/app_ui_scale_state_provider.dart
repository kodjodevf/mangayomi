import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_ui_scale_state_provider.g.dart';

/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [AppUiScale]); higher renders the UI larger, lower smaller.
@riverpod
class AppUiScaleState extends _$AppUiScaleState {
  @override
  double build() {
    return settingsRepository.current.appUiScale ?? 1.0;
  }

  void set(double value, {bool end = false}) {
    state = value;
    if (end) {
      settingsRepository.update((s) => s.appUiScale = state);
    }
  }
}
