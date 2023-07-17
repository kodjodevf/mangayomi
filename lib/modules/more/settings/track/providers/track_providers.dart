import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
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

  void updateTrackManga(Track track) {
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

    isar.writeTxnSync(() => isar.tracks.putSync(track..syncId = syncId));
  }

  void deleteTrackManga(Track track) {
    isar.writeTxnSync(() => isar.tracks.deleteSync(track.id!));
  }
}
