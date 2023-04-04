import 'package:flutter/material.dart';

class SeachWi extends StatefulWidget {
  const SeachWi({super.key});

  @override
  State<SeachWi> createState() => _SeachWiState();
}

class _SeachWiState extends State<SeachWi> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: AppBar(
          title: Row(
            children: [],
          ),
        ),
        preferredSize: Size.fromHeight(AppBar().preferredSize.height));
  }
}
