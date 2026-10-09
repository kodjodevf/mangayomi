import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';

void main() {
  test('uses the singular episode label only for one episode', () {
    final localizations = AppLocalizationsEn();

    expect(localizations.n_episodes(0), '0 episodes');
    expect(localizations.n_episodes(1), '1 episode');
    expect(localizations.n_episodes(2), '2 episodes');
  });
}
