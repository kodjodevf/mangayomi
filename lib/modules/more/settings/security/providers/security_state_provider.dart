import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'security_state_provider.g.dart';

@riverpod
class AppLockEnabledState extends _$AppLockEnabledState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.appLockEnabled ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..appLockEnabled = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

/// Tracks whether the app is currently unlocked.
/// Resets to false when app goes to background (if lock is enabled).
@riverpod
class AppUnlockedState extends _$AppUnlockedState {
  @override
  bool build() {
    // If app lock is not enabled, always unlocked
    final lockEnabled = isar.settings.getSync(227)!.appLockEnabled ?? false;
    return !lockEnabled;
  }

  void unlock() => state = true;

  void lock() => state = false;
}
