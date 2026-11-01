import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/browse/extension/widgets/foreign_updates_dialog.dart';
import 'package:mangayomi/services/extension_update.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_list_tile_widget.dart';
import 'package:mangayomi/modules/browse/widgets/extension_server_warning_banner.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class ExtensionScreen extends ConsumerStatefulWidget {
  final ItemType itemType;
  final String query;
  const ExtensionScreen({
    required this.query,
    required this.itemType,
    super.key,
  });

  @override
  ConsumerState<ExtensionScreen> createState() => _ExtensionScreenState();
}

class _ExtensionScreenState extends ConsumerState<ExtensionScreen> {
  final ScrollController controller = ScrollController();
  bool isUpdating = false;
  Future<void> _refreshSources() {
    return ref.refresh(
      fetchItemSourcesListProvider(
        id: null,
        reFresh: true,
        itemType: widget.itemType,
      ).future,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _updateSource(Source source) {
    final provider = fetchItemSourcesListProvider(
      id: source.id,
      reFresh: true,
      itemType: source.itemType,
    );
    ref.invalidate(provider);
    return ref.read(provider.future);
  }

  /// Updates [entries], asking first, once for all of them, about those
  /// whose update comes from another repository. One that fails doesn't stop
  /// the others, and says so.
  Future<void> _updateAll(
    List<Source> entries,
    void Function(VoidCallback) setRowState,
  ) async {
    final foreign = entries.where(isForeignUpdate).toList();
    var toUpdate = entries;
    if (foreign.isNotEmpty) {
      final choice = await showForeignUpdatesDialog(
        context,
        foreign: foreign,
        hasOthers: foreign.length < entries.length,
      );
      if (choice == null || !mounted) return;
      if (choice == ForeignUpdatesChoice.skipThem) {
        toUpdate = entries.where((s) => !isForeignUpdate(s)).toList();
      }
    }
    setRowState(() => isUpdating = true);
    try {
      for (final source in toUpdate) {
        try {
          await _updateSource(source);
        } catch (e, stack) {
          toastError(e, stack: stack, source: 'extension update all');
        }
      }
    } finally {
      if (mounted) setRowState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.read(
      fetchItemSourcesListProvider(
        id: null,
        reFresh: false,
        itemType: widget.itemType,
      ),
    );

    final streamExtensions = ref.watch(
      getExtensionsStreamProvider(widget.itemType),
    );
    final repositories = ref.watch(
      extensionsRepoStateProvider(widget.itemType),
    );
    final showNSFW = ref.watch(showNSFWStateProvider);

    final l10n = l10nLocalizations(context)!;
    final tvHorizontalInset = tvHorizontalSafeInset(context);

    return RefreshIndicator(
      onRefresh: _refreshSources,
      child: Padding(
        // Match the sources tab's inset so the two Browse tabs line up on TV.
        padding: EdgeInsets.only(
          top: ShioriSpace.s12,
          left: tvHorizontalInset,
          right: tvHorizontalInset,
        ),
        child: streamExtensions.when(
          data: (data) {
            final filteredData = widget.query.isEmpty
                ? data
                : data
                      .where(
                        (element) =>
                            element.name?.toLowerCase().contains(
                              widget.query.toLowerCase(),
                            ) ??
                            false,
                      )
                      .toList();

            final updateEntries = <Source>[];
            final installedEntries = <Source>[];
            final notInstalledEntries = <Source>[];
            var showWarning = false;

            for (var element in filteredData) {
              if (repositories
                      .firstWhereOrNull((e) => e == element.repo)
                      ?.hidden ??
                  false) {
                continue;
              }
              if (!showNSFW && (element.isNsfw ?? false)) {
                continue;
              }
              if (element.sourceCodeLanguage == SourceCodeLanguage.mihon) {
                showWarning = true;
              }
              final isInstalled = element.isAdded ?? false;
              final hasUpdate =
                  isInstalled &&
                  !(element.isObsolete ?? false) &&
                  compareVersions(
                        element.version ?? '',
                        element.versionLast ?? '',
                      ) <
                      0;

              if (hasUpdate) {
                updateEntries.add(element);
              } else if (isInstalled) {
                installedEntries.add(element);
              } else {
                notInstalledEntries.add(element);
              }
            }

            return Scrollbar(
              interactive: true,
              controller: controller,
              thickness: 12,
              radius: const Radius.circular(ShioriShape.card),
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  if (showWarning)
                    const SliverToBoxAdapter(
                      child: ExtensionServerWarningBanner(),
                    ),
                  if (updateEntries.isNotEmpty)
                    _buildUpdateSection(updateEntries, l10n),
                  if (installedEntries.isNotEmpty)
                    _buildInstalledSection(installedEntries, l10n),
                  if (notInstalledEntries.isNotEmpty)
                    _buildNotInstalledSection(notInstalledEntries),
                  // Trailing room rather than padding around the viewport, so
                  // rows scroll under the translucent bar (which is what gives
                  // it something to blur) and only the last one clears it.
                  SliverToBoxAdapter(
                    child: SizedBox(height: pageBottomInsets(context).bottom),
                  ),
                ],
              ),
            );
          },
          error: (error, _) => ShioriEmptyState(
            icon: Symbols.cloud_off_rounded,
            title: '$error',
            compact: true,
            actionLabel: context.l10n.refresh,
            onAction: _refreshSources,
          ),
          loading: () => ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [for (var i = 0; i < 8; i++) const ShioriSkeletonRow()],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateSection(List<Source> updateEntries, dynamic l10n) {
    return CustomSliverGroupedListView<Source, String>(
      elements: updateEntries,
      groupBy: (_) => "",
      groupSeparatorBuilder: (_) => StatefulBuilder(
        builder: (context, setState) {
          // The group's label as the other groups', with Update all as its
          // action, as Download all heads a day of updates: a full button
          // stood taller than the label and pushed into the row above.
          return ShioriSectionHeader(
            overline: true,
            title: l10n.update_pending,
            padding: const EdgeInsets.fromLTRB(
              ShioriSpace.s16,
              ShioriSpace.s16,
              ShioriSpace.s8,
              ShioriSpace.s4,
            ),
            actionLabel: l10n.update_all,
            actionBusy: isUpdating,
            onAction: () => _updateAll(updateEntries, setState),
          );
        },
      ),
      itemBuilder: (context, Source element) =>
          ExtensionListTileWidget(key: ValueKey(element.id), source: element),
      groupComparator: (group1, group2) => group1.compareTo(group2),
      itemComparator: (item1, item2) =>
          item1.name?.compareTo(item2.name ?? '') ?? 0,
      order: GroupedListOrder.ASC,
    );
  }

  Widget _buildInstalledSection(List<Source> installedEntries, dynamic l10n) {
    return CustomSliverGroupedListView<Source, String>(
      elements: installedEntries,
      groupBy: (_) => "",
      groupSeparatorBuilder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(
          ShioriSpace.s16,
          ShioriSpace.s16,
          ShioriSpace.s16,
          ShioriSpace.s4,
        ),
        child: ShioriGroupLabel(l10n.installed),
      ),
      itemBuilder: (context, Source element) =>
          ExtensionListTileWidget(key: ValueKey(element.id), source: element),
      groupComparator: (group1, group2) => group1.compareTo(group2),
      itemComparator: (item1, item2) =>
          item1.name?.compareTo(item2.name ?? '') ?? 0,
      order: GroupedListOrder.ASC,
    );
  }

  Widget _buildNotInstalledSection(List<Source> notInstalledEntries) {
    return CustomSliverGroupedListView<Source, String>(
      elements: notInstalledEntries,
      groupBy: (element) =>
          languageName(context, element.lang?.toLowerCase() ?? ''),
      groupSeparatorBuilder: (String groupByValue) => Padding(
        padding: const EdgeInsets.fromLTRB(
          ShioriSpace.s16,
          ShioriSpace.s16,
          ShioriSpace.s16,
          ShioriSpace.s4,
        ),
        child: ShioriGroupLabel(groupByValue),
      ),
      itemBuilder: (context, Source element) =>
          ExtensionListTileWidget(key: ValueKey(element.id), source: element),
      groupComparator: (group1, group2) => group1.compareTo(group2),
      itemComparator: (item1, item2) =>
          item1.name?.compareTo(item2.name ?? '') ?? 0,
      order: GroupedListOrder.ASC,
    );
  }
}
