import 'package:flutter/material.dart';

class ListTileChapterSort extends StatelessWidget {
  final String label;
  final bool reverse;
  final VoidCallback onTap;
  const ListTileChapterSort(
      {super.key,
      required this.label,
      required this.reverse,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: Theme.of(context).primaryColor,
      dense: true,
      leading: Icon(
          reverse ? Icons.arrow_downward_sharp : Icons.arrow_upward_sharp,
          color: Theme.of(context).hintColor),
      title: Text(
        label,
        style: TextStyle(fontSize: 14),
      ),
      onTap: onTap,
    );
  }
}
