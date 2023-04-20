import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/views/manga/detail/manga_details_view.dart';

class MangaReaderDetail extends ConsumerStatefulWidget {
  final ModelManga modelManga;
  const MangaReaderDetail({super.key, required this.modelManga});

  @override
  ConsumerState<MangaReaderDetail> createState() => _MangaReaderDetailState();
}

class _MangaReaderDetailState extends ConsumerState<MangaReaderDetail> {
  bool _isFavorite = false;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (_isFavorite) {
            bool isOk = false;
            ref
                .watch(getMangaDetailProvider(
                        imageUrl: widget.modelManga.imageUrl!,
                        lang: widget.modelManga.lang!,
                        title: widget.modelManga.name!,
                        source: widget.modelManga.source!,
                        url: widget.modelManga.link!)
                    .future)
                .then((value) {
              if (value.chapters.isNotEmpty &&
                  value.chapters.length > widget.modelManga.chapters!.length) {
                final model = ModelManga(
                    imageUrl: widget.modelManga.imageUrl,
                    name: widget.modelManga.name,
                    genre: widget.modelManga.genre,
                    author: widget.modelManga.author,
                    description: widget.modelManga.description,
                    status: value.status,
                    favorite: _isFavorite,
                    link: widget.modelManga.link,
                    source: widget.modelManga.source,
                    lang: widget.modelManga.lang,
                    dateAdded: widget.modelManga.dateAdded,
                    lastUpdate: DateTime.now().microsecondsSinceEpoch,
                    chapters: value.chapters,
                    category: widget.modelManga.category,
                    lastRead: widget.modelManga.lastRead);
                ref.watch(hiveBoxManga).put(
                    '${widget.modelManga.lang}-${widget.modelManga.link}',
                    model);
              }
              if (mounted) {
                setState(() {
                  isOk = true;
                });
              }
            });
            await Future.doWhile(() async {
              await Future.delayed(const Duration(seconds: 1));
              if (isOk == true) {
                return false;
              }
              return true;
            });
          }
        },
        child: ValueListenableBuilder<Box<ModelManga>>(
          valueListenable: ref.watch(hiveBoxManga).listenable(),
          builder: (context, value, child) {
            final entries = value.values
                .where((element) =>
                    '${element.lang}-${element.link}' ==
                    '${widget.modelManga.lang}-${widget.modelManga.link}')
                .toList();
            if (entries.isNotEmpty) {
              return MangaDetailsView(
                modelManga: entries[0],
                isFavorite: (value) {
                  setState(() {
                    _isFavorite = value;
                  });
                },
              );
            }
            return MangaDetailsView(
              modelManga: widget.modelManga,
              isFavorite: (value) {
                setState(() {
                  _isFavorite = value;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
