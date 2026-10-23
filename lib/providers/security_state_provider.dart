import 'package:mangayomi/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/services/secure_screen.dart';
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

@riverpod
class AppLockDelayState extends _$AppLockDelayState {
  @override
  int build() {
    return settingsRepository.current.appLockDelayMinutes ?? 0;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.appLockDelayMinutes = value);
  }
}

@riverpod
class SecureScreenState extends _$SecureScreenState {
  @override
  SecureScreenMode build() {
    final index = settingsRepository.current.secureScreen ?? 0;
    return SecureScreenMode.values[index.clamp(
      0,
      SecureScreenMode.values.length - 1,
    )];
  }

  void set(SecureScreenMode value) {
    state = value;
    settingsRepository.update((s) => s.secureScreen = value.index);
  }
}

/// Whether the screen is secure right now: see [isScreenSecure].
@riverpod
bool secureScreenOn(Ref ref) => isScreenSecure(
  ref.watch(secureScreenStateProvider),
  incognito: ref.watch(incognitoModeStateProvider),
);

@riverpod
class HideNotificationContentState extends _$HideNotificationContentState {
  @override
  bool build() {
    return settingsRepository.current.hideNotificationContent ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.hideNotificationContent = value);
  }
}
