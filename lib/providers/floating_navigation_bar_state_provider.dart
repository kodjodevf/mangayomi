import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'floating_navigation_bar_state_provider.g.dart';

@riverpod
class FloatingNavigationBarState extends _$FloatingNavigationBarState {
  @override
  bool build() {
    return settingsRepository.current.useFloatingNavigationBar ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.useFloatingNavigationBar = value);
  }
}
