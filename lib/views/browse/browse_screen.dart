import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/models/source_model.dart';
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
      _chekPermission();
      setState(() {
        _textEditingController.clear();
        _entriesFilter = [];
        _isSearch = false;
      });
    });
    super.initState();
  }

  _chekPermission() async {
    await StorageProvider().requestPermission();
  }

  List<SourceModel> _entries = [];
  List<SourceModel> _entriesFilter = [];
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
                        _entriesFilter = _entries
                            .where((element) => element.sourceName
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                    onSuffixPressed: () {
                      _textEditingController.clear();
                    },
                    onPressed: () {
                      setState(() {
                        _isSearch = false;
                      });
                      _textEditingController.clear();
                      _entriesFilter = _entries;
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
                          } else if (_tabBarController.index == 0) {
                            context.push(
                              '/globalSearch',
                            );
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
                    _textEditingController.clear();
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
              _entries = val as List<SourceModel>;
            },
            entriesFilter: _entriesFilter,
          ),
          const MigrateScreen()
        ]),
      ),
    );
  }
}
