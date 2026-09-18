import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/modules/anime/providers/anime_player_controller_provider.dart';

void main() {
  late Directory databaseDirectory;
  late Isar database;
  late ProviderContainer container;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    databaseDirectory = await Directory.systemTemp.createTemp(
      'mangayomi-anime-position-',
    );
    database = await Isar.open(
      [
        MangaSchema,
        ChapterSchema,
        HistorySchema,
        SettingsSchema,
        SourceSchema,
        TrackSchema,
      ],
      directory: databaseDirectory.path,
      name: 'anime_position_test',
    );
    app.isar = database;
    await database.writeTxn(() => database.settings.put(Settings()));
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await database.close(deleteFromDisk: true);
    if (await databaseDirectory.exists()) {
      await databaseDirectory.delete(recursive: true);
    }
  });

  test('saving playback progress persists the total duration', () async {
    final episode = Chapter(mangaId: 1, name: 'Episode 1', isRead: false);
    await database.writeTxn(() => database.chapters.put(episode));

    container
        .read(animeStreamControllerProvider(episode: episode).notifier)
        .setCurrentPosition(
          const Duration(seconds: 49),
          const Duration(minutes: 24),
          save: true,
        );
    await Future<void>.delayed(Duration.zero);

    final saved = await database.chapters.get(episode.id!);
    expect(saved?.lastPageRead, '49000');
    expect(saved?.duration, '1440000');
  });

  test('completion marks the episode seen and updates history', () async {
    final manga = Manga(
      source: 'Source',
      author: '',
      artist: '',
      genre: const [],
      imageUrl: null,
      lang: 'en',
      link: '/anime',
      name: 'Anime',
      status: Status.ongoing,
      description: '',
      sourceId: 1,
    );
    await database.writeTxn(() => database.mangas.put(manga));
    final episode = Chapter(
      mangaId: manga.id,
      name: 'Episode 1',
      isRead: false,
    )..manga.value = manga;
    await database.writeTxn(() async {
      await database.chapters.put(episode);
      await episode.manga.save();
    });

    await container
        .read(animeStreamControllerProvider(episode: episode).notifier)
        .completeEpisode(const Duration(minutes: 24), elapsedSeconds: 42);

    final saved = await database.chapters.get(episode.id!);
    final history = await database.historys.where().findFirst();
    expect(saved?.isRead, isTrue);
    expect(saved?.lastPageRead, '1440000');
    expect(saved?.duration, '1440000');
    expect(history?.mangaId, manga.id);
    expect(history?.chapterId, episode.id);
    expect(history?.readingTimeSeconds, 42);
  });

  test('intermediate playback progress saves without marking as seen', () async {
    final manga = Manga(
      source: 'Source',
      author: '',
      artist: '',
      genre: const [],
      imageUrl: null,
      lang: 'en',
      link: '/anime2',
      name: 'Anime 2',
      status: Status.ongoing,
      description: '',
      sourceId: 1,
    );
    await database.writeTxn(() => database.mangas.put(manga));
    final episode = Chapter(
      mangaId: manga.id,
      name: 'Episode 2',
      isRead: false,
    )..manga.value = manga;
    await database.writeTxn(() async {
      await database.chapters.put(episode);
      await episode.manga.save();
    });

    final notifier = container.read(
      animeStreamControllerProvider(episode: episode).notifier,
    );
    notifier.setCurrentPosition(
      const Duration(minutes: 5),
      const Duration(minutes: 24),
      save: true,
    );
    await notifier.setHistoryUpdate(elapsedSeconds: 300);

    final saved = await database.chapters.get(episode.id!);
    final history = await database.historys.where().findFirst();
    expect(saved?.isRead, isFalse);
    expect(saved?.lastPageRead, '300000');
    expect(saved?.duration, '1440000');
    expect(history?.readingTimeSeconds, 300);
  });

  test('respects episode sort order when enabled', () async {
    final manga = Manga(
      source: 'Source',
      author: '',
      artist: '',
      genre: const [],
      imageUrl: null,
      lang: 'en',
      link: '/anime3',
      name: 'Anime 3',
      status: Status.ongoing,
      description: '',
      sourceId: 1,
    );
    await database.writeTxn(() => database.mangas.put(manga));
    final ep1 = Chapter(
      mangaId: manga.id,
      name: 'Episode 1',
      isRead: false,
    )..manga.value = manga;
    final ep2 = Chapter(
      mangaId: manga.id,
      name: 'Episode 2',
      isRead: false,
    )..manga.value = manga;
    await database.writeTxn(() async {
      await database.chapters.putAll([ep1, ep2]);
      await ep1.manga.save();
      await ep2.manga.save();
      // In Mangayomi, reverse: false corresponds to descending order (ep2, ep1)
      final settings = await database.settings.where().findFirst() ?? Settings();
      settings.sortChapterList = [SortChapter(mangaId: manga.id, index: 1, reverse: false)];
      settings.playerRespectEpisodeSortOrder = true;
      await database.settings.put(settings);
    });

    final notifierEp2 = container.read(
      animeStreamControllerProvider(episode: ep2).notifier,
    );
    // In descending order: list is [ep2, ep1]
    // ep2 is at index 0, so next episode in list order is ep1
    expect(notifierEp2.hasNextEpisode, isTrue);
    expect(notifierEp2.getNextEpisode().id, ep1.id);
    expect(notifierEp2.hasPreviousEpisode, isFalse);

    // When disabled, navigation falls back to chronological ascending order [ep1, ep2]
    await database.writeTxn(() async {
      final settings = await database.settings.where().findFirst() ?? Settings();
      settings.playerRespectEpisodeSortOrder = false;
      await database.settings.put(settings);
    });

    // In chronological order, ep2 is at index 1 (last episode)
    expect(notifierEp2.hasNextEpisode, isFalse);
    expect(notifierEp2.hasPreviousEpisode, isTrue);
    expect(notifierEp2.getPrevEpisode().id, ep1.id);
  });
}
