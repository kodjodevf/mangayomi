import 'package:flutter/material.dart';

class MigrateScreen extends StatefulWidget {
  const MigrateScreen({super.key});

  @override
  State<MigrateScreen> createState() => _MigrateScreenState();
}

class _MigrateScreenState extends State<MigrateScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Migrate'),
    );
  }
}
