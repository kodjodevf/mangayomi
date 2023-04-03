import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/views/browse/extension.dart';
import 'package:mangayomi/views/browse/migrate.dart';
import 'package:mangayomi/views/browse/sources.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Browse',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          actions: [
            IconButton(
                splashRadius: 20,
                onPressed: () {},
                icon: Icon(Icons.travel_explore,
                    color: Theme.of(context).hintColor)),
            IconButton(
                splashRadius: 20,
                onPressed: () {},
                icon: Icon(Icons.filter_list_sharp,
                    color: Theme.of(context).hintColor)),
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).hintColor,
            isScrollable: true,
            tabs: const [
              Tab(text: "Sources"),
              Tab(text: "Extension"),
              Tab(text: "Migrate"),
            ],
          ),
        ),
        body: const TabBarView(
            children: [SourcesScreen(), ExtensionScreen(), MigrateScreen()]),
      ),
    );
  }
}
