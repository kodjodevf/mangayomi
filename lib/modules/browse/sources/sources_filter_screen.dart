import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class SourcesFilterScreen extends ConsumerWidget {
  final ItemType itemType;
  const SourcesFilterScreen({required this.itemType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final showNSFW = ref.watch(showNSFWStateProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sources)),
      body: Padding(
        // Same inset as the other TV list screens; zero off-TV.
        padding: const EdgeInsets.only(top: ShioriSpace.s12).add(tvPageInsets),
        child: StreamBuilder(
          stream: sourceRepository.watchWithCodeByItemType(itemType),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final entries = snapshot.data!
                  .where((e) => showNSFW || !(e.isNsfw ?? false))
                  .toList();
              return CustomScrollView(
                slivers: [
                  CustomSliverGroupedListView<Source, String>(
                    elements: entries,
                    groupBy: (element) => element.lang!,
                    groupSeparatorBuilder: (String groupByValue) =>
                        ShioriSwitchRow(
                          value: entries
                              .where(
                                (element) =>
                                    element.lang!.toLowerCase() ==
                                        groupByValue &&
                                    element.isActive! &&
                                    element.itemType == itemType,
                              )
                              .isNotEmpty,
                          onChanged: (val) {
                            final now = DateTime.now().millisecondsSinceEpoch;
                            final toUpdate = entries
                                .where(
                                  (source) =>
                                      source.lang!.toLowerCase() ==
                                      groupByValue,
                                )
                                .map(
                                  (source) => source
                                    ..isActive = val == true
                                    ..updatedAt = now,
                                )
                                .toList();
                            sourceRepository.putAll(toUpdate);
                          },
                          title: languageName(context, groupByValue),
                        ),
                    itemBuilder: (context, Source element) {
                      if (entries
                          .where(
                            (s) =>
                                s.lang!.toLowerCase() == element.lang &&
                                s.isActive! &&
                                s.itemType == itemType,
                          )
                          .isEmpty) {
                        return Container();
                      }
                      return CheckboxListTile(
                        secondary: SourceIcon(iconUrl: element.iconUrl),
                        onChanged: (bool? value) {
                          sourceRepository.save(element..isAdded = value);
                        },
                        value: element.isAdded!,
                        title: Text(element.name!),
                      );
                    },
                    groupComparator: (group1, group2) =>
                        group1.compareTo(group2),
                    itemComparator: (item1, item2) =>
                        item1.name!.compareTo(item2.name!),
                    order: GroupedListOrder.ASC,
                  ),
                ],
              );
            }
            if (snapshot.hasData) {
              return ShioriEmptyState(
                icon: Symbols.extension_rounded,
                title: l10n.no_sources_installed,
                compact: true,
              );
            }
            return const ShioriLoading();
          },
        ),
      ),
    );
  }
}
