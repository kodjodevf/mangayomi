import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'security_state_provider.g.dart';

@riverpod
class AppLockEnabledState extends _$AppLockEnabledState {
  @override
  bool build() {
    return settingsRepository.current.appLockEnabled ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.appLockEnabled = value);
  }
}

/// Tracks whether the app is currently unlocked.
/// Resets to false when app goes to background (if lock is enabled).
@riverpod
class AppUnlockedState extends _$AppUnlockedState {
  @override
  bool build() {
    // If app lock is not enabled, always unlocked
    final lockEnabled = settingsRepository.current.appLockEnabled ?? false;
    return !lockEnabled;
  }

  void unlock() => state = true;

  void lock() => state = false;
}
