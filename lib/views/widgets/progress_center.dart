import 'package:flutter/material.dart';

class ProgressCenter extends StatelessWidget {
  const ProgressCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
