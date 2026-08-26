import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'pure_black_dark_mode_state_provider.g.dart';

@riverpod
class PureBlackDarkModeState extends _$PureBlackDarkModeState {
  @override
  bool build() {
    return settingsRepository.current.pureBlackDarkMode!;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.pureBlackDarkMode = value);
  }
}
