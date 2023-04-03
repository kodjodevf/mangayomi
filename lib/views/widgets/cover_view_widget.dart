import 'package:flutter/material.dart';
class CoverViewWidget extends StatelessWidget {
  final List<Widget> children;
  const CoverViewWidget({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: children,
        ),
      ),
    );
  }
}
