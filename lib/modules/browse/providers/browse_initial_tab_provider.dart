import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';

/// A tab for [BrowseScreen] to open on, set by whoever sends the user there.
///
/// Read on the way in and [clear]ed after that frame, so a request steers only
/// the one visit it was made for and an ordinary trip to Browse still opens
/// where it always did. The clear has to wait: Riverpod counts initState as
/// part of the build and refuses a write there.
class BrowseInitialTab extends Notifier<BrowseTab?> {
  @override
  BrowseTab? build() => null;

  void request(BrowseTab tab) => state = tab;

  void clear() {
    if (state != null) state = null;
  }
}

final browseInitialTabProvider = NotifierProvider<BrowseInitialTab, BrowseTab?>(
  BrowseInitialTab.new,
);
