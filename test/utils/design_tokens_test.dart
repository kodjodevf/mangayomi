import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/design_tokens.dart';

/// The ladder existed as private constants copied into each screen that needed
/// it, which is how two screens a reader reaches from the same detail page
/// ended up with focus washes at 0.16 and 0.12 and secondary text at 0.7 and
/// 0.6. These pin the values so a copy cannot quietly diverge again.
void main() {
  test('the ladder is what the contract says', () {
    expect(Alphas.tint, 0.08);
    expect(Alphas.hairline, 0.16);
    expect(Alphas.focus, 0.14);
    expect(Alphas.accentTint, 0.16);
    expect(Alphas.secondary, 0.70);
    expect(Alphas.tvFocus, 0.45);
    expect(Alphas.disabled, 0.38);
  });

  test('disabled clears the floor that 0.5 and 0.6 were used for', () {
    // The codebase dimmed things at 0.5 and 0.6. Material's 0.38 wins because
    // disabled text has a contrast floor and the higher values do not clear it
    // against every palette in the catalogue.
    expect(Alphas.disabled, lessThan(0.5));
  });

  test('a television focus is louder than a pointer one', () {
    // It is read from across a room.
    expect(Alphas.tvFocus, greaterThan(Alphas.focus));
  });

  test('secondary text stays legible, tints stay out of the way', () {
    expect(Alphas.secondary, greaterThan(Alphas.disabled));
    expect(Alphas.tint, lessThan(Alphas.hairline));
  });

  test('covers are 2:3', () {
    expect(coverAspect, closeTo(0.667, 0.001));
  });
}
