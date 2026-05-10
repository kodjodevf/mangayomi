import 'dart:io';

/// macOS, Linux or Windows
final bool isDesktop =
    Platform.isMacOS || Platform.isLinux || Platform.isWindows;

/// Android or iOS
final bool isMobile = Platform.isAndroid || Platform.isIOS;

/// macOS or iOS
final bool isApple = Platform.isMacOS || Platform.isIOS;
