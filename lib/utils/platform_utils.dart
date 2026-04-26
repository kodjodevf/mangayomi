import 'dart:io';

final bool isDesktop =
    Platform.isMacOS || Platform.isLinux || Platform.isWindows;

final bool isMobile = Platform.isAndroid || Platform.isIOS;
