import 'dart:async';
import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/l10n/l10n_delegates.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/detail/widgets/migrate_screen.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:shiori/shiori.dart';

/// #1137: tapping a result waited for the title's chapters before opening the
/// dialog, so a slow source looked like a tap that did nothing and a failing
/// one never opened it.
void main() {
  late Directory dir;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    dir = await Directory.systemTemp.createTemp('mangayomi-migrate-');
    db = await StorageProvider().initDB(dir.path);
    app.isar = db;
  });

  tearDownAll(() async {
    await db.close(deleteFromDisk: true);
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  // Lets the card's library lookup in Isar finish on real time: left pending,
  // it kept the database from closing.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 4; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
    }
  }

  testWidgets('opens at once, then shows the error and retries', (
    tester,
  ) async {
    final source = Source(id: 1, name: 'Demo', lang: 'en');
    final replies = <Completer<MManga>>[];

    await tester.pumpWidget(
      ProviderScope(
        // As in the app, which doesn't retry a failed provider by itself.
        retry: (_, _) => null,
        overrides: [
          getDetailProvider(url: '/title', source: source).overrideWith((ref) {
            final reply = Completer<MManga>();
            replies.add(reply);
            return reply.future;
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MigrationMangaGlobalImageCard(
              oldManga: Manga(
                source: 'Old',
                author: '',
                artist: '',
                genre: const [],
                imageUrl: null,
                lang: 'en',
                link: '/old',
                name: 'Title',
                status: Status.ongoing,
                description: '',
                sourceId: null,
              ),
              manga: MManga(name: 'Title', link: '/title'),
              source: source,
            ),
          ),
        ),
      ),
    );
    await settle(tester);

    await tester.tap(find.text('Title'));
    await tester.pump();
    await tester.pump();

    // Open while the chapters load, and nothing to confirm yet.
    expect(find.byType(ShioriDialog), findsOneWidget);
    expect(find.byType(ShioriLoading), findsOneWidget);
    expect(replies, hasLength(1));

    replies.single.completeError(Exception('source is down'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.textContaining('source is down'), findsOneWidget);

    final l10n = AppLocalizations.of(
      tester.element(find.byType(ShioriDialog)),
    )!;
    await tester.tap(find.text(l10n.retry));
    await tester.pump();
    await tester.pump();
    expect(replies, hasLength(2));

    replies.last.complete(
      MManga(
        name: 'Title',
        chapters: [MChapter(name: 'Chapter 1')],
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.byType(ErrorState), findsNothing);
    expect(find.text('Chapter 1'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Closes the dialog so its pending timers end with the test.
    await tester.tap(find.text(l10n.cancel));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });
}
