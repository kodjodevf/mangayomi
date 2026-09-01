import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';

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
  Listing({required this.id, required this.name, this.kind = ListingKind.defaultKind});

  String id;
  String name;
  ListingKind kind;

  factory Listing.fromPostcard(PostcardReader reader) {
    final id = reader.readString();
    final name = reader.readString();
    final kind = ListingKind.fromValue(reader.readU8());
    return Listing(id: id, name: name, kind: kind);
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeString(id);
    writer.writeString(name);
    writer.writeU8(kind.value);
  }

  @override
  String toString() => 'Listing(id: $id, name: $name, kind: $kind)';
}
