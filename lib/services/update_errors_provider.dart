import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

// UpdateError is an @embedded model on the Settings collection; re-export it so
// existing call sites can keep importing it from this provider.
export 'package:mangayomi/models/settings.dart' show UpdateError;

/// The last library update's failures, persisted on the Settings collection so
/// they can be reviewed on the [UpdateErrorsScreen] rather than only in a
/// transient dialog.
final updateErrorsProvider =
    NotifierProvider<UpdateErrorsNotifier, List<UpdateError>>(
      UpdateErrorsNotifier.new,
    );

class UpdateErrorsNotifier extends Notifier<List<UpdateError>> {
  @override
  List<UpdateError> build() =>
      settingsRepository.current.updateErrorsList ?? const [];

  /// Replaces the stored failures with the latest update run's results.
  void set(List<UpdateError> errors) {
    state = errors;
    _persist();
  }

  /// Drops a single entry (e.g. after the user migrated or handled it).
  void remove(int mangaId) {
    state = state.where((e) => e.mangaId != mangaId).toList();
    _persist();
  }

  void clear() {
    state = [];
    _persist();
  }

  void _persist() {
    settingsRepository.update((s) => s.updateErrorsList = [...state]);
  }
}
