import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'onboarding_state_provider.g.dart';

/// Whether the first-run screen has already been dismissed.
///
/// Null means an install from before the screen existed. Those are treated as
/// done when the user already has a repository, because somebody with a library
/// should not be welcomed to the app they have been using for months.
@riverpod
class OnboardingCompletedState extends _$OnboardingCompletedState {
  @override
  bool build() {
    final settings = isar.settings.getSync(227)!;
    final completed = settings.onboardingCompleted;
    if (completed != null) return completed;
    return (settings.mangaExtensionsRepo?.isNotEmpty ?? false) ||
        (settings.animeExtensionsRepo?.isNotEmpty ?? false) ||
        (settings.novelExtensionsRepo?.isNotEmpty ?? false);
  }

  void complete() {
    final settings = isar.settings.getSync(227)!;
    state = true;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..onboardingCompleted = true
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
