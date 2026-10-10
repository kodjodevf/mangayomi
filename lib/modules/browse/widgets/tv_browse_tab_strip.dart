import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';

/// A TV tab row that stays centered when it fits and scrolls when it does not.
///
/// [TvPill] reveals itself when focused, so remote traversal can reach every
/// tab even when translations or the available viewport make the row wider
/// than the screen.
class TvBrowseTabStrip extends StatelessWidget {
  const TvBrowseTabStrip({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < labels.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    TvPill(
                      key: ValueKey('tv-browse-tab-$i'),
                      label: labels[i],
                      selected: i == selectedIndex,
                      onTap: () => onSelected(i),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
