import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shiori/shiori.dart';

// Use the default system font for mode bar labels (previously ABeeZee).
const String? barFontFamily = null;

class DownloadedOnlyBar extends StatelessWidget {
  const DownloadedOnlyBar({
    super.key,
    required this.downloadedOnly,
    required this.l10n,
  });

  final bool downloadedOnly;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) => _ModeBar(
    visible: downloadedOnly,
    fill: context.shiori.color.fgMuted,
    label: l10n.downloaded_only,
  );
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
  Widget build(BuildContext context) => _ModeBar(
    visible: incognitoMode,
    fill: context.shiori.color.accentInk,
    label: l10n.incognito_mode,
  );
}

/// A band across the top while a mode is on, under the status bar.
///
/// Its label and the status bar's icons take whichever of black and white
/// reads on the fill: a palette whose accent is white (a monochrome one)
/// wrote the label white on white.
class _ModeBar extends StatelessWidget {
  const _ModeBar({
    required this.visible,
    required this.fill,
    required this.label,
  });

  final bool visible;
  final Color fill;
  final String label;

  @override
  Widget build(BuildContext context) {
    final onFill = ShioriColors.onFill(fill);
    final bar = Material(
      child: AnimatedContainer(
        height: visible
            ? isMobile
                  ? MediaQuery.paddingOf(context).top * 2
                  : 50
            : 0,
        curve: Curves.easeIn,
        duration: ShioriMotion.fast,
        color: fill,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(ShioriSpace.s8),
              child: Text(
                label,
                style: TextStyle(color: onFill, fontFamily: barFontFamily),
              ),
            ),
          ],
        ),
      ),
    );
    if (!visible) return bar;
    final darkIcons = onFill.computeLuminance() < 0.5;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: darkIcons
          ? SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: bar,
    );
  }
}
