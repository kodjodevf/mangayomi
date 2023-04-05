import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/views/browse/extension/extension.dart';
import 'package:mangayomi/views/browse/migrate.dart';
import 'package:mangayomi/views/browse/sources.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen>
    with TickerProviderStateMixin {
  late TabController _tabBarController;

  @override
  void initState() {
    _tabBarController = TabController(length: 3, vsync: this);
    _tabBarController.animateTo(0);
    _tabBarController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

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
            if (_tabBarController.index != 2)
              IconButton(
                  splashRadius: 20,
                  onPressed: () {},
                  icon: Icon(
                      _tabBarController.index == 0
                          ? Icons.travel_explore_rounded
                          : Icons.search_rounded,
                      color: Theme.of(context).hintColor)),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  if (_tabBarController.index == 0) {
                  } else if (_tabBarController.index == 1) {
                    context.push('/extensionLang');
                  } else {}
                },
                icon: Icon(
                    _tabBarController.index == 0
                        ? Icons.filter_list_sharp
                        : _tabBarController.index == 1
                            ? Icons.translate_rounded
                            : Icons.help_outline_outlined,
                    color: Theme.of(context).hintColor)),
          ],
          bottom: TabBar(
            controller: _tabBarController,
            isScrollable: true,
            tabs: const [
              Tab(text: "Sources"),
              Tab(text: "Extension"),
              Tab(text: "Migrate"),
            ],
          ),
        ),
        body: TabBarView(controller: _tabBarController, children:  [
          SourcesScreen(),
          ExtensionScreen(),
          MigrateScreen()
        ]),
      ),
    );
  }
}
