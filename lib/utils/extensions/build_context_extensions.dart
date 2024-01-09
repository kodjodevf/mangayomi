import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  bool get isLight {
    return Theme.of(this).brightness == Brightness.light;
  }

  Color get primaryColor {
    return Theme.of(this).primaryColor;
  }

  Color get secondaryColor {
    return Theme.of(this).iconTheme.color!.withOpacity(0.7);
  }

  double mediaHeight(double data) {
    return MediaQuery.of(this).size.height * data;
  }

  double mediaWidth(double data) {
    return MediaQuery.of(this).size.width * data;
  }

  bool get isDesktop {
    return MediaQuery.of(this).size.width >= 1200;
  }

  bool get isTablet {
    return MediaQuery.of(this).size.width >= 600;
  }
}
