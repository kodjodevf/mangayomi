/// Picking the right entry out of a title search.
///
/// A library title comes from whichever source it was added from, and those
/// disagree with a metadata database about punctuation, romanisation and how
/// much of a subtitle to keep. Taking the first hit and trusting it is how a
/// lookup ends up confidently describing a different series.
library;

/// Lowercased, punctuation dropped, whitespace collapsed.
///
/// Only the separators are removed, so scripts that do not use spaces are
/// left as one token rather than being erased.
String normalizeTitle(String title) => title
    .toLowerCase()
    .replaceAll(RegExp(r'''[\s\-_:;,.!?'"()\[\]{}~/\\|+*&#@]+'''), ' ')
    .trim();

List<String> _tokens(String normalized) =>
    normalized.split(' ').where((t) => t.isNotEmpty).toList();

/// How well two titles match, from 0 to 1.
///
/// Token overlap rather than substring, because a database subtitle
/// ("Chainsaw Man: Buddy Stories") shares every word of the shorter title and
/// should still score below the title itself.
double titleSimilarity(String a, String b) {
  final left = normalizeTitle(a);
  final right = normalizeTitle(b);
  if (left.isEmpty || right.isEmpty) return 0;
  if (left == right) return 1;

  final leftTokens = _tokens(left).toSet();
  final rightTokens = _tokens(right).toSet();
  if (leftTokens.isEmpty || rightTokens.isEmpty) return 0;

  final shared = leftTokens.intersection(rightTokens).length;
  if (shared == 0) return 0;
  return shared / leftTokens.union(rightTokens).length;
}

/// The best of [candidates] for [query], or null when none is close enough.
///
/// Each candidate is every name the database knows it by, so a library holding
/// the Japanese title still matches an entry whose English title is different
/// but which lists both.
///
/// Returning null matters as much as returning a match: "nothing related was
/// found" is a true answer, and the relations of some other series is not.
int? bestTitleMatch(
  String query,
  List<List<String>> candidates, {
  double floor = 0.5,
}) {
  var bestIndex = -1;
  var bestScore = 0.0;

  for (var i = 0; i < candidates.length; i++) {
    for (final title in candidates[i]) {
      final score = titleSimilarity(query, title);
      // Strictly greater, so an earlier candidate wins a tie. The search comes
      // back in the database's own relevance order and that is a better
      // tiebreak than position in this loop.
      if (score > bestScore) {
        bestScore = score;
        bestIndex = i;
      }
    }
  }

  return bestScore >= floor ? bestIndex : null;
}
