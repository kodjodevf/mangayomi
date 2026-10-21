import 'package:flutter/material.dart';

import '../tokens.dart';

/// The mark under the current tab: a pill tinted with the accent, behind the
/// label rather than a line beneath it.
///
/// A tab bar is the second level of a screen's switching, under a
/// [ShioriSegmentedControl] when there is one; the segmented control's
/// raised segment and this tinted pill read as the same family, one step
/// apart. The pill is drawn around the label with room to breathe, and
/// TabBar moves it with the finger as the pages are swiped.
class ShioriTabIndicator extends Decoration {
  const ShioriTabIndicator({
    required this.color,
    this.height = 32,
    this.horizontalInset = ShioriSpace.s12,
  });

  /// The pill's fill: the accent at [Alphas.accentTint].
  final Color color;

  /// The pill's height, centred on the tab; never taller than the tab less
  /// a small margin.
  final double height;

  /// How far the pill reaches past each side of the label.
  final double horizontalInset;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TabIndicatorPainter(this);

  @override
  bool operator ==(Object other) =>
      other is ShioriTabIndicator &&
      other.color == color &&
      other.height == height &&
      other.horizontalInset == horizontalInset;

  @override
  int get hashCode => Object.hash(color, height, horizontalInset);
}

class _TabIndicatorPainter extends BoxPainter {
  _TabIndicatorPainter(this.decoration);

  final ShioriTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null || size.isEmpty) return;
    final height = decoration.height.clamp(0.0, size.height - ShioriSpace.s8);
    final rect = Rect.fromCenter(
      center: (offset & size).center,
      width: size.width + decoration.horizontalInset * 2,
      height: height,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(height / 2)),
      Paint()..color = decoration.color,
    );
  }
}
