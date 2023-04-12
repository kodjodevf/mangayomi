import 'package:flutter/material.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Updates',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: Icon(Icons.refresh, color: Theme.of(context).hintColor)),
        ],
      ),
      body: const Center(
        child: Text("No recent updates"),
      ),
    );
  }
}
