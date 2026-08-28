import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/trackers/simkl.dart';

/// #922: tracking an anime with Simkl filed it under TV Shows.
///
/// Simkl keeps anime apart from tv, with their own endpoints, and the tracker
/// asked the tv ones for everything that was not manga. Checked against the
/// live API while fixing this: `/search/tv?q=frieren` returns zero rows,
/// `/search/anime?q=frieren` returns "Sousou no Frieren".
///
/// These call the functions the tracker itself uses to build its URLs, so a
/// regression here is a regression there. The requests are not exercised —
/// that needs an account and a token.
void main() {
  group('an anime', () {
    test('goes to the anime endpoints, not the tv ones', () {
      expect(simklMediaType(false), 'anime');
      expect(simklSearchType(false), 'anime');
    });

    test('so its search path and public URL both say anime', () {
      expect('/search/${simklSearchType(false)}', '/search/anime');
      expect(
        'https://simkl.com/${simklSearchType(false)}/12345',
        'https://simkl.com/anime/12345',
      );
    });

    test('and its trending and library lists do too', () {
      expect('/${simklMediaType(false)}/trending', '/anime/trending');
      expect(
        '/sync/all-items/${simklMediaType(false)}',
        '/sync/all-items/anime',
      );
    });
  });

  group('manga', () {
    test('is left exactly where it was', () {
      // Simkl has no manga library; the tracker maps it onto movies, and this
      // fix is not the place to revisit that.
      expect(simklMediaType(true), 'movies');
      expect(simklSearchType(true), 'tv');
    });
  });
}
