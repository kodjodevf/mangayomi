import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// One reading of what the app is holding.
@immutable
class MemorySample {
  const MemorySample({
    required this.rssBytes,
    required this.imageCacheBytes,
    required this.imageCacheMaxBytes,
    required this.imageCacheCount,
    required this.imageCacheMaxCount,
    required this.liveImages,
  });

  /// Resident set size: what the operating system says the process is using.
  /// This is the number that matters on a device with little RAM.
  final int rssBytes;

  /// Decoded images Flutter is holding, and the ceiling it will not exceed.
  final int imageCacheBytes;
  final int imageCacheMaxBytes;

  /// How many entries, against the count ceiling. Flutter enforces both, and
  /// whichever binds first is the one worth tuning.
  final int imageCacheCount;
  final int imageCacheMaxCount;

  /// Images currently on screen. The gap between this and [imageCacheCount] is
  /// what the cache is holding purely in case you scroll back.
  final int liveImages;

  /// How full the byte budget is, 0 to 1.
  double get cacheFullness =>
      imageCacheMaxBytes == 0 ? 0 : imageCacheBytes / imageCacheMaxBytes;

  /// Whether this reading is close enough to the ceiling that the next image
  /// decoded will evict something.
  ///
  /// That is the state worth catching: a cache pinned at its limit while you
  /// scroll is re-decoding images it just threw away, which costs both CPU and
  /// the jank that comes with it. A cache sitting at half is not a problem
  /// however large it looks.
  bool get atCeiling => cacheFullness >= 0.95;

  static MemorySample take() {
    final cache = PaintingBinding.instance.imageCache;
    return MemorySample(
      rssBytes: _rss(),
      imageCacheBytes: cache.currentSizeBytes,
      imageCacheMaxBytes: cache.maximumSizeBytes,
      imageCacheCount: cache.currentSize,
      imageCacheMaxCount: cache.maximumSize,
      liveImages: cache.liveImageCount,
    );
  }

  static int _rss() {
    try {
      return ProcessInfo.currentRss;
    } catch (_) {
      // Not available everywhere; the cache numbers are still worth having.
      return 0;
    }
  }
}

/// What the samples add up to.
///
/// Peaks matter more than the current reading on a device that dies from a
/// single spike, and the share of samples spent at the ceiling says whether
/// the budget is too small for what the screen is asking for.
@immutable
class MemoryStats {
  const MemoryStats({
    this.samples = 0,
    this.atCeiling = 0,
    this.peakRssBytes = 0,
    this.peakCacheBytes = 0,
    this.peakCacheCount = 0,
    this.latest,
  });

  final int samples;
  final int atCeiling;
  final int peakRssBytes;
  final int peakCacheBytes;
  final int peakCacheCount;
  final MemorySample? latest;

  /// The share of readings taken while the cache was full, 0 to 1.
  ///
  /// Low is fine. Consistently high means the budget is the constraint, and
  /// that is the case where raising it, or decoding smaller, actually helps.
  double get ceilingShare => samples == 0 ? 0 : atCeiling / samples;

  MemoryStats add(MemorySample sample) => MemoryStats(
    samples: samples + 1,
    atCeiling: atCeiling + (sample.atCeiling ? 1 : 0),
    peakRssBytes: sample.rssBytes > peakRssBytes
        ? sample.rssBytes
        : peakRssBytes,
    peakCacheBytes: sample.imageCacheBytes > peakCacheBytes
        ? sample.imageCacheBytes
        : peakCacheBytes,
    peakCacheCount: sample.imageCacheCount > peakCacheCount
        ? sample.imageCacheCount
        : peakCacheCount,
    latest: sample,
  );
}

/// Bytes as something readable on a television from across the room.
String formatBytes(int bytes) {
  if (bytes <= 0) return '0 MB';
  const mb = 1 << 20;
  // Below a kilobyte, rounding to KB would print "1 KB" for 512 bytes, which
  // is both wrong and confusing next to a real figure.
  if (bytes < 1024) return '$bytes B';
  if (bytes < mb) return '${(bytes / 1024).toStringAsFixed(0)} KB';
  final megabytes = bytes / mb;
  return megabytes >= 100
      ? '${megabytes.toStringAsFixed(0)} MB'
      : '${megabytes.toStringAsFixed(1)} MB';
}

/// Samples memory on a timer while it is switched on.
///
/// Exists because the RAM questions on a television cannot be answered from a
/// desktop: what the budget should be, and whether decoding pages smaller
/// would help, both depend on numbers only the device can give. Guessing at
/// them is how the wrong thing gets optimised.
class MemoryProbe extends ChangeNotifier {
  MemoryProbe({this.interval = const Duration(seconds: 1)});

  final Duration interval;
  Timer? _timer;
  MemoryStats _stats = const MemoryStats();

  MemoryStats get stats => _stats;
  bool get isRunning => _timer != null;

  void start() {
    if (_timer != null) return;
    sample();
    _timer = Timer.periodic(interval, (_) => sample());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Takes one reading now. Public so a test does not need a real clock.
  void sample() {
    _stats = _stats.add(MemorySample.take());
    notifyListeners();
  }

  /// Forgets the history, so a measurement can start from a known point
  /// rather than carrying whatever happened before it.
  void reset() {
    _stats = const MemoryStats();
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
