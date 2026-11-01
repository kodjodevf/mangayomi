import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/providers/track_state_providers.dart';

/// Stands for the reader or player: a provider gone as soon as it is left.
final _screen = Provider.autoDispose<TrackerSync>(
  (ref) => ref.read(trackerSyncProvider.notifier),
);

void main() {
  test(
    'tracker updates outlive the reader or player that sent them (#1079)',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final subscription = container.listen(_screen, (_, _) {});
      final sync = subscription.read();
      // The screen is left while the tracker is still answering.
      subscription.close();
      await container.pump();

      expect(container.exists(_screen), isFalse);
      expect(container.exists(trackerSyncProvider), isTrue);
      // The answer is written through the sync's own Ref, still usable.
      expect(
        identical(container.read(trackerSyncProvider.notifier), sync),
        isTrue,
      );
    },
  );
}
