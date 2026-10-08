import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

/// Builds the mobile selection menu required by [CodeEditor].
///
/// Re-Editor owns the selection gestures, but intentionally leaves the menu UI
/// to its host app. Without a controller, selected code has no Cut, Copy, Paste,
/// or Select All actions on iOS and Android.
SelectionToolbarController createExtensionCodeSelectionToolbar() {
  return MobileSelectionToolbarController(
    builder:
        ({
          required context,
          required anchors,
          required controller,
          required onDismiss,
          required onRefresh,
        }) {
          final hasSelection = !controller.selection.isCollapsed;

          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: anchors,
            buttonItems: [
              if (hasSelection)
                ContextMenuButtonItem(
                  type: ContextMenuButtonType.cut,
                  onPressed: () {
                    controller.cut();
                    onDismiss();
                  },
                ),
              if (hasSelection)
                ContextMenuButtonItem(
                  type: ContextMenuButtonType.copy,
                  onPressed: () async {
                    await controller.copy();
                    onDismiss();
                  },
                ),
              ContextMenuButtonItem(
                type: ContextMenuButtonType.paste,
                onPressed: () {
                  controller.paste();
                  onDismiss();
                },
              ),
              if (!controller.isAllSelected)
                ContextMenuButtonItem(
                  type: ContextMenuButtonType.selectAll,
                  onPressed: () {
                    controller.selectAll();
                    onRefresh();
                  },
                ),
            ],
          );
        },
  );
}
