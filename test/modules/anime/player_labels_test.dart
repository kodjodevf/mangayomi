import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/player_labels.dart';

void main() {
  test('quality keeps the resolution and the sub/dub tag', () {
    expect(shortQualityLabel('1080p (Sub)'), '1080-sub');
    expect(shortQualityLabel('720p Dub'), '720-dub');
    expect(shortQualityLabel('480p'), '480p');
    expect(shortQualityLabel('Default'), 'Default');
  });

  test('track names keep their bracketed tag or leading word', () {
    expect(shortTrackLabel('[English] Full'), 'English');
    expect(shortTrackLabel('(jpn) Main'), 'jpn');
    expect(shortTrackLabel('French - Forced'), 'French');
    expect(shortTrackLabel('Portuguese'), 'Portug');
    expect(shortTrackLabel('  '), '');
  });

  test('every fit has a label', () {
    for (final fit in BoxFit.values) {
      expect(fitShortLabel(fit), isNotEmpty);
    }
  });
}
