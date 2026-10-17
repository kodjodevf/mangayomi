import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations_en.dart';
import 'package:mangayomi/l10n/generated/app_localizations_fr.dart';
import 'package:mangayomi/modules/more/settings/settings_index.dart';
import 'package:mangayomi/modules/more/settings/settings_search.dart';

void main() {
  final en = AppLocalizationsEn();

  test('every indexed route exists in the router', () {
    final router = File('lib/router/router.dart').readAsStringSync();
    final routes = RegExp(r'name:\s*"(\w+)"')
        .allMatches(router)
        .map((m) => '/${m.group(1)}')
        .toSet();
    final missing = settingsIndex
        .map((e) => e.route)
        .where((r) => !routes.contains(r))
        .toSet();
    expect(missing, isEmpty);
  });

  test('every entry has a title in English', () {
    for (final entry in settingsIndex) {
      expect(entry.title(en).trim(), isNotEmpty);
      expect(entry.section(en).trim(), isNotEmpty);
    }
  });

  test('accents and case do not matter', () {
    expect(foldForSearch('Thème Écran'), 'theme ecran');
  });

  test('finds a setting by its name, wherever it lives', () {
    final hits = searchSettings('wifi', en);
    expect(hits, isNotEmpty);
    expect(
      hits.every(
        (e) => '${e.title(en)} ${e.subtitle?.call(en) ?? ''}'
            .toLowerCase()
            .contains('wi'),
      ),
      isTrue,
    );
  });

  test('every word must match; a title match ranks first', () {
    final hits = searchSettings('pure black', en);
    expect(hits, isNotEmpty);
    expect(hits.first.title(en).toLowerCase(), contains('pure black'));
  });

  test('works in French, without the accents', () {
    final fr = AppLocalizationsFr();
    expect(searchSettings('apparence', fr), isNotEmpty);
  });

  test('finds the backup settings in Data and storage', () {
    final hits = searchSettings('backup', en);
    expect(hits.map((e) => e.route), contains('/dataAndStorage'));
    expect(searchSettings('clear library', en).first.route, '/dataAndStorage');
  });

  test('an empty query finds nothing', () {
    expect(searchSettings('   ', en), isEmpty);
  });
}
