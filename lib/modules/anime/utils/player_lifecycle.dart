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

/// Windows' GPU-backed external texture can outlive Flutter's graphics
/// context during navigation or standby. Pixel-buffer output avoids that
/// engine crash while leaving media decode acceleration controlled by hwdec.
bool shouldUseHardwareAcceleratedVideoOutput({
  required bool userEnabled,
  required bool isWindows,
}) => userEnabled && !isWindows;
