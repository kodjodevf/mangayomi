import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/track_search.dart';
part 'tracker_library_cache.g.dart';

/// One tracker library section's last fetched entries, so reopening the
/// tracker library shows them without hitting the tracker again. Cleared
/// per tracker and item type when the user refreshes.
@collection
@Name("Tracker Library Cache")
class TrackerLibraryCache {
  Id get id => fastHash(key);

  /// `<syncId>-<itemType>-<section name>`. Unique through [id], so a put
  /// for the same section replaces the previous entries.
  late String key;

  List<TrackSearch> tracks = [];
}

/// FNV-1a 64bit, the string-to-Id hash recommended by Isar.
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}
