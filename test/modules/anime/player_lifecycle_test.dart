import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/player_lifecycle.dart';

void main() {
  test('episode replacement preserves desktop fullscreen', () {
    expect(
      shouldExitDesktopFullscreenOnDispose(
        isDesktop: true,
        isFullscreen: true,
        isEpisodeReplacement: true,
      ),
      isFalse,
    );
  });

  test('leaving the player exits desktop fullscreen', () {
    expect(
      shouldExitDesktopFullscreenOnDispose(
        isDesktop: true,
        isFullscreen: true,
        isEpisodeReplacement: false,
      ),
      isTrue,
    );
  });

  test('Windows avoids the crashing GPU texture output', () {
    expect(
      shouldUseHardwareAcceleratedVideoOutput(
        userEnabled: true,
        isWindows: true,
      ),
      isFalse,
    );
  });

  test('surface is hidden before waiting for the raster thread', () async {
    final events = <String>[];
    await retirePlaybackSurface(
      hideSurface: () => events.add('hidden'),
      waitForFrame: () async => events.add('frame'),
      rasterDrainDelay: Duration.zero,
    );
    expect(events, ['hidden', 'frame']);
  });

  test('player disposal waits for listener cancellation', () async {
    final cancellation = Completer<void>();
    var disposeCalls = 0;
    final cleanup = disposePlaybackSession(
      listenerCancellations: [cancellation.future],
      disposePlayer: () async => disposeCalls++,
    );
    await Future<void>.delayed(Duration.zero);
    expect(disposeCalls, 0);
    cancellation.complete();
    await cleanup;
    expect(disposeCalls, 1);
  });

  test('player is disposed even when cancellation fails', () async {
    var disposeCalls = 0;
    await expectLater(
      disposePlaybackSession(
        listenerCancellations: [Future<void>.error(StateError('failed'))],
        disposePlayer: () async => disposeCalls++,
      ),
      throwsStateError,
    );
    expect(disposeCalls, 1);
  });
}
