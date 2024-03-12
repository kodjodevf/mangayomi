import 'package:flutter/material.dart';

class MeasureWidgetSizeSync extends StatefulWidget {
  final Function(Size? size) onCalculateSize;
  final Widget child;

  const MeasureWidgetSizeSync(
      {super.key, required this.onCalculateSize, required this.child});

  @override
  State<MeasureWidgetSizeSync> createState() => _MeasureWidgetSizeSyncState();
}

class _MeasureWidgetSizeSyncState extends State<MeasureWidgetSizeSync> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.onCalculateSize(_key.currentContext?.size));
    }
    return Container(key: _key, child: widget.child);
  }
}
