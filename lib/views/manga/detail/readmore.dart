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
        Container(
            color: Theme.of(context).cardColor.withOpacity(0.15),
            width: mediaWidth(context, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                expanded
                    ? Row(
                        children: const [
                          Text(
                            "Show less",
                          ),
                          Icon(Icons.keyboard_arrow_up_sharp)
                        ],
                      )
                    : Row(
                        children: const [
                          Text(
                            "Show more",
                          ),
                          Icon(Icons.keyboard_arrow_down_sharp)
                        ],
                      ),
              ],
            ))
      ],
    );
  }
}
