import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/views/manga/detail/manga_details_view.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as path;

class MangaReaderDetail extends ConsumerStatefulWidget {
  final int idManga;
  const MangaReaderDetail({super.key, required this.idManga});

  @override
  ConsumerState<MangaReaderDetail> createState() => _MangaReaderDetailState();
}

final mangaa = StreamProvider.family<ModelManga?, int>((ref, id) async* {
  // final ddd = isar.modelMangas.filter().chapters((q) => q.isReadEqualTo(true)).build().watch();
  yield* isar.modelMangas.watchObject(id, fireImmediately: true);
});

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
    final mm = ref.watch(mangaa(widget.idManga));
    return Scaffold(
        body: mm.when(
      data: (data) {
        // final mang = data.where((element) => element.id==widget.idManga).toList().first;
        return MangaDetailsView(
          modelManga: data!,
          isFavorite: (value) {
            setState(() {
              _isFavorite = value;
            });
          },
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return Text("data");
      },
      loading: () {
        return Text("eeee");
      },
    )

        //  RefreshIndicator(
        //   onRefresh: () async {
        //     if (_isFavorite) {
        //       // bool isOk = false;
        //       // ref
        //       //     .watch(getMangaDetailProvider(
        //       //             imageUrl: widget.modelManga.imageUrl!,
        //       //             lang: widget.modelManga.lang!,
        //       //             title: widget.modelManga.name!,
        //       //             source: widget.modelManga.source!,
        //       //             url: widget.modelManga.link!)
        //       //         .future)
        //       //     .then((value) {
        //       //   if (value.chapters.isNotEmpty &&
        //       //       value.chapters.length > widget.modelManga.chapters!.length) {
        //       //     List<ModelChapters>? chapters = [];
        //       //     for (var chap in widget.modelManga.chapters!) {
        //       //       chapters.add(chap);
        //       //     }
        //       //     int newChapsSize =
        //       //         value.chapters.length - widget.modelManga.chapters!.length;
        //       //     for (var i = 0; i < newChapsSize; i++) {
        //       //       chapters.insert(i, value.chapters[i]);
        //       //     }
        //       //     final model = ModelManga(
        //       //         imageUrl: widget.modelManga.imageUrl,
        //       //         name: widget.modelManga.name,
        //       //         genre: widget.modelManga.genre,
        //       //         author: widget.modelManga.author,
        //       //         description: widget.modelManga.description,
        //       //         status: value.status,
        //       //         favorite: _isFavorite,
        //       //         link: widget.modelManga.link,
        //       //         source: widget.modelManga.source,
        //       //         lang: widget.modelManga.lang,
        //       //         dateAdded: widget.modelManga.dateAdded,
        //       //         lastUpdate: DateTime.now().microsecondsSinceEpoch,
        //       //         chapters: chapters,
        //       //         categories: widget.modelManga.categories,
        //       //         lastRead: widget.modelManga.lastRead);
        //       //     ref.watch(hiveBoxMangaProvider).put(
        //       //         '${widget.modelManga.lang}-${widget.modelManga.link}',
        //       //         model);
        //       //   }
        //       //   if (mounted) {
        //       //     setState(() {
        //       //       isOk = true;
        //       //     });
        //       //   }
        //       // });
        //       // await Future.doWhile(() async {
        //       //   await Future.delayed(const Duration(seconds: 1));
        //       //   if (isOk == true) {
        //       //     return false;
        //       //   }
        //       //   return true;
        //       // });
        //     }
        //   },
        //   child:

        //   //  ValueListenableBuilder<ModelManga>(
        //   //   valueListenable: ref.watch(hiveBoxMangaProvider).listenable(),
        //   //   builder: (context, value, child) {
        //   //     final entries = value.values
        //   //         .where((element) =>
        //   //             '${element.lang}-${element.link}' ==
        //   //             '${widget.modelManga.lang}-${widget.modelManga.link}')
        //   //         .toList();
        //   //     if (entries.isNotEmpty) {
        //   //       return MangaDetailsView(
        //   //         modelManga: entries[0],
        //   //         isFavorite: (value) {
        //   //           setState(() {
        //   //             _isFavorite = value;
        //   //           });
        //   //         },
        //   //       );
        //   //     }
        //   //     return MangaDetailsView(
        //   //       modelManga: widget.modelManga,
        //   //       isFavorite: (value) {
        //   //         setState(() {
        //   //           _isFavorite = value;
        //   //         });
        //   //       },
        //   //     );
        //   //   },
        //   // ),
        // ),
        );
  }
}
