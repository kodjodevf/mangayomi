import 'package:mangayomi/main.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

// Restore's transactions are large, restore-specific bulk operations (clear +
// replace/merge across mangas, chapters, categories, settings, etc.) that
// don't fit the per-aggregate repositories' intent-named methods - each
// restore path needs its own bespoke logic, not a generic "save" or "putAll".
// This just gives restore its own queued write path, consistent with the
// rest of the app, without forcing that logic into the wrong repository.
class RestoreRepository {
  Future<T> run<T>(T Function() body) =>
      dbWriteQueue.run(() => isar.writeTxnSync<T>(body));
}

final restoreRepository = RestoreRepository();
