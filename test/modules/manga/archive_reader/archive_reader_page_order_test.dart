import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';

void main() {
  test('archive pages use natural numeric filename order', () {
    final paths = [
      'pages/10.webp',
      'pages/2.webp',
      'pages/01.webp',
      'pages/1.webp',
      'pages/11.webp',
    ]..sort(compareArchiveReaderPaths);

    expect(paths, [
      'pages/1.webp',
      'pages/01.webp',
      'pages/2.webp',
      'pages/10.webp',
      'pages/11.webp',
    ]);
  });

  test('numeric runs do not overflow integers', () {
    final paths = ['100000000000000000000.webp', '9.webp', '10.webp']
      ..sort(compareArchiveReaderPaths);

    expect(paths, ['9.webp', '10.webp', '100000000000000000000.webp']);
  });

  test('comparison is stable for case and identical numeric values', () {
    final paths = ['Page02.webp', 'page2.webp', 'page001.webp', 'PAGE1.webp']
      ..sort(compareArchiveReaderPaths);

    expect(paths, ['PAGE1.webp', 'page001.webp', 'page2.webp', 'Page02.webp']);
  });
}
