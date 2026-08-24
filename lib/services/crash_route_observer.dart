import 'package:flutter/widgets.dart';
import 'package:mangayomi/services/crash_report.dart';

/// Tells [CrashReports] which screen the app is on, so a recorded error says
/// where it happened.
///
/// Only the route's name is kept, never its arguments, because those carry the
/// manga or chapter the reader opened.
class CrashRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      CrashReports.screen = _name(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      CrashReports.screen = _name(previousRoute);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      CrashReports.screen = _name(newRoute);

  static String? _name(Route<dynamic>? route) {
    final settings = route?.settings;
    if (settings == null) return null;
    final name = settings.name;
    if (name == null || name.isEmpty) return null;
    // A go_router path can carry ids: /mangaDetail/1234 says which manga.
    final firstSegment = name.split('/').where((e) => e.isNotEmpty).firstOrNull;
    return firstSegment == null ? '/' : '/$firstSegment';
  }
}
