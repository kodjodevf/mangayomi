import 'package:flutter/material.dart';

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({super.key});

  @override
  State<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
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
          trailing: SizedBox(
              width: 110,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text(
                    "Latest",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.push_pin_outlined,
                    color: Colors.black,
                  )
                ],
              )),
        )
      ],
    );
  }
}
