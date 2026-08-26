import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/memory_probe.dart';

MemorySample sample({
  int rss = 0,
  int cacheBytes = 0,
  int cacheMax = 64 << 20,
  int count = 0,
  int maxCount = 1000,
  int live = 0,
}) => MemorySample(
  rssBytes: rss,
  imageCacheBytes: cacheBytes,
  imageCacheMaxBytes: cacheMax,
  imageCacheCount: count,
  imageCacheMaxCount: maxCount,
  liveImages: live,
);

/// The point of this is to answer two questions on a television that cannot be
/// answered from a desktop: what the image cache budget should be, and whether
/// decoding pages smaller would help. Both need numbers from the device.
void main() {
  // MemorySample.take reads PaintingBinding.instance.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('reading one sample', () {
    test('a cache at its ceiling is the state worth catching', () {
      // A full cache evicts on the next decode, so scrolling re-decodes what
      // it just threw away. That is the case where the budget is the problem.
      expect(sample(cacheBytes: 64 << 20, cacheMax: 64 << 20).atCeiling, true);
      expect(sample(cacheBytes: 62 << 20, cacheMax: 64 << 20).atCeiling, true);
    });

    test('a cache with room is not, however large it looks', () {
      expect(sample(cacheBytes: 32 << 20, cacheMax: 64 << 20).atCeiling, false);
      expect(sample(cacheBytes: 0, cacheMax: 64 << 20).atCeiling, false);
    });

    test('a zero budget does not divide by it', () {
      expect(sample(cacheBytes: 10, cacheMax: 0).cacheFullness, 0);
      expect(sample(cacheBytes: 10, cacheMax: 0).atCeiling, false);
    });
  });

  group('what the samples add up to', () {
    test('peaks survive a later dip, which is the point of tracking them', () {
      // A device dies from the spike, not from the average.
      var stats = const MemoryStats()
          .add(sample(rss: 300 << 20, cacheBytes: 60 << 20, count: 90))
          .add(sample(rss: 120 << 20, cacheBytes: 10 << 20, count: 12));

      expect(stats.peakRssBytes, 300 << 20);
      expect(stats.peakCacheBytes, 60 << 20);
      expect(stats.peakCacheCount, 90);
      expect(stats.latest!.rssBytes, 120 << 20, reason: 'latest is still now');
    });

    test('the ceiling share says whether the budget is the constraint', () {
      var stats = const MemoryStats();
      for (var i = 0; i < 3; i++) {
        stats = stats.add(sample(cacheBytes: 64 << 20, cacheMax: 64 << 20));
      }
      stats = stats.add(sample(cacheBytes: 1 << 20, cacheMax: 64 << 20));

      expect(stats.samples, 4);
      expect(stats.atCeiling, 3);
      expect(stats.ceilingShare, closeTo(0.75, 0.001));
    });

    test('no samples is not a division by zero', () {
      expect(const MemoryStats().ceilingShare, 0);
      expect(const MemoryStats().latest, isNull);
    });
  });

  group('the probe', () {
    test('records on demand without needing a real clock', () {
      final probe = MemoryProbe();
      addTearDown(probe.dispose);

      probe.sample();
      probe.sample();

      expect(probe.stats.samples, 2);
      expect(probe.isRunning, false, reason: 'sampling is not starting');
    });

    test('reset clears history so a run starts from a known point', () {
      final probe = MemoryProbe();
      addTearDown(probe.dispose);
      probe.sample();

      probe.reset();

      expect(probe.stats.samples, 0);
      expect(probe.stats.peakRssBytes, 0);
    });

    test('starting twice does not sample twice as fast', () {
      final probe = MemoryProbe();
      addTearDown(probe.dispose);

      probe.start();
      final after = probe.stats.samples;
      probe.start();

      expect(probe.isRunning, true);
      expect(probe.stats.samples, after, reason: 'the second start is a no-op');
    });
  });

  group('showing a number on a television', () {
    test('reads at a glance from across the room', () {
      expect(formatBytes(0), '0 MB');
      expect(formatBytes(512), '512 B', reason: 'not rounded up to 1 KB');
      expect(formatBytes(64 << 10), '64 KB');
      expect(formatBytes(64 << 20), '64.0 MB');
      expect(formatBytes(1500 << 20), '1500 MB');
    });
  });
}
