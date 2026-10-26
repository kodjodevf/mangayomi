import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_group_switcher.dart';
import 'package:mangayomi/modules/widgets/collapsing_header.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

abstract class BaseLibraryTabScreenState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T>
    with TickerProviderStateMixin {
  final textEditingController = TextEditingController();
  late TabController tabController;
  late List<ItemType> visibleTabTypes;
  late final List<ProviderSubscription<Object?>> _visibilitySubscriptions;
  bool isSearch = false;

  /// Whether the content has scrolled the group's switcher out of sight, in
  /// which case the title names this screen rather than the group.
  final ValueNotifier<bool> headerCollapsed = ValueNotifier(false);

  /// Screen-specific title
  String get title;

  /// This screen's navigation route, when it can be one member of a grouped
  /// destination (Updates and History in Activity). Null otherwise.
  String? get navRoute => null;

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
    visibleTabTypes = _computeVisibleTabTypes();
    tabController = _newTabController(0);

    // Settings can change while this screen stays mounted (a type hidden in
    // More > Navigation), so the tabs follow them.
    _visibilitySubscriptions = [
      ref.listenManual(
        hideItemsStateProvider,
        (_, _) => _applyVisibleTabTypes(),
      ),
      ref.listenManual(
        animeOnlyTvModeProvider,
        (_, _) => _applyVisibleTabTypes(),
      ),
    ];
  }

  List<ItemType> _computeVisibleTabTypes() {
    final types = hiddenItemTypes(ref.read(hideItemsStateProvider));

    // Anime-only layout: only the anime tab (hides manga/novel in History,
    // Updates, and any other screen built on this base).
    if (ref.read(animeOnlyTvModeProvider)) {
      return types.where((t) => t == ItemType.anime).toList();
    }
    return types;
  }

  TabController _newTabController(int initialIndex) {
    final controller = TabController(
      length: visibleTabTypes.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    controller.addListener(_onTabControllerChanged);
    return controller;
  }

  void _onTabControllerChanged() {
    // Another tab's list starts at its top: the header comes back.
    headerCollapsed.value = false;
    onTabChanged(visibleTabTypes[tabController.index]);
    setState(() {
      textEditingController.clear();
      isSearch = false;
    });
  }

  /// Rebuilds the tabs when the visible types change, keeping the current
  /// tab if it is still visible.
  void _applyVisibleTabTypes() {
    final types = _computeVisibleTabTypes();
    if (listEquals(types, visibleTabTypes)) return;

    final selected = visibleTabTypes.isEmpty
        ? null
        : visibleTabTypes[tabController.index];
    final previous = tabController;
    final kept = selected == null ? -1 : types.indexOf(selected);
    setState(() {
      visibleTabTypes = types;
      tabController = _newTabController(kept < 0 ? 0 : kept);
    });
    previous.removeListener(_onTabControllerChanged);
    previous.dispose();
  }

  /// Called whenever the active tab type changes.
  void onTabChanged(ItemType type) {}

  @override
  void dispose() {
    for (final subscription in _visibilitySubscriptions) {
      subscription.close();
    }
    tabController.removeListener(_onTabControllerChanged);
    tabController.dispose();
    textEditingController.dispose();
    headerCollapsed.dispose();
    super.dispose();
  }

  ItemType getCurrentItemType() => visibleTabTypes[tabController.index];

  /// Accent focus tint for a top-bar action icon on Android TV so the focused
  /// icon is clearly visible on a remote; `null` (default) off-TV. Subclasses
  /// use this for the icons they add in [buildExtraActions].
  Color? tvIconFocusColor(BuildContext context) => isTv
      ? context.shiori.color.accent.withValues(alpha: Alphas.tvFocus)
      : null;

  /// The tab switcher below the title: TV-home style pills on Android TV, the
  /// classic underline [TabBar] elsewhere. On TV a single visible tab (e.g.
  /// anime-only mode) needs no switcher at all.
  PreferredSizeWidget? _buildTabSwitcher(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (isTv) {
      if (visibleTabTypes.length < 2) return null;
      return PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: AnimatedBuilder(
          animation: tabController,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < visibleTabTypes.length; i++) ...[
                    if (i > 0) const SizedBox(width: ShioriSpace.s8),
                    TvPill(
                      label: visibleTabTypes[i].localized(l10n),
                      selected: tabController.index == i,
                      onTap: () {
                        tabController.animateTo(i);
                        onTabChanged(visibleTabTypes[i]);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }
    return TabBar(
      controller: tabController,
      onTap: (i) => onTabChanged(visibleTabTypes[i]),
      tabs: visibleTabTypes.map((type) {
        return buildTabLabel(type, type.localized(l10n));
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = navRoute != null && isGroupedNavRoute(ref, navRoute!);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: isSearch
            ? null
            // A main destination's title, as Library, Browse and More set it.
            // Grouped, it names the group until the switcher scrolls away,
            // then this screen ("Activity", then "Updates").
            : ValueListenableBuilder<bool>(
                valueListenable: headerCollapsed,
                builder: (context, collapsed, _) => CollapsingTitle(
                  grouped && !collapsed
                      ? navGroupTitle(context, navRoute!)
                      : title,
                  style: context.shiori.text.screenTitle.copyWith(
                    color: context.shiori.color.fg,
                  ),
                ),
              ),
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
                  tooltip: MaterialLocalizations.of(context).searchFieldLabel,
                  splashRadius: 20,
                  focusColor: tvIconFocusColor(context),
                  onPressed: () => setState(() => isSearch = true),
                  icon: Icon(
                    Symbols.search_rounded,
                    fill: 1,
                    color: context.shiori.color.fgMuted,
                  ),
                ),
          ...buildExtraActions(context),
        ],
        // Grouped, the switcher and the tabs sit in the body instead, so
        // the switcher can fold away without resizing the app bar.
        bottom: grouped ? null : _buildTabSwitcher(context),
      ),
      body: grouped
          ? CollapseOnScroll(
              collapsed: headerCollapsed,
              child: Column(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: headerCollapsed,
                    builder: (context, collapsed, child) =>
                        CollapsibleHeaderPart(
                          collapsed: collapsed,
                          child: child!,
                        ),
                    child: NavGroupSwitcher(route: navRoute!),
                  ),
                  ?_buildTabSwitcher(context),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: visibleTabTypes.map(buildTab).toList(),
                    ),
                  ),
                ],
              ),
            )
          : TabBarView(
              controller: tabController,
              children: visibleTabTypes.map(buildTab).toList(),
            ),
    );
  }
}
