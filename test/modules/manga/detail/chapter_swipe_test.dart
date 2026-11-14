import 'dart:async';
import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart' as app;
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_swipe.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/repositories/db_write_queue.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shiori/shiori.dart';

void main() {
  late Directory dir;
  late Isar db;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('mangayomi-chapter-swipe-');
    db = await StorageProvider().initDB(dir.path);
    app.isar = db;
  });

  tearDown(() async {
    await db.close(deleteFromDisk: true);
    if (await dir.exists()) await dir.delete(recursive: true);
  });

  testWidgets('a swipe marks the row read before the save lands', (
    tester,
  ) async {
    final chapter = Chapter(id: 1, mangaId: 1, name: 'Chapter 1');
    // Holds the save back, as a busy write queue does.
    final busy = Completer<void>();
    unawaited(dbWriteQueue.run(() => busy.future));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildShioriTheme(
            brightness: Brightness.dark,
            colors: FlexColor.schemesList[2].dark,
            tintSurfaces: false,
            blendLevel: 10,
            density: ShioriDensity.phone,
          ),
          home: Scaffold(
            body: ChapterSwipe(
              chapter: chapter,
              builder: (_) => SizedBox(
                width: 400,
                height: 60,
                child: Text(chapter.isRead! ? 'read' : 'unread'),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.text('unread'), findsOneWidget);

    // Leftwards: the end action, which is "mark read" by default.
    await tester.drag(find.text('unread'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('read'), findsOneWidget);
    expect(db.chapters.getSync(1), isNull);

    busy.complete();
    await tester.runAsync(() => dbWriteQueue.run(() {}));
    expect(db.chapters.getSync(1)?.isRead, isTrue);
  });
}
