import 'dart:math';

import 'package:mangayomi/repositories/changed_part_repository.dart';

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
Future<void> backfillMissingClientIds() =>
    changedPartRepository.backfillMissingClientIds(generateClientId);
