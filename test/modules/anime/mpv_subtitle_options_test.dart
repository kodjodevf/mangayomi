import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/utils/mpv_subtitle_options.dart';

void main() {
  test('colours are written as #AARRGGBB', () {
    expect(toMpvColor(255, 255, 0, 16), '#FFFF0010');
    expect(toMpvColor(0, 0, 0, 0), '#00000000');
  });

  test('unset settings fall back to the default style', () {
    // A row saved before these fields existed reads every one back as null.
    final style = mpvSubtitleStyle(PlayerSubtitleSettings.fromJson({}));

    expect(style, {
      'sub-font-size': '45',
      'sub-bold': 'yes',
      'sub-italic': 'no',
      'sub-color': '#FFFFFFFF',
      'sub-border-color': '#FF000000',
      'sub-back-color': '#00000000',
      'sub-ass-override': 'scale',
    });
  });

  test('overriding ASS styles also justifies them', () {
    final style = mpvSubtitleStyle(
      PlayerSubtitleSettings(overrideAssSubtitles: true),
    );

    expect(style['sub-ass-override'], 'force');
    expect(style['sub-ass-justify'], 'yes');
  });

  test('the initial options add the fixed layout to the style', () {
    final options = mpvInitialSubtitleOptions(PlayerSubtitleSettings());

    expect(options, containsPair('sub-border-size', '3'));
    expect(options, containsPair('sub-pos', '100'));
    expect(options, containsPair('sub-font-size', '45'));
  });
}
