import 'dart:async';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@riverpod
class CachedSettings extends _$CachedSettings {
  StreamSubscription<List<Settings>>? _subscription;

  @override
  Settings build() {
    // Single initial sync read from Isar on app boot
    final initialSettings = isar.settings.getSync(227) ?? Settings(id: 227);

    // Watch Isar settings collection for external changes (e.g. sync/restore)
    _subscription?.cancel();
    _subscription = isar.settings
        .where()
        .idEqualTo(227)
        .watch(fireImmediately: false)
        .listen((events) {
          if (events.isNotEmpty) {
            state = events.first;
          }
        });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return initialSettings;
  }

  void update(Settings Function(Settings s) updater) {
    final updated = updater(state);
    isar.writeTxnSync(() {
      isar.settings.putSync(
        updated..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
    state = updated;
  }
}
