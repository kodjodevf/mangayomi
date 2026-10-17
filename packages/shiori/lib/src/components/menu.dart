import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../tokens.dart';

/// One entry in a [ShioriMenuButton].
class ShioriMenuItem {
  const ShioriMenuItem({
    required this.label,
    required this.onSelected,
    this.icon,
    this.checked,
    this.destructive = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onSelected;

  /// A leading `Symbols.*_rounded` glyph.
  final IconData? icon;

  /// For a menu of toggles or of one-of-several: a check when true, room
  /// for one when false, nothing when null.
  final bool? checked;

  /// For an action that deletes or discards: drawn in the error colour.
  final bool destructive;
  final bool enabled;
}

/// An overflow button that opens a menu of actions: "More", a sort order.
///
/// Built on [MenuAnchor], so the menu opens with the keyboard and the
/// D-pad, moves with the arrows and closes with Escape or Back.
class ShioriMenuButton extends StatelessWidget {
  const ShioriMenuButton({
    super.key,
    required this.items,
    required this.tooltip,
    this.icon = Symbols.more_vert_rounded,
  });

  /// A null entry draws a divider between groups.
  final List<ShioriMenuItem?> items;

  /// Names the button, which shows only an icon.
  final String tooltip;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final entries = _tidy(items);
    // Labels line up: once one entry has an icon, the others keep its room.
    final aligned = entries.any((item) => item?.icon != null);
    return MenuAnchor(
      style: shioriMenuStyle(context),
      menuChildren: [
        for (final item in entries)
          if (item == null)
            const Divider(height: ShioriSpace.s8)
          else
            ShioriMenuEntry(item, reserveIcon: aligned),
      ],
      builder: (context, controller, _) => IconButton(
        tooltip: tooltip,
        icon: Icon(icon),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}

/// [items] without the dividers that would separate nothing: at either
/// end, or next to another one. Groups built from conditions can be empty.
List<ShioriMenuItem?> _tidy(List<ShioriMenuItem?> items) {
  final out = <ShioriMenuItem?>[];
  for (final item in items) {
    if (item == null && (out.isEmpty || out.last == null)) continue;
    out.add(item);
  }
  if (out.isNotEmpty && out.last == null) out.removeLast();
  return out;
}

/// A [ShioriMenuItem] as a row of a [MenuAnchor], for a menu opened by
/// something other than [ShioriMenuButton].
class ShioriMenuEntry extends StatelessWidget {
  const ShioriMenuEntry(this.item, {super.key, this.reserveIcon = false});

  final ShioriMenuItem item;

  /// Keeps an icon's room before the label when [item] has none, so its
  /// label lines up with the entries that do.
  final bool reserveIcon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final error = Theme.of(context).colorScheme.error;
    final fg = item.destructive ? error : tokens.color.fg;
    return MenuItemButton(
      onPressed: item.enabled ? item.onSelected : null,
      leadingIcon: item.icon != null
          ? Icon(item.icon, color: item.destructive ? error : null)
          : reserveIcon
          ? const SizedBox(width: 24)
          : null,
      trailingIcon: item.checked == null
          ? null
          : SizedBox(
              width: ShioriSpace.s24,
              child: item.checked!
                  ? Icon(Symbols.check_rounded, color: tokens.color.accentInk)
                  : null,
            ),
      style: MenuItemButton.styleFrom(
        foregroundColor: fg,
        textStyle: tokens.text.row,
        minimumSize: Size(0, tokens.density.minTarget),
        padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
      ),
      child: Text(item.label),
    );
  }
}

/// The surface of a Shiori menu: the raised ink, the card corner.
MenuStyle shioriMenuStyle(BuildContext context) {
  final tokens = context.shiori;
  return MenuStyle(
    backgroundColor: WidgetStatePropertyAll(tokens.color.ink3),
    surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
    shape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ShioriShape.card)),
      ),
    ),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(vertical: ShioriSpace.s8),
    ),
  );
}
