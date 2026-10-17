import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/categories/widgets/custom_textfield.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
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
        body: ShioriEmptyState(
          icon: Symbols.label_rounded,
          title: context.l10n.empty_placeholder,
          compact: true,
        ),
      );
    }
    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: _visibleTabTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.data.$1 ? l10n.edit_categories : l10n.categories),
          bottom: TabBar(
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
            return ShioriEmptyState(
              icon: Symbols.label_rounded,
              title: l10n.edit_categories_description,
              actionLabel: l10n.add_category,
              onAction: _addCategory,
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
          return ErrorState(detail: error.toString());
        },
        loading: () {
          return const ShioriLoading();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCategory,
        icon: const Icon(Symbols.add_rounded),
        label: Text(l10n.add),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Category category,
    int index,
  ) {
    final l10n = context.l10n;
    final hidden = category.hide ?? false;
    final updates = category.shouldUpdate ?? true;
    return ShioriListRow(
      key: Key('category_${category.id}'),
      leading: ReorderableDragStartListener(
        index: index,
        child: const Icon(Symbols.drag_handle_rounded),
      ),
      title: category.name!,
      subtitle: updates ? null : l10n.skip_updates,
      // A hidden category stays here, faded, so it can be shown again.
      dimmed: hidden,
      onTap: () => _renameCategory(category),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: hidden ? l10n.show_category : l10n.hide_category,
            onPressed: () async {
              category.hide = !hidden;
              await categoryRepository.save(category);
            },
            icon: Icon(
              hidden
                  ? Symbols.visibility_off_rounded
                  : Symbols.visibility_rounded,
            ),
          ),
          ShioriMenuButton(
            tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
            items: [
              ShioriMenuItem(
                label: l10n.rename,
                icon: Symbols.edit_rounded,
                onSelected: () => _renameCategory(category),
              ),
              ShioriMenuItem(
                label: l10n.skip_updates,
                checked: !updates,
                onSelected: () async {
                  category.shouldUpdate = !updates;
                  await categoryRepository.save(category);
                },
              ),
              null,
              ShioriMenuItem(
                label: l10n.delete,
                icon: Symbols.delete_rounded,
                destructive: true,
                onSelected: () async {
                  // Removing a category also takes every series out of it,
                  // which Undo could not put back: this one asks.
                  final confirmed = await showShioriConfirm(
                    context,
                    title: l10n.delete_category,
                    message: l10n.delete_category_msg(category.name!),
                    confirmLabel: l10n.delete,
                    cancelLabel: l10n.cancel,
                    destructive: true,
                  );
                  if (confirmed) await _removeCategory(category);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _removeCategory(Category category) async {
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
  }

  Future<void> _addCategory() async {
    final name = await promptCategoryName(
      context,
      title: context.l10n.add_category,
      confirmLabel: context.l10n.add,
      existing: _entries,
    );
    if (name == null) return;
    await categoryRepository.create(
      Category(
        forItemType: widget.itemType,
        name: name,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Future<void> _renameCategory(Category category) async {
    final name = await promptCategoryName(
      context,
      title: context.l10n.rename_category,
      confirmLabel: context.l10n.ok,
      existing: _entries,
      initial: category.name,
    );
    if (name == null) return;
    category.name = name;
    await categoryRepository.save(category);
  }
}
