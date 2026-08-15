import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/get_source_baseurl.dart';

void main() {
  test('joins a source BaseUrl and relative path with one slash', () {
    expect(
      buildSourceUrl('https://toki30.com', '/webtoon/1'),
      'https://toki30.com/webtoon/1',
    );
    expect(
      buildSourceUrl('https://toki30.com/', '/webtoon/1'),
      'https://toki30.com/webtoon/1',
    );
    expect(
      buildSourceUrl('https://sbxh9.com', 'manga/2'),
      'https://sbxh9.com/manga/2',
    );
  });

  test('replaces the domain of an absolute stored URL', () {
    expect(
      buildSourceUrl(
        'https://toki30.com',
        'https://newtoki1.org/webtoon/1?x=1#page',
      ),
      'https://toki30.com/webtoon/1?x=1#page',
    );
  });
}
