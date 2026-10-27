import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';

void main() {
  testWidgets('sfx outline inherits the same style as its fill', (
    tester,
  ) async {
    // The app theme sets letter spacing on every text role; an outline
    // that ignores it drifts away from the fill.
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: DefaultTextStyle(
          style: TextStyle(
            letterSpacing: 7,
            leadingDistribution: TextLeadingDistribution.even,
          ),
          textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: false,
          ),
          child: StripSfx('390', style: TextStyle(fontSize: 40)),
        ),
      ),
    );

    final paint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(StripSfx),
        matching: find.byType(CustomPaint),
      ),
    );
    final painter = paint.painter! as SfxStrokePainter;
    expect(painter.style.letterSpacing, 7);
    expect(painter.style.leadingDistribution, TextLeadingDistribution.even);
    expect(painter.style.fontSize, 40);
    expect(painter.textHeightBehavior?.applyHeightToFirstAscent, isFalse);
  });
}
