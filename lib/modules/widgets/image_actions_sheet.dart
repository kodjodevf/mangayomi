import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// Bottom sheet offering to set an image as the cover, share it or save it
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
    return SuperListView(
      shrinkWrap: true,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: context.themeData.scaffoldBackgroundColor,
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 7,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: context.secondaryColor.withValues(alpha: 0.4),
                  ),
                ),
              ),
              Row(
                children: [
                  _ActionButton(
                    label: context.l10n.set_as_cover,
                    icon: Icons.image_outlined,
                    onPressed: () => onSetCover(context),
                  ),
                  _ActionButton(
                    label: context.l10n.share,
                    icon: Icons.share_outlined,
                    onPressed: () => onShare(context),
                  ),
                  _ActionButton(
                    label: context.l10n.save,
                    icon: Icons.save_outlined,
                    onPressed: () => onSave(context),
                  ),
                ],
              ),
              ?footer,
            ],
          ),
        ),
      ],
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
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: const EdgeInsets.all(4), child: Icon(icon)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
