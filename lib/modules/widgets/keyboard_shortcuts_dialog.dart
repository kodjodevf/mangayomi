import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Lists keyboard shortcuts in a dialog: what each does, and its keys as key
/// caps. The readers and the video player each give their own [shortcuts].
Future<void> showKeyboardShortcuts(
  BuildContext context,
  List<(String label, List<String> keys)> shortcuts,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => ShioriDialog(
      title: context.l10n.keyboard_shortcuts,
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (label, keys) in shortcuts)
                KeyboardShortcutRow(label: label, keys: keys),
            ],
          ),
        ),
      ),
      actions: [
        ShioriButton(
          label: MaterialLocalizations.of(dialogContext).okButtonLabel,
          onPressed: () => Navigator.pop(dialogContext),
        ),
      ],
    ),
  );
}

/// One shortcut: what it does, then its keys.
class KeyboardShortcutRow extends StatelessWidget {
  const KeyboardShortcutRow({
    super.key,
    required this.label,
    required this.keys,
  });

  final String label;
  final List<String> keys;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s4),
      child: Row(
        spacing: ShioriSpace.s12,
        children: [
          Expanded(
            child: Text(
              label,
              style: tokens.text.row.copyWith(color: tokens.color.fg),
            ),
          ),
          Wrap(
            spacing: ShioriSpace.s4,
            children: [for (final key in keys) KeyCap(key)],
          ),
        ],
      ),
    );
  }
}

/// One key, drawn as a key cap.
class KeyCap extends StatelessWidget {
  const KeyCap(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Container(
      constraints: BoxConstraints(minWidth: tokens.scaled(28)),
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: tokens.color.ink2,
        borderRadius: BorderRadius.circular(ShioriShape.badge),
        border: Border(
          bottom: BorderSide(color: tokens.color.hairline, width: 2),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: tokens.text.meta.copyWith(
          color: tokens.color.fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
