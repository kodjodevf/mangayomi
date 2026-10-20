import 'package:flutter/material.dart';

import '../alphas.dart';
import '../tokens.dart';

/// Opens a sheet from the bottom of the screen, in Shiori's shape.
///
/// The sheet sizes to its content up to [maxHeightFactor] of the screen and
/// scrolls past that. [title] adds a header row under the handle.
Future<T?> showShioriSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  double maxHeightFactor = 0.9,
  bool useRootNavigator = true,
}) {
  final tokens = context.shiori;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: useRootNavigator,
    useSafeArea: true,
    backgroundColor: tokens.color.ink1,
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(ShioriShape.sheet),
      ),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * maxHeightFactor,
    ),
    builder: (sheetContext) =>
        ShioriSheet(title: title, child: builder(sheetContext)),
  );
}

/// The inside of a sheet: the handle, an optional title, and the content.
///
/// [showShioriSheet] wraps its builder in this; use it directly only when a
/// sheet is opened some other way.
class ShioriSheet extends StatelessWidget {
  const ShioriSheet({super.key, this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: ShioriSpace.s8),
            child: Container(
              width: 36,
              height: ShioriSpace.s4,
              decoration: BoxDecoration(
                color: tokens.color.fg.withValues(alpha: Alphas.hairline * 2),
                borderRadius: BorderRadius.circular(ShioriShape.pill),
              ),
            ),
          ),
        ),
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              ShioriSpace.s16,
              ShioriSpace.s16,
              ShioriSpace.s16,
              ShioriSpace.s8,
            ),
            child: Semantics(
              header: true,
              child: Text(
                title!,
                style: tokens.text.section.copyWith(color: tokens.color.fg),
              ),
            ),
          ),
        Flexible(child: child),
      ],
    );
  }
}
