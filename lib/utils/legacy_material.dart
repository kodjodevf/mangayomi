// The point of this file: the bridge and the old library it serves.
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart' as legacy;
import 'package:material_ui/material_ui.dart';

/// Lets the packages still built on Flutter's old built-in Material library
/// work under the app's material_ui widgets.
///
/// The two libraries have their own types, so a package such as bot_toast,
/// table_calendar or media_kit_video looked up a theme, strings and a
/// Material that weren't there. This hands them the app's theme and strings,
/// and a transparent Material for their buttons to sit on. Remove it once
/// those packages have moved to material_ui.
class LegacyMaterialBridge extends StatelessWidget {
  const LegacyMaterialBridge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialUiCompatibilityBridge(
      child: legacy.Material(
        type: legacy.MaterialType.transparency,
        child: child,
      ),
    );
  }
}
