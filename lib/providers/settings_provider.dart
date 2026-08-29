import 'dart:async';

import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class CachedSettings extends _$CachedSettings {
  StreamSubscription<Settings>? _subscription;

  @override
  Settings build() {
    // Single initial sync read from Isar on app boot
    final initialSettings =
        settingsRepository.currentOrNull ?? Settings(id: 227);

    // Watch Isar settings collection for external changes (e.g. sync/restore)
    _subscription?.cancel();
    _subscription = settingsRepository.watch().listen((settings) {
      state = settings;
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return initialSettings;
  }

  void update(Settings Function(Settings s) updater) {
    final updated = updater(state);
    settingsRepository.save(updated);
    state = updated;
  }
}
