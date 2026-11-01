import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_decoder_state_provider.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/repositories/settings_repository.dart';

/// The player's fit outlives the episode (#996), subtitles can start off
/// (#615), and the Linux decoders stay chosen on Linux (#627).
void main() {
  late Directory directory;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // The binding answers every request with a 400; step out of it for the
    // one download Isar needs.
    final overrides = HttpOverrides.current;
    HttpOverrides.global = null;
    try {
      await Isar.initializeIsarCore(download: true);
    } finally {
      HttpOverrides.global = overrides;
    }
  });

  setUp(() async {
    directory = Directory.systemTemp.createTempSync('player_preferences');
    isar = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: directory.path,
      name: 'player_${directory.path.hashCode}',
    );
    isar.writeTxnSync(() => isar.settings.putSync(Settings()));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('the fit chosen in one episode is the next one\'s', () async {
    final first = ProviderContainer();
    expect(first.read(playerVideoFitStateProvider), BoxFit.contain);
    first.read(playerVideoFitStateProvider.notifier).set(BoxFit.cover);
    // set() queues its write; this waits for it.
    await settingsRepository.transaction(() {});
    first.dispose();

    final next = ProviderContainer();
    addTearDown(next.dispose);
    expect(next.read(playerVideoFitStateProvider), BoxFit.cover);
  });

  test('an unknown fit falls back to contain', () {
    isar.writeTxnSync(
      () => isar.settings.putSync(
        isar.settings.getSync(227)!..playerVideoFit = 'stretched',
      ),
    );
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(playerVideoFitStateProvider), BoxFit.contain);
  });

  test('subtitles are on by default and can be turned off', () async {
    final first = ProviderContainer();
    expect(first.read(subtitlesOnByDefaultStateProvider), isTrue);
    first.read(subtitlesOnByDefaultStateProvider.notifier).set(false);
    // set() queues its write; this waits for it.
    await settingsRepository.transaction(() {});
    first.dispose();

    final next = ProviderContainer();
    addTearDown(next.dispose);
    expect(next.read(subtitlesOnByDefaultStateProvider), isFalse);
  });

  test('both travel with the settings backup', () {
    final restored = Settings.fromJson(
      (Settings()
            ..playerVideoFit = BoxFit.fitWidth.name
            ..subtitlesOnByDefault = false)
          .toJson(),
    );
    expect(restored.playerVideoFit, 'fitWidth');
    expect(restored.subtitlesOnByDefault, isFalse);
  });

  test('VAAPI and VDPAU are offered for Linux, VideoToolbox for macOS', () {
    for (final mode in ['vaapi', 'vaapi-copy', 'vdpau', 'vdpau-copy']) {
      expect(hwdecs[mode], ['linux'], reason: mode);
    }
    expect(hwdecs['videotoolbox'], contains('macos'));
  });
}
