import 'package:flutter/material.dart';

/// Invisible tap-zone overlays for the novel reader (left/center/right and
/// top/bottom regions) that trigger page/scroll steps or toggle UI chrome.
class NovelTapZones extends StatelessWidget {
  final bool usePageTapZones;
  final bool isContinuousMode;
  final ValueChanged<double> onPageStep;
  final VoidCallback onToggleUi;

  const NovelTapZones({
    super.key,
    required this.usePageTapZones,
    required this.isContinuousMode,
    required this.onPageStep,
    required this.onToggleUi,
  });

  @override
  Widget build(BuildContext context) {
    final enableTapPaging = usePageTapZones || !isContinuousMode;
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  enableTapPaging ? onPageStep(-100) : onToggleUi();
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onToggleUi,
              ),
            ),
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  enableTapPaging ? onPageStep(100) : onToggleUi();
                },
              ),
            ),
          ],
        ),
        Column(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  usePageTapZones ? onPageStep(-100) : onToggleUi();
                },
              ),
            ),
            const Expanded(flex: 5, child: SizedBox.shrink()),
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  usePageTapZones ? onPageStep(100) : onToggleUi();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
