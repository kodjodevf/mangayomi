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
}
