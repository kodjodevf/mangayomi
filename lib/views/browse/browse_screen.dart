import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/views/browse/extension/extension_screen.dart';
import 'package:mangayomi/views/browse/migrate_screen.dart';
import 'package:mangayomi/views/browse/sources_screen.dart';
import 'package:mangayomi/views/library/search_text_form_field.dart';

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

  List<SourceModel> entries = [];
  List<SourceModel> entriesFilter = [];
  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
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
            _isSearch
                ? SeachFormTextField(
                    onChanged: (value) {
                      setState(() {
                        entriesFilter = entries
                            .where((element) => element.sourceName
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    onPressed: () {
                      setState(() {
                        _isSearch = false;
                      });
                      _textEditingController.clear();
                    },
                    controller: _textEditingController,
                  )
                : _tabBarController.index != 2
                    ? IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          if (_tabBarController.index == 1) {
                            setState(() {
                              _isSearch = true;
                            });
                          }
                        },
                        icon: Icon(
                            _tabBarController.index == 0
                                ? Icons.travel_explore_rounded
                                : Icons.search_rounded,
                            color: Theme.of(context).hintColor))
                    : Container(),
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
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabBarController,
            tabs: const [
              Tab(text: "Sources"),
              Tab(text: "Extension"),
              Tab(text: "Migrate"),
            ],
          ),
        ),
        body: TabBarView(controller: _tabBarController, children: [
          const SourcesScreen(),
          ExtensionScreen(
            entriesData: (val) {
              entries = val as List<SourceModel>;
            },
            entriesFilter: entriesFilter,
          ),
          const MigrateScreen()
        ]),
      ),
    );
  }
}
