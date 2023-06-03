import 'package:flutter/material.dart';
import 'package:mangayomi/utils/colors.dart';

class BottomTextWidget extends StatelessWidget {
  final bool isLoading;
  final String text;
  final bool isComfortableGrid;
  final double? fontSize;
  final int? maxLines;
  const BottomTextWidget(
      {super.key,
      required this.text,
      this.isLoading = false,
      this.isComfortableGrid = false,
      this.fontSize = 12.0,
      this.maxLines = 2});

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
                      color: primaryColor(context),
                    ),
                    maxLines: maxLines,
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
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            shadows: <Shadow>[
                              Shadow(offset: Offset(0.5, 0.9), blurRadius: 3.0)
                            ],
                          ),
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6)
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
                            style: const TextStyle(
                              fontSize: 13.0,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                    offset: Offset(0.5, 0.9), blurRadius: 3.0)
                              ],
                            ),
                            maxLines: maxLines,
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
