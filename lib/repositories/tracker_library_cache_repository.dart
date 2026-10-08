import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/models/tracker_library_cache.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class TrackerLibraryCacheRepository {
  Future<List<TrackSearch>?> get(String key) async =>
      (await isar.trackerLibraryCaches.get(fastHash(key)))?.tracks;

  Future<void> put(String key, List<TrackSearch> tracks) => dbWriteQueue.run(
    () => isar.writeTxn(
      () => isar.trackerLibraryCaches.put(
        TrackerLibraryCache()
          ..key = key
          ..tracks = tracks,
      ),
    ),
  );

  Future<void> deleteByPrefix(String prefix) => dbWriteQueue.run(
    () => isar.writeTxn(
      () =>
          isar.trackerLibraryCaches.filter().keyStartsWith(prefix).deleteAll(),
    ),
  );
}

final trackerLibraryCacheRepository = TrackerLibraryCacheRepository();
