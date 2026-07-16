import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';

/// Whether to show the source name as a badge on library covers. Off by default
/// (covers already carry several badges). Persisted on the Settings collection.
final librarySourceBadgeProvider = NotifierProvider<LibrarySourceBadge, bool>(
  LibrarySourceBadge.new,
);

class LibrarySourceBadge extends Notifier<bool> {
  @override
  bool build() => isar.settings.getSync(227)?.showSourceBadge ?? false;

  void set(bool value) {
    state = value;
    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227);
      if (settings != null) {
        isar.settings.putSync(settings..showSourceBadge = value);
      }
    });
  }
}
