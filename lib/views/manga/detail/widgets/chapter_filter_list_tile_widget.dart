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
          ? SizedBox(
              height: 20, width: 20, child: Icon(Icons.check_box_outline_blank))
          : type == 1
              ? SizedBox(height: 20, width: 20, child: Icon(Icons.check_box))
              : Stack(
                  children: [
                    SizedBox(
                        height: 20,
                        width: 20,
                        child: Icon(Icons.check_box_outline_blank)),
                    Positioned(
                      top: 3,
                      left: 2,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(2)),
                        height: 18,
                        width: 17,
                        child: Icon(
                          Icons.clear,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
      title: Text(
        label,
        style: TextStyle(fontSize: 14),
      ),
      onTap: onTap,
    );
  }
}
