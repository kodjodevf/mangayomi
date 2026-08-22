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
