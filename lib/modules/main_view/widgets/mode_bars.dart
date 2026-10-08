import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/main_view/main_screen.dart';

class DownloadedOnlyBar extends StatelessWidget {
  const DownloadedOnlyBar({
    super.key,
    required this.downloadedOnly,
    required this.l10n,
  });

  final bool downloadedOnly;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
        height: downloadedOnly
            ? isMobile
                  ? MediaQuery.paddingOf(context).top * 2
                  : 50
            : 0,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 150),
        color: context.secondaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.downloaded_only,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: barFontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncognitoModeBar extends StatelessWidget {
  const IncognitoModeBar({
    super.key,
    required this.incognitoMode,
    required this.l10n,
  });

  final bool incognitoMode;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
        height: incognitoMode
            ? isMobile
                  ? MediaQuery.paddingOf(context).top * 2
                  : 50
            : 0,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 150),
        color: context.primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.incognito_mode,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: barFontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
