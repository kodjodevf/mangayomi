import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MigrateScreen extends StatefulWidget {
  const MigrateScreen({super.key});

  @override
  State<MigrateScreen> createState() => _MigrateScreenState();
}

class _MigrateScreenState extends State<MigrateScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Center(
      child: Text(l10n.migrate),
    );
  }
}
