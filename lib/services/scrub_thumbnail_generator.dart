import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Generates scrub-preview thumbnails from a hidden, headless [Player] that
/// decodes the same source as the visible one but is never shown on screen —
/// seeking it to preview a position never touches the frame actually
/// displayed. `screenshot()` pulls the frame through mpv's own
/// `screenshot-raw` command, so no [Video] widget ever needs to be built.
///
/// A bare [Player] alone is not enough, though: media_kit opens every player
/// with `--vid=no` and only flips it to `--vid=auto` (i.e. actually decodes
/// video at all) once a [VideoController] attaches — normally the one a
/// [Video] widget owns. So a [VideoController] is created here too, purely
/// to switch decoding on; it is never handed to a widget, and disposing the
/// [Player] tears its native resources down along with everything else.
/// It's also configured to decode at preview size rather than full
/// resolution — the bubble only ever shows a ~128x72 image, and a smaller
/// texture is both faster to render into and faster to read back.
///
/// `hr-seek` is forced on: mpv's default is a fast *keyframe* seek, which
/// jumps to the nearest keyframe *at or before* the target — fine for the
/// real player mid-playback, but on a source whose keyframe index isn't
/// fully known yet (typical right after opening a network stream) that can
/// resolve to the very first keyframe, i.e. the start of the video,
/// regardless of where was asked for. Precise seeking costs a bit more time
/// per request but actually lands where asked.
///
/// The player opens lazily on the first request (or eagerly via [prewarm])
/// and is reused across a session; callers own its lifecycle and must
/// [dispose] it (typically when the reader itself is disposed) since a
/// second decoder has a real CPU/GPU cost that shouldn't outlive the screen
/// that asked for it.
class ScrubThumbnailGenerator {
  static const _previewSize = VideoControllerConfiguration(
    width: 320,
    height: 180,
  );
  static const _maxCacheEntries = 30;

  Player? _player;
  // Never read again after _ensureOpen — kept only so this VideoController
  // (and the native decoding it switched on) stays alive for as long as
  // _player does, rather than becoming collectible the moment the local
  // reference in _ensureOpen goes out of scope.
  // ignore: unused_field
  VideoController? _controller;
  String? _openedUrl;
  Future<void>? _opening;
  int _requestId = 0;
  bool _disposed = false;

  /// Fast in-memory LRU cache of recently generated thumbnails bucketed by
  /// 2-second intervals, avoiding redundant MPV seeks and decoding when the
  /// user scrubs back and forth.
  final LinkedHashMap<int, Uint8List> _cache = LinkedHashMap();

  /// Opens the source ahead of the first actual scrub, so that latency —
  /// creating the native texture, then buffering the stream enough to open
  /// it — happens while the viewer is just watching, not the moment they
  /// first touch the seekbar. Safe to call speculatively; failures are
  /// swallowed the same way [thumbnailAt] swallows them.
  Future<void> prewarm({required String url, Map<String, String>? headers}) {
    if (_disposed) return Future.value();
    return _ensureOpen(url, headers).catchError((_) {});
  }

  Future<void> _ensureOpen(String url, Map<String, String>? headers) async {
    if (_disposed) return;
    if (_player != null && _openedUrl == url) {
      await _opening;
      return;
    }
    _cache.clear();
    final previousPlayer = _player;
    final player = Player(
      configuration: const PlayerConfiguration(
        muted: true,
        // Every seek this player ever issues should be frame-accurate — see
        // the class doc for why the default fast/keyframe seek is unsafe on
        // a freshly-opened network source.
        options: {'hr-seek': 'yes', 'hr-seek-framedrop': 'no'},
      ),
    );
    final controller = VideoController(player, configuration: _previewSize);
    _player = player;
    _controller = controller;
    _openedUrl = url;
    _opening = () async {
      // Waits for the native texture to actually exist, i.e. for --vid=auto
      // to have taken effect — screenshot() before this point just returns
      // whatever an un-decoded player has, which is nothing.
      await controller.platform.future;
      if (_disposed) return;
      await player.open(Media(url, httpHeaders: headers), play: false);
    }();
    await _opening;
    if (_disposed) {
      unawaited(player.dispose());
      return;
    }
    unawaited(previousPlayer?.dispose());
  }

  /// Waits until mpv actually reports being at (or very near) [target] *and*
  /// isn't still buffering the data that frame needs, rather than sleeping a
  /// fixed guess. A local seek often settles within a couple of
  /// milliseconds; a network one can report the target position as soon as
  /// the seek command is acknowledged, well before the corresponding
  /// segment/range has actually downloaded and decoded — so position alone
  /// is not enough evidence there on its own. [isLocal] widens the timeout
  /// accordingly, since network round trips are the whole reason to wait
  /// longer, not something to time out on.
  Future<void> _waitForSeekSettle(
    Player player,
    Duration target, {
    required bool isLocal,
  }) async {
    final tolerance = const Duration(milliseconds: 120);
    final timeout = isLocal
        ? const Duration(milliseconds: 250)
        : const Duration(milliseconds: 1200);
    final deadline = DateTime.now().add(timeout);
    bool isClose(Duration p) => (p - target).abs() <= tolerance;

    if (!isClose(player.state.position)) {
      try {
        await player.stream.position.firstWhere(isClose).timeout(timeout);
      } catch (_) {
        // Position never confirmed — screenshot whatever is there rather
        // than block the preview indefinitely.
      }
    }

    final remaining = deadline.difference(DateTime.now());
    if (remaining > Duration.zero && player.state.buffering) {
      try {
        await player.stream.buffering
            .firstWhere((buffering) => !buffering)
            .timeout(remaining);
      } catch (_) {
        // Still buffering when time ran out — same tradeoff as above.
      }
    }
  }

  /// Returns a JPEG-encoded frame near [position] for the source identified
  /// by [url], or `null` on failure (unsupported source, still opening, a
  /// newer call superseding this one...) — callers should degrade to a
  /// text-only preview rather than treat a null as an error. [isLocal] only
  /// affects how long a request is willing to wait for the frame to settle.
  Future<Uint8List?> thumbnailAt(
    Duration position, {
    required String url,
    Map<String, String>? headers,
    bool isLocal = false,
  }) async {
    if (_disposed) return null;

    final bucket = position.inMilliseconds ~/ 2000;
    final cached = _cache[bucket];
    if (cached != null) {
      _cache.remove(bucket);
      _cache[bucket] = cached;
      return cached;
    }

    final id = ++_requestId;
    try {
      await _ensureOpen(url, headers);
      if (_disposed || id != _requestId) return null;
      final player = _player;
      if (player == null) return null;
      await player.seek(position);
      if (_disposed || id != _requestId) return null;
      await _waitForSeekSettle(player, position, isLocal: isLocal);
      if (_disposed || id != _requestId) return null;
      final image = await player.screenshot(format: 'image/jpeg');
      if (image != null && !_disposed && id == _requestId) {
        if (_cache.length >= _maxCacheEntries) {
          _cache.remove(_cache.keys.first);
        }
        _cache[bucket] = image;
      }
      return image;
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _disposed = true;
    _requestId++;
    _cache.clear();
    _player?.dispose();
    _player = null;
    _controller = null;
    _openedUrl = null;
  }
}
