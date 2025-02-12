import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/categories/widgets/custom_textfield.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  final (bool, int) data;
  const CategoriesScreen({required this.data, super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with TickerProviderStateMixin {
  late TabController _tabBarController;
  int tabs = 3;
  @override
  void initState() {
    _tabBarController = TabController(length: tabs, vsync: this);
    _tabBarController.animateTo(widget.data.$2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int newTabs = 0;
    final hideItems = ref.watch(hideItemsStateProvider);
    if (!hideItems.contains("/MangaLibrary")) newTabs++;
    if (!hideItems.contains("/AnimeLibrary")) newTabs++;
    if (!hideItems.contains("/NovelLibrary")) newTabs++;
    if (tabs != newTabs) {
      _tabBarController.dispose();
      _tabBarController = TabController(length: newTabs, vsync: this);
      _tabBarController.animateTo(0);
      setState(() {
        tabs = newTabs;
      });
    }
    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: newTabs,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.data.$1 ? l10n.edit_categories : l10n.categories,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabBarController,
            tabs: [
              if (!hideItems.contains("/MangaLibrary")) Tab(text: l10n.manga),
              if (!hideItems.contains("/AnimeLibrary")) Tab(text: l10n.anime),
              if (!hideItems.contains("/NovelLibrary")) Tab(text: l10n.novel),
            ],
          ),
        ),
        body: TabBarView(controller: _tabBarController, children: [
          if (!hideItems.contains("/MangaLibrary"))
            CategoriesTab(
              itemType: ItemType.manga,
            ),
          if (!hideItems.contains("/AnimeLibrary"))
            CategoriesTab(
              itemType: ItemType.anime,
            ),
          if (!hideItems.contains("/NovelLibrary"))
            CategoriesTab(
              itemType: ItemType.novel,
            )
        ]),
      ),
    );
  }
}

class CategoriesTab extends ConsumerStatefulWidget {
  final ItemType itemType;
  const CategoriesTab({required this.itemType, super.key});

  @override
  ConsumerState<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends ConsumerState<CategoriesTab> {
  List<Category> _entries = [];
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final categories =
        ref.watch(getMangaCategorieStreamProvider(itemType: widget.itemType));
    return Scaffold(
      body: categories.when(
        data: (data) {
          if (data.isEmpty) {
            _entries = [];
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l10n.edit_categories_description,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          _entries = data;
          return ListView.builder(
            itemCount: _entries.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Card(
                  child: Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)))),
                          onPressed: () {
                            _renameCategory(_entries[index]);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Icon(Icons.label_outline_rounded),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text(_entries[index].name!))
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(Icons.arrow_drop_up_outlined),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_drop_down_outlined)
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _renameCategory(_entries[index]);
                                  },
                                  icon: const Icon(
                                      Icons.mode_edit_outline_outlined)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return AlertDialog(
                                                title: Text(
                                                  l10n.delete_category,
                                                ),
                                                content: Text(
                                                    l10n.delete_category_msg(
                                                        _entries[index].name!)),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              l10n.cancel)),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      TextButton(
                                                          onPressed: () async {
                                                            await isar.writeTxn(
                                                                () async {
                                                              await isar
                                                                  .categorys
                                                                  .delete(_entries[
                                                                          index]
                                                                      .id!);
                                                            });
                                                            await ref
                                                                .read(synchingProvider(
                                                                        syncId:
                                                                            1)
                                                                    .notifier)
                                                                .addChangedPartAsync(
                                                                    ActionType
                                                                        .removeCategory,
                                                                    _entries[
                                                                            index]
                                                                        .id,
                                                                    "{}",
                                                                    true);
                                                            if (context
                                                                .mounted) {
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Text(
                                                            l10n.ok,
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete_outlined))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (Object error, StackTrace stackTrace) {
          _entries = [];
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.edit_categories_description,
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        loading: () {
          return const ProgressCenter();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            bool isExist = false;
            final controller = TextEditingController();
            showDialog(
                context: context,
                builder: (context) {
                  return SizedBox(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text(l10n.add_category),
                          content: CustomTextFormField(
                              controller: controller,
                              entries: _entries,
                              context: context,
                              exist: (value) {
                                setState(() {
                                  isExist = value;
                                });
                              },
                              isExist: isExist,
                              val: (val) {}),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(l10n.cancel)),
                                const SizedBox(
                                  width: 15,
                                ),
                                TextButton(
                                    onPressed: controller.text.isEmpty ||
                                            isExist
                                        ? null
                                        : () async {
                                            final category = Category(
                                              forItemType: widget.itemType,
                                              name: controller.text,
                                            );
                                            await isar.writeTxn(() async {
                                              await isar.categorys
                                                  .put(category);
                                            });
                                            await ref
                                                .read(
                                                    synchingProvider(syncId: 1)
                                                        .notifier)
                                                .addChangedPartAsync(
                                                    ActionType.addCategory,
                                                    category.id,
                                                    category.toJson(),
                                                    true);
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                    child: Text(
                                      l10n.add,
                                      style: TextStyle(
                                          color:
                                              controller.text.isEmpty || isExist
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                      .withValues(alpha: 0.2)
                                                  : null),
                                    )),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  );
                });
          },
          label: Row(
            children: [
              const Icon(Icons.add),
              const SizedBox(
                width: 10,
              ),
              Text(l10n.add)
            ],
          )),
    );
  }

  _renameCategory(Category category) {
    bool isExist = false;
    final controller = TextEditingController(text: category.name);
    bool isSameName = controller.text == category.name;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              final l10n = l10nLocalizations(context);
              return AlertDialog(
                title: Text(
                  l10n!.rename_category,
                ),
                content: CustomTextFormField(
                    controller: controller,
                    entries: _entries,
                    context: context,
                    exist: (value) {
                      setState(() {
                        isExist = value;
                      });
                    },
                    isExist: isExist,
                    name: category.name!,
                    val: (val) {
                      setState(() {
                        isSameName = controller.text == category.name;
                      });
                    }),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(l10n.cancel)),
                      const SizedBox(
                        width: 15,
                      ),
                      TextButton(
                          onPressed: controller.text.isEmpty ||
                                  isExist ||
                                  isSameName
                              ? null
                              : () async {
                                  await isar.writeTxn(() async {
                                    category.name = controller.text;
                                    await isar.categorys.put(category);
                                  });
                                  await ref
                                      .read(
                                          synchingProvider(syncId: 1).notifier)
                                      .addChangedPartAsync(
                                          ActionType.renameCategory,
                                          category.id,
                                          category.toJson(),
                                          true);
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                          child: Text(
                            l10n.ok,
                            style: TextStyle(
                                color: controller.text.isEmpty ||
                                        isExist ||
                                        isSameName
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withValues(alpha: 0.2)
                                    : null),
                          )),
                    ],
                  )
                ],
              );
            },
          );
        });
  }
}
