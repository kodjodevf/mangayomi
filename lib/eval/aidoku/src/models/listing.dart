enum ListingKind {
  defaultKind(0),
  list(1);

  const ListingKind(this.value);
  final int value;

  static ListingKind fromValue(int val) {
    for (final k in values) {
      if (k.value == val) return k;
    }
    return ListingKind.defaultKind;
  }
}

/// Represents a source listing (e.g. Popular, Latest, Top Rated).
class Listing {
  Listing({
    required this.id,
    required this.name,
    this.kind = ListingKind.defaultKind,
  });

  String id;
  String name;
  ListingKind kind;

  @override
  String toString() => 'Listing(id: $id, name: $name, kind: $kind)';
}
