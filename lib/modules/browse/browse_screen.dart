import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/browse/extension/extension_screen.dart';
import 'package:mangayomi/modules/browse/migrate_screen.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart';
import 'package:mangayomi/modules/library/search_text_form_field.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen>
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
        _isSearch = false;
      });
    });
    super.initState();
  }

  _chekPermission() async {
    await StorageProvider().requestPermission();
  }

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
                      setState(() {});
                    },
                    onSuffixPressed: () {
                      _textEditingController.clear();
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
                    context.push('/sourceFilter');
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
            query: _textEditingController.text,
          ),
          const MigrateScreen()
        ]),
      ),
    );
  }
}
