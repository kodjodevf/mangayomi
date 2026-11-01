import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_badges.dart';
import 'package:mangayomi/providers/show_updates_badge_state_provider.dart';
import 'package:mangayomi/modules/updates/providers/updates_last_seen_provider.dart';
import 'package:mangayomi/modules/updates/updates_screen.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:mangayomi/router/router.dart';
import 'package:shiori/shiori.dart';

/// Stands in for the router: tests move between tabs by setting the location.
class _Location extends RouterCurrentLocationState {
  @override
  String? build() => '/MangaLibrary';

  void go(String location) => state = location;
}

void main() {
  group('countNewUpdates', () {
    Update at(String? date) => Update(mangaId: 1, chapterName: 'c', date: date);

    test('counts only chapters found after the last visit', () {
      final updates = [at('100'), at('200'), at('300')];
      expect(countNewUpdates(updates, 0), 3);
      expect(countNewUpdates(updates, 200), 1);
      expect(countNewUpdates(updates, 300), 0);
    });

    test('an update with no readable date is not new', () {
      expect(countNewUpdates([at(null), at(''), at('soon')], 0), 0);
    });
  });

  test('Updates is recognised whatever the query', () {
    expect(isUpdatesLocation('/updates'), isTrue);
    expect(isUpdatesLocation('/updates?tab=1'), isTrue);
    expect(isUpdatesLocation('/history'), isFalse);
    expect(isUpdatesLocation(null), isFalse);
  });

  test('the badge is on by default and survives settings JSON', () {
    final defaults = Settings();
    expect(defaults.showUpdatesBadge, isTrue);
    expect(defaults.updatesLastSeenAt, isNull);

    final restored = Settings.fromJson({
      ...defaults.toJson(),
      'showUpdatesBadge': false,
      'updatesLastSeenAt': 42,
    });
    expect(restored.showUpdatesBadge, isFalse);
    expect(restored.updatesLastSeenAt, 42);

    final old = Settings().toJson()
      ..remove('showUpdatesBadge')
      ..remove('updatesLastSeenAt');
    expect(Settings.fromJson(old).showUpdatesBadge, isTrue);
  });

  group('the Updates badge', () {
    late Directory dir;
    late Isar db;
    late Manga manga;

    setUpAll(() async {
      // The test binding answers every request with a 400; step out of it for
      // the one download Isar needs.
      final overrides = HttpOverrides.current;
      HttpOverrides.global = null;
      try {
        await Isar.initializeIsarCore(download: true);
      } finally {
        HttpOverrides.global = overrides;
      }
      dir = await Directory.systemTemp.createTemp('mangayomi-badge-');
      db = await StorageProvider().initDB(dir.path);
      app.isar = db;
      manga = Manga(
        source: 'Demo',
        author: '',
        artist: '',
        genre: const [],
        imageUrl: null,
        lang: 'en',
        link: '/series',
        name: 'Series',
        status: Status.ongoing,
        description: '',
        sourceId: null,
        favorite: true,
      );
      await db.writeTxn(() => db.mangas.put(manga));
    });

    tearDownAll(() async {
      await db.close(deleteFromDisk: true);
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    Future<void> addUpdates(int count, int date) async {
      await db.writeTxn(() async {
        for (var i = 0; i < count; i++) {
          final chapter = Chapter(mangaId: manga.id, name: 'Chapter $date-$i');
          await db.chapters.put(chapter);
          chapter.manga.value = manga;
          await chapter.manga.save();
          final update = Update(
            mangaId: manga.id,
            chapterName: chapter.name,
            date: '$date',
          );
          await db.updates.put(update);
          update.chapter.value = chapter;
          await update.chapter.save();
        }
      });
    }

    // A chapter found after any visit so far.
    Future<void> addNewUpdate(WidgetTester tester) => tester.runAsync(
      () => addUpdates(
        1,
        DateTime.now().add(const Duration(minutes: 1)).millisecondsSinceEpoch,
      ),
    );

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 8; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 30)),
        );
        await tester.pump(const Duration(milliseconds: 30));
      }
    }

    String? badge(WidgetTester tester) {
      final badges = tester.widgetList<Badge>(find.byType(Badge));
      if (badges.isEmpty) return null;
      return (badges.single.label! as Text).data;
    }

    // The nav icon, above the Updates screen when [withUpdates]: the way the
    // shell keeps every visited tab mounted and only the route says which one
    // is showing.
    Future<ProviderContainer> pumpApp(
      WidgetTester tester, {
      bool withUpdates = false,
    }) async {
      tester.view.physicalSize = const Size(400, 860);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(
        overrides: [
          routerCurrentLocationStateProvider.overrideWith(_Location.new),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (_, _) => Scaffold(
                    body: withUpdates
                        ? const UpdatesScreen()
                        : const SizedBox.shrink(),
                    bottomNavigationBar: Consumer(
                      builder: (context, ref, _) => UpdatesBadgeWidget(
                        icon: const Icon(Icons.new_releases),
                        ref: ref,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            theme: buildShioriTheme(
              brightness: Brightness.dark,
              colors: FlexColor.schemesList[2].dark,
              tintSurfaces: false,
              blendLevel: 10,
              density: ShioriDensity.phone,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await settle(tester);
      return container;
    }

    // Settings writes go through dbWriteQueue, whose futures belong to the
    // zone that queued them. Queued from a test's fake-async zone they would be
    // stranded once that test ends, so every write is made on real time and
    // waited for.
    Future<void> act(WidgetTester tester, void Function() change) async {
      await tester.runAsync(() async {
        change();
        await settingsRepository.transaction(() {});
      });
      await settle(tester);
    }

    // Unmounting the screen leaves a five-minute cache timer behind.
    Future<void> unmount(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(minutes: 6));
    }

    void go(ProviderContainer container, String location) => (container.read(
      routerCurrentLocationStateProvider.notifier,
    ) as _Location).go(location);

    testWidgets('clears after visiting Updates, then counts new chapters', (
      tester,
    ) async {
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .millisecondsSinceEpoch;
      await tester.runAsync(() => addUpdates(3, yesterday));
      final container = await pumpApp(tester, withUpdates: true);
      expect(badge(tester), '3');

      final settingsStampBefore = settingsRepository.current.updatedAt;
      await act(tester, () => go(container, '/updates'));
      expect(badge(tester), isNull);

      await act(tester, () => go(container, '/MangaLibrary'));
      expect(badge(tester), isNull);
      expect(settingsRepository.current.updatesLastSeenAt, isNotNull);
      // A visit is not a settings change: it must not win a sync.
      expect(settingsRepository.current.updatedAt, settingsStampBefore);

      final later = DateTime.now()
          .add(const Duration(seconds: 5))
          .millisecondsSinceEpoch;
      await tester.runAsync(() => addUpdates(2, later));
      await settle(tester);
      expect(badge(tester), '2');

      // The same after a restart: the last visit is stored.
      final restarted = ProviderContainer();
      expect(
        restarted.read(updatesLastSeenStateProvider),
        settingsRepository.current.updatesLastSeenAt,
      );
      restarted.dispose();
      await unmount(tester);
    });

    testWidgets('the switch hides the badge', (tester) async {
      await addNewUpdate(tester);
      final container = await pumpApp(tester);
      expect(badge(tester), isNotNull);

      final badgeSetting = container.read(
        showUpdatesBadgeStateProvider.notifier,
      );
      await act(tester, () => badgeSetting.set(false));
      expect(badge(tester), isNull);
      expect(settingsRepository.current.showUpdatesBadge, isFalse);

      await act(tester, () => badgeSetting.set(true));
      expect(badge(tester), isNotNull);
      await unmount(tester);
    });

    testWidgets('hidden item types are not counted', (tester) async {
      await addNewUpdate(tester);
      final container = await pumpApp(tester);
      expect(badge(tester), isNotNull);

      final hideItems = container.read(hideItemsStateProvider.notifier);
      await act(tester, () => hideItems.set(['/MangaLibrary']));
      expect(badge(tester), isNull);

      await act(tester, () => hideItems.set([]));
      expect(badge(tester), isNotNull);
      await unmount(tester);
    });
  });
}
