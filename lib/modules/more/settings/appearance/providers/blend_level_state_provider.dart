import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'blend_level_state_provider.g.dart';

@riverpod
class BlendLevelState extends _$BlendLevelState {
  @override
  double build() {
    return settingsRepository.current.flexColorSchemeBlendLevel!;
  }

  void setBlendLevel(double blendLevelValue, {bool end = false}) {
    state = blendLevelValue;
    if (end) {
      settingsRepository.update((s) => s.flexColorSchemeBlendLevel = state);
    }
  }
}
