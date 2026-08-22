import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';
import 'package:mangayomi/modules/browse/providers/browse_initial_tab_provider.dart';

void main() {
  testWidgets('a requested tab is cleared after the frame, not during it', (
    tester,
  ) async {
    // Riverpod counts initState as part of the build and throws on a write
    // there. Clearing the request as it was read took the whole Browse screen
    // down with "Tried to modify a provider while the widget tree was
    // building", which is the one path onboarding sends people down.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(browseInitialTabProvider.notifier)
      ..request(const BrowseTab(ItemType.manga, BrowseTabKind.extensions));

    expect(container.read(browseInitialTabProvider), isNotNull);

    // Reading it must not clear it, so a widget can read it in initState.
    expect(container.read(browseInitialTabProvider), isNotNull);

    notifier.clear();
    expect(container.read(browseInitialTabProvider), isNull);
  });
}
