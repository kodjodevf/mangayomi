import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';

void main() {
  final l10n = AppLocalizationsEn();
  Manga series(ItemType type) => Manga(
    name: 'Solo Leveling',
    author: null,
    artist: null,
    genre: const [],
    imageUrl: '',
    link: '',
    source: 'x',
    lang: 'en',
    status: Status.ongoing,
    description: null,
    itemType: type,
    sourceId: 1,
  );
  Chapter named(String name) => Chapter(mangaId: 1, name: name);

  test('keeps the source title unless asked for numbers', () {
    expect(
      chapterDisplayName(
        named('Vol.2 Ch.12 - The Return'),
        series(ItemType.manga),
        l10n,
        byNumber: false,
      ),
      'Vol.2 Ch.12 - The Return',
    );
  });

  test('names a chapter by its number', () {
    expect(
      chapterDisplayName(
        named('Vol.2 Ch.12 - The Return'),
        series(ItemType.manga),
        l10n,
        byNumber: true,
      ),
      'Chapter 12',
    );
  });

  test('keeps decimals and says episode for anime', () {
    expect(
      chapterDisplayName(
        named('Episode 7.5'),
        series(ItemType.anime),
        l10n,
        byNumber: true,
      ),
      'Episode 7.5',
    );
  });

  test('falls back to the title when there is no number', () {
    expect(
      chapterDisplayName(
        named('Prologue'),
        series(ItemType.manga),
        l10n,
        byNumber: true,
      ),
      'Prologue',
    );
  });
}
