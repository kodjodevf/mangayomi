import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shiori/shiori.dart';

/// A panel with a share button that sends it as a PNG. The button sits
/// outside the captured boundary, so it never shows in the image.
class SharePanel extends StatefulWidget {
  const SharePanel({super.key, required this.name, required this.child});

  /// File name without extension.
  final String name;
  final Widget child;

  @override
  State<SharePanel> createState() => _SharePanelState();
}

class _SharePanelState extends State<SharePanel> {
  final _boundary = GlobalKey();
  bool _busy = false;

  Future<void> _share(BuildContext buttonContext) async {
    final boundary =
        _boundary.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null || _busy) return;
    setState(() => _busy = true);
    try {
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (bytes == null || !buttonContext.mounted) return;
      final box = buttonContext.findRenderObject() as RenderBox?;
      await shareOrCopy(
        ShareParams(
          files: [
            XFile.fromData(
              bytes.buffer.asUint8List(),
              name: '${widget.name}.png',
              mimeType: 'image/png',
            ),
          ],
          sharePositionOrigin: box == null
              ? null
              : box.localToGlobal(Offset.zero) & box.size,
        ),
        fallbackName: widget.name,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Panels get the strip's full width, not their content's.
      fit: StackFit.passthrough,
      children: [
        RepaintBoundary(key: _boundary, child: widget.child),
        Positioned(
          top: ShioriSpace.s8,
          right: ShioriSpace.s8,
          child: Builder(
            builder: (buttonContext) => IconButton.filled(
              tooltip: context.l10n.share,
              onPressed: _busy ? null : () => _share(buttonContext),
              style: IconButton.styleFrom(
                backgroundColor: StripColors.shade,
                foregroundColor: StripColors.paper,
                visualDensity: VisualDensity.compact,
              ),
              icon: const Icon(Symbols.share_rounded),
            ),
          ),
        ),
      ],
    );
  }
}
