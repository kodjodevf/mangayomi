import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/modules/browse/extension/providers/fetch_anime_sources.dart';
import 'package:mangayomi/modules/browse/extension/providers/fetch_manga_sources.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_list_tile_widget.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

class ExtensionScreen extends ConsumerWidget {
  final bool isManga;
  final String query;
  const ExtensionScreen(
      {required this.query, required this.isManga, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamExtensions =
        ref.watch(getExtensionsStreamProvider(isManga: isManga, query: query));
    if (isManga) {
      ref.watch(fetchMangaSourcesListProvider(id: null, reFresh: false));
    } else {
      ref.watch(fetchAnimeSourcesListProvider(id: null, reFresh: false));
    }
    final l10n = l10nLocalizations(context)!;
    return RefreshIndicator(
      onRefresh: () => isManga
          ? ref.refresh(
              fetchMangaSourcesListProvider(id: null, reFresh: true).future)
          : ref.refresh(
              fetchAnimeSourcesListProvider(id: null, reFresh: true).future),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: streamExtensions.when(
          data: (data) {
            final entries1 = data
                .where((element) => ref.watch(showNSFWStateProvider)
                    ? true
                    : element.isNsfw == false)
                .where((element) => element.version == element.versionLast!)
                .where((element) => !element.isAdded!)
                .toList();
            final entries2 = data
                .where((element) => ref.watch(showNSFWStateProvider)
                    ? true
                    : element.isNsfw == false)
                .where((element) => element.version == element.versionLast!)
                .where((element) => element.isAdded!)
                .toList();
            final entries = data
                .where((element) => ref.watch(showNSFWStateProvider)
                    ? true
                    : element.isNsfw == false)
                .where((element) =>
                    compareVersions(element.version!, element.versionLast!) < 0)
                .toList();
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (useTestSourceCode)
                    for (var e in testSourceModelList)
                      ExtensionListTileWidget(
                          source: e, isTestSource: useTestSourceCode),
                  GroupedListView<Source, String>(
                    elements: entries,
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
                                for (var source in entries) {
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
                    shrinkWrap: true,
                    itemComparator: (item1, item2) =>
                        item1.name!.compareTo(item2.name!),
                    order: GroupedListOrder.ASC,
                  ),
                  GroupedListView<Source, String>(
                    elements: entries2,
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
                    shrinkWrap: true,
                    itemComparator: (item1, item2) =>
                        item1.name!.compareTo(item2.name!),
                    order: GroupedListOrder.ASC,
                  ),
                  GroupedListView<Source, String>(
                    elements: entries1,
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
                    shrinkWrap: true,
                    order: GroupedListOrder.ASC,
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error),
          loading: () => const ProgressCenter(),
        ),
      ),
    );
  }
}
