import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'track_providers.g.dart';

@riverpod
class Tracks extends _$Tracks {
  @override
  TrackPreference? build({required int? syncId}) {
    return isar.trackPreferences.getSync(syncId!);
  }

  void login(TrackPreference trackPreference) {
    isar.writeTxnSync(() {
      isar.trackPreferences.putSync(trackPreference);
    });
  }

  void logout() {
    isar.writeTxnSync(() {
      isar.trackPreferences.deleteSync(syncId!);
    });
  }

  void updateTrackManga(Track track, ItemType itemType) {
    final tra = isar.tracks
        .filter()
        .syncIdEqualTo(syncId)
        .mangaIdEqualTo(track.mangaId)
        .findAllSync();
    if (tra.isNotEmpty) {
      if (tra.first.mediaId != track.mangaId) {
        track.id = tra.first.id;
      }
    }

    isar.writeTxnSync(() {
      isar.tracks.putSync(track
        ..syncId = syncId
        ..itemType = itemType);
      if (tra.isEmpty) {
        ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPart(ActionType.addTrack, null, track.toJson(), false);
      } else {
        ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(
            ActionType.updateTrack, track.id, track.toJson(), false);
      }
    });
  }

  void deleteTrackManga(Track track) {
    isar.writeTxnSync(() {
      isar.tracks.deleteSync(track.id!);
      ref
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPart(ActionType.removeTrack, track.id, "{}", false);
    });
  }
}

@riverpod
class UpdateProgressAfterReadingState
    extends _$UpdateProgressAfterReadingState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.updateProgressAfterReading ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..updateProgressAfterReading = value));
  }
}
