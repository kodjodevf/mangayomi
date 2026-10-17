import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/constant.dart';

/// A tracker's logo on the tracker's own colour, as in its apps: the same
/// tile wherever a tracker is listed.
class TrackerLogo extends StatelessWidget {
  const TrackerLogo({super.key, required this.syncId, this.size = 44});

  final int syncId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final side = context.shiori.scaled(size);
    return ClipRRect(
      borderRadius: BorderRadius.circular(ShioriShape.cover),
      child: Container(
        width: side,
        height: side,
        color: trackInfos(syncId).$3,
        padding: const EdgeInsets.all(ShioriSpace.s8),
        child: Image.asset(trackInfos(syncId).$1),
      ),
    );
  }
}
