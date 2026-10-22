import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

/// A genre chip that exposes the same search menu in every detail layout.
class DetailGenreChip extends StatelessWidget {
  const DetailGenreChip({
    super.key,
    required this.label,
    required this.libraryLabel,
    required this.sourceLabel,
    required this.onSelected,
  });

  final String label;
  final String libraryLabel;
  final String sourceLabel;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        end: ShioriSpace.s4,
        bottom: ShioriSpace.s4,
      ),
      child: SizedBox(
        height: 32,
        child: MenuAnchor(
          style: shioriMenuStyle(context),
          menuChildren: [
            ShioriMenuEntry(
              ShioriMenuItem(
                label: libraryLabel,
                icon: Symbols.collections_bookmark_rounded,
                onSelected: () => onSelected(0),
              ),
            ),
            ShioriMenuEntry(
              ShioriMenuItem(
                label: sourceLabel,
                icon: Symbols.travel_explore_rounded,
                onSelected: () => onSelected(1),
              ),
            ),
          ],
          builder: (context, controller, _) => Material(
            color: context.shiori.color.ink2,
            shape: StadiumBorder(
              side: BorderSide(color: context.shiori.color.hairline),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ShioriSpace.s12,
                ),
                child: Align(
                  widthFactor: 1,
                  child: Text(
                    label,
                    style: context.shiori.text.meta.copyWith(
                      color: context.shiori.color.fg,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
