import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/utils/media_query.dart';

class ReadMoreWidget extends StatefulWidget {
  const ReadMoreWidget({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  ReadMoreWidgetState createState() => ReadMoreWidgetState();
}

class ReadMoreWidgetState extends State<ReadMoreWidget>
    with TickerProviderStateMixin {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ExpandableText(
              animationDuration: const Duration(milliseconds: 500),
              onExpandedChanged: (ok) {
                setState(() => expanded = ok);
              },
              expandOnTextTap: true,
              widget.text,
              expandText: '',
              maxLines: 3,
              expanded: false,
              onPrefixTap: () {
                setState(() => expanded = !expanded);
              },
              linkColor: Theme.of(context).scaffoldBackgroundColor,
              animation: true,
              collapseOnTextTap: true,
              prefixText: '',
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: expanded
                    ? const Icon(Icons.keyboard_arrow_up_sharp)
                    : const Icon(Icons.keyboard_arrow_down_sharp))
          ],
        ),
        Container(
          color: Theme.of(context).cardColor.withOpacity(0.15),
          width: mediaWidth(context, 1),
        )
      ],
    );
  }
}
