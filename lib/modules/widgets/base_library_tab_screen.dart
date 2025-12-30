import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

abstract class BaseLibraryTabScreenState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T>
    with TickerProviderStateMixin {
  final textEditingController = TextEditingController();
  late TabController tabController;
  late List<ItemType> visibleTabTypes;
  late final List<String> hideItems;
  bool isSearch = false;

  /// Screen-specific title
  String get title;

  /// Build the content of each tab
  Widget buildTab(ItemType type);

  /// Optional extra actions (refresh, delete, etc.)
  List<Widget> buildExtraActions(BuildContext context) => [];

  /// Optional custom Tab widget (Updates needs this)
  Widget buildTabLabel(ItemType type, String label) {
    return Tab(text: label);
  }

  @override
  void initState() {
    super.initState();
    hideItems = ref.read(hideItemsStateProvider);

    visibleTabTypes = hiddenItemTypes(hideItems);

    tabController = TabController(length: visibleTabTypes.length, vsync: this);

    tabController.addListener(() {
      setState(() {
        textEditingController.clear();
        isSearch = false;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  ItemType getCurrentItemType() => visibleTabTypes[tabController.index];

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: isSearch
            ? null
            : Text(title, style: TextStyle(color: Theme.of(context).hintColor)),
        actions: [
          isSearch
              ? SeachFormTextField(
                  controller: textEditingController,
                  onChanged: (_) => setState(() {}),
                  onSuffixPressed: () {
                    textEditingController.clear();
                    setState(() {});
                  },
                  onPressed: () {
                    setState(() => isSearch = false);
                    textEditingController.clear();
                  },
                )
              : IconButton(
                  splashRadius: 20,
                  onPressed: () => setState(() => isSearch = true),
                  icon: Icon(Icons.search, color: Theme.of(context).hintColor),
                ),
          ...buildExtraActions(context),
        ],
        bottom: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: visibleTabTypes.map((type) {
            return buildTabLabel(type, type.localized(l10n));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: visibleTabTypes.map(buildTab).toList(),
      ),
    );
  }
}
