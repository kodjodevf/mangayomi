import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

void main() {
  late Directory databaseDirectory;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    databaseDirectory = await Directory.systemTemp.createTemp(
      'mangayomi-community-repo-',
    );
    app.isar = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: databaseDirectory.path,
      name: 'community_repo_${databaseDirectory.path.hashCode}',
    );
    app.isar.writeTxnSync(() {
      app.isar.settings.putSync(Settings()..checkForExtensionUpdates = false);
    });
  });

  tearDown(() async {
    await app.isar.close(deleteFromDisk: true);
    if (await databaseDirectory.exists()) {
      await databaseDirectory.delete(recursive: true);
    }
  });

  test('awaiting set guarantees that the repository is persisted', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(
      extensionsRepoStateProvider(ItemType.manga).notifier,
    );

    await notifier.set([
      Repo(name: 'Community', jsonUrl: 'https://example.com/manga.json'),
    ]);

    expect(
      app.isar.settings.getSync(227)!.mangaExtensionsRepo!.single.jsonUrl,
      'https://example.com/manga.json',
    );
  });

  test('concurrent content-type writes are serialized without loss', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await Future.wait([
      container.read(extensionsRepoStateProvider(ItemType.manga).notifier).set([
        Repo(jsonUrl: 'https://example.com/manga.json'),
      ]),
      container.read(extensionsRepoStateProvider(ItemType.anime).notifier).set([
        Repo(jsonUrl: 'https://example.com/anime.json'),
      ]),
      container.read(extensionsRepoStateProvider(ItemType.novel).notifier).set([
        Repo(jsonUrl: 'https://example.com/novel.json'),
      ]),
    ]);

    final settings = app.isar.settings.getSync(227)!;
    expect(
      settings.mangaExtensionsRepo!.single.jsonUrl,
      'https://example.com/manga.json',
    );
    expect(
      settings.animeExtensionsRepo!.single.jsonUrl,
      'https://example.com/anime.json',
    );
    expect(
      settings.novelExtensionsRepo!.single.jsonUrl,
      'https://example.com/novel.json',
    );
  });

  test('set waits behind an active settings transaction', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final transactionStarted = Completer<void>();
    final releaseTransaction = Completer<void>();
    final activeWrite = settingsRepository.transaction(() async {
      transactionStarted.complete();
      await releaseTransaction.future;
    });
    await transactionStarted.future;

    var setCompleted = false;
    final setFuture = container
        .read(extensionsRepoStateProvider(ItemType.anime).notifier)
        .set([Repo(jsonUrl: 'https://example.com/queued.json')])
        .then((_) => setCompleted = true);
    await Future<void>.delayed(Duration.zero);
    expect(setCompleted, isFalse);

    releaseTransaction.complete();
    await Future.wait([activeWrite, setFuture]);
    expect(setCompleted, isTrue);
  });
}
