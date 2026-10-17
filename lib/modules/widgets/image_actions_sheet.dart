import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// The inside of a bottom sheet (open it with showShioriSheet) offering to set an image as the cover, share it or save it
/// to the gallery. Used for reader pages and for player screenshots.
///
/// Each action gets the sheet's own context, to pop it or to anchor the
/// share popover to it.
class ImageActionsSheet extends StatelessWidget {
  const ImageActionsSheet({
    super.key,
    required this.onSetCover,
    required this.onShare,
    required this.onSave,
    this.footer,
  });

  final ValueChanged<BuildContext> onSetCover;
  final ValueChanged<BuildContext> onShare;
  final ValueChanged<BuildContext> onSave;

  /// Shown under the actions, for options specific to the image source.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    // The sheet (showShioriSheet) brings the handle and the surface.
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _ActionButton(
                label: context.l10n.set_as_cover,
                icon: Symbols.image_rounded,
                onPressed: () => onSetCover(context),
              ),
              _ActionButton(
                label: context.l10n.share,
                icon: Symbols.share_rounded,
                onPressed: () => onShare(context),
              ),
              _ActionButton(
                label: context.l10n.save,
                icon: Symbols.save_rounded,
                onPressed: () => onSave(context),
              ),
            ],
          ),
          ?footer,
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        child: Material(
          type: MaterialType.transparency,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ShioriShape.card),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: ShioriSpace.s4,
                children: [
                  Icon(icon, color: context.shiori.color.accentInk),
                  Text(
                    label,
                    style: context.shiori.text.meta.copyWith(
                      color: context.shiori.color.fg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
