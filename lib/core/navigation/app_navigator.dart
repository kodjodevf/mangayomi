import 'package:go_router/go_router.dart';
import 'package:mangayomi/router/router.dart';

/// The one seam non-widget code (providers, services, utils) is allowed to
/// use to reach the widget tree for navigation.
///
/// Providers and services should never import [navigatorKey] or `BuildContext`
/// directly — going through here keeps that coupling in one place instead of
/// scattered across the codebase, and gives it a spot to become
/// injectable/mockable later if a call site needs to be unit tested.
class AppNavigator {
  const AppNavigator._();

  /// Navigates to [location] from outside the widget tree. A no-op if there
  /// is currently no active navigator context (e.g. during startup).
  static void push(String location, {Object? extra}) {
    navigatorKey.currentContext?.push(location, extra: extra);
  }
}
