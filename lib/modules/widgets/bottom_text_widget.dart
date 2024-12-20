import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class BottomTextWidget extends StatelessWidget {
  final bool isLoading;
  final String text;
  final bool isComfortableGrid;
  final double? fontSize;
  final int? maxLines;
  final Color? textColor;
  final bool? isTorrent;
  const BottomTextWidget(
      {super.key,
      required this.text,
      this.isLoading = false,
      this.isComfortableGrid = false,
      this.fontSize = 12.0,
      this.maxLines = 2,
      this.textColor,
      this.isTorrent = false});

  @override
  Widget build(BuildContext context) {
    return isComfortableGrid
        ? Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? context.textColor,
                    ),
                    maxLines: isTorrent! ? 8 : maxLines,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          )
        : Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: isLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: textColor ?? Colors.white,
                            shadows: const <Shadow>[
                              Shadow(offset: Offset(0.5, 0.9), blurRadius: 3.0)
                            ],
                          ),
                          maxLines: isTorrent! ? 8 : maxLines,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: isTorrent! ? 200 : 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6)
                        ],
                        stops: const [0, 1],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, bottom: 5),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: textColor ?? Colors.white,
                              shadows: const <Shadow>[
                                Shadow(
                                    offset: Offset(0.5, 0.9), blurRadius: 3.0)
                              ],
                            ),
                            maxLines: isTorrent! ? 8 : maxLines,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
          );
  }
}
