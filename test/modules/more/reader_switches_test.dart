import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/l10n/generated/app_localizations_fr.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_switches.dart';

void main() {
  test('every reader switch is named, in English and French', () {
    for (final l10n in [AppLocalizationsEn(), AppLocalizationsFr()]) {
      for (final option in ReaderSwitch.values) {
        expect(option.title(l10n).trim(), isNotEmpty, reason: '$option');
        final subtitle = option.subtitle(l10n);
        if (subtitle != null) expect(subtitle.trim(), isNotEmpty);
      }
    }
  });

  test('no two switches share a name', () {
    final en = AppLocalizationsEn();
    final titles = ReaderSwitch.values.map((o) => o.title(en)).toList();
    expect(titles.toSet().length, titles.length);
  });
}
