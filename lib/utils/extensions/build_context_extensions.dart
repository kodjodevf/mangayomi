import 'dart:io';

import 'package:flutter/material.dart';

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

  bool get isDesktop {
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  }

  bool get isMobile {
    return Platform.isIOS || Platform.isAndroid;
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
}
