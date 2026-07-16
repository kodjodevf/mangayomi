import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/global_search/global_search_screen.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/get_latest_updates.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// Aggregates the latest entries from every pinned source — one horizontal row
/// per source, mirroring the global search results layout so it reuses the same
/// card widget. Each source is fetched through [getLatestUpdatesProvider], which
/// runs the extension call in the isolate pool off the UI thread; a source that
/// doesn't provide a latest listing just shows a compact error in its row rather
/// than blocking the screen.
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Only a cheap Isar read on the main thread; the actual latest fetch per
    // source happens off-thread in the isolate pool.
    final sources = isar.sources
        .filter()
        .idIsNotNull()
        .isActiveEqualTo(true)
        .isPinnedEqualTo(true)
        .findAllSync();
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: sources.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Pin sources (Browse → long-press a source) to see their '
                  'latest entries here.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              itemCount: sources.length,
              itemBuilder: (context, index) =>
                  _SourceFeedSection(source: sources[index]),
            ),
    );
  }
}

class _SourceFeedSection extends ConsumerWidget {
  const _SourceFeedSection({required this.source});

  final Source source;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(
      getLatestUpdatesProvider(source: source, page: 1),
    );
    return SizedBox(
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            onTap: () => Navigator.push(
              context,
              createRoute(
                page: MangaHomeScreen(source: source, isLatest: true),
              ),
            ),
            title: Text(source.name ?? ''),
            subtitle: Text(
              completeLanguageName(source.lang ?? ''),
              style: const TextStyle(fontSize: 10),
            ),
            trailing: const Icon(Icons.arrow_forward_sharp),
          ),
          Flexible(
            child: latest.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    e.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (pages) => (pages?.list.isNotEmpty ?? false)
                  ? SuperListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pages!.list.length,
                      itemBuilder: (context, index) => MangaGlobalImageCard(
                        manga: pages.list[index],
                        source: source,
                      ),
                    )
                  : const Center(child: Text('No results')),
            ),
          ),
        ],
      ),
    );
  }
}
