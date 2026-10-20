import 'package:flutter/material.dart';

import '../tokens.dart';
import 'button.dart';

/// Asks the reader to confirm an action. Resolves to true only when they
/// confirm; dismissing the dialog counts as no.
///
/// [confirmLabel] should name the action ("Delete", "Replace"), not say
/// "OK". [cancelLabel] defaults to the platform's own "Cancel".
Future<bool> showShioriConfirm(
  BuildContext context, {
  required String title,
  String? message,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => ShioriDialog(
      title: title,
      content: message == null ? null : Text(message),
      actions: [
        ShioriButton.quiet(
          label:
              cancelLabel ??
              MaterialLocalizations.of(dialogContext).cancelButtonLabel,
          onPressed: () => Navigator.pop(dialogContext, false),
        ),
        ShioriButton(
          label: confirmLabel,
          destructive: destructive,
          onPressed: () => Navigator.pop(dialogContext, true),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// A dialog in Shiori's shape and type. Prefer [showShioriConfirm] for a
/// yes-or-no question.
class ShioriDialog extends StatelessWidget {
  const ShioriDialog({
    super.key,
    required this.title,
    this.content,
    this.actions = const [],
  });

  final String title;
  final Widget? content;

  /// Laid out at the end, the primary action last.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return AlertDialog(
      backgroundColor: tokens.color.ink1,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ShioriShape.sheet),
      ),
      title: Text(
        title,
        style: tokens.text.section.copyWith(color: tokens.color.fg),
      ),
      content: content == null
          ? null
          : DefaultTextStyle.merge(
              style: tokens.text.body.copyWith(color: tokens.color.fgMuted),
              child: content!,
            ),
      actionsPadding: const EdgeInsets.fromLTRB(
        ShioriSpace.s16,
        0,
        ShioriSpace.s16,
        ShioriSpace.s16,
      ),
      actions: actions,
    );
  }
}
