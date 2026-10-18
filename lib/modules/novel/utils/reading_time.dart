/// Reading speeds behind the estimate: words a minute for scripts that
/// separate words with spaces, characters a minute for those that do not
/// (Chinese, Japanese, Korean). Middling adult silent-reading rates.
const _wordsPerMinute = 230;
const _charsPerMinute = 500;

final _tags = RegExp(r'<[^>]*>');
final _entities = RegExp(r'&[a-zA-Z#0-9]+;');
final _cjk = RegExp(r'[぀-ヿ㐀-䶿一-鿿가-힯]');
final _words = RegExp(r'\S+');

/// Minutes it takes to read a chapter whose text is [html]. Worth working
/// out once per chapter: it walks the whole text.
double readingMinutes(String html) {
  final text = html.replaceAll(_tags, ' ').replaceAll(_entities, ' ');
  final cjk = _cjk.allMatches(text).length;
  return cjk > text.length / 4
      ? cjk / _charsPerMinute
      : _words.allMatches(text).length / _wordsPerMinute;
}

/// Minutes left of [total] with [progress] (0 to 1) read. Rounded up, so
/// the last stretch says "1 min" rather than "0".
int minutesLeft(double total, double progress) {
  final left = total * (1 - progress.clamp(0.0, 1.0));
  return left <= 0 ? 0 : left.ceil();
}

/// [minutesLeft] of a chapter's [html].
int readingMinutesLeft(String html, double progress) =>
    minutesLeft(readingMinutes(html), progress);
