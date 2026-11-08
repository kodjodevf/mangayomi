import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/utils/mpv_subtitle_options.dart';

void main() {
  test('colours are written as #AARRGGBB', () {
    expect(toMpvColor(255, 255, 0, 16), '#FFFF0010');
    expect(toMpvColor(0, 0, 0, 0), '#00000000');
  });

  const mpvDefaults = {
    'sub-font-size': '55',
    'sub-bold': 'no',
    'sub-italic': 'no',
    'sub-color': '#FFFFFFFF',
    'sub-border-color': '#FF000000',
    'sub-back-color': '#00000000',
    'sub-ass-override': 'yes',
    'sub-ass-justify': 'no',
  };

  test('with the switch off, mpv gets its defaults, whatever was picked', () {
    final style = mpvSubtitleStyle(
      PlayerSubtitleSettings(
        overrideAssSubtitles: false,
        fontSize: 80,
        useItalic: true,
        textColorR: 0,
      ),
    );

    expect(style, mpvDefaults);
  });

  test('unset settings count as the switch off', () {
    // A row saved before these fields existed reads every one back as null.
    expect(mpvSubtitleStyle(PlayerSubtitleSettings.fromJson({})), mpvDefaults);
  });

  test('with the switch on, the picked style is forced', () {
    final style = mpvSubtitleStyle(
      PlayerSubtitleSettings(overrideAssSubtitles: true, fontSize: 80),
    );

    expect(style['sub-font-size'], '80');
    expect(style['sub-ass-override'], 'force');
    expect(style['sub-ass-justify'], 'yes');
  });

  test('both states set the same options, so neither outlives the other', () {
    expect(
      mpvSubtitleStyle(PlayerSubtitleSettings(overrideAssSubtitles: true)).keys
          .toSet(),
      mpvDefaults.keys.toSet(),
    );
  });

  test('the initial options add the fixed layout to the style', () {
    final options = mpvInitialSubtitleOptions(
      PlayerSubtitleSettings(overrideAssSubtitles: true),
    );

    expect(options, containsPair('sub-border-size', '3'));
    expect(options, containsPair('sub-pos', '100'));
    expect(options, containsPair('sub-font-size', '45'));
  });
}
