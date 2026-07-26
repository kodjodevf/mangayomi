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
    final size = mq.size;
    if (size.isEmpty || size.width <= 0) return child;

    final s = scale <= 0 ? 1.0 : scale;
    final double target;
    if (isTv) {
      // TV: lay out against a fixed reference width and scale to the panel, so
      // the UI is consistent across TVs regardless of the density the device
      // reports. A higher user scale => narrower target => larger UI.
      target = referenceWidth / s;
    } else {
      // Elsewhere there is no density problem, so the scale is a straight
      // multiplier on the native size: 1.0 is native (no-op), higher zooms in.
      if (s == 1.0) return child;
      target = size.width / s;
    }
    // Match the aspect ratio so the uniform fit never distorts.
    final designSize = Size(target, target * size.height / size.width);
    // Convert real insets into design space so safe-area padding stays correct.
    final ratio = target / size.width;

    return FittedBox(
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
    );
  }
}
