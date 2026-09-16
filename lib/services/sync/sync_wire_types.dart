import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';

// Positionally aligned with the server's zod enums (see lib/validation/sync.ts),
// so the index each Dart enum already carries doubles as the lookup key.
const wireItemTypes = ['MANGA', 'ANIME', 'NOVEL'];
const wireStatuses = [
  'ONGOING',
  'COMPLETED',
  'CANCELED',
  'UNKNOWN',
  'ON_HIATUS',
  'PUBLISHING_FINISHED',
];
const wireTrackStatuses = [
  'READING',
  'COMPLETED',
  'ON_HOLD',
  'DROPPED',
  'PLAN_TO_READ',
  'RE_READING',
  'WATCHING',
  'PLAN_TO_WATCH',
  'RE_WATCHING',
];

ItemType itemTypeFromWire(String value) =>
    ItemType.values[wireItemTypes.indexOf(value)];
Status statusFromWire(String? value) =>
    value == null ? Status.unknown : Status.values[wireStatuses.indexOf(value)];
TrackStatus trackStatusFromWire(String? value) => value == null
    ? TrackStatus.reading
    : TrackStatus.values[wireTrackStatuses.indexOf(value)];
