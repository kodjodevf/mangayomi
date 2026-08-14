import 'package:flutter/material.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Normalizes the TV UI to a fixed reference width so it looks the same on every
/// television regardless of the density the device reports (OEMs set that wildly
/// inconsistently, which is why the same layout is comfortable on one box and
/// zoomed-in on another). The whole subtree is laid out as if the screen were
/// [referenceWidth] logical pixels wide, then scaled uniformly to fill the real
/// panel. [scale] is the user's fine-tune (1.0 == the reference). Off-TV it is a
/// transparent pass-through.
class AppUiScale extends StatelessWidget {
  const AppUiScale({super.key, required this.child, this.scale = 1.0});

  final Widget child;
  final double scale;

  /// Logical width the TV UI is designed against. 1280 == what Android density
  /// 240 gives on a 1080p panel, the comfortable 10-foot reference.
  static const double referenceWidth = 1280.0;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final s = scale <= 0 ? 1.0 : scale;
    // Off-TV at 1.0 there is nothing to do; on TV we always normalize to the
    // reference width, so keep going.
    if (!isTv && s == 1.0) return child;

    // Measure the real box we are given rather than trusting MediaQuery.size,
    // which can differ from the actual render constraints on desktop and left
    // the scaled subtree mis-sized (blank right/bottom edges).
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        if (!w.isFinite || !h.isFinite || w <= 0 || h <= 0) return child;

        // Design width: a fixed reference on TV (density-independent), else the
        // real width divided by the user's zoom. A higher scale => narrower
        // design width => the FittedBox blows it up more.
        final double designWidth = isTv ? referenceWidth / s : w / s;
        // Convert real insets into design space so safe-area padding stays right.
        final ratio = designWidth / w;
        // Same aspect ratio as the box so the uniform fit never distorts.
        final designSize = Size(designWidth, h * ratio);

        // Pin the FittedBox to the real box (tight w x h) so the scaled subtree
        // always covers the whole window. Without this, under loose constraints
        // the FittedBox shrinks to the smaller design child and leaves the right
        // and bottom of the window blank.
        return SizedBox(
          width: w,
          height: h,
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox.fromSize(
              size: designSize,
              child: MediaQuery(
                data: mq.copyWith(
                  size: designSize,
                  padding: mq.padding * ratio,
                  viewPadding: mq.viewPadding * ratio,
                  viewInsets: mq.viewInsets * ratio,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
