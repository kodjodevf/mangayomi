import 'package:flutter/foundation.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'onboarding_state_provider.g.dart';

/// Whether the first-run screen has already been dismissed.
///
/// Null means the question has never been answered on this install, either
/// because it predates the screen or because the install is new. An existing
/// user with a repository is treated as done, because somebody with a library
/// should not be welcomed to the app they have been using for months.
///
/// A debug build answers null as done too. Those get installed over and over
/// during development and a welcome screen on every one of them is noise; the
/// entry in General settings is how to see the screen on purpose. Release
/// builds keep the real first-run behaviour.
@riverpod
class OnboardingCompletedState extends _$OnboardingCompletedState {
  @override
  bool build() {
    final settings = isar.settings.getSync(227)!;
    final completed = settings.onboardingCompleted;
    if (completed != null) return completed;
    if (kDebugMode) return true;
    return (settings.mangaExtensionsRepo?.isNotEmpty ?? false) ||
        (settings.animeExtensionsRepo?.isNotEmpty ?? false) ||
        (settings.novelExtensionsRepo?.isNotEmpty ?? false);
  }

  void complete() => _set(true);

  /// Shows the first-run screen again, from the beginning.
  ///
  /// Writing false rather than clearing the flag matters: null would fall back
  /// to the checks above, which answer "done" for anyone who already has a
  /// repository, so the screen would never actually appear.
  void showAgain() => _set(false);

  void _set(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..onboardingCompleted = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
