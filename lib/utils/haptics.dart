import 'package:flutter/services.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// A light tick when the interface changes mode under the finger: entering
/// selection, a swipe that acted on a chapter. Phones only; a desktop or a
/// TV has nothing to vibrate, and a tick on every tap would mean nothing.
void selectionHaptic() {
  if (isMobile && !isTv) HapticFeedback.selectionClick();
}
