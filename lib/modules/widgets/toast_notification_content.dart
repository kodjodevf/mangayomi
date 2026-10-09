import 'package:flutter/material.dart';

/// Keeps notification actions from competing with the message for horizontal
/// space on narrow screens.
class ToastNotificationContent extends StatelessWidget {
  const ToastNotificationContent({
    super.key,
    required this.message,
    this.action,
    this.fontSize,
    this.maxLines = 6,
  });

  final String message;
  final Widget? action;
  final double? fontSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          message,
          style: TextStyle(fontSize: fontSize),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
        if (action != null) ...[
          const SizedBox(height: 8),
          Align(alignment: AlignmentDirectional.centerStart, child: action!),
        ],
      ],
    );
  }
}
