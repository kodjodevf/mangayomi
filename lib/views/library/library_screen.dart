import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Library',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: Icon(Icons.search, color: Theme.of(context).hintColor)),
          IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: Icon(Icons.filter_list_sharp,
                  color: Theme.of(context).hintColor)),
          PopupMenuButton(
              color: Theme.of(context).hintColor,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("1"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("2"),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("3"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                } else if (value == 1) {
                } else if (value == 2) {}
              }),
        ],
      ),
    );
  }
}
