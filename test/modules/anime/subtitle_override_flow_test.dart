import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/anime/providers/state_provider.dart';
import 'package:mangayomi/modules/anime/utils/mpv_subtitle_options.dart';

void main() {
  late Directory directory;

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
    directory = Directory.systemTemp.createTempSync('subtitle_override');
    isar = await Isar.open(
      [SettingsSchema, SourceSchema],
      directory: directory.path,
      name: 'subtitle_override_${directory.path.hashCode}',
    );
    await isar.writeTxn(() => isar.settings.put(Settings()));
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  test('the player is told each time the ASS override is switched', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    // What the player's listener sends to mpv, one entry per change.
    final sent = <String>[];
    container.listen(subtitleSettingsStateProvider, (previous, next) {
      sent.add(mpvSubtitleStyle(next)['sub-ass-override']!);
    });
    final notifier = container.read(subtitleSettingsStateProvider.notifier);

    notifier.setOverrideAss(true);
    notifier.setOverrideAss(false);
    notifier.setOverrideAss(true);

    expect(sent, ['force', 'yes', 'force']);
    expect(container.read(overrideAssSubtitlesStateProvider), isTrue);
  });
}
