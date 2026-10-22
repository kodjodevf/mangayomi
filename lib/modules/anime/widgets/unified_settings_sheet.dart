import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

import 'package:mangayomi/modules/widgets/settings/settings_drilldown.dart';

export 'package:mangayomi/modules/widgets/settings/settings_drilldown.dart';
export 'package:mangayomi/modules/widgets/settings/settings_rows.dart';

/// The mobile chrome around [SettingsDrilldown]: a modal bottom sheet with a
/// drag handle and rounded top corners.
class UnifiedSettingsSheet extends StatelessWidget {
  final String title;
  final List<SettingsEntry> entries;
  final int initialIndex;

  const UnifiedSettingsSheet({
    super.key,
    required this.title,
    required this.entries,
    this.initialIndex = -1,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: context.shiori.color.ink1,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(ShioriShape.sheet),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: ShioriSpace.s12),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: context.shiori.color.fgMuted.withValues(alpha: 0.40),
                  borderRadius: BorderRadius.circular(ShioriShape.pill),
                ),
              ),
              const SizedBox(height: ShioriSpace.s8),
              SettingsDrilldown(
                title: title,
                entries: entries,
                initialIndex: initialIndex,
                onClose: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Whether the player's settings open beside the video rather than over
/// it: on a screen wider than tall, as the episode list does, so what they
/// change (a subtitle's size, the fit) can be seen while it is changed.
bool playerSettingsOpenBeside(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width > size.height && size.width >= 600;
}

/// Opens the mobile settings: a panel from the side in landscape, a sheet
/// from the bottom in portrait.
Future<T?> showUnifiedPlayerSettings<T>(
  BuildContext context, {
  required String title,
  required List<SettingsEntry> entries,
  int initialIndex = -1,
}) {
  if (playerSettingsOpenBeside(context)) {
    final size = MediaQuery.sizeOf(context);
    final width = (size.width * 0.42).clamp(340.0, 440.0);
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: ShioriMotion.of(context, ShioriMotion.enter),
      transitionBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: ShioriMotion.enterCurve),
        ),
        child: child,
      ),
      pageBuilder: (dialogContext, _, _) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: Material(
            color: dialogContext.shiori.color.ink1.withValues(
              alpha: Alphas.chrome,
            ),
            borderRadius: const BorderRadiusDirectional.horizontal(
              start: Radius.circular(ShioriShape.sheet),
            ),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              left: false,
              child: SettingsDrilldown(
                title: title,
                entries: entries,
                initialIndex: initialIndex,
                // The header's height off the panel's.
                maxBodyHeight:
                    MediaQuery.sizeOf(dialogContext).height -
                    MediaQuery.paddingOf(dialogContext).vertical -
                    ShioriSpace.s48 -
                    ShioriSpace.s16,
                onClose: () => Navigator.pop(dialogContext),
              ),
            ),
          ),
        ),
      ),
    );
  }
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => UnifiedSettingsSheet(
      title: title,
      entries: entries,
      initialIndex: initialIndex,
    ),
  );
}

/// Opens the desktop settings menu as a small popup anchored to [anchor]
/// (the gear icon, the speed pill...) — matching YouTube desktop's own
/// settings gear, rather than a sheet or a docked panel. It grows from the
/// anchor with the platform's usual popup-menu animation and dismisses on an
/// outside click or Escape, same as any other popup menu.
Future<void> showDesktopPlayerSettingsMenu(
  BuildContext anchor, {
  required String title,
  required List<SettingsEntry> entries,
  int initialIndex = -1,
}) {
  final navigator = Navigator.of(anchor);
  final overlay = navigator.overlay!.context.findRenderObject() as RenderBox;
  final renderObject = anchor.findRenderObject();
  final button = renderObject is RenderBox ? renderObject : null;

  // Anchored to the button's own rect — showMenu grows the popup from it,
  // flipping above when (as here, a bottom control bar) there's no room
  // below, exactly like YouTube's gear menu growing upward from the bar.
  final RelativeRect position;
  if (button != null &&
      button.attached &&
      button.hasSize &&
      button.size != overlay.size) {
    position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
  } else {
    // Fallback if anchor is the full screen or unmeasured: anchor to bottom-right corner
    final right = 16.0;
    final bottom = 64.0;
    position = RelativeRect.fromLTRB(
      overlay.size.width - right - 40,
      overlay.size.height - bottom - 40,
      right,
      bottom,
    );
  }
  return showMenu<void>(
    context: anchor,
    position: position,
    color: anchor.shiori.color.ink2,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(ShioriShape.card),
    ),
    menuPadding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 300, maxWidth: 360),
    items: [
      PopupMenuItem<void>(
        enabled: false,
        padding: EdgeInsets.zero,
        child: Builder(
          builder: (menuContext) => SettingsDrilldown(
            title: title,
            entries: entries,
            initialIndex: initialIndex,
            onClose: () {
              if (menuContext.mounted) {
                Navigator.of(menuContext).pop();
              } else if (navigator.mounted) {
                navigator.pop();
              }
            },
          ),
        ),
      ),
    ],
  );
}
