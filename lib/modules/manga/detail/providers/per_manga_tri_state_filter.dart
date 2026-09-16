// The read/write/cycle mechanics shared by the three chapter-list filter
// notifiers in state_providers.dart (downloaded/unread/bookmarked): each
// keeps a list of per-manga filter records in settings (defaulting to
// "off" when this manga has no record yet) and cycles its type through
// 0 (off) -> 1 (match) -> 2 (exclude) -> 0. The three notifiers used to
// copy this by hand, differing only in which settings list and record type
// they point at.
/// Deliberately not constrained with `on Notifier<int>`: Riverpod's
/// generated family-notifier base class doesn't satisfy that constraint
/// cleanly, and it breaks the analyzer's override check on `build()`.
/// Declaring `state` directly is enough - the generated class already has
/// a matching getter/setter.
mixin PerMangaTriStateFilter<T> {
  int get mangaId;
  int get state;
  set state(int value);

  /// The current list of filter records for every manga (from settings).
  List<T> currentList();

  int mangaIdOf(T entry);
  int typeOf(T entry);
  T create(int mangaId, int type);

  /// Persists the updated per-manga list.
  void persist(List<T> updated);

  int getType() {
    for (final entry in currentList()) {
      if (mangaIdOf(entry) == mangaId) return typeOf(entry);
    }
    return 0;
  }

  void setType(int type) {
    final updated = [
      for (final entry in currentList())
        if (mangaIdOf(entry) != mangaId) entry,
      create(mangaId, type),
    ];
    persist(updated);
    state = type;
  }

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
