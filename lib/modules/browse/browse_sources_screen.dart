import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/main.dart';
import 'package:isar/isar.dart';

class BrowseSourcesScreen extends ConsumerStatefulWidget {
  final bool isManga;
  const BrowseSourcesScreen({super.key, required this.isManga});

  @override
  ConsumerState<BrowseSourcesScreen> createState() =>
      _BrowseSourcesScreenState();
}

class _BrowseSourcesScreenState extends ConsumerState<BrowseSourcesScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          l10n.browse,
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () {
              context.push('/globalSearch', extra: widget.isManga);
            },
            icon: Icon(Icons.travel_explore_rounded,
                color: Theme.of(context).hintColor),
          ),
          IconButton(
            splashRadius: 20,
            onPressed: () {
              context.push(widget.isManga ? '/MangaLibrary' : '/AnimeLibrary');
            },
            icon: Icon(Icons.favorite_outline_rounded,
                color: Theme.of(context).hintColor),
          ),
          IconButton(
            splashRadius: 20,
            onPressed: () {
              context.push('/history/${widget.isManga ? 'manga' : 'anime'}');
            },
            icon: Icon(Icons.history,
                color: Theme.of(context).hintColor),
            tooltip: l10n.history,
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                splashRadius: 20,
                icon: Icon(Icons.new_releases_outlined,
                    color: Theme.of(context).hintColor),
                onPressed: () {
                  context
                      .push(widget.isManga ? '/mangaUpdates' : '/animeUpdates');
                },
                tooltip: l10n.updates,
              ),
              Positioned(
                right: 14,
                top: 3,
                child: _updatesTotalNumbers(ref),
              ),
            ],
          ),
          IconButton(
            splashRadius: 20,
            onPressed: () {
              context.push('/sourceFilter', extra: widget.isManga);
            },
            icon: Icon(Icons.filter_list_sharp,
                color: Theme.of(context).hintColor),
          ),
        ],
      ),
      body: SourcesScreen(
        isManga: widget.isManga,
        tabIndex: (_) {},
      ),
    );
  }
}

Widget _updatesTotalNumbers(WidgetRef ref) {
  return StreamBuilder(
      stream: isar.updates.filter().idIsNotNull().watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final entries = snapshot.data!.where((element) {
            if (!element.chapter.isLoaded) {
              element.chapter.loadSync();
            }
            return !(element.chapter.value?.isRead ?? false);
          }).toList();
          return entries.isEmpty
              ? Container()
              : Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 176, 46, 37)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Text(
                      entries.length.toString(),
                      style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).textTheme.bodySmall!.color),
                    ),
                  ),
                );
        }
        return Container();
      });
}
