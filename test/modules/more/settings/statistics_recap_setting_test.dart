import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/statistics_recap_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

void main() {
  late Directory directory;
  late ProviderContainer container;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('recap_setting');
    isar = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: directory.path,
      name: 'recap_setting_${directory.path.hashCode}',
    );
    isar.writeTxnSync(() => isar.settings.putSync(Settings()));
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  Settings stored() => isar.settings.getSync(227)!;

  test('recap defaults on when null', () {
    expect(stored().statisticsRecap, isNull);
    expect(container.read(statisticsRecapStateProvider), isTrue);
  });

  test('set(false) persists and round-trips through JSON', () async {
    container.read(statisticsRecapStateProvider.notifier).set(false);
    await settingsRepository.transaction(() {});

    expect(stored().statisticsRecap, isFalse);
    final restarted = ProviderContainer();
    addTearDown(restarted.dispose);
    expect(restarted.read(statisticsRecapStateProvider), isFalse);

    final copy = Settings.fromJson(
      (stored()..statisticsReaderName = 'Yeab').toJson(),
    );
    expect(copy.statisticsRecap, isFalse);
    expect(copy.statisticsReaderName, 'Yeab');
  });

  test('blank reader name stores null', () async {
    final notifier = container.read(statisticsReaderNameStateProvider.notifier);

    notifier.set('  Sung Jinwoo  ');
    await settingsRepository.transaction(() {});
    expect(stored().statisticsReaderName, 'Sung Jinwoo');
    expect(container.read(statisticsReaderNameStateProvider), 'Sung Jinwoo');

    notifier.set('   ');
    await settingsRepository.transaction(() {});
    expect(stored().statisticsReaderName, isNull);
    expect(container.read(statisticsReaderNameStateProvider), isNull);
  });
}
