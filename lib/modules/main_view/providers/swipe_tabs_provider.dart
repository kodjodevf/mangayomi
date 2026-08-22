import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Where swiping between tabs is offered at all.
///
/// A TV has no touchscreen to swipe on, and a desktop pointer is a mouse, so
/// neither is asked about it: the setting is hidden and the gesture is off
/// regardless of what was stored.
///
/// A getter rather than a final, for the same reason [usesFloatingNav] is:
/// [isTv] is hydrated asynchronously and a final would cache the answer from
/// before detection finished.
bool get swipeBetweenTabsSupported => !isTv && !isDesktop;

/// Whether a horizontal drag on a page moves between navigation tabs.
///
/// Off unless asked for. A sideways drag is the most contested gesture on a
/// page - inner tab strips, cover carousels and the reader all want it - so
/// handing it to navigation by default changes how the whole app feels for
/// people who never asked for it. Those who do want it turn it on once.
final swipeBetweenTabsProvider = NotifierProvider<SwipeBetweenTabs, bool>(
  SwipeBetweenTabs.new,
);

class SwipeBetweenTabs extends Notifier<bool> {
  @override
  bool build() =>
      swipeBetweenTabsSupported &&
      (isar.settings.getSync(227)?.swipeBetweenTabs ?? false);

  void set(bool value) {
    state = value;
    isar.writeTxnSync(() {
      final settings = isar.settings.getSync(227);
      if (settings != null) {
        settings.swipeBetweenTabs = value;
        isar.settings.putSync(settings);
      }
    });
  }
}
