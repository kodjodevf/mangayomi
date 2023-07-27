import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/search_manga.dart';
import 'package:mangayomi/modules/manga/home/manga_home_screen.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';

class SearchResultScreen extends ConsumerWidget {
  final String query;
  final Source source;
  final bool viewOnly;
  const SearchResultScreen({
    super.key,
    required this.query,
    required this.source,
    this.viewOnly = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final search =
        ref.watch(searchMangaProvider(source: source, query: query, page: 1));
    return Scaffold(
        appBar: viewOnly
            ? AppBar(
                title: Text(query),
              )
            : null,
        body: search.when(
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            data: (data) {
              if (data.isNotEmpty) {
                return GridViewWidget(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return MangaHomeImageCard(
                      manga: data[index]!,
                      source: source,
                      isManga: source.isManga ?? true,
                    );
                  },
                );
              }
              return Center(
                child: Text(l10n.no_result),
              );
            }));
  }
}
