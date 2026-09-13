import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';

class TrackRepository {
  TrackPreference? getPreferenceById(int id) =>
      isar.trackPreferences.getSync(id);

  List<Track> getBySyncIdAndMangaId(int? syncId, int? mangaId) => isar.tracks
      .filter()
      .syncIdEqualTo(syncId)
      .mangaIdEqualTo(mangaId)
      .findAllSync();

  Stream<List<TrackPreference>> watchAllNotRefreshing() => isar.trackPreferences
      .filter()
      .syncIdIsNotNull()
      .anyOf([false, null], (q, e) => q.refreshingEqualTo(e))
      .watch(fireImmediately: true);

  Stream<List<TrackPreference>> watchAllWithSyncId() => isar.trackPreferences
      .filter()
      .syncIdIsNotNull()
      .watch(fireImmediately: true);

  Stream<List<Track>> watchByItemTypeWithMangaId(ItemType itemType) => isar
      .tracks
      .filter()
      .itemTypeEqualTo(itemType)
      .mangaIdIsNotNull()
      .watch(fireImmediately: true);

  Stream<List<Track>> watchByItemTypeAndSyncId(ItemType itemType, int syncId) =>
      isar.tracks
          .filter()
          .idIsNotNull()
          .itemTypeEqualTo(itemType)
          .syncIdEqualTo(syncId)
          .watch(fireImmediately: true);

  Stream<List<Track>> watchByMediaIdAndItemType(
    int mediaId,
    ItemType itemType,
  ) => isar.tracks
      .filter()
      .idIsNotNull()
      .mediaIdEqualTo(mediaId)
      .itemTypeEqualTo(itemType)
      .watch(fireImmediately: true);

  Stream<List<Track>> watchBySyncIdAndMangaId(int? syncId, int mangaId) => isar
      .tracks
      .filter()
      .idIsNotNull()
      .syncIdEqualTo(syncId)
      .mangaIdEqualTo(mangaId)
      .watch(fireImmediately: true);

  Stream<List<Track>> watchByMangaId(int mangaId) => isar.tracks
      .filter()
      .idIsNotNull()
      .mangaIdEqualTo(mangaId)
      .watch(fireImmediately: true);

  List<Track> getAllByMangaIdItemType(int mangaId, ItemType itemType) => isar
      .tracks
      .where()
      .mangaIdItemTypeEqualTo(mangaId, itemType)
      .findAllSync();

  Future<TrackPreference?> findPreferenceBySyncIdAsync(int? syncId) =>
      isar.trackPreferences.filter().syncIdEqualTo(syncId).findFirst();

  Stream<List<Track>> watchByEitherMediaId(int? mediaId, int? altMediaId) =>
      isar.tracks
          .filter()
          .idIsNotNull()
          .mediaIdEqualTo(mediaId)
          .or()
          .mediaIdEqualTo(altMediaId)
          .watch(fireImmediately: true);

  TrackPreference? findPreferenceBySyncId(int? syncId) => isar.trackPreferences
      .filter()
      .syncIdIsNotNull()
      .syncIdEqualTo(syncId)
      .findFirstSync();

  List<Track> getAllByMangaId(int? mangaId) =>
      isar.tracks.filter().mangaIdEqualTo(mangaId).findAllSync();

  List<Track> getAll() => isar.tracks.filter().idIsNotNull().findAllSync();

  List<Track> getChangedSince(int since) => isar.tracks
      .filter()
      .updatedAtGreaterThan(since, include: true)
      .findAllSync();

  Track? getByClientId(int clientId) => isar.tracks
      .filter()
      .clientIdEqualTo(clientId)
      .or()
      .idEqualTo(clientId)
      .findFirstSync();

  Track? findBySyncIdAndMangaId(int? syncId, int? mangaId) => isar.tracks
      .filter()
      .syncIdEqualTo(syncId)
      .mangaIdEqualTo(mangaId)
      .findFirstSync();

  // Async twin, for callers already inside an async writeTxn/writeTransactionAsync
  // — Isar rejects a sync findAllSync() call from inside an async transaction.
  Future<List<Track>> getAllAsync() =>
      isar.tracks.filter().idIsNotNull().findAll();

  Stream<List<Track>> watchAll() =>
      isar.tracks.where().watch(fireImmediately: true);

  List<TrackPreference> getAllPreferences() =>
      isar.trackPreferences.filter().syncIdIsNotNull().findAllSync();

  Future<List<TrackPreference>> getAllPreferencesWithSyncId() =>
      isar.trackPreferences.filter().syncIdIsNotNull().findAll();

  int? getMediaIdBySyncAndManga(int syncId, int mangaId) => isar.tracks
      .filter()
      .syncIdEqualTo(syncId)
      .mangaIdEqualTo(mangaId)
      .findFirstSync()
      ?.mediaId;

  Future<void> savePreference(TrackPreference preference) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => isar.trackPreferences.putSync(preference)),
  );

  Future<void> putAllPreferences(List<TrackPreference> preferences) =>
      dbWriteQueue.run(
        () => isar.writeTxn(() => isar.trackPreferences.putAll(preferences)),
      );

  Future<void> deletePreference(int syncId) => dbWriteQueue.run(
    () => isar.writeTxnSync(() => isar.trackPreferences.deleteSync(syncId)),
  );

  // Stamps updatedAt for callers that just want to persist a mutated Track
  // they already hold, without setting the timestamp themselves.
  Future<void> save(Track track) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      track.updatedAt = DateTime.now().millisecondsSinceEpoch;
      isar.tracks.putSync(track);
    });
  });

  Future<void> delete(Ref ref, Track track) => dbWriteQueue.run(() {
    isar.writeTxnSync(() {
      isar.tracks.deleteSync(track.id!);
      ref
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPart(
            ActionType.removeTrack,
            track.id,
            "{}",
            false,
            clientId: track.clientId,
          );
    });
  });

  // Async primitives below are for callers already inside a write
  // transaction opened by transaction()/writeTransaction() — they don't
  // queue on their own.
  Future<int> putAsync(Track track) => isar.tracks.put(track);

  Future<bool> deleteAsync(int id) => isar.tracks.delete(id);

  void putAllSync(List<Track> tracks) => isar.tracks.putAllSync(tracks);

  void clearSync() => isar.tracks.clearSync();

  void putAllPreferencesSync(List<TrackPreference> preferences) =>
      isar.trackPreferences.putAllSync(preferences);

  void clearPreferencesSync() => isar.trackPreferences.clearSync();

  // Escape hatch for track-rooted transactions too specific to name.
  Future<T> transaction<T>(FutureOr<T> Function() body) =>
      dbWriteQueue.run(body);

  Future<T> writeTransaction<T>(T Function() body) =>
      dbWriteQueue.run(() => isar.writeTxnSync(body));

  Future<T> writeTransactionAsync<T>(Future<T> Function() body) =>
      dbWriteQueue.run(() => isar.writeTxn(body));
}

final trackRepository = TrackRepository();
