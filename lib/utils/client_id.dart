import 'dart:math';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';

/// Generates a `clientId`: a value made once when a synced row is created,
/// then only ever compared, never regenerated for that row again (see
/// docs/sync_api.md in the sync server repo for the wire contract this
/// backs).
///
/// Kept within 2^52 so two devices that create rows on their own, before
/// ever syncing with each other, almost never collide by accident, while
/// staying well under Dart/JS's safe integer range (2^53 - 1) so the value
/// survives a JSON round trip through the server without precision loss.
final _random = Random.secure();

const _maxClientId = 0xFFFFFFFFFFFFF; // 2^52 - 1

int generateClientId() {
  // Random.secure() only hands out 32 bits at a time, so two calls are
  // combined to fill the wider range instead of wasting the extra headroom.
  final high = _random.nextInt(1 << 32);
  final low = _random.nextInt(1 << 32);
  final combined = (high << 32) | low;
  // & keeps this positive and within _maxClientId regardless of how the
  // bits landed above.
  final value = combined & _maxClientId;
  // 0 is reserved as "not yet assigned" throughout the sync code, so never hand it out.
  return value == 0 ? 1 : value;
}

/// Assigns a `clientId` to every synced row that doesn't have one yet: both
/// pre-existing rows from before this field existed, and any created during
/// the current session. Cheap to call often - `clientId` is indexed, so once
/// caught up this is just six empty indexed lookups.
///
/// Called once at app startup (covers old data promptly), and again right
/// before a sync's upload is built (covers a row made earlier in the same
/// session, which startup's sweep couldn't have seen yet).
///
/// The reads happen outside any transaction (Isar allows that freely); the
/// writes are wrapped in one `isar.writeTxnSync()` - Isar requires every
/// write, even a single `put()`, to run inside an explicit transaction, and
/// it does not open one of its own. Kept fully synchronous (no `await`
/// anywhere inside the transaction) rather than the async `writeTxn` form:
/// a sync transaction is one uninterrupted call with no event-loop turn in
/// the middle, so there is no window for it to overlap with anything else.
/// Routed through `dbWriteQueue` like every other write in the app, since
/// this can run unawaited at startup (see main.dart) alongside an ordinary
/// save or a sync - the shared queue serializes those instead of letting
/// them collide.
Future<void> backfillMissingClientIds() async {
  final categories = isar.categorys.filter().clientIdIsNull().findAllSync();
  final mangas = isar.mangas.filter().clientIdIsNull().findAllSync();
  final chapters = isar.chapters.filter().clientIdIsNull().findAllSync();
  final tracks = isar.tracks.filter().clientIdIsNull().findAllSync();
  final histories = isar.historys.filter().clientIdIsNull().findAllSync();
  final updates = isar.updates.filter().clientIdIsNull().findAllSync();

  if (categories.isEmpty &&
      mangas.isEmpty &&
      chapters.isEmpty &&
      tracks.isEmpty &&
      histories.isEmpty &&
      updates.isEmpty) {
    return;
  }

  await dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      for (final row in categories) {
        categoryRepository.putSync(row..clientId = generateClientId());
      }
      for (final row in mangas) {
        mangaRepository.putSync(row..clientId = generateClientId());
      }
      for (final row in chapters) {
        chapterRepository.putSync(row..clientId = generateClientId());
      }
      for (final row in tracks) {
        isar.tracks.putSync(row..clientId = generateClientId());
      }
      for (final row in histories) {
        historyRepository.putSync(row..clientId = generateClientId());
      }
      for (final row in updates) {
        updateRepository.putSync(row..clientId = generateClientId());
      }
    });
  });
}
