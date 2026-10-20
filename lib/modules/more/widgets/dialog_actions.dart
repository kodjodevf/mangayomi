import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Cancel, then the action, for a dialog built around something other than
/// a yes-or-no question (which is [showShioriConfirm]). A [confirmColor]
/// marks the action as destructive: it is drawn in the error colours.
List<Widget> dialogCancelConfirmActions({
  required BuildContext dialogContext,
  required String confirmLabel,
  Color? confirmColor,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
}) {
  final l10n = dialogContext.l10n;
  return [
    ShioriButton.quiet(
      label: l10n.cancel,
      onPressed: onCancel ?? () => Navigator.pop(dialogContext, false),
    ),
    ShioriButton(
      label: confirmLabel,
      destructive: confirmColor != null,
      onPressed: onConfirm ?? () => Navigator.pop(dialogContext, true),
    ),
  ];
}

List<Widget> dialogCancelOnlyAction(BuildContext dialogContext) {
  return [
    ShioriButton.quiet(
      label: dialogContext.l10n.cancel,
      onPressed: () => Navigator.pop(dialogContext, null),
    ),
  ];
}

/// Asked right before a restore that would push its data to a connected
/// sync server — lets the user back out of overwriting good server data
/// with a wrong backup, or re-enable sync if it was previously disabled.
/// Not dismissible (no back button, no barrier tap); always resolves to
/// true (sync/re-enable) or false (skip/keep disabled).
Future<bool?> confirmSyncAfterRestore(
  BuildContext context, {
  required bool syncOn,
}) {
  final l10n = context.l10n;
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return PopScope(
        canPop: false,
        child: ShioriDialog(
          title: syncOn
              ? l10n.restore_sync_question_title
              : l10n.restore_sync_disabled_question_title,
          content: Text(
            syncOn
                ? l10n.restore_sync_question_message
                : l10n.restore_sync_disabled_question_message,
          ),
          actions: [
            ShioriButton.quiet(
              label: syncOn
                  ? l10n.restore_sync_question_deny
                  : l10n.restore_sync_question_keep_disabled,
              destructive: true,
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            ShioriButton(
              label: syncOn
                  ? l10n.restore_sync_question_confirm
                  : l10n.restore_sync_question_reenable,
              onPressed: () => Navigator.pop(dialogContext, true),
            ),
          ],
        ),
      );
    },
  );
}

void showBusyDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => PopScope(
      canPop: false,
      // The surface and shape of a ShioriDialog, which wants a title this
      // one has no use for.
      child: AlertDialog(
        backgroundColor: dialogContext.shiori.color.ink1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ShioriShape.sheet),
        ),
        content: Row(
          spacing: ShioriSpace.s16,
          children: [
            const ShioriLoading.inline(),
            Expanded(
              child: Text(
                message,
                style: dialogContext.shiori.text.body.copyWith(
                  color: dialogContext.shiori.color.fg,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void hideBusyDialog(BuildContext context) {
  final navigator = Navigator.of(context, rootNavigator: true);
  if (navigator.canPop()) navigator.pop();
}

/// Asks before logging out of a tracker or sync server named [serviceName].
Future<void> showLogOutDialog(
  BuildContext context, {
  required String serviceName,
  required VoidCallback onLogOut,
}) async {
  final l10n = context.l10n;
  final confirmed = await showShioriConfirm(
    context,
    title: l10n.log_out_from(serviceName),
    confirmLabel: l10n.log_out,
    destructive: true,
  );
  if (confirmed) onLogOut();
}
