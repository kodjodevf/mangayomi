/// The one place the design contract's numbers live.
///
/// These were previously copied into each screen that needed them, as private
/// constants, which is how two screens reached for the same concept and picked
/// different values: an audit found focus washes at 0.16 and 0.12, neutral
/// fills at 0.08 and 0.09, and secondary text at 0.7 and 0.6, between two
/// screens a reader reaches from the same detail page.
///
/// Reconciling those was the easy half. The hard half is not doing it again,
/// and a copied constant is copied again by the next screen.
library;

/// Neutral and accent tints are an alpha over the foreground or the accent,
/// never a separate colour, so they survive a theme change and every palette
/// in the catalogue.
///
/// This ladder is closed. Reaching for an eighth value almost always means
/// duplicating one of these.
abstract final class Alphas {
  /// Chip and neutral badge fill, over the foreground.
  static const double tint = 0.08;

  /// Thin rules and connectors, over the foreground.
  static const double hairline = 0.16;

  /// Pointer and d-pad focus wash on an InkWell, over the accent.
  static const double focus = 0.14;

  /// Accent tinted badge fill, over the accent.
  static const double accentTint = 0.16;

  /// Secondary text, over the foreground.
  static const double secondary = 0.70;

  /// Ambient focusColor on a television only, over the accent. Higher than
  /// [focus] because it is read from across a room.
  static const double tvFocus = 0.45;

  /// Disabled text and icons, over the foreground.
  ///
  /// Material's own value rather than the 0.5 and 0.6 found in the codebase,
  /// because disabled text has a contrast floor to clear and 0.5 does not
  /// clear it against every palette.
  static const double disabled = 0.38;
}

/// Covers are 2:3. Every source ships them at some approximation of it, so the
/// box is fixed and the image is cropped to fill rather than the box moving to
/// fit whatever arrived.
const double coverAspect = 2 / 3;
