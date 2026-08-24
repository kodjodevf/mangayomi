import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

List<Widget> dialogCancelConfirmActions({
  required BuildContext dialogContext,
  required String confirmLabel,
  Color? confirmColor,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
}) {
  final l10n = dialogContext.l10n;
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.pop(dialogContext, false),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: dialogContext.primaryColor),
          ),
        ),
        TextButton(
          onPressed: onConfirm ?? () => Navigator.pop(dialogContext, true),
          child: Text(
            confirmLabel,
            style: TextStyle(color: confirmColor ?? dialogContext.primaryColor),
          ),
        ),
      ],
    ),
  ];
}

List<Widget> dialogCancelOnlyAction(BuildContext dialogContext) {
  final l10n = dialogContext.l10n;
  return [
    TextButton(
      onPressed: () => Navigator.pop(dialogContext, null),
      child: Text(
        l10n.cancel,
        style: TextStyle(color: dialogContext.primaryColor),
      ),
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
        child: AlertDialog(
          title: Text(
            syncOn
                ? l10n.restore_sync_question_title
                : l10n.restore_sync_disabled_question_title,
          ),
          content: Text(
            syncOn
                ? l10n.restore_sync_question_message
                : l10n.restore_sync_disabled_question_message,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                syncOn
                    ? l10n.restore_sync_question_deny
                    : l10n.restore_sync_question_keep_disabled,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                syncOn
                    ? l10n.restore_sync_question_confirm
                    : l10n.restore_sync_question_reenable,
              ),
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
      child: AlertDialog(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
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
