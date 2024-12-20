import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/language.dart';

class SourcesFilterScreen extends ConsumerWidget {
  final bool isManga;
  const SourcesFilterScreen({required this.isManga, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sources),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder(
            stream: isar.sources
                .filter()
                .idIsNotNull()
                .and()
                .sourceCodeIsNotEmpty()
                .and()
                .isMangaEqualTo(isManga)
                .watch(fireImmediately: true),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final entries = snapshot.data!;
                return CustomScrollView(
                  slivers: [
                    SliverGroupedListView<Source, String>(
                      elements: entries,
                      groupBy: (element) => element.lang!,
                      groupSeparatorBuilder: (String groupByValue) =>
                          SwitchListTile(
                        value: entries
                            .where((element) =>
                                element.lang!.toLowerCase() == groupByValue &&
                                element.isActive! &&
                                element.isManga == isManga)
                            .isNotEmpty,
                        onChanged: (val) {
                          isar.writeTxnSync(() {
                            for (var source in entries) {
                              if (source.lang!.toLowerCase() == groupByValue) {
                                isar.sources
                                    .putSync(source..isActive = val == true);
                              }
                            }
                          });
                        },
                        title: Text(
                          completeLanguageName(groupByValue),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      itemBuilder: (context, Source element) {
                        if (entries
                            .where((s) =>
                                s.lang!.toLowerCase() == element.lang &&
                                s.isActive! &&
                                s.isManga == isManga)
                            .isEmpty) {
                          return Container();
                        }
                        return CheckboxListTile(
                          secondary: Container(
                            height: 37,
                            width: 37,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .secondaryHeaderColor
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(5)),
                            child: element.iconUrl!.isEmpty
                                ? const Icon(Icons.source_outlined)
                                : cachedNetworkImage(
                                    imageUrl: element.iconUrl!,
                                    fit: BoxFit.contain,
                                    width: 37,
                                    height: 37,
                                    errorWidget: const SizedBox(
                                      width: 37,
                                      height: 37,
                                      child: Center(
                                        child: Icon(Icons.source_outlined),
                                      ),
                                    ),
                                  ),
                          ),
                          onChanged: (bool? value) {
                            isar.writeTxnSync(() {
                              isar.sources.putSync(element..isAdded = value);
                            });
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
              return Container();
            }),
      ),
    );
  }
}
