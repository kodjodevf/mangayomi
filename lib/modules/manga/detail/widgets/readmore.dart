import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/manga/detail/widgets/expandable_text.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class ReadMoreWidget extends StatefulWidget {
  const ReadMoreWidget({
    super.key,
    required this.text,
    required this.onChanged,
    this.initExpanded = false,
  });
  final Function(bool) onChanged;
  final String text;
  final bool initExpanded;

  @override
  ReadMoreWidgetState createState() => ReadMoreWidgetState();
}

class ReadMoreWidgetState extends State<ReadMoreWidget>
    with TickerProviderStateMixin {
  late bool expanded = widget.initExpanded;
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return widget.text.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(l10n.no_description)],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s8),
            child: ExpandableText(
              widget.text.trim(),
              expandText: '',
              maxLines: 3,
              expanded: expanded,
              linkColor: Colors.transparent,
              animation: true,
              animationDuration: ShioriMotion.exitSlow,
              expandOnTextTap: true,
              collapseOnTextTap: true,
              prefixText: '',
              showGradientOverlay: false,
              showExpandCollapseIcon: true,
              expandIcon: Symbols.keyboard_arrow_down_rounded,
              collapseIcon: Symbols.keyboard_arrow_up_rounded,
              onExpandedChanged: (value) {
                setState(() => expanded = value);
                widget.onChanged(value);
              },
            ),
          );
  }
}
