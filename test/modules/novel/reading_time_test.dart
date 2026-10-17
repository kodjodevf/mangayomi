import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/novel/utils/reading_time.dart';

void main() {
  final page = '<p>${List.filled(2300, 'word').join(' ')}</p>';

  test('words at 230 a minute, tags ignored', () {
    expect(readingMinutesLeft(page, 0), 10);
  });

  test('scales with what is left, rounded up', () {
    expect(readingMinutesLeft(page, 0.5), 5);
    expect(readingMinutesLeft(page, 0.99), 1);
    expect(readingMinutesLeft(page, 1), 0);
  });

  test('scripts without spaces are counted by character', () {
    final cjk = '<p>${'読' * 1000}</p>';
    expect(readingMinutesLeft(cjk, 0), 2);
  });

  test('entities are not words', () {
    expect(readingMinutesLeft('&nbsp; &amp; &#8212;', 0), 0);
  });
}
