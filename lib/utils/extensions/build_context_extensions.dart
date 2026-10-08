import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';

/// Whether a viewport of this size is rail-shaped.
///
/// Measured on the shortest side, not the width: a phone turned landscape is
/// over 600 wide but is still a phone, and judging it by width alone handed it
/// a rail the moment it rotated.
///
/// Separate from [BuildContextExtensions.prefersNavRail] so the rule can be
/// exercised on its own. That getter short-circuits on platforms using the
/// floating bar, which on an Apple test host is always, leaving nothing to
/// test.
bool sizeWantsNavRail(Size size) => size.shortestSide >= 600;

extension BuildContextExtensions on BuildContext {
  bool get isLight {
    return Theme.of(this).brightness == Brightness.light;
  }

  Color get primaryColor {
    return Theme.of(this).primaryColor;
  }

  Color get dynamicThemeColor {
    return isLight ? secondaryColor : primaryColor;
  }

  Color get dynamicWhiteBlackColor {
    return isLight ? Colors.black : Colors.white;
  }

  Color get dynamicBlackWhiteColor {
    return isLight ? Colors.white : Colors.black;
  }

  Color get textColor {
    return themeData.textTheme.bodyLarge!.color!;
  }

  Color get secondaryColor {
    return Theme.of(this).iconTheme.color!.withValues(alpha: 0.7);
  }

  ThemeData get themeData {
    return Theme.of(this);
  }

  double height(double data) {
    return MediaQuery.of(this).size.height * data;
  }

  double width(double data) {
    return MediaQuery.of(this).size.width * data;
  }

  bool get isTablet {
    return MediaQuery.of(this).size.width >= 600;
  }

  /// Whether this viewport should navigate by a rail rather than a bottom bar.
  ///
  /// Platforms on the floating bar never take a rail at all. There the bar
  /// carries labels in landscape instead, which is the same navigation in both
  /// orientations rather than two different ones.
  ///
  /// A TV is the case this ordering exists for: it is excluded from the
  /// floating bar, so it falls through to the size rule and keeps the rail its
  /// remote can actually focus.
  bool get prefersNavRail {
    if (usesFloatingNav) return false;
    return sizeWantsNavRail(MediaQuery.of(this).size);
  }

  /// Wide enough to put labels beside the icons rather than icons alone.
  bool get isLandscape {
    final size = MediaQuery.of(this).size;
    return size.width > size.height;
  }
}
