/// Cancels player listeners and optional platform cleanup before releasing the
/// native player. `Player.dispose()` already stops playback; racing it with a
/// separate stop call can terminate desktop builds during route disposal.
Future<void> disposePlaybackSession({
  required Iterable<Future<void>> listenerCancellations,
  Future<void> Function()? beforeDisposePlayer,
  required Future<void> Function() disposePlayer,
}) async {
  try {
    await Future.wait(listenerCancellations);
  } finally {
    try {
      await beforeDisposePlayer?.call();
    } finally {
      await disposePlayer();
    }
  }
}

/// Removes a platform texture from the render tree before native teardown.
Future<void> retirePlaybackSurface({
  required void Function() hideSurface,
  required Future<void> Function() waitForFrame,
  Duration rasterDrainDelay = const Duration(milliseconds: 100),
}) async {
  hideSurface();
  await waitForFrame();
  if (rasterDrainDelay > Duration.zero) {
    await Future<void>.delayed(rasterDrainDelay);
  }
}

bool shouldExitDesktopFullscreenOnDispose({
  required bool isDesktop,
  required bool isFullscreen,
  required bool isEpisodeReplacement,
}) => isDesktop && isFullscreen && !isEpisodeReplacement;

/// Allows hardware-accelerated video output if enabled by user settings.
/// On Windows, users can toggle this in Settings > Decoder (falls back to
/// pixel-buffer output if turned off or to resolve driver crashes).
bool shouldUseHardwareAcceleratedVideoOutput({
  required bool userEnabled,
  bool isWindows = false,
}) => userEnabled;
