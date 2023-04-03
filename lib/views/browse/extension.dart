import 'package:flutter/material.dart';

class ExtensionScreen extends StatefulWidget {
  const ExtensionScreen({super.key});

  @override
  State<ExtensionScreen> createState() => _ExtensionScreenState();
}

class _ExtensionScreenState extends State<ExtensionScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {},
          leading: Container(
            height: 37,
            width: 37,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(5)),
          ),
          subtitle: const Text('English'),
          title: const Text('MangaHere'),
          trailing: TextButton(onPressed: () {}, child: Text("Update")),
        )
      ],
    );
  }
}
