import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'show_updates_badge_state_provider.g.dart';

@riverpod
class ShowUpdatesBadgeState extends _$ShowUpdatesBadgeState {
  @override
  bool build() {
    return settingsRepository.current.showUpdatesBadge ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.showUpdatesBadge = value);
  }
}
