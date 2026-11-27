import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/reader/widgets/read_next_shelf.dart';

Manga _manga(String name, [List<String> genre = const []]) => Manga(
  source: 'Demo',
  author: '',
  artist: '',
  genre: genre,
  imageUrl: null,
  lang: 'en',
  link: '/$name',
  name: name,
  status: Status.ongoing,
  description: '',
  sourceId: null,
  favorite: true,
);

ReadNextEntry _entry(
  String name, {
  int unread = 1,
  int read = 0,
  bool downloaded = false,
  int genres = 0,
  int lastReadAt = 0,
}) => ReadNextEntry(
  manga: _manga(name),
  unread: unread,
  read: read,
  downloadedUnread: downloaded,
  sharedGenres: List.filled(genres, 'Action'),
  lastReadAt: lastReadAt,
);

List<String> _names(List<ReadNextEntry> ranked) =>
    ranked.map((e) => e.manga.name!).toList();

void main() {
  test('genres are matched whatever their case and spacing', () {
    final m = _manga('A', [' Action', 'Murim', 'Romance ', '']);
    expect(sharedGenresOf(m, {'action', 'romance'}), ['Action', 'Romance']);
    expect(sharedGenresOf(_manga('B'), {'action'}), isEmpty);
  });

  test('a series with nothing left to read is never offered', () {
    expect(
      _names(rankReadNext([_entry('done', unread: 0, genres: 5), _entry('x')])),
      ['x'],
    );
  });

  test('a downloaded chapter to read comes before everything else', () {
    final ranked = rankReadNext([
      _entry('alike', genres: 3, read: 200),
      _entry('downloaded', downloaded: true),
    ]);
    expect(_names(ranked), ['downloaded', 'alike']);
  });

  test('then the most genres in common, then the longest followed', () {
    final ranked = rankReadNext([
      _entry('one genre, long read', genres: 1, read: 300),
      _entry('two genres, short read', genres: 2, read: 3),
      _entry('two genres, long read', genres: 2, read: 120),
    ]);
    expect(_names(ranked), [
      'two genres, long read',
      'two genres, short read',
      'one genre, long read',
    ]);
  });

  test('the latest read settles a tie, and the row is capped', () {
    final ranked = rankReadNext([
      _entry('older', lastReadAt: 10),
      _entry('newer', lastReadAt: 20),
      for (var i = 0; i < 10; i++) _entry('n$i'),
    ]);
    expect(ranked.length, 8);
    expect(_names(ranked).take(2), ['newer', 'older']);
  });
}
