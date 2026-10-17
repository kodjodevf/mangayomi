import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/categories/widgets/custom_textfield.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  final (bool, int) data;
  const CategoriesScreen({required this.data, super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with TickerProviderStateMixin {
  late TabController _tabBarController;
  late final List<ItemType> _visibleTabTypes;
  @override
  void initState() {
    super.initState();
    var types = hiddenItemTypes(ref.read(hideItemsStateProvider));
    // Anime-only layout: only manage anime categories.
    if (ref.read(animeOnlyTvModeProvider)) {
      types = types.where((t) => t == ItemType.anime).toList();
    }
    _visibleTabTypes = types;
    _tabBarController = TabController(
      length: _visibleTabTypes.length,
      vsync: this,
    );
    _tabBarController.animateTo(widget.data.$2);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleTabTypes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.categories)),
        body: Center(child: Text(context.l10n.empty_placeholder)),
      );
    }
    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: _visibleTabTypes.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.data.$1 ? l10n.edit_categories : l10n.categories,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabBarController,
            tabs: _visibleTabTypes.map((type) {
              return Tab(text: type.localized(l10n));
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabBarController,
          children: _visibleTabTypes.map((type) {
            return CategoriesTab(itemType: type);
          }).toList(),
        ),
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
    final categories = ref.watch(
      getMangaCategorieStreamProvider(itemType: widget.itemType),
    );
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
          final sortedData = [...data]
            ..sort((a, b) => (a.pos ?? 0).compareTo(b.pos ?? 0));
          _entries = sortedData;

          return ReorderableListView.builder(
            buildDefaultDragHandles: false,
            itemCount: _entries.length,
            padding: const EdgeInsets.only(bottom: 100),
            onReorderItem: (int oldIndex, int newIndex) async {
              final item = _entries.removeAt(oldIndex);
              _entries.insert(newIndex, item);
              final now = DateTime.now().millisecondsSinceEpoch;
              for (int i = 0; i < _entries.length; i++) {
                _entries[i].pos = i;
                _entries[i].updatedAt = now;
              }
              setState(() {});
              await categoryRepository.putAll(_entries);
            },
            itemBuilder: (context, index) {
              final category = _entries[index];
              return _buildCategoryCard(context, category, index);
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
                        val: (val) {},
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(l10n.cancel),
                            ),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed: controller.text.isEmpty || isExist
                                  ? null
                                  : () async {
                                      final category = Category(
                                        forItemType: widget.itemType,
                                        name: controller.text,
                                        updatedAt: DateTime.now()
                                            .millisecondsSinceEpoch,
                                      );
                                      await categoryRepository.create(category);

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    },
                              child: Text(
                                l10n.add,
                                style: TextStyle(
                                  color: controller.text.isEmpty || isExist
                                      ? Theme.of(context).primaryColor
                                            .withValues(alpha: 0.2)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
        label: Row(
          children: [
            const Icon(Icons.add),
            const SizedBox(width: 10),
            Text(l10n.add),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category,
    int index,
  ) {
    final l10n = l10nLocalizations(context)!;
    return Padding(
      key: Key('category_${category.id}'),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Icon(Icons.drag_handle),
              ),
            ),
            Expanded(
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
                          topLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _renameCategory(category);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(Icons.label_outline_rounded),
                        const SizedBox(width: 10),
                        Expanded(child: Text(category.name!)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          _renameCategory(category);
                        },
                        icon: const Icon(Icons.mode_edit_outline_outlined),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () async {
                          category.shouldUpdate =
                              !(category.shouldUpdate ?? true);
                          await categoryRepository.save(category);
                        },
                        icon: Icon(
                          category.shouldUpdate ?? true
                              ? Icons.update_outlined
                              : Icons.update_disabled_outlined,
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () async {
                          category.hide = !(category.hide ?? false);
                          await categoryRepository.save(category);
                        },
                        icon: Icon(
                          !(category.hide ?? false)
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text(l10n.delete_category),
                                    content: Text(
                                      l10n.delete_category_msg(category.name!),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(l10n.cancel),
                                          ),
                                          const SizedBox(width: 15),
                                          TextButton(
                                            onPressed: () async {
                                              await _removeCategory(
                                                category,
                                                context,
                                              );
                                            },
                                            child: Text(l10n.ok),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeCategory(Category category, BuildContext context) async {
    await categoryRepository.remove(category);

    await ref
        .read(synchingProvider(syncId: 1).notifier)
        .addChangedPartAsync(
          ActionType.removeCategory,
          category.id,
          "{}",
          true,
          clientId: category.clientId,
        );
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _renameCategory(Category category) {
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
              title: Text(l10n!.rename_category),
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
                },
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(l10n.cancel),
                    ),
                    const SizedBox(width: 15),
                    TextButton(
                      onPressed:
                          controller.text.isEmpty || isExist || isSameName
                          ? null
                          : () async {
                              category.name = controller.text;
                              await categoryRepository.save(category);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                      child: Text(
                        l10n.ok,
                        style: TextStyle(
                          color:
                              controller.text.isEmpty || isExist || isSameName
                              ? Theme.of(context).primaryColor
                                    .withValues(alpha: 0.2)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
