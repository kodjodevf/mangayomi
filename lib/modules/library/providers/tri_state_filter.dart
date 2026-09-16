// The read/write/cycle mechanics shared by every "library filter" notifier
// in library_state_provider.dart (downloaded/unread/started/bookmarked/
// completed/tracking): each cycles one int settings field through
// 0 (off) -> 1 (match) -> 2 (exclude) -> 0, picking the field by item type.
// The six notifiers used to copy this by hand; only the field itself
// (and, for three of them, what "match"/"exclude" filters out of the manga
// list) actually differs between them.
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

/// The trio of settings fields (one per item type) a tri-state filter reads
/// and writes.
class TriStateFilterFields {
  TriStateFilterFields({required this.read, required this.write});

  final int Function(Settings settings, ItemType itemType) read;
  final Settings Function(Settings settings, ItemType itemType, int type) write;
}

/// Provides `getType()`/`setType()` for a tri-state library filter notifier,
/// given the settings fields it points at. Mix in alongside a `fields`
/// override on top of the generated `_$Foo` base class.
///
/// Deliberately not constrained with `on Notifier<int>`: Riverpod's
/// generated family-notifier base class doesn't satisfy that constraint
/// cleanly, and it breaks the analyzer's override check on `build()`.
/// Declaring `state` directly is enough - the generated class already has
/// a matching getter/setter.
mixin TriStateFilterField {
  ItemType get itemType;
  Settings get settings;
  TriStateFilterFields get fields;
  int get state;
  set state(int value);

  int getType() => fields.read(settings, itemType);

  void setType(int type) {
    settingsRepository.save(fields.write(settings, itemType, type));
    state = type;
  }
}

/// Adds the plain 0->1->2->0 cycle on top of [TriStateFilterField], for
/// filters that don't need to return anything from `update()` (they read
/// the manga list back out through a `.select`/`getData()`-style provider
/// elsewhere instead).
mixin TriStateFilterCycle on TriStateFilterField {
  void update() {
    if (state == 0) {
      setType(1);
    } else if (state == 1) {
      setType(2);
    } else {
      setType(0);
    }
  }
}
