import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          l10n!.updates,
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {},
              icon: Icon(Icons.refresh, color: Theme.of(context).hintColor)),
        ],
      ),
      body: Center(
        child: Text(l10n.no_recent_updates),
      ),
    );
  }
}
