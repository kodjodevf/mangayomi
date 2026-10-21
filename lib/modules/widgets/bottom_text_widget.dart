import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

class BottomTextWidget extends StatelessWidget {
  final bool isLoading;
  final String text;
  final bool isComfortableGrid;
  final double? fontSize;
  final int? maxLines;
  final Color? textColor;
  final bool? isTorrent;
  const BottomTextWidget({
    super.key,
    required this.text,
    this.isLoading = false,
    this.isComfortableGrid = false,
    this.fontSize = 12.0,
    this.maxLines = 2,
    this.textColor,
    this.isTorrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final lines = isTorrent! ? 8 : maxLines;
    if (isComfortableGrid) {
      // Under the cover, on the page's own ground.
      return Padding(
        padding: const EdgeInsetsDirectional.only(
          start: ShioriSpace.s4,
          bottom: ShioriSpace.s4,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: tokens.text.card.copyWith(
                  fontSize: fontSize,
                  color: textColor ?? tokens.color.fg,
                ),
                maxLines: lines,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      );
    }
    // Over the cover: the image is the ground, so the text is white on a
    // scrim, whatever the theme.
    final label = Padding(
      padding: const EdgeInsetsDirectional.only(
        start: ShioriSpace.s4,
        end: ShioriSpace.s4,
        bottom: ShioriSpace.s4,
      ),
      child: Text(
        text,
        style: tokens.text.card.copyWith(
          color: textColor ?? Colors.white,
          shadows: const [Shadow(color: ShioriScrim.shadow, blurRadius: 3)],
        ),
        maxLines: lines,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    );
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: isLoading
          ? label
          : Container(
              height: isTorrent! ? 200 : 70,
              alignment: AlignmentDirectional.bottomStart,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, ShioriScrim.underText],
                ),
              ),
              child: label,
            ),
    );
  }
}
