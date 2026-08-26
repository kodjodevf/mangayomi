import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/related_screen.dart';

/// Kitsu and AniList both hand formats over shouting: TV, OVA, ONE_SHOT,
/// LIGHT_NOVEL. Title case reads better on a card, but naive title case turns
/// TV into "Tv", which is what this is guarding.
void main() {
  test('an acronym keeps its case', () {
    expect(prettyFormat('TV'), 'TV');
    expect(prettyFormat('OVA'), 'OVA');
    expect(prettyFormat('ONA'), 'ONA');
  });

  test('a word is title cased', () {
    expect(prettyFormat('MOVIE'), 'Movie');
    expect(prettyFormat('MANHWA'), 'Manhwa');
    expect(prettyFormat('SPECIAL'), 'Special');
  });

  test('only the first word of a phrase is capitalised', () {
    expect(prettyFormat('ONE_SHOT'), 'One shot');
    expect(prettyFormat('LIGHT_NOVEL'), 'Light novel');
  });

  test('an acronym inside a phrase still keeps its case', () {
    expect(prettyFormat('TV_SHORT'), 'TV short');
  });

  test('nothing sensible in, nothing thrown out', () {
    expect(prettyFormat(''), '');
    expect(prettyFormat('_'), '_');
  });

  test('the acronym set is upper case, since lookups upper case first', () {
    for (final acronym in formatAcronyms) {
      expect(acronym, acronym.toUpperCase());
    }
  });
}
