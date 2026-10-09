import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';

/// Restore and sync both read settings back from decoded JSON, where every
/// list is a List<dynamic>. The source filters were assigned as is, so any
/// backup or sync payload with one set failed with "type 'List<dynamic>' is
/// not a subtype of type 'List<String>?'" (#1055).
Settings roundTrip(Settings settings) => Settings.fromJson(
  jsonDecode(jsonEncode(settings.toJson())) as Map<String, dynamic>,
);

void main() {
  test('library source filters survive a JSON round trip', () {
    final settings = Settings()
      ..libraryFilterMangasSourceIds = ['MangaDex', 'Comick']
      ..libraryFilterAnimeSourceIds = ['AnimePahe']
      ..libraryFilterNovelSourceIds = ['NovelBin'];

    final restored = roundTrip(settings);

    expect(restored.libraryFilterMangasSourceIds, ['MangaDex', 'Comick']);
    expect(restored.libraryFilterAnimeSourceIds, ['AnimePahe']);
    expect(restored.libraryFilterNovelSourceIds, ['NovelBin']);
  });

  test('unset source filters stay unset', () {
    final restored = roundTrip(Settings());

    expect(restored.libraryFilterMangasSourceIds, isNull);
    expect(restored.libraryFilterAnimeSourceIds, isNull);
    expect(restored.libraryFilterNovelSourceIds, isNull);
  });
}
