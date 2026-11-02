import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';

/// Ends the chapter selection when the page goes, so the top and bottom bars
/// don't bleed into the library screen.
///
/// A page the router removes, as searching a genre in the library does, pops
/// while the navigator builds, when a provider can't change: the reset waits
/// until that build is over, by when this page's own ref may be gone.
class ChapterSelectionResetScope extends StatelessWidget {
  const ChapterSelectionResetScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) return;
        final container = ProviderScope.containerOf(context, listen: false);
        Future(() {
          container.read(isLongPressedStateProvider.notifier).update(false);
          container.read(chaptersListStateProvider.notifier).clear();
        });
      },
      child: child,
    );
  }
}
