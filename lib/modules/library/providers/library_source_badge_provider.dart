import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

const _boxName = 'library_prefs';
const _key = 'show_source_badge';

/// Opens the backing box. Called once at startup (see main.dart).
Future<void> openLibraryPrefsBox() async {
  if (!Hive.isBoxOpen(_boxName)) {
    await Hive.openBox(_boxName);
  }
}

/// Whether to show the source name as a badge on library covers. Off by
/// default — covers already carry several badges — and persisted in Hive so it
/// needs no Isar schema change.
final librarySourceBadgeProvider = NotifierProvider<LibrarySourceBadge, bool>(
  LibrarySourceBadge.new,
);

class LibrarySourceBadge extends Notifier<bool> {
  @override
  bool build() {
    if (Hive.isBoxOpen(_boxName)) {
      final v = Hive.box(_boxName).get(_key);
      if (v is bool) return v;
    }
    return false;
  }

  void set(bool value) {
    state = value;
    if (Hive.isBoxOpen(_boxName)) {
      Hive.box(_boxName).put(_key, value);
    }
  }
}
