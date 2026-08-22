import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';

/// A tab for [BrowseScreen] to open on, set by whoever sends the user there.
///
/// [take] clears it as it reads, so a request steers only the one visit it was
/// made for and an ordinary trip to Browse still opens where it always did.
class BrowseInitialTab extends Notifier<BrowseTab?> {
  @override
  BrowseTab? build() => null;

  void request(BrowseTab tab) => state = tab;

  BrowseTab? take() {
    final requested = state;
    if (requested != null) state = null;
    return requested;
  }
}

final browseInitialTabProvider = NotifierProvider<BrowseInitialTab, BrowseTab?>(
  BrowseInitialTab.new,
);
