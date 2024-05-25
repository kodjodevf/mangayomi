import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/services/fetch_anime_sources.dart';
import 'package:mangayomi/services/fetch_manga_sources.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_list_tile_widget.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

class ExtensionScreen extends ConsumerStatefulWidget {
  final bool isManga;
  final String query;
  const ExtensionScreen(
      {required this.query, required this.isManga, super.key});

  @override
  ConsumerState<ExtensionScreen> createState() => _ExtensionScreenState();
}

class _ExtensionScreenState extends ConsumerState<ExtensionScreen> {
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final streamExtensions =
        ref.watch(getExtensionsStreamProvider(widget.isManga));
    if (widget.isManga) {
      ref.watch(fetchMangaSourcesListProvider(id: null, reFresh: false));
    } else {
      ref.watch(fetchAnimeSourcesListProvider(id: null, reFresh: false));
    }
    final l10n = l10nLocalizations(context)!;
    return RefreshIndicator(
      onRefresh: () => widget.isManga
          ? ref.refresh(
              fetchMangaSourcesListProvider(id: null, reFresh: true).future)
          : ref.refresh(
              fetchAnimeSourcesListProvider(id: null, reFresh: true).future),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: streamExtensions.when(
          data: (data) {
            data = widget.query.isEmpty
                ? data
                : data
                    .where((element) => element.name!
                        .toLowerCase()
                        .contains(widget.query.toLowerCase()))
                    .toList();
            data = data
                .where((element) => ref.watch(showNSFWStateProvider)
                    ? true
                    : element.isNsfw == false)
                .toList();
            final notInstalledEntries = data
                .where((element) => element.version == element.versionLast!)
                .where((element) => !element.isAdded!)
                .toList();
            final installedEntries = data
                .where((element) => element.version == element.versionLast!)
                .where((element) => element.isAdded!)
                .toList();
            final updateEntries = data
                .where((element) =>
                    compareVersions(element.version!, element.versionLast!) < 0)
                .toList();
            return Scrollbar(
              interactive: true,
              controller: controller,
              thickness: 12,
              radius: const Radius.circular(10),
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  SliverGroupedListView<Source, String>(
                    elements: updateEntries,
                    groupBy: (element) => "",
                    groupSeparatorBuilder: (_) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.update_pending,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                for (var source in updateEntries) {
                                  source.isManga!
                                      ? await ref.watch(
                                          fetchMangaSourcesListProvider(
                                                  id: source.id, reFresh: true)
                                              .future)
                                      : await ref.watch(
                                          fetchAnimeSourcesListProvider(
                                                  id: source.id, reFresh: true)
                                              .future);
                                }
                              },
                              child: Text(l10n.update_all))
                        ],
                      ),
                    ),
                    itemBuilder: (context, Source element) {
                      return ExtensionListTileWidget(
                        source: element,
                      );
                    },
                    groupComparator: (group1, group2) =>
                        group1.compareTo(group2),
                    itemComparator: (item1, item2) =>
                        item1.name!.compareTo(item2.name!),
                    order: GroupedListOrder.ASC,
                  ),
                  SliverGroupedListView<Source, String>(
                    elements: installedEntries,
                    groupBy: (element) => "",
                    groupSeparatorBuilder: (_) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        l10n.installed,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    itemBuilder: (context, Source element) {
                      return ExtensionListTileWidget(source: element);
                    },
                    groupComparator: (group1, group2) =>
                        group1.compareTo(group2),
                    itemComparator: (item1, item2) =>
                        item1.name!.compareTo(item2.name!),
                    order: GroupedListOrder.ASC,
                  ),
                  SliverGroupedListView<Source, String>(
                    elements: notInstalledEntries,
                    groupBy: (element) =>
                        completeLanguageName(element.lang!.toLowerCase()),
                    groupSeparatorBuilder: (String groupByValue) => Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Text(
                            groupByValue,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (context, Source element) {
                      return ExtensionListTileWidget(
                        source: element,
                      );
                    },
                    groupComparator: (group1, group2) =>
                        group1.compareTo(group2),
                    itemComparator: (item1, item2) =>
                        item1.name!.compareTo(item2.name!),
                    order: GroupedListOrder.ASC,
                  ),
                ],
              ),
            );
          },
          error: (error, _) => Center(
            child: ElevatedButton(
                onPressed: () {
                  if (widget.isManga) {
                    ref.invalidate(
                        fetchMangaSourcesListProvider(id: null, reFresh: true));
                  } else {
                    ref.invalidate(
                        fetchAnimeSourcesListProvider(id: null, reFresh: true));
                  }
                },
                child: Text(context.l10n.refresh)),
          ),
          loading: () => const ProgressCenter(),
        ),
      ),
    );
  }
}
