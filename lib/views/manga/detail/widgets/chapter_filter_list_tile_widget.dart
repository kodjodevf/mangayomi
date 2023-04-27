import 'package:flutter/material.dart';

class ListTileChapterFilter extends StatelessWidget {
  final String label;
  final int type;
  final VoidCallback onTap;
  const ListTileChapterFilter(
      {super.key,
      required this.label,
      required this.type,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      iconColor: Theme.of(context).primaryColor,
      dense: true,
      leading: type == 0
          ? const SizedBox(
              height: 20, width: 20, child: Icon(Icons.check_box_outline_blank))
          : type == 1
              ? const SizedBox(
                  height: 20, width: 20, child: Icon(Icons.check_box))
              : const SizedBox(
                  height: 20,
                  width: 20,
                  child: Icon(Icons.indeterminate_check_box_rounded)),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
      onTap: onTap,
    );
  }
}
