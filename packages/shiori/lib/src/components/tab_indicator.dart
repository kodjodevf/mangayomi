import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

/// Paints a tab's press feedback inside the same pill bounds as
/// [ShioriTabIndicator], rather than across the full [Expanded] tab slot.
class ShioriTabSplashFactory extends InteractiveInkFeatureFactory {
  const ShioriTabSplashFactory({
    required this.color,
    this.height = 32,
    this.horizontalInset = ShioriSpace.s12,
  });

  final Color color;
  final double height;
  final double horizontalInset;

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return _ShioriTabSplash(
      controller: controller,
      referenceBox: referenceBox,
      color: this.color,
      height: height,
      horizontalInset: horizontalInset,
      onRemoved: onRemoved,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ShioriTabSplashFactory &&
      other.color == color &&
      other.height == height &&
      other.horizontalInset == horizontalInset;

  @override
  int get hashCode => Object.hash(color, height, horizontalInset);
}

class _ShioriTabSplash extends InteractiveInkFeature {
  _ShioriTabSplash({
    required super.controller,
    required super.referenceBox,
    required super.color,
    required this.height,
    required this.horizontalInset,
    super.onRemoved,
  }) : _alphaController = AnimationController(
         duration: const Duration(milliseconds: 100),
         reverseDuration: const Duration(milliseconds: 150),
         vsync: controller.vsync,
       ) {
    _alphaController
      ..addListener(controller.markNeedsPaint)
      ..forward();
    controller.addInkFeature(this);
  }

  final double height;
  final double horizontalInset;
  final AnimationController _alphaController;

  @override
  void confirm() => _dismiss();

  @override
  void cancel() => _dismiss();

  void _dismiss() {
    if (_alphaController.isDismissed) {
      dispose();
      return;
    }
    _alphaController.reverse().whenCompleteOrCancel(() {
      if (_alphaController.isDismissed) {
        dispose();
      }
    });
  }

  @override
  void dispose() {
    _alphaController.dispose();
    super.dispose();
  }

  RenderBox _findTabLabelBox(RenderBox root) {
    RenderObject? current = root;
    while (current != null) {
      if (current is RenderPositionedBox) {
        final padded = current.child;
        if (padded is RenderPadding && padded.child != null) {
          return padded.child!;
        }
        if (padded != null) return padded;
      }
      if (current is RenderStack) {
        current = current.firstChild;
      } else if (current is RenderObjectWithChildMixin<RenderBox>) {
        current = current.child;
      } else if (current is RenderObjectWithChildMixin<RenderObject>) {
        final child = current.child;
        current = child is RenderBox ? child : null;
      } else {
        RenderObject? first;
        current.visitChildren((child) {
          first ??= child;
        });
        current = first;
      }
    }
    return root;
  }

  Rect _pillRect() {
    final size = referenceBox.size;
    final box = _findTabLabelBox(referenceBox);
    final pillHeight = height.clamp(0.0, size.height - ShioriSpace.s8);
    final pillWidth = (box.size.width + horizontalInset * 2).clamp(
      0.0,
      size.width,
    );
    final centerX = identical(box, referenceBox) || !box.attached
        ? size.width / 2
        : box
              .localToGlobal(
                box.size.center(Offset.zero),
                ancestor: referenceBox,
              )
              .dx;
    return Rect.fromCenter(
      center: Offset(centerX, size.height / 2),
      width: pillWidth,
      height: pillHeight,
    );
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final alpha = _alphaController.value;
    if (alpha <= 0 || !referenceBox.hasSize || referenceBox.size.isEmpty) {
      return;
    }
    final rect = _pillRect();
    if (rect.isEmpty) return;

    canvas.save();
    canvas.transform(transform.storage);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)),
      Paint()..color = color.withValues(alpha: color.a * alpha),
    );
    canvas.restore();
  }
}
